---
name: gmail-api-laravel
description: Use when integrating, building, or debugging the Gmail API in a Laravel/PHP app — sending, reading, replying/threading, push notifications (Cloud Pub/Sub watch + history), OAuth vs service-account domain-wide delegation, reply/bounce detection, deliverability, or the google-api-php-client (Google\Model) library. Triggers on "Gmail API", "google/apiclient", "Gmail OAuth", "Gmail webhook", "watch()/history.list", "domain-wide delegation", "send/read email Laravel".
---

# Gmail API + Laravel

Reference + playbook for Gmail integration. Read the relevant section; don't
re-research the basics. Verify exact SDK method names against the installed
`google/apiclient` version when in doubt.

## 1. FIRST DECISION: which auth mode

| | Service account + domain-wide delegation | Per-inbox OAuth2 |
|---|---|---|
| Works with | **Google Workspace** (own domain) | Any Gmail incl. **free @gmail.com** |
| Consent screen / verification | **None** — admin grants scopes in Admin console | App verification required at scale |
| `gmail.send` (sensitive) verification | bypassed | CASA Tier 2 |
| `gmail.readonly` (restricted) verification | **bypassed** | CASA Tier 3 (pen-test, annual, $$$) |
| Impersonation | `$client->setSubject($inboxEmail)` | none (you ARE the user) |
| Token | service-account JSON key | per-user refresh token |

**Rules of thumb:**
- Workspace on a domain you control → **delegation**. Avoids the entire OAuth
  verification/CASA cost, even for reading mailboxes. Best path.
- Free @gmail.com → **OAuth only**. Service accounts **cannot** send/read consumer
  Gmail (no mailbox, no delegation) → `403 Delegation denied`.
- Local dev when client will later give a Workspace service account: develop on
  **OAuth against your own gmail**, keep auth behind a swappable seam (§7), flip to
  delegation at handover with **zero code change**.
- OAuth "Testing" publishing mode: no verification/CASA for listed **test users**,
  but **refresh tokens expire after 7 days** + 100-user cap + unverified-app warning.

Scopes for send+read+reply: `gmail.send` + `gmail.readonly`.

## 2. Library essentials — `Google\Client` + `Google\Model`

Every Gmail object (`Message`, `MessagePart`, `WatchRequest`, `Draft`…) extends
`Google\Model` (JSON⇄object translator).
- **Build with setters**, read with **getters** (`$msg->setRaw()`,
  `$msg->getPayload()->getHeaders()`). Typed; typo'd setters error, typo'd
  properties silently vanish (`#[AllowDynamicProperties]`).
- `Model::NULL_VALUE` to send an explicit `null` (normally nulls are dropped).
- `composer require google/apiclient:^2.18`.

Authenticated service:
```php
// OAuth:
$client->setClientId(...); $client->setClientSecret(...); $client->setRedirectUri(...);
$client->setScopes([Gmail::GMAIL_SEND, Gmail::GMAIL_READONLY]);
$client->setAccessType('offline'); $client->setPrompt('consent');   // ← needed for refresh token
$client->fetchAccessTokenWithRefreshToken($refreshToken);
// Delegation:
$client->setAuthConfig(json_decode($serviceAccountJson, true));
$client->setScopes([Gmail::GMAIL_SEND, Gmail::GMAIL_READONLY]);
$client->setSubject($inboxEmail);
$gmail = new Gmail($client);
```

## 3. SEND

`users.messages.send('me', new Message(['raw' => $base64url]))`. Raw = base64url
RFC-2822. Build it yourself for control. Quality lives in the MIME:
- **multipart/alternative**: always include text **and** html part.
- Headers: `From`, `To`, `Subject`, **stamp your own `Message-ID: <uuid@domain>`**
  (so replies/bounces match), `MIME-Version: 1.0`.
- Bulk: `List-Unsubscribe` + `List-Unsubscribe-Post: List-Unsubscribe=One-Click`.
- Unicode subject: RFC-2047 `=?UTF-8?B?<base64>?=`.
- Inline images: `multipart/related` + `Content-ID` + `<img src="cid:...">`.
- **Strip `\r\n` from every header value** (header-injection guard).
- Gmail **preserves** a Message-ID header you set → reply `In-Reply-To` will match it.
- `send()` returns a Message; `getId()` (Gmail internal id) + `getThreadId()`. Store
  your **stamped Message-ID** and the **threadId** for matching, not getId().
- Preview before send: `drafts.create` → `drafts.send`.
- Caps: Workspace 2,000 sends/day, free Gmail 500/day, 500 recipients/msg.

## 4. READ + REPLY

- List: `users_messages->listUsersMessages('me', ['q' => 'in:inbox is:unread'])` →
  ids → `get('me', $id, ['format' => 'metadata'|'full', 'metadataHeaders' => [...]])`.
- Parse headers: loop `$msg->getPayload()->getHeaders()` (name/value).
- **Reply in-thread** = set `In-Reply-To` + `References` = original Message-ID,
  `Subject: Re: …`, AND pass `threadId` on send:
  `send('me', new Message(['raw' => $raw, 'threadId' => $threadId]))`.

## 5. WEBHOOKS / PUSH (no plain webhook — it's Pub/Sub)

Flow: **mailbox change → `watch()` publishes → Cloud Pub/Sub topic → Pub/Sub HTTP
POST → your endpoint**. The notification is **only** `{emailAddress, historyId}` —
a bookmark, NOT the email.

Setup: Pub/Sub topic → grant `gmail-api-push@system.gserviceaccount.com` Publisher
→ push subscription → your URL. Then:
```php
$gmail->users->watch('me', new WatchRequest(['topicName'=>$topic, 'labelIds'=>['INBOX']]));
// returns historyId (seed cursor) + expiration (ms epoch, ~7 days)
```
On notification, pull changes:
```php
$gmail->users_history->listUsersHistory('me', ['startHistoryId'=>$cursor, 'historyTypes'=>'messageAdded']);
// walk getHistory()->getMessagesAdded(), messages.get each, then advance cursor
```
**Critical rules (cost real bugs):**
1. Advance the stored `historyId` **only after** processing the whole batch.
2. **Follow `nextPageToken` to exhaustion** before advancing the cursor.
3. Push is best-effort (drops/delays, ≤1/sec/user) → **also run a polling reconcile
   on a timer** (same history code). Push = doorbell; `history.list` = open door.
4. **`watch()` expires in 7 days → renew daily.**
5. Notifications can arrive with a historyId whose history has no relevant records →
   handle empty idempotently, never error.
6. `getExpiration()` is **absolute epoch-ms**, not a duration →
   `CarbonImmutable::createFromTimestampMs(...)`.

Endpoint security: gate by a shared-secret token on the push URL
(`?token=…` + `hash_equals`) or verify the Pub/Sub OIDC JWT. CSRF-exempt the route
(`preventRequestForgery(except: ['webhooks/*'])`). Always return 2xx so Pub/Sub
doesn't redeliver; offload work to a queued job.

## 6. CLASSIFY INBOUND: reply vs bounce

- **Reply**: same `threadId` as a sent email, or `In-Reply-To` == your stamped
  `Message-ID`. → record + suppress contact (suppression permanent).
- **Bounce (NDR)**: `From` is `mailer-daemon@`/`postmaster@`, or `Content-Type:
  multipart/report; report-type=delivery-status`. Lands in the same thread →
  threadId is the reliable join. → flag bad address (feed bounce-rate monitor).
- Skip your own outbound copies (From == inbox) and unmatched messages.

## 7. LARAVEL ARCHITECTURE PATTERN (proven)

- **Swappable auth seam**: `interface GmailClientFactory { gmailFor(Inbox): Gmail; }`
  with `DelegatedGmailClientFactory` (prod) + `OAuthGmailClientFactory` (local).
  Bind by config `GMAIL_AUTH_MODE` (delegation|oauth). All send/read/reply/watch
  code depends on the interface → environment swap = config only.
- Store **encrypted** `refresh_token` per mailbox (`'refresh_token' => 'encrypted'`
  cast). Plus `history_id` + `watch_expires_at` columns.
- `gmail:connect {email}` artisan command for one-time OAuth (dev).
- Send driver returns a small `SendResult(messageId, gmailThreadId)` DTO; persist
  both (message_id matches In-Reply-To; threadId matches bounces).
- Inbound: thin **webhook controller** → queued job → **service** holds domain logic
  (read history, classify, suppress, advance cursor; idempotent via stored cursor +
  `firstOrCreate`). Scheduled **reconcile job** = polling fallback + local driver
  (`gmail:reconcile`).
- Cross-module suppression via a **domain event** (don't import another module's
  service); the owning module listens and suppresses.
- Symmetry: any API-batch path and cache/sync path must apply identical
  post-processing.

## 8. WHAT THE API DOES NOT GIVE (set expectations)

- No "delivered to recipient" receipt — only "accepted by Gmail." Silence ≈ ok.
- No open/click tracking (pixel/redirect hacks only; privacy + spam caveats).
- Bounce is **not** an API event — it's an inbound NDR email you must detect.

## 9. QUOTA (API units ≠ send caps)

6,000 units/min/user. send=100, watch=100, history.list=2, messages.get=20,
messages.list=5. Usually the binding limit is the per-mailbox **send cap**, not units.

## 10. COMMON ERRORS

- `invalid_grant` → OAuth refresh token expired (Testing mode 7-day) or revoked → reconnect.
- `redirect_uri_mismatch` → URI must match Console exactly (scheme/host/port/path).
- `403 Delegation denied` / `failed_precondition` → tried service-account on consumer
  Gmail, or delegation scopes not granted in Workspace admin (must match exactly).
- `Request had insufficient authentication scopes` → token predates an added scope → reconsent.
- Reply not threading → need BOTH `threadId` on send AND `In-Reply-To`/`References` headers.

## Reference docs
- Sending: https://developers.google.com/gmail/api/guides/sending
- Push (watch+Pub/Sub): https://developers.google.com/gmail/api/guides/push
- History list: https://developers.google.com/gmail/api/reference/rest/v1/users.history/list
- Messages: https://developers.google.com/gmail/api/reference/rest/v1/users.messages
- Scopes: https://developers.google.com/gmail/api/auth/scopes
- OAuth web-server flow: https://developers.google.com/identity/protocols/oauth2/web-server
- Quota: https://developers.google.com/gmail/api/reference/quota
- PHP client: https://github.com/googleapis/google-api-php-client
