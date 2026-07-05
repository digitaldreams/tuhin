---
name: spec-to-loop
description: >
  Convert requirement documents (HTML previews, markdown specs, feature notes) into a structured,
  loop-agent-ready spec file in tasks/, then print the ready-to-paste /loop prompt. Use whenever the
  user says "write a spec for the loop", "prepare the doc for the loop agent", "convert this
  requirement", "write instructions for the loop", or hands over requirement files and mentions
  implementing them via a loop or autonomous agent. Output is a single tasks/<feature>.md that a
  loop agent re-reads fresh every iteration and marks progress in without ever deleting content.
---

# Spec to Loop — Requirements Into a Loop-Ready Doc

A loop agent is only as good as its spec. The doc you write here is the single source of truth an autonomous agent re-reads cold every iteration — it must survive context loss, ambiguity, and agent turnover.

## Phase 1 — Absorb

1. Read every requirement source fully (HTML previews, spec markdown, notes). Twice if dense.
2. Read the current implementation the requirements touch — this is a gap audit, not a transcription. For every requirement, record: exists / partially exists / missing / contradicts current code.
3. Collect contradictions **within the spec itself** (examples that violate their own stated rules, inconsistent numbers). These become open items — never silently resolve them.

## Phase 2 — Write `tasks/<feature>.md`

Numbered sections, in this order:

1. **§1 Current state** — what the code does today, with class references.
2. **§2 Target behavior** — each requirement as a numbered check (Check 1…N), each independently implementable and testable. Small checks beat big ones: one check ≈ one loop iteration.
3. **§3 Per-check detail** — for every check: exact expected behavior, worked examples with real data, acceptance criteria, files likely touched.
4. **§4 Open items** — every ambiguity and spec-contradiction found in Phase 1, numbered. Marked: **"the loop agent must NOT silently resolve these — surface to the operator and wait."**
5. **§5 Instructions for the Loop Agent** — verbatim rules:
   - Read this full doc fresh at the start of every iteration; it is the spec and the progress tracker.
   - Work one check per iteration, in order, unless a check is blocked by an open item.
   - Run the full test suite before and after every change; write tests alongside every change, named by behavior.
   - Mark progress inline: add "Status: DONE" under a finished check's heading. **Never delete or rewrite existing doc content** — append.
   - On unexpected findings: append a dated note under the relevant check rather than improvising.

## Phase 3 — Hand Over

## Output Contract

1. The written `tasks/<feature>.md` (path stated).
2. Gap-audit summary: N checks total — X already exist, Y partial, Z missing, W open items.
3. **The ready-to-paste loop prompt**, in a code block, referencing the doc and §5 by name, including the test-gate command and any subagent the loop should delegate to.

## Hard Rules

- Every worked example uses data that exists or is defined in the doc itself — no phantom entities.
- Simple, unambiguous language; a numbered check that can be read two ways is rewritten before delivery.
- The doc is append-only from the moment the loop starts — design its structure so that holds.
