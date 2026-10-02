# DDD Audit Checklist

Cite findings by id: `DDD-n · file:line · what's wrong · the fix`. Ranked by risk: **High**
breaks invariants or data, **Medium** erodes the design, **Low** is style.

| Id | Risk | Rule | How to detect | Fix |
|---|---|---|---|---|
| DDD-1 | High | The Domain has no framework imports | `grep -rE 'use (Symfony\|Doctrine\\ORM)' src/*/Domain` (`Doctrine\Common\Collections` is allowed) | Move the code to Infrastructure behind a port; move the mapping out of attributes |
| DDD-2 | High | Events leave only after commit | `MessageBusInterface::dispatch()` called inside a transaction, in an entity, or before `flush()` | Collect the events, then dispatch them after `wrapInTransaction()` returns (`symfony-wiring.md`) |
| DDD-3 | High | Invariants are guarded inside the aggregate | Public setters / `public` mutable props on entities; state changed from outside (`$product->status = …`, `setStatus()`) | An intention-revealing method on the root (`publish()`) that checks the rule; `public private(set)` |
| DDD-4 | High | No business rules in application services | `if`/`match` on entity state, then a mutation in an `*Service` | Move the check into the aggregate method; the service only calls it |
| DDD-5 | High | Concurrency on aggregates with counters/derived values | Count/sum fields with no version field | Add an integer version field (optimistic lock) and map `OptimisticLockException` to 409 |
| DDD-6 | Medium | One repository per aggregate root | A repository for a child entity (`ReviewRepository` when `Review` lives inside `Product`) | Delete it; reach children through the root |
| DDD-7 | Medium | Repositories don't commit | `flush()` / `beginTransaction()` inside a repository | Persist only; the `TransactionalSession` port owns the transaction |
| DDD-8 | Medium | Repository ports live in the Domain | The interface in Infrastructure, or services type-hinting a Doctrine repository class | An interface in `Domain/Model/<Aggregate>`, an adapter with `#[AsAlias]` |
| DDD-9 | Medium | Application services never return entities | `execute()` returns an entity, or a controller receives one | Return a DTO, an id or nothing |
| DDD-10 | Medium | Cross-context references are ids | An entity in context A holds an object from context B (a Doctrine association across contexts) | Store B's id as a string/VO; sync through events |
| DDD-11 | Medium | Events are raised in the Domain | Events created/dispatched in controllers, listeners or services for a domain fact | Raise them inside the aggregate method that changed the state |
| DDD-12 | Medium | Primitive obsession for concepts with rules | `int $price` / `string $email` validated in several places | A Value Object that validates once |
| DDD-13 | Medium | Domain services are rare and named in the domain language | `*DomainService`/`*Helper`/`*Manager` with logic that one entity could own | Move it into the entity; keep a domain service only for rules spanning aggregates |
| DDD-14 | Low | Commands are framework-free | `#[Assert\…]` or Symfony types on Command classes | Plain `final readonly` primitives; the Domain validates, `#[MapRequestPayload]` handles types |
| DDD-15 | Low | Events are serializable facts | Events with entities/objects inside, mutable events, present-tense names | `final readonly`, primitives only, past tense, named arguments |
| DDD-16 | Low | Ids are app-generated | DB auto-increment ids on aggregates that raise events | `nextIdentity()` with UUID v7 |
| DDD-17 | Low | Ubiquitous language in the code | `setStatus(2)`, `flag_active`, names the domain expert wouldn't recognize | Rename to the domain's words (`publish()`, `isPublished()`) |

## Report shape

```
## DDD audit — src/Catalog (2026-10-02)

High
- DDD-2 · src/Catalog/Application/PublishProductService.php:31 · dispatches ProductPublished before flush → a message for a product that may roll back · collect the events and dispatch after commit

Medium
- …

Summary: 1 high, 3 medium, 2 low. Best payoff: DDD-2, DDD-4 (PublishProductService), DDD-6.
```

Don't fix anything in AUDIT mode. The user picks what to fix, and then BUILD mode applies it.
