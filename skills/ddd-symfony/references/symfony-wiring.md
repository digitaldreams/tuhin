# Symfony Wiring (Our Defaults)

Use these only when the project has no pattern of its own (SKILL.md Step 0).

**Verified on 2026-10-02 against:** Symfony 8.1.8, Doctrine ORM 3.7.3, DoctrineBundle 3.3.2,
doctrine/persistence 4.2.0, PHP 8.5. If `composer.lock` shows newer majors or minors, read their
UPGRADE notes for the items below before generating.

---

## Mapping: PHP driver, files in Infrastructure

The Domain has no ORM attributes. The mapping lives in Infrastructure.

```yaml
# config/packages/doctrine.yaml
doctrine:
    orm:
        mappings:
            Catalog:
                type: php
                dir: '%kernel.project_dir%/src/Catalog/Infrastructure/Persistence/Doctrine/Mapping'
                prefix: 'App\Catalog\Domain\Model'
```

- One mapping entry per bounded context. Remove the recipe's default `App` → `src/Entity` mapping
  if that folder isn't used.
- `is_bundle` isn't needed: it's auto-detected when `dir` exists.
- DoctrineBundle accepts `attribute`, `xml`, `php` or `staticphp`. If the project already uses
  XML (`*.orm.xml`), keep XML.

**File name = the FQCN with dots + `.php`** (found by `DefaultFileLocator`). The file **returns a
closure**: writing into a global `$metadata` is deprecated since doctrine/persistence 4.2.

```php
// Infrastructure/Persistence/Doctrine/Mapping/App.Catalog.Domain.Model.Product.Product.php

use Doctrine\ORM\Mapping\Builder\ClassMetadataBuilder;
use Doctrine\ORM\Mapping\ClassMetadata;

return static function (ClassMetadata $metadata): void {
    $builder = new ClassMetadataBuilder($metadata);
    $builder->setTable('catalog_products');

    $builder->createField('id', 'product_id')->makePrimaryKey()->build();
    $builder->createField('title', 'string')->length(100)->unique()->build();
    $builder->addEmbedded('price', ProductPrice::class, 'price_');
    $metadata->mapField(['fieldName' => 'status', 'type' => 'string', 'enumType' => ProductStatus::class]);
    $builder->createField('version', 'integer')->isVersionField()->build();

    $builder->createOneToMany('reviews', Review::class)
        ->mappedBy('product')
        ->cascadePersist()
        ->orphanRemoval()
        ->build();
};
```

- **Value objects** are embeddables, with their own mapping file
  (`$builder->setEmbeddable()`, plus their fields).
- **Enums:** `enumType` with a backed enum.
- **Optimistic lock:** an integer version field. A conflict throws
  `Doctrine\ORM\OptimisticLockException` on flush.
- **Final entities** work, because native lazy objects are always on in DoctrineBundle 3.

## Id types (DBAL 4)

```php
namespace App\Catalog\Infrastructure\Persistence\Doctrine\Type;

#[AsDbalType('product_id')]
final class ProductIdType extends Type
{
    public function getSQLDeclaration(array $column, AbstractPlatform $platform): string
    {
        return $platform->getGuidTypeDeclarationSQL($column);
    }

    public function convertToPHPValue(mixed $value, AbstractPlatform $platform): ?ProductId
    {
        return $value === null ? null : new ProductId((string) $value);
    }

    public function convertToDatabaseValue(mixed $value, AbstractPlatform $platform): ?string
    {
        return $value === null ? null : (string) $value;
    }
}
```

DBAL 4 removed `Type::getName()` and the comment hints. Don't generate them.

## Ports → adapters with `#[AsAlias]`

```php
#[AsAlias(ProductRepository::class)]
final readonly class DoctrineProductRepository implements ProductRepository
{
    public function __construct(private EntityManagerInterface $entityManager) {}

    public function nextIdentity(): ProductId
    {
        return new ProductId(Uuid::v7()->toRfc4122());
    }

    public function add(Product $product): void
    {
        $this->entityManager->persist($product); // no flush
    }

    public function productOfId(ProductId $id): ?Product
    {
        return $this->entityManager->find(Product::class, $id);
    }

    public function existsWithTitle(string $title): bool
    {
        return $this->entityManager->getRepository(Product::class)->count(['title' => $title]) > 0;
    }
}
```

The fluent PHP *semantic* config was removed in Symfony 8, but `services.php` `$services->alias()`
and YAML aliases still work. Follow what the project uses; for new code, use the attribute.

## Transactions + events dispatched after commit

```php
namespace App\Shared\Infrastructure\Persistence;

#[AsAlias(TransactionalSession::class)]
final readonly class DoctrineTransactionalSession implements TransactionalSession
{
    public function __construct(
        private EntityManagerInterface $entityManager,
        private MessageBusInterface $messageBus,
    ) {}

    public function executeAtomically(callable $operation): mixed
    {
        $collector = new DomainEventCollector();
        $subscriberId = DomainEventPublisher::instance()->subscribe($collector);

        try {
            $result = $this->entityManager->wrapInTransaction(fn () => $operation());
        } finally {
            DomainEventPublisher::instance()->unsubscribe($subscriberId);
        }

        foreach ($collector->release() as $event) {
            $this->messageBus->dispatch($event); // only after a successful commit
        }

        return $result;
    }
}
```

`DomainEventCollector` implements `DomainEventSubscriber`, keeps the events in an array, and
`release()` returns them and clears the array. `wrapInTransaction()` flushes and commits, and on
an error it rolls back and rethrows, so no event leaves.

## Messenger between bounded contexts

```yaml
# config/packages/messenger.yaml
framework:
    messenger:
        failure_transport: failed
        transports:
            async: '%env(MESSENGER_TRANSPORT_DSN)%'   # e.g. redis://localhost:6379/messages
            failed: 'doctrine://default?queue_name=failed'
        routing:
            App\Shared\Domain\Event\CommonEvent: async
```

```php
namespace App\Inventory\Infrastructure\Messaging;

#[AsMessageHandler]
final readonly class WhenProductPublishedCreateStockItem
{
    public function __construct(private CreateStockItemService $service) {}

    public function __invoke(ProductPublished $event): void
    {
        $this->service->execute(new CreateStockItemCommand(productId: $event->productId));
    }
}
```

- Routing by the parent class (`CommonEvent`) covers every event.
- Handlers must be idempotent: Messenger delivers at least once.
- **Production note:** if the broker is down right after the commit, the event is lost. Use an
  **Outbox** (the events saved in a Doctrine transport table in the same transaction, then
  forwarded by a worker) when losing an event is unacceptable. Ask before adding it.

## Delivery: controllers and console

- A controller turns HTTP into a Command and calls `execute()`. `#[MapRequestPayload] CreateProductCommand
  $command` works and keeps the Command free of Symfony code (wrong types → 422 automatically; the
  JSON keys must match the property names).
- An invokable console command: `#[AsCommand(name: 'catalog:product:publish')]` with
  `__invoke(SymfonyStyle $io, #[Argument] string $productId): int`.
- One exception listener maps domain errors for every controller:

```php
#[AsEventListener]
final class DomainExceptionListener
{
    public function __invoke(ExceptionEvent $event): void
    {
        $exception = $event->getThrowable();

        $status = match (true) {
            $exception instanceof ProductNotFound => 404,
            $exception instanceof ProductTitleAlreadyUsed,
            $exception instanceof OptimisticLockException => 409,
            $exception instanceof \DomainException,
            $exception instanceof \InvalidArgumentException => 422,
            default => null,
        };

        if ($status !== null) {
            $event->setResponse(new JsonResponse(['error' => $exception->getMessage()], $status));
        }
    }
}
```

More specific exceptions go first in the `match`. A "not found" extends `\DomainException`, so it
must come before the 422 line.
