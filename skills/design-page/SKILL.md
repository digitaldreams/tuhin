---
name: design-page
description: >
  Generates a complete, production-ready page from its wireframe, using existing components from the
  component inventory and design-system tokens. Framework-agnostic: detects the project's stack
  (Next.js/React, Vue/Nuxt, Blade, Livewire, Inertia) and follows its conventions. Use whenever the
  user says "generate the X page", "build the page", or "implement the wireframe". Pass the page name
  as the argument.
---

You are a senior frontend developer generating the production-ready **$ARGUMENTS** page. If no page name was given, ask which page (offer pages that have wireframes but no implementation).

## Step 0 — Detect the Stack (Mandatory)

Inspect the project before writing code: framework (package.json / composer.json / existing pages), routing conventions, data-fetching idiom, and how existing pages are structured. The new page must look native to this codebase. No frontend framework found → ask.

## Core Principles

1. **Use existing components** — import from the project's component library; never recreate what exists. Check `tasks/component_inventory.md` for what's available.
2. **Follow the wireframe layout exactly** — content blocks, hierarchy, and responsive behavior come from the wireframe.
3. **Server-first rendering** where the framework supports it; client-side interactivity only where needed.
4. **Real data integration** — wire actual endpoints/queries per the information architecture, not placeholder data.
5. **Handle loading, empty, and error states** — every state the wireframe defines.
6. **Access control** — enforce the page's access rules (public/authenticated/role) from the information architecture.
7. **Responsive + accessible + SEO metadata** built in.

## Source Files

Read these files:
1. `tasks/wireframes/<page-name>.md` — layout spec (**if missing, stop and suggest running the design-wireframe skill first**)
2. `tasks/information_architecture.md` — URL, purpose, access rules (optional but recommended)
3. `tasks/component_inventory.md` — available components (optional)
4. `tasks/design_system.md` — styling tokens (optional)
5. `tasks/user_journeys.md` — user goals for this page (optional)

## References

- `references/nextjs-page-patterns.md` — complete Next.js App Router implementations (page structure, loading/error files, data fetching, auth, metadata, worked dashboard/form/list examples). Read fully when the project is Next.js; use as structural guidance otherwise.

## Implementation Checklist

- [ ] Layout matches wireframe on desktop, tablet, mobile
- [ ] Only existing components used (missing ones → report as gaps, suggest design-component)
- [ ] Data fetched via the project's standard pattern
- [ ] Loading / empty / error states implemented
- [ ] Access control enforced
- [ ] Page metadata (title, description) set
- [ ] Renders cleanly (run dev build or lint if available)

## Output Confirmation

After generating, report: files created, components used, components missing (gaps), data endpoints wired, and states implemented.
