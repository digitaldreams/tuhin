# Bridges and example scripts

## Bridges

All under `Symfony\AI\Platform\Bridge\<Name>`, each with a `Factory` exposing `createProvider(...)` and `createPlatform(...)` taking the same arguments.

| Bridge | Ships in | Covers |
|---|---|---|
| `OpenAi` | `symfony/ai-platform` | GPT, embeddings, Whisper, GPT Image, TTS, server tools |
| `Anthropic` | `symfony/ai-platform` | Claude, prompt caching, server tools |
| `Gemini` | `symfony/ai-gemini-platform` | Gemini chat, embeddings, voice, server tools |
| `VertexAi` | `symfony/ai-platform` | Gemini + Vertex Gen AI on GCP |
| `Ollama` | `symfony/ai-ollama-platform` | any local Ollama model; live catalog |
| `Bedrock` | `symfony/ai-platform` | Claude, Nova, Llama on AWS |
| `Azure` | `symfony/ai-platform` | GPT + Llama deployments |
| `Mistral` | `symfony/ai-platform` | chat, embeddings, OCR, audio |
| `Generic` | `symfony/ai-platform` | any OpenAI-compatible endpoint; needs an explicit `ModelCatalog` |
| `OpenRouter` `LiteLLM`* | `symfony/ai-platform` | multi-provider gateways (*LiteLLM via `Generic`) |
| `LmStudio` `DockerModelRunner` `TransformersPhp` | `symfony/ai-platform` | other local runtimes |
| `HuggingFace` | `symfony/ai-platform` | inference API, ~20 task types |
| `ElevenLabs` `Deepgram` `Cartesia` | `symfony/ai-platform` | TTS + STT |
| `Decart` | `symfony/ai-platform` | text→image, text→video |
| `Voyage` `Cohere` | `symfony/ai-platform` | embeddings, reranking |
| `DeepSeek` `Perplexity` `Cerebras` `Scaleway` `Ovh` `Albert` `AmazeeAi` `AiMlApi` `MiniMax` `Meta` `Replicate` | `symfony/ai-platform` | further hosted providers |
| `ClaudeCode` `Codex` | `symfony/ai-platform` | local coding-agent CLIs as a platform |
| `OpenResponses` | `symfony/ai-platform` | OpenAI Responses API shape |
| `ModelsDev` | `symfony/models-dev` | catalog source, not an inference backend |
| `Cache` | `symfony/ai-cache-platform` | `CachePlatform` decorator |
| `Failover` | `symfony/ai-platform` | `FailoverPlatform` decorator |

Bridge-specific factory arguments vary; the shared shape is roughly `(endpointOrApiKey, ?apiKey, ?HttpClientInterface $httpClient, ?Contract $contract, ?EventDispatcherInterface $eventDispatcher, string $name, ?ModelRouterInterface $modelRouter)`. Read the bridge's `Factory.php` in `vendor/` rather than assuming — the leading arguments differ (Ollama takes an endpoint first, OpenAI an API key).

## Example scripts

In [symfony/ai](https://github.com/symfony/ai) under `examples/`. Every script is standalone, requires `examples/bootstrap.php`, and reads config from `examples/.env`. They double as an HTTP-cassette test suite: `CASSETTE=record` writes fixtures, `CASSETTE=replay` runs offline.

Grouped by what you'd be looking for rather than by provider — most patterns exist under several providers, so `openai/stream.php`, `gemini/stream.php` and `ollama/stream.php` are the same script against different backends.

### Platform-level

| Want | Script |
|---|---|
| plain chat | `<provider>/chat.php` |
| streaming | `<provider>/stream.php` |
| streaming with reasoning | `openai/stream-reasoning.php`, `gemini/stream-thinking.php`, `mistral/chat-stream-reasoning.php` |
| token usage | `<provider>/token-metadata.php`, `<provider>/stream-token-metadata.php`, `ollama/chat-llama-with-token-usage.php` |
| finish reason | `misc/finish-reason.php` |
| parallel calls | `misc/parallel-chat-gpt.php`, `misc/parallel-embeddings.php` |
| caching | `misc/agent-with-cache.php`, `misc/agent-with-external-cache.php` |
| failover | `misc/failover-platform.php` |
| prompt from a file | `misc/prompt-text-file.php`, `misc/prompt-json-file.php` |
| system prompt | `misc/chat-system-prompt.php` |
| model catalogs | `models-dev/catalog.php`, `models-dev/discovery.php`, `openrouter/cached-api-model-catalog.php` |

### Modalities

| Want | Script |
|---|---|
| image input | `<provider>/image-input-binary.php`, `image-input-url.php` |
| image generation / editing | `openai/image-generation.php`, `openai/image-editing-gpt-image-1.php`, `gemini/image-editing.php`, `decart/text-to-image.php` |
| video | `decart/text-to-video.php`, `decart/animated-image.php` |
| PDF input | `<provider>/pdf-input-binary.php`, `mistral/pdf-input-url.php` |
| OCR | `mistral/ocr-binary.php`, `mistral/ocr-url.php` |
| audio input | `openai/audio-input.php`, `gemini/audio-input.php`, `mistral/audio-understanding.php` |
| transcription (STT) | `openai/audio-transcript.php`, `elevenlabs/speech-to-text.php`, `deepgram/speech-to-text.php`, `cartesia/speech-to-text.php` |
| subtitles from STT | `elevenlabs/speech-to-text-srt.php` |
| TTS | `openai/audio-output.php`, `elevenlabs/text-to-speech.php`, `gemini/single-speaker-voice.php`, `gemini/multi-speaker-voice.php` |
| streamed TTS | `elevenlabs/text-to-speech-as-stream.php` |
| STT → LLM → TTS chain | `speech/agent-openai-eleven-labs-speech-sts.php` |
| embeddings | `<provider>/embeddings.php`, `voyage/multimodal-embeddings.php` |

### Structured output

| Want | Script |
|---|---|
| basic | `<provider>/structured-output-math.php` |
| nested objects | `platform/structured-output-nested-objects.php` |
| populate an existing instance | `platform/structured-output-populate-object.php` |
| streamed objects | `platform/streaming-structured-output.php` |
| partial JSON from a stream | `platform/partial-json-stream.php` |
| polymorphic / union types | `openai/structured-output-list-of-polymorphic-items.php`, `openai/structured-output-union-types.php` |
| custom schema provider | `openai/structured-output-schema-provider.php` |

### Tool calling (Agent component)

`<provider>/toolcall.php`, `toolcall-stream.php`, `toolcall-roundtrip.php`, `anthropic/toolcall-parallel.php`, `agent/toolcall-limit.php`, `agent/toolcall-nested-objects.php`, `agent/toolcall-polymorphic-interface.php`. Ready-made tools under `toolbox/`: `clock`, `brave`, `tavily`, `serpapi`, `firecrawl-*`, `mapbox-*`, `ollama-web-search`, plus `confirmation.php` (human-in-the-loop) and `validation.php`.

Provider-hosted tools: `<provider>/server-tools*.php`, `openai/web-search.php`, `openai/code-interpreter.php`, `openai/file-search.php`, `openai/mcp.php`.

### Agent, Chat, RAG

| Want | Script |
|---|---|
| lazy execution / observing a run | `agent/execution-callbacks.php`, `agent/execution-iterable.php` |
| multi-turn reasoning | `agent/multi-turn-thinking.php`, `agent/multi-turn-thinking-stream.php`, `agent/multi-turn-reasoning-stateless.php` |
| persisted conversation | `chat/persistent-chat.php` + one per backend (`-session`, `-cache`, `-doctrine-dbal`, `-redis`, `-mongodb`, `-meilisearch`, `-surrealdb`, `-cloudflare`, `-pogocache`) |
| streamed chat with history | `chat/stream-chat.php` |
| memory | `memory/static.php`, `memory/mariadb.php` |
| multi-agent orchestration | `multi-agent/orchestrator.php`, `openai/subagents.php`, `gemini/subagents.php` |
| RAG | `rag/in-memory.php` first, then one per store (~25: postgres, qdrant, pinecone, chromadb, milvus, weaviate, redis, mongodb, elasticsearch, opensearch, meilisearch, typesense, neo4j, clickhouse, sqlite-vec, supabase, …) |
| agentic / hybrid search | `rag/agentic-search.php`, `rag/hybrid-reranking.php`, `rag/meilisearch-hybrid.php` |
| indexing pipeline | `indexer/index-documents.php`, `index-file-loader.php`, `index-rss-loader.php`, `index-with-filters.php`, `chunk-delay.php`, `summary-generator.php` |
| retrieval | `retriever/basic.php`, `hybrid-rrf.php`, `hybrid-rrf-reranking.php`, `query-expansion.php` |
| document splitting / vectorizing | `document/splitting.php`, `document/vectorizing.php`, `document/vectorizing-text-documents.php` |

There is also a full Symfony application under `demo/` in the monorepo — the closest thing to a reference integration.
