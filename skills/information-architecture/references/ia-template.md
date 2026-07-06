# Information Architecture — Section Template

Placeholders only. Mini-examples show FORMAT — never copy their content into a real project.

```markdown
# Information Architecture

**Project:** [name] · **Generated:** [date]

## 1. Structural Decisions

**Core finding:** [one sentence — e.g., "Users need 2 primary paths: capture and review"]

1. [Decision — e.g., "Dashboard-centric for authenticated users"]
2. [Decision — e.g., "Public browsing without registration"]
3. [Decision — e.g., "Admin area fully separated from user flows"]

**Critical pages:** [3–5 pages the core journeys cannot work without]

## 2. Sitemap

Plain indented tree, access noted per branch:

/                       [public]
/auth
  /auth/login           [guest only]
  /auth/register        [guest only]
/dashboard              [auth]
/[resource]
  /[resource]           [public] — browse
  /[resource]/{slug}    [public] — detail
  /[resource]/create    [auth]
/admin                  [admin role]
  /admin/[area]

## 3. Page Inventory

One block per page, grouped by access level:

### [Page Name] ([/url])
- **Purpose:** [one line]
- **Target user:** [persona]
- **Journey ref:** [Journey N, step M]
- **Content blocks:** [ordered list of what's on the page]
- **Primary actions:** [action] → [destination /url or effect]
- **Data needs:** [entities, e.g., "user's open orders" — never endpoints]
- **Key states:** [empty: what shows · error: what shows]
- **Access:** [public / auth / role / owner-only]

## 4. Navigation

**Primary (header):** [items visible to whom]
**User menu:** [items; role-conditional items marked]
**Mobile:** [what collapses into the drawer; what stays visible]
**Secondary (contextual):** [sidebar/tabs per area — e.g., settings tabs]
**Breadcrumbs:** [which nested areas get them; pattern: Section > Subsection > Page]

## 5. Access Control Matrix

| Page/Feature | Public | Authenticated | [Role] |
|---|---|---|---|
| [page] | ✅/❌ | ✅/❌ (owner-only?) | ✅/❌ |

[One row per page. Guests hitting auth pages → redirect where? Non-role hitting role pages → 403 or redirect?]

## 6. URL Rules

- Lowercase, hyphens, short, descriptive.
- [Human-facing resources] → slug URLs (`/posts/how-to-x`)
- [Internal/admin resources] → id URLs (`/admin/users/42`)
- [List each dynamic route pattern: /resource/{slug|id} — and why]

## 7. Search & Filtering

- **Global search:** [exists? scope? placement?] — or "none; per-page filters suffice"
- **Per-page filters:** [page → filter/sort controls]

## 8. Validation Checklist

- [ ] Every journey step maps to a page (list orphan steps)
- [ ] Every page traces to a journey step or requirement (list orphan pages)
- [ ] Every page has an access level; every role transition defined
- [ ] Navigation reaches every page in ≤ [N] clicks from its area root
- [ ] URL rules applied to every route

## Next Steps
1. Wireframes for critical pages → wireframe skill
2. Design system → design-system skill
3. Component inventory → component-inventory skill
```
