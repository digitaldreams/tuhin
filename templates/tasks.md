# Task Board
<!-- task-agent:board -->
<!-- task-agent:config
plan_checkpoint: on
-->

Managed by the task-agent plugin. One writer: the manager agent (or a human).
Implementation agents never edit this file.

## Format

```
- [ ] TASK-<n> [tag] <one-sitting deliverable> — status: todo
      depends: TASK-<m>          (optional)
      plan:                      (added at plan checkpoint)
      - ...
      approved:                  (human sets "approved: yes")
```

Statuses: `todo → planning → plan-review → doing → review → done` | `blocked`
Tags: `backend`, `frontend` — must match an installed task-agent agent.

Run `/task-agent:task-next` to advance the board, `/task-agent:task-status` to
see it, `/task-agent:task-review` to review a PR.

## Tasks

- [ ] TASK-1 [backend] Example: add GET /health endpoint returning app+db status, with feature test — status: todo
