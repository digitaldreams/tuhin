# tuhin

Tuhin Bepari's dev identity as a Claude Code plugin: an autonomous Laravel task
workflow plus a personal toolbox of engineering skills and a digital-twin
implementation agent.

## Part 1 — Task workflow

You keep a `tasks.md` board. Agents claim a task, write a plan, wait for your
approval, implement it in an isolated git worktree, pass quality gates
(Pint / Pest / PHPStan), open a **draft** PR, review it, and notify you.
**You merge.** Always.

Pure content — markdown agents, skills, commands, one hook script. The runtime
is your coding CLI.

### Where it sits

| Layer | Owner |
|---|---|
| Knowledge — schema, routes, package docs, framework conventions | [Laravel Boost](https://github.com/laravel/boost) (prerequisite) |
| Workflow — roles, board, plan checkpoints, worktrees, gates, PRs, review | **tuhin** (this plugin) |

No overlap: the workflow agents call Boost's MCP tools instead of guessing
about your app.

## Install

```
/plugin marketplace add digitaldreams/tuhin
/plugin install tuhin@tuhin-marketplace
```

Then, inside your Laravel project:

```
/tuhin:task-init
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
   /tuhin:task-next
   ```
   First run produces a plan and stops (`plan-review`). Add `approved: yes`
   under the plan, run again → worktree, implementation, gates, draft PR,
   review, notification.
4. Watch it: `/tuhin:task-status`. Re-review a PR: `/tuhin:task-review TASK-2`.

### Hands-off dispatch

- In-session loop: `/loop 15m /tuhin:task-next`
- Cron (headless):
  ```
  */30 * * * * cd /path/to/app && claude -p "/tuhin:task-next" >> storage/logs/task-agent.log 2>&1
  ```
Plan checkpoints still stop for your approval; set `plan_checkpoint: off` in
the `tasks.md` config block for trusted recipe tasks.

### The rules the agents live by

- `tasks.md` has one writer (the manager). Implementation agents never touch it.
- No agent-to-agent chat — communication is task status, plan comments, PR
  diffs, and review comments.
- Gates before every commit (also enforced by a PreToolUse hook), max 2 fix
  cycles, then the task is `blocked` for a human with the failure attached.
- PRs are always draft; reviewer verdicts are PASS/FAIL with diff-anchored
  findings; humans always merge.
- Statuses: `todo → planning → plan-review → doing → review → done` | `blocked`.

## Part 2 — Personal skills & digital twin

Bundled skills, available in every project once the plugin is installed:

| Skill | What it does |
|---|---|
| `understand` | Build a full mental model of a codebase/module before any change |
| `blast-radius` | Trace the impact of a change/deletion before editing shared code |
| `red-first` | Regression-test-first bug fixing: failing test before the fix |
| `brutal-qa` | Adversarial pre-release QA pass with ranked findings |
| `red-team` | Security audit of your own codebase (find + validate modes) |
| `performance-audit` | Laravel perf sweep: N+1, indexes, cache, queue candidates → `performance_audit.md` |
| `vsa` | Vertical Slice Architecture placement and isolation audits |
| `readability-sweep` | Comment removal, method extraction, naming challenges |
| `driver` | Scaffold a swappable vendor driver behind an interface |
| `manual-test-cases` | Product-owner-runnable manual test scripts |
| `spec-to-loop` | Convert requirement docs into loop-agent-ready spec files |
| `log-analyzer` | Laravel log diagnosis to root cause |
| `gmail-api-laravel` | Gmail API integration reference for Laravel |

SDLC pipeline skills (spec-driven: each reads/writes docs under `tasks/`; frontend skills are framework-agnostic and detect the project's stack):

| Skill | What it does |
|---|---|
| `requirements` | Brutally honest analysis of `tasks/requirements.md` → `requirement_analysis.md` |
| `architecture` | Practical web architecture design → `architecture.md` |
| `system-design` | Concise system design doc → `system_design.md` |
| `system-modeling` | All UML/system models (use cases, class, sequence, state, ERD) → `system_model.md` |
| `api-contract` | REST API contract: endpoints, shapes, errors, versioning → `api_contract.md` |
| `task-breakdown` | Requirements → Epics + task breakdown → `epics.md` (task-manager converts to the board) |
| `design-user-journey-map` | User journey insights → `user_journeys.md` |
| `design-information-architecture` | IA / navigation structure → `information_architecture.md` |
| `design-wireframe` | Page wireframes → `wireframes/<page>.md` |
| `design-system` | Custom, opinionated Tailwind v4.1+ design system → `design_system.md` |
| `deployment` | Release procedure: checklist, migration safety, rollback, smoke checks → `deployment.md` |

Plus the **`tuhin` agent** — digital twin of Tuhin Bepari: understands the
codebase first, maps blast radius, delivers small reviewable parts, tests
before and after every change, never over-builds.

## Codex / Gemini CLI

`task-init` writes managed blocks into `AGENTS.md` and `GEMINI.md` carrying the
same workflow rules, so Codex and Gemini CLI users can run the loop by prompt.
Best-effort tier: no native subagents or hooks there — gates run by instruction
(back them with CI).

## License

MIT
