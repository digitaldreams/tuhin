---
name: review
description: Review procedure for task PRs — deterministic tool output first, LLM judgment second, verdict on the board. Use when reviewing a task's pull request or when asked for a task-agent review.
---

# Review

Review one draft PR produced by the task workflow. Output: PR comments plus a
single verdict. Reviewers never push fixes — they report.

## Order matters: tools before opinions

1. **Gather deterministic signal first** (in the PR's worktree or a fresh checkout
   of the branch):
   - `vendor/bin/pint --test` — style
   - `vendor/bin/phpstan analyse` — types/bugs (if installed)
   - `php artisan test` — behavior
   - `gh pr diff <number>` — the actual change
   Any gate failure is an automatic fail verdict; report the output, done.
2. **LLM review only for what tools can't catch**, anchored to diff lines:
   - does the change do what the task + approved plan say, nothing more?
   - missing test cases for the changed behavior (not style preferences)
   - security at trust boundaries: validation, authorization, mass assignment,
     query injection
   - N+1 queries, unbounded queries, missing indexes for new query paths
   - conventions: follows Laravel Boost guidelines and `docs/conventions.md`
3. **Skip entirely**: style nits Pint already enforces, hypothetical refactors,
   scope expansion ("while you're here…"), praise padding.

## Report

Post one PR comment via `gh pr comment` (or reply inline where supported):

```
task-agent review — TASK-<n>

Gates: pint ✓ / phpstan ✓ / tests ✓
Findings:
1. <file:line> — <problem> — <required fix>   (only real findings; empty is fine)

Verdict: PASS | FAIL — <one-line reason>
```

## Verdict → board

- **PASS** → task `status: done`. Note "ready for human merge" in the comment —
  the reviewer never marks the PR ready and never merges.
- **FAIL** → task `status: blocked` with the findings summary as an indented
  board comment. Fixes are a new run's job (human resets status after triage).
