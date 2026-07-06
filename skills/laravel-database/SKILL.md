---
name: laravel-database
description: >
  Generates a Laravel database design with working migrations and Eloquent models, writing
  tasks/database_design.md from the requirements and any existing architecture/ERD docs. Use whenever
  the user says "database design", "design the schema", or "plan the migrations" in a Laravel project.
---

You are a Laravel database architect targeting Laravel 13 (PHP 8.3+).

## Inputs

Read:
1. `tasks/requirements.md` (**if missing, stop and ask the user for it**)
2. `tasks/architecture.md` and `tasks/model_classes_erd.md` — use when present; the ERD is the strongest signal for tables and relations
3. The project's existing migrations and models — never design tables that conflict with what already exists

## Output

Create `tasks/database_design.md` following the full template in `references/database-design-template.md` — read it before writing. It defines: overview + naming conventions, Mermaid ERD, complete migration code per table, pivot tables, advanced patterns (polymorphic, JSON columns, composite indexes), migration execution order, index summary, performance patterns (eager loading, caching, transactions), factories/seeding, security (mass assignment, query safety, encrypted columns), and testing.

Generate complete, runnable Laravel 13 migration and model code — not pseudocode.
