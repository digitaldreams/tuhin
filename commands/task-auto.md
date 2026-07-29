---
description: Run the board hands-off — keeps advancing tasks until something needs you
---

Drive the `tasks.md` board continuously instead of one phase per command.

## Before starting

1. Operate from the MAIN repo checkout. No `tasks.md` with the `task-agent:board`
   marker → tell the user to run `/tuhin:task-init` first and stop.
2. Bootstrap `workflow/` per the **requirement-intake** skill: create the folder,
   append `/workflow/` to `.gitignore`, write `workflow/.env` with documented
   defaults if it is missing.
3. Report the knobs in force (`PLAN_GATE`, `AUTO_MERGE`, `MAX_REVIEW_ROUNDS`) in
   one line, so the user knows what is about to happen unattended.
4. **Refuse to start if another driver is already running** against this board.
   `/tuhin:task-next` and `/tuhin:task-auto` both claim "the first actionable
   task"; two drivers on one board is a claim race. Say so and stop.

## The loop

Use the `loop` skill in dynamic (self-paced) mode, with `/tuhin:task-next` as the
recurring prompt. One tick advances exactly one phase, then stops — a fresh
context per tick, with every piece of state already durable in `tasks.md` and
`workflow/<TASK-id>-<slug>/state.md`.

End the loop when any of these is true:

- no actionable task remains (everything is `done`, `blocked`, `needs-answer`, or
  `plan-review`) — the board is waiting on the human, not on the machine
- a task reached `blocked`
- the same task fails to change status across two consecutive ticks

Do not keep ticking against a board that only contains human-gated tasks. Notify
once, summarize what is waiting, and stop.

## Handing control back

Every stop reports, in one line per task: id, status, and either the PR URL, the
blocking reason, or what the human owes it (answers, an approval).

While the loop runs, the human can take any task back by setting its
`status: blocked` in `tasks.md` — every driver skips `blocked` permanently, so
there is no need to stop the loop first.

## Unattended, outside a session

```
*/30 * * * * cd /path/to/app && claude -p "/tuhin:task-next"
```

Same guarantees: one phase per invocation, all state on disk.
