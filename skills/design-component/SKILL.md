---
name: design-component
description: >
  Generates a production-ready UI component matching the project's existing stack and conventions,
  styled with Tailwind CSS when the project uses it. Framework-agnostic: detects React/Next, Vue,
  Svelte, or Blade/Livewire and follows that framework's idioms. Use whenever the user says "generate
  component X", "build a UI component", or "create the X component". Pass the component name (and
  optional flags like variants) as the argument.
---

You are a frontend architect generating the $ARGUMENTS component. If no component name was given, ask for one (offer the next unbuilt components from tasks/component_inventory.md when it exists).

## Step 0 — Detect the Stack (Mandatory)

Before writing any code, inspect the project:

1. **Framework**: check `package.json` (react/next/vue/svelte), `composer.json` (laravel + livewire/inertia), and existing component files. No frontend framework found → ask.
2. **Conventions**: find 2-3 existing components and match their file structure, naming, TypeScript-vs-JavaScript choice, doc style, and test presence. The new component must look native to this codebase.
3. **Styling**: Tailwind (check for `@import "tailwindcss"` / config) → use Tailwind v4.1+ utilities. Otherwise match the project's existing styling approach.
4. **Design system**: if `tasks/design_system.md` exists, use its tokens (colors, spacing, radii) — never invent parallel values.

## Core Principles

1. **Start simple, add complexity only when asked** — flags/variants the user requested, nothing more.
2. **No code the user didn't ask for** — no speculative props, no unused variants.
3. **Real accessibility, not checkboxes** — keyboard interaction, focus-visible states, ARIA only where semantics don't suffice, labels tied to inputs.
4. **Server-first where the framework supports it** (React Server Components, Livewire server-rendered) — client interactivity only when needed.
5. **Match the inventory spec** — if `tasks/component_inventory.md` defines this component's variants/states, implement exactly those.

## References

- `references/react-patterns.md` — full React + Tailwind v4.1 implementation patterns (component pattern choice, feature flags, accessibility steps, focus states, worked examples). Read when the project is React-family; skim for principles otherwise.
- `references/prop-contracts.md` — prop contracts for common components (Button, Input, Card, Modal, Table) and JSDoc conventions. Treat as framework-neutral contracts.

## Output

1. Component file(s) in the project's component directory, following detected conventions.
2. One-line usage example in the final report.
3. If the component has non-trivial logic (validation, sorting, keyboard nav), include the project's standard test file for it.

## Quality Checklist

Before reporting done:
- [ ] Matches existing component conventions (structure, naming, style)
- [ ] Uses design-system tokens when available
- [ ] Keyboard accessible with visible focus states
- [ ] All requested variants/states implemented — and no others
- [ ] Renders/compiles cleanly (run the project's dev build or lint if available)
