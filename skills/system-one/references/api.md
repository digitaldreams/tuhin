# System One API reference

Sources: docs.ollama.com/api/systemone, docs.ollama.com/capabilities/decision, docs.typesafe.ai (api, models, sdk/*). Read 2026-10-10.

## Ollama — OpenAPI summary

`POST /v1/systemone`, server `http://localhost:11434`, no security.

**SystemOneRequest** (required: `model`, `state`, `questions`)
- `model` string, non-blank. Local System One model with GGUF weights + scoring-capable runner.
- `state` SystemOneContent: non-empty string | object | array (serialized to JSON text; not chat messages).
- `images` array of base64 strings. Clef/Clef Flash with vision weights only. No URLs, no data URLs. Shared by all questions in order. `state` still required.
- `questions` object, 1–64 entries, non-blank keys, values one of:
  - **Choice** (`type`, `instructions`, `criteria` required): criteria object 2–255 entries, `string | null` values.
  - **Noul** (`type`, `instructions` required): criteria optional `{false: string = "No", true: string = "Yes"}`, no other keys.
  - **Score** (`type`, `instructions`, `criteria` required): criteria array 2–26 strings, index 0 lowest.
- `keep_alive` string | number. Duration (`"5m"`) or seconds; `0` unload after; negative keep loaded. Default server setting (5m).

Note: Ollama's schema types criteria values as strings; TypeSafe accepts objects/arrays there. Structured criteria on Ollama is unverified.

**SystemOneResponse** (`model`, `answers`, `usage` required)
- Choice answer: `type`, `choice`, `probabilities`, `confidence`.
- Noul answer: `type`, `noul` (0–1, probability of true).
- Score answer: `type`, `score` (0–25, not rounded/normalized), `legend` (index-string → description), `probabilities` (index-string keyed), `confidence`.
- `usage.input_tokens`: includes image positions; shared context counted again when questions are scored separately.
- `usage.output_tokens`: internal scoring tokens incl. prefix prep and retries; may exceed question count.
- `confidence` = `1 − H(p)/ln(N)`.

Limits: one JSON response; no streaming/video/tools/generation controls. Nimble and Tev need two spare token positions for scoring. Input never truncated.

Errors: 400, 404, 413 (`"request body must not exceed 64 KiB without images"`), 500.

### Ollama examples

```bash
ollama pull nimble

curl http://localhost:11434/v1/systemone -H 'Content-Type: application/json' -d '{
  "model": "nimble",
  "state": "Our checkout has returned 500 errors since 9am.",
  "questions": {"label": {"type": "choice", "instructions": "Which label fits this ticket?",
    "criteria": {"billing": "Payments and refunds", "bug": "Software errors", "account": "Login and account access"}}}
}'
# → {"model":"nimble","answers":{"label":{"type":"choice","choice":"bug",
#    "probabilities":{"billing":0.0125,"bug":0.9781,"account":0.0093},"confidence":0.8906}},
#    "usage":{"input_tokens":174,"output_tokens":1}}
```

Image judging:
```bash
curl http://localhost:11434/v1/systemone -d '{
  "model": "clef-flash",
  "state": "A user took this screenshot and wants to know what it shows.",
  "images": ["<base64>"],
  "questions": {
    "has_ollama": {"type": "noul", "instructions": "Does this image contain Ollama?"},
    "app": {"type": "choice", "instructions": "Which application is shown in this screenshot?",
      "criteria": {"vscode": "Visual Studio Code", "terminal": "A terminal emulator",
                   "browser": "A web browser", "other": "A different application"}}}
}'
# → has_ollama 0.959; app vscode 0.966, confidence 0.868; input_tokens 677
```

## TypeSafe — HTTP

```
POST https://api.typesafe.ai/v1/systemone
Authorization: Bearer <API_KEY>
Content-Type: application/json
```
Body: `state` (string|object|array), `model` (`jev-latest`), `questions` map.
- Noul: `type`, `instructions`, optional `criteria {true, false}` (each string|object|array).
- Choice: `type`, `instructions`, `criteria` map option → string|object|array|null, max 255.
- Score: `type`, `instructions`, `criteria` array of string|object|array, 2–10 levels.
- Structured fields: `instructions`, choice values, score entries, noul true/false all accept `string | object | array | null` (`EntryType`).

Errors: `401` bad key · `422` validation (body names the field) · `429` rate limit · `529` overloaded. Retry 429/529 with exponential backoff; honor `retry-after`.

`GET /v1/models` → `{models: [{name, description, release_date}]}` (lists aliases; versioned IDs accepted anyway).

Models: `jev-1.13.0`; aliases `jev-latest` (stable), `jev-preview` (currently same). Pin the version if thresholds were tuned against it. Rate limits ~100K tok/s, 80 req/s (dynamic). Not fine-tuned per customer; not trained on customer data.

Gateways (OpenAPI-compatible base URLs): OpenRouter `https://openrouter.ai/api` model `~typesafe/jev-latest`; Vercel `https://ai-gateway.vercel.sh/typesafe` model `typesafe-ai/jev`; Pydantic `https://gateway-us.pydantic.dev/proxy/typesafe` model `jev-latest`.

## Python SDK — `typesafe-sdk` (v0.7.3, Python ≥ 3.10)

```bash
pip install typesafe-sdk          # or: uv add typesafe-sdk ; extra: typesafe-sdk[http2]
```

```python
from typesafe_sdk import Choice, Noul, NoulCriteria, Score, TypeSafeClient

with TypeSafeClient() as client:                     # reads TYPESAFE_API_KEY
    r = client.system_one(
        state={"document": "I was charged twice. Please fix this ASAP."},
        questions={
            "billing": Noul(instructions="Is this ticket about billing?"),
            "tone": Choice(instructions="What is the customer's tone?",
                           criteria={"calm": None, "frustrated": None, "angry": None}),
            "urgency": Score(instructions="How urgent is this ticket?",
                             criteria=["can wait", "this week", "today"]),
            "repeat": Noul(instructions="Has the customer contacted support before?",
                           criteria=NoulCriteria(true="Mentions a prior attempt", false="No sign of prior contact")),
        },
    )
r.answers["billing"].noul ; r.nouls["billing"].noul
r.choices["tone"].choice, .probabilities, .confidence
r.scores["urgency"].score, .legend, .probabilities    # int-keyed
r.model, r.usage.input_tokens, r.request_id, r.raw_http_response
```

- Positional form: `client.system_one(state, questions)`. Questions may be plain dicts (`{"type": "noul", "instructions": …}`), mixed with objects.
- Async: `AsyncTypeSafeClient`, `await client.system_one(...)`, `async with`.
- Client args: `api_key`, `model`, `retry`, `timeout`, `headers`, `transport` | `http_client` (httpx2, exclusive), `base_url`.
- Call args: `model`, `retry`, `timeout`, `extra_headers`, `extra_body` (shallow merge, last write wins), `response_model` (pydantic).
- Typed responses:
  ```python
  class BillingResponse(SystemOneResponse):
      billing: NoulAnswer
  r = client.system_one(state, {"billing": Noul(instructions="…")}, response_model=BillingResponse)
  r.billing.noul
  ```
- `client.models.list().models` → `name, description, release_date`.
- `RetryPolicy(max_retries=2, backoff_initial=0.5, backoff_max=5.0, backoff_jitter=0.25, http_statuses={408,429,500..599}, respect_retry_after=True, api_connection_error=True, api_timeout_error=True, exceptions=set(), predicate=None, timeout=30.0)`; `max_retries=0` disables.
- Exceptions: `TypeSafeError` ⊃ `TypeSafeAPIError` (`status, body, headers, endpoint, request_id`) ⊃ BadRequest 400, Authentication 401, PermissionDenied 403, NotFound 404, UnprocessableEntity 422, RateLimit 429 (`retry_after_ms`), InternalServer 5xx, `TypeSafeAPIResponseValidationError` (`field_path`); `TypeSafeAPIConnectionError` ⊃ `TypeSafeAPITimeoutError`.
- Raises `TypeSafeError` locally if state is None, questions empty, choice/score has no criteria, or noul has neither instructions nor criteria.
- Env: `TYPESAFE_API_KEY` (required), `TYPESAFE_BASE_URL` (`https://api.typesafe.ai`), `TYPESAFE_DEFAULT_MODEL` (`jev-latest`), `TYPESAFE_LOG_LEVEL` (debug/info/warning/error/off). Default timeout 10s.
- Logger `typesafe_sdk`; secret headers redacted, bodies not.
- Perf: reuse clients; one client per thread under load; `httpx-aiohttp` for high-rate async; default pool 100 connections, 30s keepalive; HTTP/2 only for low-moderate concurrency.
- Unknown answer kinds are skipped with a warning; read `raw_http_response.json()`.

## JS/TS SDK — `@typesafe-ai/sdk` (v0.6.0, Node ≥ 20)

```ts
import { choice, noul, score, TypeSafeClient } from "@typesafe-ai/sdk";
const client = new TypeSafeClient();                  // TYPESAFE_API_KEY
const { answers } = await client.systemOne({
  state: { document: "I was charged twice. Please fix this ASAP." },
  questions: {
    category: choice("What is this ticket about?", { billing: null, technical: null, other: null }),
    refund: noul("Is a refund requested?", { true: "Asks for money back", false: "No refund asked" }),
    urgency: score("How urgent?", ["can wait", "this week", "today"] as const),
  },
});
answers.category.choice; answers.refund.noul; answers.urgency.score;
```
- Answer types inferred from questions (`ResultFor<T>`); tuple score criteria give typed legend keys.
- Config: `apiKey, baseURL, defaultModel, defaultHeaders, fetch, logger, logLevel ("debug"|"info"|"warn"|"error"|"off"), retry (Partial<RetryPolicy>), timeout (ms per attempt, default 10000), dangerouslyAllowBrowser`.
- Per call: `{ headers, retry, signal, timeout }`.
- `APIPromise`: `.withResponse()` → `{data, response, requestId}`, `.asResponse()`, `.map(fn)`.
- RetryPolicy: `maxRetries 2, backoffInitialMs 500, backoffMaxMs 5000, backoffJitter 0.25, httpStatuses 408/429/5xx, respectRetryAfter true, maxRetryAfterMs 60000, apiConnectionError true, apiTimeoutError true`.
- Errors: `TypeSafeError` ⊃ `APIError` (`status, body, headers, requestId`) ⊃ BadRequest, Authentication, PermissionDenied, NotFound, UnprocessableEntity, RateLimit, InternalServer; plus `APIConnectionError`, `APITimeoutError`, `APIUserAbortError`.
