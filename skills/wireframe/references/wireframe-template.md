# Wireframe — Document Template

Placeholders only. Layout examples show ASCII style, not a required shell — derive every layout from this page's IA entry.

```markdown
# Wireframe: [Page Name]

**Page:** [Name] ([/url]) · **Created:** [date]
**Purpose:** [one sentence, from IA page inventory]
**Target user:** [persona] · **Journey ref:** [Journey N, steps M–K]

## Page Overview

**Primary goal:** [what the user accomplishes here]
**Chrome:** standard shell per IA §4 [— or list exactly what this page changes/omits]
**Entry points:** [from journey: how users arrive]
**Exit points:** success → [/url] · cancel/abandon → [/url]

## Desktop Layout

[ASCII of the MAIN content area only — no header/sidebar/footer unless this page changes them]

┌─────────────────────────────────────────┐
│  PAGE TITLE                             │
│  [supporting line if IA lists one]      │
│                                         │
│  [Primary Action] [Secondary Action]    │
│                                         │
│  ┌─ CONTENT BLOCK 1 ─────────────────┐  │
│  │ [derived from IA content blocks]  │  │
│  └───────────────────────────────────┘  │
│  ┌─ CONTENT BLOCK 2 ─────────────────┐  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘

**Key elements:** [one line per block: what it is, why it's placed there]

## Mobile Layout

[ASCII — what stacks, what collapses, what moves]

**Changes from desktop:** [bullet list — column collapse, full-width actions, table→cards]

[## Tablet Layout — ONLY if structurally different from both; otherwise omit]

## Content Blocks

Per block from the IA entry:

### [Block name]
- **Content:** [what appears — entity-level data ("user's open orders"), never endpoints]
- **Layout:** [cards / table / list / form]
- **Actions:** [what the user can do here]

## Interactive Elements

| Element | Action | Result |
|---|---|---|
| [Primary button] | Click | [what happens] → [where user lands] |
| [Item card] | Click | [destination] |

## States

Draw every state the IA page inventory lists for this page:

### Empty
┌──────────────────────┐
│      [icon]          │
│  No [items] yet      │
│  [Create first item] │
└──────────────────────┘

### Loading
[skeleton placeholders; which actions disable]

### Error
[message + recovery action + fallback path]

## Forms (only if the page has one)

[ASCII of field order]

| Field | Type | Required | Validation (user-visible rule) |
|---|---|---|---|

- Submit → [result + destination] · Cancel → [destination]
- Inline errors appear [where]; the failure branch from the journey table is drawn, not assumed.

## Tables (only if the page has one)

- **Columns:** [name — content — sortable?]
- **Row actions:** [edit/delete/view] · **Bulk:** [if any] · **Pagination:** [style]
- **Mobile:** [scroll or card collapse — pick one and draw it]

## Responsive Behavior

| Element | Desktop | Mobile |
|---|---|---|
| [cards] | [3-across] | [stacked] |
| [table] | [full] | [cards] |
| [actions] | [inline] | [full-width] |

## Accessibility (structural)

- [ ] Logical tab order; all interactive elements keyboard-reachable
- [ ] One H1; heading hierarchy matches content blocks
- [ ] Every form field labeled; errors announced
- [ ] Focus visible; touch targets adequate on mobile

## Validation Checklist

- [ ] Layout serves the primary goal; most important element is most prominent
- [ ] Every content block from the IA entry appears
- [ ] Every IA-listed state is drawn
- [ ] Journey design decisions honored (list which)
- [ ] Entry and exit points wired
```
