---
description: Claim and execute the next actionable task from tasks.md
---

Work the task board using the **task-workflow** skill.

Rules of engagement:
- Operate from the main repo checkout. If `tasks.md` with the `task-agent:board`
  marker is missing, tell the user to run `/task-agent:task-init` first and stop.
- Advance exactly one task as far as the workflow allows (approved plan → PR;
  fresh todo → plan checkpoint), then stop with a one-line summary:
  task id, new status, and PR URL or blocking reason.
- If no task is actionable (all done/blocked/awaiting approval), print the board
  summary instead — do not invent work, do not retry `blocked` tasks.
