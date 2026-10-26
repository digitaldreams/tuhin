---
name: symfony-ai-platform
description: Reference for the Symfony AI Platform component (symfony/ai-platform) — the provider-agnostic layer under symfony/ai. Covers PlatformInterface::invoke, DeferredResult and its as*() readers, MessageBag and content types, streaming deltas, options, Contract and custom normalizers, model catalogs, structured output, CachePlatform/FailoverPlatform, the testing doubles, the AI Bundle wiring, and the 0.12 vs 0.13 API drift. Use whenever the work involves symfony/ai, symfony/ai-platform, symfony/ai-agent, symfony/ai-chat, symfony/ai-bundle, Symfony\AI\Platform classes, or wiring an LLM (Ollama, Gemini, OpenAI, Anthropic, …) into a Symfony app.
---

# Symfony AI — Platform component

`composer require symfony/ai-platform`. Provider-agnostic layer: one API over OpenAI, Anthropic, Gemini, Ollama, Mistral, Bedrock, ElevenLabs, Deepgram, and ~35 other bridges. Everything else in the `symfony/ai` monorepo (`ai-agent`, `ai-chat`, `ai-store`, `ai-bundle`) sits on top of it.

Repo: [symfony/ai](https://github.com/symfony/ai). Docs: [symfony.com/doc/current/ai/components/platform.html](https://symfony.com/doc/current/ai/components/platform.html), canonical source at `docs/components/platform.rst` in the repo.

## The one call

```php
public function invoke(
    string|Model $model,
    array|string|object $input,
    array $options = [],
): DeferredResult;
```

`$model` — a name resolved through the catalog, or a `Model` instance that bypasses it. `$input` — `MessageBag`, plain string, `Audio`, `Document`, whatever the bridge accepts. `$options` — model + platform options.

`PlatformInterface` also has `getModelCatalog(): ModelCatalogInterface`.

```php
use Symfony\AI\Platform\Bridge\Ollama\Factory;
use Symfony\AI\Platform\Message\Message;
use Symfony\AI\Platform\Message\MessageBag;

$platform = Factory::createPlatform('http://127.0.0.1:11434');

$messages = new MessageBag(
    Message::forSystem('You are a helpful assistant.'),
    Message::ofUser('What is the capital of France?'),
);

echo $platform->invoke('llama3.2', $messages)->asText();
```

### Architecture

`Platform` is a **router** over one or more `ProviderInterface` instances:

```php
new Platform(
    array $providers,                    // at least one, or InvalidArgumentException
    ModelRouterInterface $modelRouter = new CatalogBasedModelRouter(),
    ?EventDispatcherInterface $eventDispatcher = null,
);
```

A `Provider` bundles everything for one backend: model clients, result converters, a `Contract`, a `ModelCatalog`. Every bridge `Factory` exposes both `createProvider(...)` and `createPlatform(...)` with the same arguments — use `createProvider()` when composing several backends behind one `Platform`.

```php
$platform = new Platform([
    OpenAiFactory::createProvider(apiKey: $openAiKey),
    AnthropicFactory::createProvider(apiKey: $anthropicKey),
]);

$platform->invoke('gpt-4o', $messages);            // → OpenAI
$platform->invoke('claude-sonnet-4-5', $messages); // → Anthropic
```

Routing is `ModelRouterInterface::resolve(string|Model $model, iterable $providers, array|string|object $input, array $options = []): RoutingDecision`. Override it to route on the *input* rather than the model name — send anything containing an image to a vision model, cheap models for short prompts, and so on. A `ModelRoutingEvent` listener can also swap the provider before the router runs.

## DeferredResult

`invoke()` returns a `DeferredResult` — **lazy**. The HTTP request is in flight, nothing has been read. This is what makes parallelism free:

```php
foreach ($inputs as $input) {
    $results[] = $platform->invoke('gpt-5-mini', $input);   // all fire
}
foreach ($results as $result) {
    echo $result->asText();                                  // then collect
}
```

Readers — pick the one matching what the model returns:

| Method | Returns |
|---|---|
| `asText(): string` | text |
| `asObject(): object` | structured output (needs `response_format`) |
| `asVectors(): array` | `Vector[]` from an embeddings model |
| `asBinary(): string` | raw bytes (TTS audio, image) |
| `asFile(string $path): void` | write bytes to disk |
| `asDataUri(?string $mimeType = null): string` | bytes as a `data:` URI |
| `asToolCalls(): array` | `ToolCall[]` |
| `asReranking(): array` | reranked documents |
| `asStream(): \Generator` | every `DeltaInterface` |
| `asTextStream(): \Generator` | `TextDelta` text only |
| `asStreamedObject(): \Generator` | progressive structured-output snapshots |
| `asPartialJsonStream(): \Generator` | progressive parsed JSON |
| `getResult(): ResultInterface` | the typed result object |

Plus `getMetadata()` (`finish_reason`, `citations`, token usage), `getRawResult()`, `getResultConverter()`, and `onConvert(\Closure)` / `onError(\Closure)` hooks.

Result types: `TextResult` `VectorResult` `BinaryResult` `ObjectResult` `MultiPartResult` `StreamResult` `ToolCallResult` `ThinkingResult` `ChoiceResult` `RerankingResult` `WebSearchResult` `McpCallResult` and friends.

## Messages

```php
Message::forSystem(\Stringable|string|Template $content): SystemMessage
Message::ofUser(\Stringable|string|ContentInterface ...$content): UserMessage
Message::ofAssistant(string|ContentInterface|ResultInterface ...$parts): AssistantMessage
Message::ofToolCall(ToolCall $toolCall, \Stringable|string|ContentInterface ...$content): ToolCallMessage
```

`MessageBag` is the container. `->with(...)` returns a copy with a message appended (use it in loops — leaves the base bag alone); `->add(...)` mutates; `->merge(...)` joins two bags. Every message carries a UUID v7 `getId()`, so `$message->getId()->getDateTime()` gives creation time for free.

Content types under `Message\Content\`: `Text` `Image` `ImageUrl` `Audio` `Video` `Document` `DocumentUrl` `Thinking` `File` `Collection` plus the server-tool ones (`WebSearch`, `McpCall`, `CodeExecution`, `ComputerCall`, …).

```php
Message::ofUser(
    'Describe this.',
    Image::fromFile('/path/img.jpg'),
    Image::fromDataUrl('data:image/png;base64,…'),
    new ImageUrl('https://example.com/i.png'),
);
```

## Streaming

```php
$result = $platform->invoke($model, $messages, ['stream' => true]);

foreach ($result->asTextStream() as $text) { echo $text; }     // text only
```

For anything else, `asStream()` and match on the delta:

`TextDelta` `ThinkingDelta` `ThinkingComplete` `ThinkingSignature` `ThinkingStart` `ToolCallStart` `ToolInputDelta` `ToolCallComplete` `MetadataDelta` `ChoiceDelta` `BinaryDelta` `PartialObjectDelta`.

`ToolCallComplete` is the **authoritative** one — it carries every tool call of the response. `ToolCallStart` and `ToolInputDelta` are optional; a provider that only knows its tool calls once they are complete emits neither. Multi-candidate Gemini/VertexAI responses wrap deltas in `ChoiceDelta`.

Symfony controller:

```php
#[Route('/chat/stream', methods: ['POST'])]
public function stream(PlatformInterface $platform, Request $request): StreamedResponse
{
    $result = $platform->invoke('gpt-5-mini', $messages, ['stream' => true]);

    return new StreamedResponse(function () use ($result) {
        foreach ($result->asStream() as $delta) {
            if (!$delta instanceof TextDelta) {
                continue;                                   // thinking/tool/usage deltas are not answer text
            }
            echo 'data: '.json_encode(['text' => $delta->getText()])."\n\n";
            if (ob_get_level() > 0) { ob_flush(); }
            flush();
        }
    }, 200, [
        'Content-Type'      => 'text/event-stream',
        'Cache-Control'     => 'no-cache',
        'X-Accel-Buffering' => 'no',                        // or nginx buffers the whole stream
    ]);
}
```

## Options

Third argument, flat array, merged into the model's own defaults:

`temperature` `max_output_tokens` / `max_tokens` `top_p` `top_k` `seed` `stream` `response_format` `thinking` `template_vars` `template_options` — plus anything bridge-specific (Ollama: `num_ctx`, `think`, `keep_alive`; Anthropic: `cacheRetention` at factory level).

`thinking` on reasoning models: `['type' => 'enabled', 'budget_tokens' => 10000]`. Streamed reasoning arrives as `ThinkingDelta`, closed by a `ThinkingComplete` carrying a signature you must replay verbatim on the next turn — build the assistant message with `new AssistantMessage(new Thinking($text, $signature), new Text($answer))`, or simply `$messages->add(Message::ofAssistant($result))`.

`finish_reason` metadata tells a finished answer from a truncated one:

```php
if ($result->getMetadata()->get('finish_reason')?->is(FinishReasonCase::LENGTH)) { /* cut off */ }
```

Cases: `STOP` `LENGTH` `TOOL_CALL` `CONTENT_FILTER` `STOP_SEQUENCE` `OTHER`.

## Contract — how a MessageBag becomes a request body

Every provider owns a `Contract`: a `Serializer` of normalizers that turns the `MessageBag` into that API's payload shape.

```php
final public function createRequestPayload(Model $model, object|array|string $input, array $options = []): string|array;
Contract::create(array $normalizers = []): self;
```

**Custom normalizers passed to `create()` are placed before the built-ins, so they win.** That is the extension point when a provider wants a shape the bundled normalizer does not produce:

```php
final class MyUserMessageNormalizer implements NormalizerInterface
{
    public function supportsNormalization(mixed $data, ?string $format = null, array $context = []): bool
    {
        return $data instanceof UserMessage;
    }

    public function getSupportedTypes(?string $format): array
    {
        return [UserMessage::class => true];
    }

    public function normalize(mixed $data, ?string $format = null, array $context = []): array
    {
        // $context[Contract::CONTEXT_MODEL]   → the Model
        // $context[Contract::CONTEXT_OPTIONS] → the invoke() options
        return ['role' => $data->getRole()->value, 'content' => '…'];
    }
}

$platform = OllamaFactory::createPlatform($host, contract: OllamaContract::create([
    new MyUserMessageNormalizer(),
]));
```

Start from the bridge's own contract class (`OllamaContract`, `AnthropicContract`, …), not the base `Contract` — the bridge one already registers its provider-specific normalizers.

Do **not** register such a normalizer as an autoconfigured service in a Symfony app: `autoconfigure` would tag it and inject it into the application-wide serializer. Exclude the directory in `services.yaml` and construct it by hand.

## Model catalogs

`$platform->invoke('some-model', …)` asks the provider's catalog to resolve the name into a `Model` (name + `Capability` set + default options). Catalogs are hand-curated and shipped with the bridge, so **a model newer than your installed bridge is simply not there** and the call fails before any request is made.

Three ways out:

1. **Pass a `Model` instance** — bypasses the catalog entirely. Must be the *bridge-specific* subclass (`Gpt`, `Claude`, `Gemini`, `Ollama`, …); clients and converters dispatch on the concrete class, so a bare `Model` has no client.

   ```php
   $model = new Gpt('gpt-newest', [Capability::INPUT_MESSAGES, Capability::OUTPUT_TEXT], ['temperature' => 0.5]);
   $platform->invoke($model, $messages);
   ```

2. **AI Bundle `model:` config** — merged into the built-in catalog, keyed by platform name, and takes precedence over a same-named entry, so it also overrides capabilities.

   ```yaml
   ai:
       model:
           lmstudio:
               qwen3-coder-next:
                   class: 'Symfony\AI\Platform\Bridge\Generic\CompletionsModel'
                   capabilities:
                       - !php/const Symfony\AI\Platform\Capability::INPUT_MESSAGES
                       - !php/const Symfony\AI\Platform\Capability::OUTPUT_TEXT
                       - !php/const Symfony\AI\Platform\Capability::OUTPUT_STREAMING
   ```

3. **`symfony/models-dev`** — replaces a bridge's catalog with the community models.dev registry, updated by `composer update` on its own schedule rather than the framework's.

`Capability` cases: `INPUT_{TEXT,MESSAGES,IMAGE,AUDIO,VIDEO,PDF,MULTIPLE,MULTIMODAL}`, `OUTPUT_{TEXT,IMAGE,AUDIO,STREAMING,STRUCTURED}`, `TOOL_CALLING`, `THINKING`, `EMBEDDINGS`, `RERANKING`, `TEXT_TO_SPEECH(_ASYNC)`, `SPEECH_TO_TEXT`, `TEXT_TO_IMAGE`, `IMAGE_TO_IMAGE`, `TEXT_TO_VIDEO`, `IMAGE_TO_VIDEO`, `VIDEO_TO_VIDEO`, `VIDEO_FRAME_TO_FRAME`, `VIDEO_WITH_SUBJECT`, `FILL_IN_THE_MIDDLE`, `MUSIC`.

**Ollama specifically:** its catalog is not a static list — `ModelCatalog::getModel()` does a live `POST /api/show` against the host. A model that is not pulled there 404s and raises `ModelNotFoundException`, which surfaces as a 500 before a single token streams. Symptom: the model name is right but the host has never pulled it. `Ollama` model names support size variants and query options — `qwen3:32b?temperature=0.5&top_p=0.9`.

## Structured output

Needs the `PlatformSubscriber` on an `EventDispatcher` handed to the factory — without it `response_format` does nothing.

```php
$dispatcher = new EventDispatcher();
$dispatcher->addSubscriber(new PlatformSubscriber());
$dispatcher->addSubscriber(new ValidatorSubscriber());       // optional: throws ValidationException

$platform = Factory::createPlatform($key, eventDispatcher: $dispatcher);

$result = $platform->invoke('gpt-4o', $messages, ['response_format' => MathReasoning::class]);
$obj = $result->asObject();                                   // MathReasoning instance
```

`response_format` also accepts a raw `['type' => 'json_schema', 'json_schema' => [...]]` array (then `asObject()` gives an array), or an **existing object instance** to populate in place (`assert($city === $result->asObject())`). Serializer groups are honoured through `template_options.normalizer_context.groups`.

Streaming it: `['stream' => true, 'response_format' => Recipe::class]` then `foreach ($result->asStreamedObject() as $snapshot)`, or `asPartialJsonStream()` for raw progressive JSON. `PartialJsonParser::parse($buffer, $error)` is the standalone piece.

## Platform decorators

```php
new CachePlatform($platform, cache: new TagAwareAdapter(new FilesystemAdapter('ai_cache')));
new FailoverPlatform([$primary, $fallback], $rateLimiterFactory);   // needs symfony/rate-limiter
new TraceablePlatform($platform);                                    // profiler integration
```

`CachePlatform` keys on model + input + options, so it is only useful for deterministic prompts. `FailoverPlatform` moves to the next platform when one fails — including "the model is not in this provider's catalog", which is how a local Ollama can fall back to a hosted API.

## Testing

```php
new InMemoryPlatform('Fake result');
new InMemoryPlatform(fn ($model, $input, $options) => "Echo: {$input}");
new InMemoryPlatform(fn () => new VectorResult([new Vector([0.1, 0.2, 0.3])]));
new InMemoryPlatform(fn () => new BinaryResult('pdf-bytes', 'application/pdf'));

MockPlatformFactory::createPlatform('Mock result');
MockPlatformFactory::createPlatform(['gpt-4o-mini' => 'cheap', 'gpt-4o' => 'expensive']);
MockPlatformFactory::createPlatform(fn () => new ObjectResult((object) ['city' => 'Paris']));
```

For real traffic recorded once and replayed forever, wrap a provider in `RecordingProvider` with a `Cassette`, or the HTTP client in `CassetteHttpClient` with an `HttpCassette` — the monorepo's own examples do the latter, driven by a `CASSETTE=record|replay` env var. One cassette per run means one shared client instance: appends accumulate, replay consumes FIFO.

## In a Symfony app (AI Bundle)

```yaml
# config/packages/ai.yaml
ai:
    platform:
        ollama:
            endpoint: '%env(OLLAMA_HOST_URL)%'
        gemini:
            api_key: '%env(GEMINI_API_KEY)%'
    agent:
        default:
            platform: 'ai.platform.ollama'
            model: 'gemma3:12b'
```

Service ids follow the config keys: `ai.platform.<name>`, `ai.agent.<name>`, `ai.platform.cache.<name>`, `ai.store.<type>.<name>`. Autowire `PlatformInterface` when there is one platform; use `#[Target('ollama')]` or the explicit service id when there are several. `#[AsInputProcessor]` / `#[AsOutputProcessor]` accept an `agent:` argument to scope a processor to one agent.

## Version drift

The monorepo moves fast and `symfony.com/doc/current` tracks `main`, not your installed version. Check `composer.lock` before trusting a snippet.

The **Platform** component is stable across 0.12 → 0.13: `PlatformInterface`, `Platform`, `Provider`, `ModelRouter`, `Contract`, `DeferredResult` and the delta types are identical. Only change: Gemini/VertexAI now emit **one** terminal `ToolCallComplete` carrying every function call, instead of one per streamed `functionCall` part — code that merged them across deltas should just assign.

**Agent** and **Chat** did break in 0.13:

- `Toolbox\AgentProcessor` removed. Tool calling is no longer an input/output processor pair; pass the toolbox to the `Agent` — `new Agent($platform, $model, toolbox: $toolbox, maxToolCalls: 75, includeSources: true)`.
- `AgentInterface::call()` returns a lazy `Execution`, not a `ResultInterface`. `$agent->call($x)->getContent()` still works, but the agent does not run until consumed, so exceptions surface at `getResult()`/iteration rather than at the `call()` line, and `instanceof` checks need `getResult()` first.
- `Toolbox\StreamListener` and `ChatStreamListener` removed; `call()` with `stream` no longer returns a `StreamResult`.
- A tool-calling round now adds **one** assistant message per turn (text + thinking + tool calls together) instead of splitting it.
- Bundle: agent option `keep_tool_messages` renamed to `exclude_tool_messages` — the old name was inverted against its behavior.

`InputProcessorInterface` / `OutputProcessorInterface` survive; only the toolbox processor went away. That keeps the standard trick working: `Chat::submit()` calls `Agent::call()` with no options, so **an input processor is the only place to set per-call model options** on the Agent path.

```php
final class DefaultInvocationOptions implements InputProcessorInterface
{
    public function __construct(private readonly array $defaults) {}

    public function processInput(Input $input): void
    {
        $input->setOptions([...$this->defaults, ...$input->getOptions()]);   // explicit options win
    }
}
```

## Gotchas

- **`invoke()` is lazy.** Nothing happens until an `as*()` reader runs. Fire N calls in one loop and read them in a second loop to get parallelism; conversely, a call whose result is never read never completes.
- **Filter the stream.** `asStream()` yields thinking, tool-call and metadata deltas alongside text. Echoing everything to an SSE channel leaks reasoning into the answer. `asTextStream()` if text is all you want.
- **`X-Accel-Buffering: no`** on streamed responses, or nginx holds the whole thing.
- **Model catalog before network.** "No provider found for model" / `ModelNotFoundException` is a catalog miss, not an API error — the request was never sent.
- **A bare `Model` has no client.** Instantiate the bridge subclass.
- **`response_format` without `PlatformSubscriber` is silently ignored.**
- **Custom normalizers must not be autoconfigured services** — they would join the app-wide serializer.
- **`MessageBag::with()` vs `add()`** — the first copies, the second mutates. In a loop over prompts you want `with()`.
- Seeds and other large ints: check the bridge; some encode options through JSON where doubles lose precision.
- `Message::ofAssistant()` accepts a `ResultInterface` directly, which is the cheapest correct way to append a finished turn (thinking signatures included) to the bag.

## Siblings

`symfony/ai-agent` (tool calling, processors, multi-agent), `symfony/ai-chat` (`Chat` + `MessageStoreInterface` persistence — session, cache, Doctrine DBAL, Redis, MongoDB, …), `symfony/ai-store` (vector stores + RAG indexers, ~25 backends), `symfony/ai-bundle` (DI wiring), `symfony/mcp-bundle`, `symfony/ai-mate`.

`references/bridges-and-examples.md` in this skill — bridge/factory table, and the example-script index from the monorepo mapped by topic.
