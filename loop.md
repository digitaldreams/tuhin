# task-agent — Build Loop
<!-- task-agent:board -->

Board for building the plugin itself. Same format the plugin ships. One task = one
agent responsibility = one verifiable deliverable. Executor claims first `todo`,
sets `doing`, finishes, sets `done`. Reviewer tasks gate the phase before it.

Statuses: `todo → doing → review → done` | `blocked`
Tags = responsible agent:
- `[architect]` — structure, manifests, wiring
- `[workflow-author]` — skills + commands (process content)
- `[agent-author]` — agent definition files (role prompts)
- `[template-author]` — scaffolding templates, docs stubs
- `[hook-author]` — hooks json + gate script
- `[doc-author]` — README, marketplace listing
- `[qa]` — verification runs, failure-path tests
- `[reviewer]` — reads deliverables of a phase, blocks or passes

## Phase 1 — Skeleton

- [x] TASK-01 [architect] Create repo skeleton: git init, dirs `.claude-plugin/ commands/ agents/ skills/task-workflow/ skills/review/ hooks/ templates/docs/` — status: done
- [x] TASK-02 [architect] Write `.claude-plugin/plugin.json`: name `task-agent`, version 0.1.0, description states "workflow layer on top of Laravel Boost" — status: done
- [x] TASK-03 [architect] Write `.claude-plugin/marketplace.json` so the repo doubles as its own marketplace (`/plugin marketplace add <repo>`) — status: done

## Phase 2 — Core workflow content

- [x] TASK-04 [workflow-author] Write `skills/task-workflow/SKILL.md`: full loop — claim rules (manager sole tasks.md writer), statuses `todo→planning→plan-review→doing→review→done|blocked`, plan-checkpoint protocol (`approved: yes`), worktree naming `../<repo>-worktrees/TASK-n`, gates (pint/pest/phpstan, max 2 retry cycles), draft-PR rule, notify step — status: done
- [x] TASK-05 [workflow-author] Write `commands/task-next.md`: claims next `todo` from tasks.md and executes it via task-workflow skill; refuses politely if no `todo`/approved task exists — status: done
- [x] TASK-06 [workflow-author] Write `skills/review/SKILL.md`: review procedure — static analysis output first (pint/phpstan), `gh pr diff` second, LLM comments only on what tools can't catch; verdict `done` or `blocked` with reasons — status: done
- [x] TASK-07 [workflow-author] Write `commands/task-review.md`: run review skill against a task id or PR number argument — status: done
- [x] TASK-08 [workflow-author] Write `commands/task-status.md`: render board as table (id, tag, title, status, PR link via `gh pr list`), highlight `blocked` with reasons — status: done
- [x] TASK-09 [reviewer] Review Phase 2 files: loop has no claim race (single writer stated), no agent↔agent chat anywhere, every status transition has exactly one owner — status: done

## Phase 3 — Agent roles

- [x] TASK-10 [agent-author] Write `agents/manager.md`: decomposes features into tagged tasks, sole tasks.md writer, talks to human, never writes code — status: done
- [x] TASK-11 [agent-author] Write `agents/backend.md`: implements `[backend]` tasks in worktree; must use Laravel Boost MCP (schema, routes, docs search) before guessing; writes Pest tests; never edits tasks.md — status: done
- [x] TASK-12 [agent-author] Write `agents/frontend.md`: implements `[frontend]` tasks — Blade/Livewire/Vite/Tailwind; Boost guidelines for conventions; never edits tasks.md — status: done
- [x] TASK-13 [agent-author] Write `agents/reviewer.md`: input = PR diff + gate output, posts PR comments via `gh`, verdict only (`done`/`blocked`), never pushes fixes — status: done
- [x] TASK-14 [reviewer] Review Phase 3: each agent has exactly one responsibility, no overlap with Boost's knowledge layer, tool lists minimal — status: done

## Phase 4 — Scaffolding & gates

- [x] TASK-15 [template-author] Write `templates/tasks.md`: board marker comment, format doc, config block (`plan_checkpoint: on`), one example task — status: done
- [x] TASK-16 [template-author] Write `templates/docs/` human-owned stubs: `requirements.md`, `conventions.md`, `ux_design.md`, `information_architecture.md` — each with fill-me prompts, header "human-owned, agents read-only" — status: done
- [x] TASK-17 [hook-author] Write `hooks/gate.sh`: PreToolUse guard — fires only on `git commit` in a repo whose tasks.md has the board marker; runs `pint --test`, `php artisan test`, phpstan if present; exit 2 + reason on failure — status: done
- [x] TASK-18 [hook-author] Write `hooks/hooks.json` wiring gate.sh to PreToolUse/Bash — status: done
- [x] TASK-19 [workflow-author] Write `commands/task-init.md`: prereq checks (git repo, gh auth, laravel installed, pint, pest; boost recommended), copy templates non-destructively (existing docs/tasks.md win — search root + docs/ for variants like ARCHITECTURE.md), commit board, generate `AGENTS.md`/`GEMINI.md` managed blocks (`<!-- task-agent:start/end -->`) for Codex/Gemini users — status: done
- [x] TASK-20 [reviewer] Review Phase 4: init is provably non-destructive, gate script can never fire outside a task-agent project, managed blocks never clobber user content — status: done

## Phase 5 — Docs & release

- [x] TASK-21 [doc-author] Write `README.md`: what/why (Boost = knowledge, task-agent = workflow), install (`/plugin marketplace add`, `/plugin install`), quickstart, dispatch recipes (cron `claude -p "/task-agent:task-next"`, `/loop`), Codex/Gemini best-effort tier, prerequisites — status: done
- [x] TASK-22 [doc-author] Add `LICENSE` (MIT) and version/changelog stub — status: done

## Phase 6 — QA (end-to-end)

- [x] TASK-23 [qa] Scaffold fresh Laravel app in scratchpad (composer create-project + pint + pest; boost if non-interactive install works), git init + gh private repo — status: done
- [x] TASK-24 [qa] Install plugin into e2e app (plugin CLI or copy fallback), run `/task-init`; verify: prereq report, board committed, pre-created custom `docs/requirements.md` untouched — status: done
- [x] TASK-25 [qa] Seed `TASK-1 [backend] add /health endpoint with test`; run `/task-next` → plan comment + `plan-review` stop; approve; rerun → worktree, branch, gates pass, draft PR, status `review` — status: done
- [x] TASK-26 [qa] Run `/task-review TASK-1` → reviewer comment on PR, status `done`, notification fired — status: done
- [x] TASK-27 [qa] Failure paths: unknown tag → `blocked`; force failing test → exactly 2 retry cycles → `blocked`, worktree intact; gate.sh in non-task-agent repo → no-op — status: done
- [x] TASK-28 [reviewer] Final pass: every file matches plan, loop.md all `done`, ship-ready verdict — status: done
