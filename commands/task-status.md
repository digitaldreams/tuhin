---
description: Show the task board - statuses, PRs, blockers
---

Report the current state of the `tasks.md` board. Read-only: change nothing.

1. Parse every task line (`TASK-<n> [tag] title — status: <status>`), including
   indented plan/blocker comments and PR URLs.
2. Cross-check open PRs with `gh pr list --search "TASK-" --state open` when
   `gh` is available; note tasks whose PR was merged or closed but whose status
   wasn't advanced.
3. Render a table: ID | tag | title | status | PR | note. Group order:
   `blocked` first (with reasons — these need a human), then `plan-review`
   (awaiting approval), `review`, `doing`, `todo`, `done` last as a count.
4. End with one line: what a human should do next (approve plans, triage
   blockers, merge ready PRs), or "board idle" if nothing is waiting on anyone.
