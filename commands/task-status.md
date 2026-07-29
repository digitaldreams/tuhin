---
description: Show the task board - statuses, PRs, blockers
---

Report the current state of the `tasks.md` board. Read-only: change nothing.

1. Parse every task line (`TASK-<n> [tag] title — status: <status>`), including
   indented plan/blocker comments, questions, and PR URLs. Untagged tasks are
   requirements awaiting intake — show them with tag `—`.
2. Cross-check open PRs with `gh pr list --search "TASK-" --state open` when
   `gh` is available; note tasks whose PR was merged or closed but whose status
   wasn't advanced.
3. Read `workflow/<TASK-id>-<slug>/state.md` where it exists for `size` and
   `round` — the board deliberately does not carry them.
4. Render a table: ID | tag | title | status | size | round | PR | note. Group
   order: `blocked` first (with reasons), then `needs-answer` (unanswered
   questions — quote them), `plan-review` (awaiting approval), `review`, `doing`,
   `todo`, `done` last as a count.
5. Report the knobs in force from `workflow/.env` in one line: `PLAN_GATE`,
   `AUTO_MERGE`, `MAX_REVIEW_ROUNDS`.
6. End with one line: what a human should do next (answer questions, approve
   plans, triage blockers, merge ready PRs), or "board idle" if nothing is
   waiting on anyone.
