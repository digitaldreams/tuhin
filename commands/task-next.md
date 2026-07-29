---
description: Claim and execute the next actionable task from tasks.md
---

Work the task board using the **task-workflow** skill.

Rules of engagement:
- Operate from the main repo checkout. If `tasks.md` with the `task-agent:board`
  marker is missing, tell the user to run `/tuhin:task-init` first and stop.
- An **untagged** task is a requirement, not a task: hand it to the
  **requirement-intake** skill, which runs the requirement engineer and produces
  the plan (and the tag). A tagged task goes straight through task-workflow.
- Advance exactly one task as far as the workflow allows (approved plan → PR;
  fresh todo → plan checkpoint), then stop with a one-line summary:
  task id, new status, and PR URL or blocking reason.
- If no task is actionable (all done/blocked/awaiting approval or answers), print
  the board summary instead — do not invent work, do not retry `blocked` tasks.
- For hands-off operation use `/tuhin:task-auto`. Never run both drivers against
  one board at the same time.
