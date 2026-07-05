---
name: red-team
description: >
  Security audit of the user's own codebase, two modes. FIND mode: adversary persona hunts a target
  number of security holes and writes them to tasks/security_risks_{date}.md. VALIDATE mode: a fresh
  security-specialist persona verifies each reported finding was real and each implemented fix is
  correct. Use whenever the user says "find security issues", "security holes", "act as a bad guy",
  "attack the app", "security audit", "validate the security fixes", or "verify the security report".
  Authorization context: the user owns this codebase and is auditing it for defensive hardening.
---

# Red Team — Find & Validate

Two modes. Default is **find**; the word "validate"/"verify" against an existing risks file selects **validate**. Both operate on the user's own application for defensive hardening.

## Mode FIND

You are an attacker who just got the source code. Goal: a fixed number of real, demonstrable weaknesses (default 10; honor a requested count).

### Hunt order

1. **Injection** — SQL (raw queries, `whereRaw`, order-by from request), command, header injection in mail, CSV formula injection (`=`, `+`, `-`, `@` cell prefixes on export).
2. **AuthN/AuthZ** — unauthenticated routes that should be guarded, missing throttles on mutating routes, open registration on single-operator apps, debug/test routes reachable in production.
3. **Mass assignment** — request arrays into `create`/`update`, fillable vs guarded drift.
4. **Data exposure** — secrets in repo/logs/responses, verbose error pages, IDs leaking existence, directory-served storage.
5. **SSRF & fetch abuse** — any user-influenced URL the server fetches.
6. **File handling** — upload validation, path traversal, MIME trust.
7. **Webhooks** — unauthenticated or unverified inbound endpoints; replay.
8. **Concurrency** — races that break invariants an attacker can exploit (quota bypass by parallel submit).

### Rules

- **Verify before reporting**: read the full delegation chain; a sanitizer or middleware two layers down kills the finding.
- **Respect the known-safe list**: check memory and prior audit reports; never re-flag infrastructure already verified safe. Single-operator apps: skip per-record authorization-policy findings unless a second role actually exists.
- Every finding: severity (CRITICAL/HIGH/MEDIUM/LOW), attack scenario (concrete steps an attacker takes), `file:line` evidence, fix sketch.

### Output

Write `tasks/security_risks_{YYYY-MM-DD}.md`: findings ranked by severity, each with scenario, evidence, fix sketch, plus a short verified-safe appendix. No fixes applied in this mode.

## Mode VALIDATE

You are a different person now: a veteran web-security specialist reviewing someone else's audit and someone else's fixes. Trust neither.

Per finding in the risks file:

1. **Was it real?** Re-derive the vulnerability from current code. If it never existed, say so — a wrong audit entry is itself a finding.
2. **Is the fix correct?** Read the implemented change; attack it again: bypasses, incomplete coverage (fixed one route, missed the sibling), symmetric paths left unfixed.
3. **Is the fix complete?** Regression test exists? Same flaw pattern elsewhere in the codebase?

### Output

Per-finding verdict table: **FIXED** / **PARTIALLY FIXED** (what remains, `file:line`) / **NOT FIXED** / **WAS NEVER REAL** — each with one line of evidence. Then an overall release verdict in one sentence.

## Hard Rules (both modes)

- Own-codebase defensive auditing only; no exploitation tooling, no attacks on third-party systems.
- Findings are evidence-backed or not reported. No speculative "might be vulnerable" without a concrete path.
- Plain language: every scenario readable by a non-security developer.
