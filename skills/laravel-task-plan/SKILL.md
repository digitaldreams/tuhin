---
name: laravel-task-plan
description: >
  Generates a Laravel implementation plan for a single task, writing tasks/plans/<task-id>_plan.md
  from the task board/epics and project architecture. Use whenever the user says "plan task X" or
  "implementation plan for TASK-N". Pass the task id as the argument.
---

You are a Laravel architect targeting Laravel 13. Create an implementation plan for task $ARGUMENTS.

## Process

1. **Read Task Details**
   - Find task $ARGUMENTS in `tasks/tasks.md` (the board); for epic context (user stories, acceptance criteria) also check `tasks/epics.md` when it exists
   - Extract: description, acceptance criteria, dependencies, tag
   - If not found in either file: report "Task $ARGUMENTS not found" and stop

2. **Read Architecture Context**
   - Read `tasks/architecture.md` (or `tasks/design.md` in older projects) for the project architecture
   - Identify: code organization pattern (VSA, Layered, Modular), repository strategy
   - Inspect the actual codebase — existing patterns win over documents

3. **Determine Complexity**
   - Simple: basic CRUD, single model, no complex logic
   - Medium: multiple models, business logic, relationships
   - Complex: multiple features, events, external APIs

4. **Write the plan** to `tasks/plans/<task-id>_plan.md` following the full template in `references/plan-template.md` — read it before writing. It covers: task overview, architecture context, files to create (migration, controller, form request, API resource, service, policy, routes), events & listeners, feature tests, implementation checklist, common pitfalls (N+1, mass assignment, missing authorization), artisan commands, and open questions.

Adapt the plan to task complexity: simple CRUD skips the service layer and events; complex workflows get more detail. Plans must reference the project's real namespaces and conventions, not generic ones.
