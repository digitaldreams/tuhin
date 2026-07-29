---
description: Review a task's draft PR (argument - task id like TASK-3, or a PR number)
argument-hint: <TASK-id or PR number>
---

Review `$ARGUMENTS` using the **review** skill, in the reviewer agent's role.

- Given a task id: find its PR URL in the indented comments under the task in
  `tasks.md`. Given a PR number: use it directly, and locate the matching task
  by the `TASK-<n>` prefix in the PR title.
- No argument: review the first task with `status: review`.
- Follow the review skill exactly: gates first, diff-anchored findings, one PR
  comment, PASS/FAIL verdict, notify the human per the task-workflow skill's
  notification step.
- The verdict feeds task-workflow steps 8–9: PASS finishes the task (human merge
  unless `AUTO_MERGE=gated` and every condition holds); FAIL starts a fix round,
  up to `MAX_REVIEW_ROUNDS`, then `blocked`.
- Re-running this on a task already past round 1 is a **re-review**: verify the
  previous round's findings are resolved and look for regressions. New unrelated
  findings go to `workflow/<TASK-id>-<slug>/backlog.md`, not into this PR.
