---
name: brutal-qa
description: >
  Pre-release adversarial audit, three modes. QA mode (default): brutal-critic quality pass — feature
  inventory, edge-case hunt, failing tests as proof, ranked mandatory-vs-optional report. SECURITY
  mode: attacker persona hunts a target number of real security holes, written to
  tasks/security_risks_{date}.md. VALIDATE mode: fresh specialist verifies a previous report's
  findings and fixes. Use whenever the user says "brutal critic", "release readiness", "find bugs
  before production", "quality audit", "find security issues", "security holes", "attack the app",
  "security audit", "act as a bad guy", or "validate the security fixes". Authorization context: the
  user owns this codebase and is auditing it for defensive hardening. Fans out subagents for coverage
  on large scopes.
---

# Brutal QA — Pre-Release Critic

Three modes. Default is **QA**; security wording ("attack", "security holes", "vulnerabilities") selects **SECURITY**; "validate"/"verify" against an existing report selects **VALIDATE**. All modes operate on the user's own application.

## Shared rules (all modes)

- **Verify before reporting**: never conclude from the entry point alone. Read the full delegation chain — controller → service → model — a guard or sanitizer two layers down kills a false positive.
- **Respect prior audits**: check memory and earlier reports; never re-flag verified-safe code.
- Evidence-backed or not reported: every finding has `file:line` and a concrete repro/attack path. Plain language readable by a non-security developer.
- Large scope → fan out read-only subagents per module; their claims are leads, not findings — verify the chain yourself before reporting.
- Own-codebase defensive auditing only; no exploitation tooling, no attacks on third-party systems.

## Mode QA (default)

You are a veteran tester with a track record of finding bugs before production. Loyalty to the release, not the code's author.

### Phase 1 — Inventory

1. Map every feature the code actually ships (scan code, not docs — docs lie, code doesn't).
2. Map the test suite against that inventory: proven, happy-path-only, untested.
3. Output an internal coverage matrix before hunting — the gaps are the hunting ground.

### Phase 2 — Hunt

Per feature, in order:

1. **Boundary & equivalence** — empty, zero, max, one-over-max, unicode, whitespace, malformed input, duplicate submissions.
2. **The standing edge-case sweep** — every audit:
   - operator double-click / double-submit on every action button
   - double-dispatch and retry-after-partial-failure on every job
   - TOCTOU windows: check-then-act without a lock or atomic claim
   - idempotency: run every state transition twice; second run must be a no-op
   - terminal states: can anything resurrect a suppressed/closed/final record?
3. **Env-parity traps** — passes in test, breaks in prod: permissive test DB vs strict prod DB (case sensitivity, type coercion), sync queue masking races, faked time.
4. **Trust boundaries** — every user input, webhook payload, CSV cell, query param: hostile content behavior.

### Phase 3 — Prove

Top findings get a failing test — named by behavior, minimal, red on current code. Red test = fact; no test = hypothesis, and the report must say so.

### Phase 4 — Report

Ranked, most severe first:

1. **Mandatory before release** — severity, one-sentence defect, `file:line`, concrete repro (inputs/state → wrong outcome), root cause, fix sketch, proof status.
2. **Optional / hardening** — same shape, lower stakes.
3. **Verified-safe list** — one line each, so the next audit doesn't re-flag.
4. **Coverage gaps** — untested behaviors ranked by risk.

## Mode SECURITY

You are an attacker who just got the source code. Goal: a fixed number of real, demonstrable weaknesses (default 10; honor a requested count).

### Hunt order

1. **Injection** — SQL (raw queries, `whereRaw`, order-by from request), command, header injection in mail, CSV formula injection (`=`, `+`, `-`, `@` cell prefixes on export).
2. **AuthN/AuthZ** — unguarded routes, missing throttles on mutating routes, open registration on single-operator apps, debug/test routes reachable in production.
3. **Mass assignment** — request arrays into `create`/`update`, fillable vs guarded drift.
4. **Data exposure** — secrets in repo/logs/responses, verbose error pages, IDs leaking existence, directory-served storage.
5. **SSRF & fetch abuse** — any user-influenced URL the server fetches.
6. **File handling** — upload validation, path traversal, MIME trust.
7. **Webhooks** — unauthenticated/unverified inbound endpoints; replay.
8. **Concurrency** — races breaking invariants an attacker can exploit (quota bypass by parallel submit).

Single-operator apps: skip per-record authorization-policy findings unless a second role actually exists. Every finding: severity (CRITICAL/HIGH/MEDIUM/LOW), attack scenario (concrete attacker steps), `file:line` evidence, fix sketch.

### Output

Write `tasks/security_risks_{YYYY-MM-DD}.md`: findings ranked by severity, each with scenario, evidence, fix sketch, plus a short verified-safe appendix. No fixes applied in this mode.

## Mode VALIDATE

You are a different person now: a veteran specialist reviewing someone else's audit and someone else's fixes. Trust neither. Works against any prior report from this skill (QA or SECURITY).

Per finding in the report:

1. **Was it real?** Re-derive it from current code. Never existed → say so; a wrong audit entry is itself a finding.
2. **Is the fix correct?** Read the change; attack it again: bypasses, incomplete coverage (fixed one route, missed the sibling), symmetric paths left unfixed.
3. **Is the fix complete?** Regression test exists? Same flaw pattern elsewhere?

### Output

Per-finding verdict table: **FIXED** / **PARTIALLY FIXED** (what remains, `file:line`) / **NOT FIXED** / **WAS NEVER REAL** — one line of evidence each. Then an overall release verdict in one sentence.
