# Design System — Document Template

Placeholders only. Hex values and class lists show FORMAT — every real value comes from the project analysis.

```markdown
# Design System

**Project:** [name] · **Type:** [classification] · **Generated:** [date]

## Executive Summary

**What this system is for:** [2–3 sentences: project type, users, design needs]

**Key decisions:**
1. [decision + reason — "muted palette because analysts spend 4+ hour sessions"]
2. [decision + reason]
3. [decision + reason]

**Priorities:** [e.g., scanning speed > visual flair · consistency > flexibility]

## Project Analysis

- Forms: [n] · Tables: [n] · Card types: [n] · Modals: [n] · Button variants used: [n]
- Density: [sparse/medium/dense] → [what that implies]
- [Each count → its implication: "9 forms → validation states are critical"]

## Tokens (@theme)

At [path from architecture: resources/css/app.css | app/globals.css]:

\`\`\`css
@import "tailwindcss";

@theme {
  /* Primary — [why THIS color for THIS product] */
  --color-primary-50: [hex];
  --color-primary-500: [hex];  /* main */
  --color-primary-600: [hex];  /* hover */
  --color-primary-700: [hex];  /* active */
  /* [only the shades the analysis needs — rarely more than 7] */

  /* Semantic — one block per role the wireframes use */
  --color-success-*: [...];
  --color-error-*: [...];
  --color-warning-*: [...];

  /* Data-viz — ONLY if charts exist; colorblind-distinguishable */
  --color-chart-1..n: [...];

  /* Typography */
  --font-display: [font + why];
  --font-body: [font + why — system stack unless brand justifies the load];
  --font-mono: [only if code/data display exists];

  /* Semantic spacing — values from density analysis */
  --spacing-field: [rem];    /* between form fields */
  --spacing-section: [rem];  /* between page sections */
  --spacing-card: [rem];     /* card padding */
  --spacing-inline: [rem];   /* icon-to-text */

  /* Elevation & shape */
  --shadow-card: [...];
  --shadow-overlay: [...];
  --radius-button: [rem];
  --radius-card: [rem];
  --radius-modal: [rem];
}
\`\`\`

## Color Rules

Per color role:

### [Role — e.g., Success]
- **Used for:** [specific uses from wireframes]
- **Do NOT use for:** [the mistake this rule prevents]
- Example: `bg-success-100 text-success-700` badge · `border-success-500` validated input

### Neutrals
[Which gray family and why it complements the primary; light/dark surface mapping:
page bg / card bg / hover bg in both modes.]

## Typography

- **Scale:** [only the levels wireframes use] — H1 `text-[size]` [role], H2 …, body `text-[size]`, small `text-[size]`. [Why this scale for this density.]
- **Weights:** normal=body · medium=labels/emphasis · semibold=headings/buttons · bold=[rarely — say when].

## Spacing

Base 4px. Common values: [the 4–6 steps this project actually uses and where].
Semantic tokens above are the default for their contexts — raw values need a reason.

## Component Patterns

Per component the wireframes contain (and none they don't):

### [Component — e.g., Button]
- **Variants:** [only those counted: primary ×[n], secondary ×[n], destructive ×[n]]
- **Sizes:** [max 2]
- **Required states:** default / hover / active / focus-visible / disabled [+ loading if shown]
- **Token recipe:** [the classes/tokens that define it — e.g., `px-4 py-2 bg-primary-600 hover:bg-primary-700 rounded-[--radius-button] font-medium text-sm focus-visible:outline-2`]
- **Rules:** [e.g., destructive always pairs with confirmation]

[Repeat per component: inputs (with error/success state recipe), cards, badges, alerts, modals, tables — as counted. Recipes and rules only — no full HTML markup; implementation belongs to component-generation skills.]

## Responsive

- Mobile-first breakpoints; container queries (`@container`, `@sm:`) for components that must adapt to their parent, not the viewport — [name which components from the wireframes].
- [Project's grid patterns: e.g., cards 1 → 2 → 3 columns.]

## Accessibility

- Contrast: 4.5:1 body, 3:1 large text and interactive elements — verified in BOTH modes.
- `focus-visible` ring on every interactive element (recipe above).
- Touch targets ≥ 44px on mobile.
- Error states never color-only — icon or text accompanies.

## Dark Mode

- Strategy: [soft dark (gray-900) vs pure black — and why]
- What shifts: [surfaces, borders, text mapping] · What stays: [brand moments]
- Class-based toggle on `<html>`; every token pair listed in Neutrals above.

## Custom Utilities

Only patterns used 3+ times:

\`\`\`css
@utility [name] { [rules using theme() tokens] }
\`\`\`

[List each with its use count.]

## Component Checklist

Derived from wireframes — build order for the component skills:
- [ ] [component] — needed by [pages]
- [ ] [component] — needed by [pages]
```
