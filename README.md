# task-agent

Autonomous task workflow for Laravel teams, as a Claude Code plugin.

You keep a `tasks.md` board. Agents claim a task, write a plan, wait for your
approval, implement it in an isolated git worktree, pass quality gates
(Pint / Pest / PHPStan), open a **draft** PR, review it, and notify you.
**You merge.** Always.

Pure content — markdown agents, skills, commands, one hook script. The runtime
is your coding CLI.

## Where it sits

| Layer | Owner |
|---|---|
| Knowledge — schema, routes, package docs, framework conventions | [Laravel Boost](https://github.com/laravel/boost) (prerequisite) |
| Workflow — roles, board, plan checkpoints, worktrees, gates, PRs, review | **task-agent** (this plugin) |

No overlap: task-agent's agents call Boost's MCP tools instead of guessing
about your app.

## Install

```
/plugin marketplace add digitaldreams/task-agent
/plugin install task-agent@task-agent-marketplace
```

Then, inside your Laravel project:

```
/task-agent:task-init
```

Non-destructive: existing `tasks.md`, `docs/*`, `AGENTS.md` content always wins.

### Prerequisites

- Laravel app in a git repository, `gh` CLI authenticated (draft PRs)
- `laravel/pint` + Pest (or PHPUnit) — the quality gates
- `laravel/boost` — knowledge layer (`composer require laravel/boost --dev && php artisan boost:install`)
- optional: `phpstan/larastan` — extra gate, picked up automatically

## Use

1. Fill the human-owned docs `task-init` created (`docs/requirements.md`,
   `docs/conventions.md`, `docs/ux_design.md`, `docs/information_architecture.md`)
   — or keep your existing ones; agents read whichever exist.
2. Seed the board (or ask the manager agent to decompose a feature):
   ```
   - [ ] TASK-2 [backend] Add invoice CSV export endpoint with test — status: todo
   ```
3. Advance the board:
   ```
   /task-agent:task-next
   ```
   First run produces a plan and stops (`plan-review`). Add `approved: yes`
   under the plan, run again → worktree, implementation, gates, draft PR,
   review, notification.
4. Watch it: `/task-agent:task-status`. Re-review a PR: `/task-agent:task-review TASK-2`.

### Hands-off dispatch

- In-session loop: `/loop 15m /task-agent:task-next`
- Cron (headless):
  ```
  */30 * * * * cd /path/to/app && claude -p "/task-agent:task-next" >> storage/logs/task-agent.log 2>&1
  ```
Plan checkpoints still stop for your approval; set `plan_checkpoint: off` in
the `tasks.md` config block for trusted recipe tasks.

## The rules the agents live by

- `tasks.md` has one writer (the manager). Implementation agents never touch it.
- No agent-to-agent chat — communication is task status, plan comments, PR
  diffs, and review comments.
- Gates before every commit (also enforced by a PreToolUse hook), max 2 fix
  cycles, then the task is `blocked` for a human with the failure attached.
- PRs are always draft; reviewer verdicts are PASS/FAIL with diff-anchored
  findings; humans always merge.
- Statuses: `todo → planning → plan-review → doing → review → done` | `blocked`.

## Codex / Gemini CLI

`task-init` writes managed blocks into `AGENTS.md` and `GEMINI.md` carrying the
same workflow rules, so Codex and Gemini CLI users can run the loop by prompt.
Best-effort tier: no native subagents or hooks there — gates run by instruction
(back them with CI).

## License

MIT
