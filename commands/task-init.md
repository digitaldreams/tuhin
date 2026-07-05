---
description: Set up the task-agent workflow in this Laravel project (non-destructive)
---

Initialize this project for the task-agent workflow. Every step is
non-destructive: an existing file always wins over a template.

## 1. Prerequisite check

Verify and report each as ✓/✗ (do not abort on ✗ unless marked REQUIRED):

- REQUIRED: inside a git repository (`git rev-parse`)
- REQUIRED: a Laravel app (`artisan` file present)
- `gh` installed and authenticated (`gh auth status`) — needed for PRs
- `vendor/bin/pint` — style gate
- `vendor/bin/pest` or phpunit via `php artisan test` — test gate
- `laravel/boost` in composer.json — strongly recommended knowledge layer;
  if missing, suggest `composer require laravel/boost --dev && php artisan boost:install`
- optional: `vendor/bin/phpstan`

Missing REQUIRED item → print what to do and stop.

## 2. Task board

If a `tasks.md` containing the marker `task-agent:board` exists → leave it,
report "board present". Otherwise copy the plugin template
`${CLAUDE_PLUGIN_ROOT}/templates/tasks.md` to the project root.

## 3. SE docs (existing files win)

For each of `requirements.md`, `conventions.md`, `ux_design.md`,
`information_architecture.md`:

1. Search for an existing equivalent before copying anything: check the project
   root and `docs/` for name variants — exact name, upper-case
   (`REQUIREMENTS.md`), hyphenated (`ux-design.md`), and common synonyms
   (`ARCHITECTURE.md` or `system_design.md` count as `conventions.md`-level
   architecture truth; `SPEC.md`/`PRD.md` count for `requirements.md`).
2. Found → report "using existing <path>" and DO NOT copy the template.
3. Not found → copy from `${CLAUDE_PLUGIN_ROOT}/templates/docs/` into `docs/`.

Never overwrite, never rename, never merge into an existing doc.

## 4. Codex / Gemini instruction blocks

For `AGENTS.md` and `GEMINI.md` in the project root, insert a managed block so
non-Claude CLIs can follow the same workflow:

- Block delimiters: `<!-- task-agent:start -->` / `<!-- task-agent:end -->`.
- File missing → create it containing only the block.
- File exists without block → append the block at the end; touch nothing else.
- Block already present → replace only the block content (idempotent re-init).

Block content: a condensed rendition (~40 lines) of the task-workflow skill —
board format and statuses, sole-writer rule, plan checkpoint with
`approved: yes`, worktree-per-task, gates (`vendor/bin/pint --test`,
`php artisan test`, phpstan if present, max 2 fix cycles then blocked), draft
PR via `gh pr create --draft`, reviewer procedure summary (gates first,
diff-anchored findings, PASS/FAIL), human merges. Write it from the installed
skills so it never drifts from the Claude Code behavior.

## 5. Commit the board

Stage and commit ONLY files this init created or modified (`tasks.md`, new
`docs/` files, `AGENTS.md`, `GEMINI.md`):
`git commit -m "chore: initialize task-agent workflow"`.
Dirty unrelated working tree → leave those files alone and commit only ours.
If an `origin` remote exists, push the base branch afterwards — an unpushed
init commit would otherwise bleed into every task PR's diff.

## 6. Report

Summary table: prerequisite results, each file created / reused / skipped,
then next steps: fill the human-owned docs, seed a task in tasks.md, run
`/task-agent:task-next` (mention cron and `/loop` recipes from the plugin
README for hands-off dispatch).
