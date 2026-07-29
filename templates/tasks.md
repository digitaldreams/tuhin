# Task Board
<!-- task-agent:board -->
<!-- task-agent:config
plan_checkpoint: on
-->

Managed by the task-agent plugin. **This is the only file you write in.**
Everything the agents produce lives in `workflow/` (gitignored) and is linked
from here. Implementation agents never edit this file.

## Two ways to add work

**You know the change** — write it as a tagged task and it goes straight to code:

```
- [ ] TASK-<n> [backend] <one-sitting deliverable> — status: todo
```

**You know the outcome, not the change** — leave the tag off and write a
paragraph. A requirement engineer reads the codebase, asks you anything that
genuinely blocks it, and writes the plan (and picks the tag):

```
- [ ] TASK-<n> <title> — status: todo
      <description, as many indented lines as you want>
```

Rule of thumb: if you can write the tag honestly, you already did the requirement
engineering.

## Format

```
- [ ] TASK-<n> [tag] <title> — status: todo
      depends: TASK-<m>                                (optional)
      workflow: TASK-<n>-<slug>                        (added by the agent)
      plan: workflow/TASK-<n>-<slug>/plan.md  (SIZE)   (added at plan checkpoint)
      Q1: <question>? (default: <answer>)              (added when the agent is blocked)
      A1:                                              ← you answer here
      answered:                                        ← you write "answered: yes" here
      approved:                                        ← you write "approved: yes" here
```

Statuses: `todo → planning → (needs-answer) → plan-review → doing → review → done`, or `blocked`
Tags: `backend`, `frontend` — must match an installed task-agent agent.

You only ever write five things: the task line, its description, `A<n>:` answers,
`answered: yes`, and `approved: yes`. Everything else on this board is
agent-written and safe to skim past.

Every question names a default, so you can answer only the ones you care about —
each blank `A<n>` becomes a recorded assumption. Nothing moves until you write
`answered: yes`, so a running loop can never answer its own questions.

## Commands

```
/tuhin:task-next            advance the board one phase
/tuhin:task-auto            keep advancing until something needs you
/tuhin:task-status          see the board
/tuhin:task-review TASK-3   re-run review on a task's PR
```

Never run `task-next` and `task-auto` against this board at the same time. To take
a task back from a running loop, set its status to `blocked`.

## Tasks

- [ ] TASK-1 [backend] Example: add GET /health endpoint returning app+db status, with feature test — status: todo
