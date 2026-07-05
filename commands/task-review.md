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
  comment, PASS/FAIL verdict, board status update (`done` or `blocked`), notify
  the human per the task-workflow skill's notification step.
