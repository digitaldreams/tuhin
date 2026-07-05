---
name: task-workflow
description: Core loop for executing tasks from the tasks.md board — claim, plan checkpoint, worktree, implement, quality gates, draft PR, review handoff, human notification. Use whenever asked to work the task board, run the next task, or continue a task in progress.
---

# Task Workflow

The process for taking one task from `tasks.md` to a reviewed draft PR. One run
of this skill advances exactly one task as far as it can go, then stops.

## Board rules (non-negotiable)

1. **tasks.md has one writer.** All board edits (claims, status changes, plan
   comments) happen in the MAIN repo checkout, in manager context. Implementation
   agents working in worktrees NEVER edit tasks.md — their copy is stale by design.
2. **No agent-to-agent conversation.** Agents communicate only through artifacts:
   task status, plan comments on the board, the PR diff, and PR review comments.
3. **PRs are always draft. Humans always merge.** Never mark a PR ready for
   review, never merge, never push to the base branch.
4. **Every stop notifies the human** (see Notification below).

## Task format

```
- [ ] TASK-12 [backend] Add invoice export endpoint with test — status: todo
```

- Tag in `[...]` selects the implementation agent (`backend`, `frontend`, …).
- Statuses: `todo → planning → plan-review → doing → review → done`, plus
  `blocked` (terminal until a human intervenes).
- Plan comments and block reasons are indented lines under the task.
- The board header may contain a config block:
  ```
  <!-- task-agent:config
  plan_checkpoint: on
  -->
  ```
  `plan_checkpoint: off` skips steps 2–3 (trusted recipe tasks).

## The loop

### 1. Claim
Find the first actionable task, in priority order:
- a `plan-review` task whose plan comment has an `approved: yes` line → continue at step 4
- a `doing` task (crashed/interrupted run) → resume at step 5 in its existing worktree
- the first `todo` task → set `status: planning`, continue at step 2

No actionable task → report the board state and stop. If a task's tag matches no
known agent, set `status: blocked` with reason `unknown tag`, notify, and stop.

### 2. Plan
Read the task, relevant human docs (`docs/requirements.md`, `docs/conventions.md`,
and for `[frontend]` also `docs/ux_design.md`, `docs/information_architecture.md`
— only the ones that exist), and inspect the app via Laravel Boost MCP tools
(schema, routes, existing code) rather than assumptions. Produce a short plan:
files to touch, migration/route/test outline, open questions.

### 3. Plan checkpoint
Write the plan as indented comment lines under the task, set
`status: plan-review`, notify the human, and STOP:

```
- [ ] TASK-12 [backend] Add invoice export endpoint — status: plan-review
      plan:
      - migration: add exported_at to invoices
      - POST /invoices/{id}/export route + controller + Pest feature test
      approved:
```

The human edits the plan if needed and sets `approved: yes`. The next run picks
it up in step 1. (`plan_checkpoint: off` → skip straight to step 4.)

### 4. Workspace
From the main checkout:
```
git worktree add ../<repo-name>-worktrees/TASK-<n> -b task/TASK-<n>
```
Set `status: doing` on the board. All implementation happens inside the worktree.

### 5. Implement
Delegate to the tag-matched agent (e.g. `backend`) with: the task line, the
approved plan, and the worktree path as working directory. The agent implements
the plan, writing tests alongside code, using Boost MCP for schema/route/docs
lookups. It must not touch tasks.md, other tasks' code, or the base branch.

### 6. Gates
Inside the worktree, run in order, skipping tools that are not installed:
```
vendor/bin/pint --test
vendor/bin/phpstan analyse   (if phpstan present)
php artisan test
```
On failure: feed the exact failure output back to the implementation agent to
fix, then re-run the gates. **Maximum 2 fix cycles.** Still failing → set
`status: blocked` with the last failure summary as an indented comment, notify,
leave the worktree intact for a human, and STOP.

### 7. Ship for review
```
git add -A && git commit -m "TASK-<n>: <task title>"
git push -u origin task/TASK-<n>
gh pr create --draft --title "TASK-<n>: <task title>" --body "<plan + summary>. Closes from tasks.md TASK-<n>."
```
Set `status: review` with the PR URL as an indented comment. Then run the
`review` skill against the PR (reviewer agent). Reviewer verdict:
- pass → set `status: done`
- fail → set `status: blocked` with the review summary

### 8. Notify
Every terminal state of a run (`plan-review`, `review`, `done`, `blocked`)
notifies the human. On macOS:
```
osascript -e 'display notification "TASK-<n> <status>: <PR URL or reason>" with title "task-agent"'
```
Elsewhere, print a clearly-marked summary line. If the project defines a
notification command in the board config (`notify: <shell command>`), use that
instead, with the message as `$1`.

## Failure discipline

- Anything unexpected (git conflict, missing prerequisite, ambiguous task) →
  `blocked` with a reason on the board. Never guess past a blocker, never
  delete a worktree that contains unmerged work.
- A `blocked` task is a human's job. Do not retry it on later runs unless the
  human has reset its status.
