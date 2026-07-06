---
name: design-vsa-plan
description: >
  Generates a complete Vertical Slice Architecture folder plan for a frontend application from the
  information architecture, component inventory, and user journeys, writing tasks/vsa_structure.md.
  Framework-agnostic: detects the project's frontend stack and adapts folder conventions. Use whenever
  the user says "VSA plan", "slice structure", "frontend folder structure", or "organize the frontend
  folders". Laravel backend slice placement and audits use the vsa skill instead.
---

You are a senior architect designing a Vertical Slice Architecture for this project's frontend.

## Core Principles of VSA

1. **Feature-based organization** — group by feature, not by technical layer
2. **Self-contained slices** — each feature owns its components, state, utilities
3. **Clear boundaries** — obvious what belongs where; shared code lives only at the shared root
4. **One-way imports** — slices import from shared; slices never import from other slices
5. **Scalable** — a new feature is a new slice, never edits to existing slices

## Step 0 — Detect the Stack

Identify the frontend framework and its routing conventions from the codebase (or from tasks/architecture.md if the project isn't scaffolded yet). The slice plan must use that framework's real conventions, not a foreign template.

## Source Files

Read these files:
1. `tasks/information_architecture.md` — all pages and routes (**if missing, stop and suggest running the design-information-architecture skill first**)
2. `tasks/component_inventory.md` — components per page (optional but recommended)
3. `tasks/user_journeys.md` — feature groupings (optional)
4. `tasks/requirements.md` — application features (optional)
5. `tasks/wireframes/*.md` — page wireframes (optional)

## Output

Create `tasks/vsa_structure.md` containing:
- Overview: the slices identified and why (feature groupings from journeys/IA)
- High-level structure: shared root vs slices
- Detailed structure per slice: routes/pages, components, state, data access
- Complete directory tree
- Import rules (what may import what, with examples)
- File naming conventions matching the detected framework
- Validation checklist

## References

- `references/nextjs-vsa-structure.md` — full worked Next.js App Router VSA blueprint (directory trees, import patterns, migration guide, FAQ). Read fully for Next.js projects; use as the structural model for other frameworks.

## Output Confirmation

After generating, report: number of slices, shared modules, the one rule that must never be broken (no cross-slice imports), and the first slice to scaffold.
