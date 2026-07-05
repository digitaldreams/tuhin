# Wireframe — Document Template
```markdown
# Wireframe: [Page Name]

**Page:** [Page Name] ([URL Path])
**Created:** [Current Date]
**Purpose:** [One sentence from IA document]
**Target User:** [User persona]

---

## Page Overview

**Primary Goal:** [What user accomplishes here]

**Key Content:**
- [Content block 1]
- [Content block 2]
- [Content block 3]

**From User Journey:**
- **Pain Points Addressed:** [List 2-3 from journey map]
- **Opportunities:** [How this layout solves them]

---

## Desktop Layout

\`\`\`
┌──────────────────────────────────────────────────────────────────────────┐
│  HEADER                                                                  │
│  Logo              [Search...]           [Notifications] [Help] [Avatar] │
├──────────────────────────────────────────────────────────────────────────┤
│  Breadcrumb: Home > Section > Current Page                              │
├────────────┬─────────────────────────────────────────────────────────────┤
│  SIDEBAR   │  MAIN CONTENT                                              │
│            │                                                             │
│  Overview  │  ┌───────────────────────────────────────────────────────┐│
│  Activity  │  │  PAGE TITLE                                           ││
│  Reports   │  │  Brief description of what this page does             ││
│  • Current │  └───────────────────────────────────────────────────────┘│
│  Settings  │                                                             │
│            │  [Primary Action]  [Secondary Action]                      │
│            │                                                             │
│  SECTION   │  ┌───────────────────────────────────────────────────────┐│
│            │  │  CONTENT SECTION 1                                    ││
│  Link      │  │                                                       ││
│  Link      │  │  ┌──────────┐  ┌──────────┐  ┌──────────┐          ││
│            │  │  │  Item 1  │  │  Item 2  │  │  Item 3  │          ││
│            │  │  │  Details │  │  Details │  │  Details │          ││
│            │  │  │  [Action]│  │  [Action]│  │  [Action]│          ││
│            │  │  └──────────┘  └──────────┘  └──────────┘          ││
│            │  └───────────────────────────────────────────────────────┘│
│            │                                                             │
│            │  ┌───────────────────────────────────────────────────────┐│
│            │  │  CONTENT SECTION 2                                    ││
│            │  │  [Content details]                                    ││
│            │  │  [More information]                                   ││
│            │  └───────────────────────────────────────────────────────┘│
│            │                                                             │
└────────────┴─────────────────────────────────────────────────────────────┘
│  FOOTER: Links | Privacy | Terms                                        │
└──────────────────────────────────────────────────────────────────────────┘
\`\`\`

**Key Elements:**
- **Header:** Fixed, always visible
- **Sidebar:** Navigation (240px wide, collapsible)
- **Main Content:** Scrollable, contains primary content
- **Footer:** Informational links only

---

## Tablet Layout (Medium Screens)

\`\`\`
┌──────────────────────────────────────────────────┐
│  HEADER                                          │
│  [Menu] Logo         [Search]      [🔔] [Avatar] │
├──────────────────────────────────────────────────┤
│  Breadcrumb: Home > Current                      │
├──────────────────────────────────────────────────┤
│  MAIN CONTENT (Full Width)                       │
│                                                  │
│  ┌────────────────────────────────────────────┐ │
│  │  PAGE TITLE                                │ │
│  │  Description                               │ │
│  └────────────────────────────────────────────┘ │
│                                                  │
│  [Primary Action]  [Secondary]                  │
│                                                  │
│  ┌────────────────────────────────────────────┐ │
│  │  CONTENT SECTION                           │ │
│  │  ┌──────────┐    ┌──────────┐            │ │
│  │  │  Item 1  │    │  Item 2  │            │ │
│  │  └──────────┘    └──────────┘            │ │
│  └────────────────────────────────────────────┘ │
│                                                  │
└──────────────────────────────────────────────────┘

Changes from Desktop:
• Sidebar becomes hamburger menu
• Content takes full width
• Items flow into 2 columns
\`\`\`

---

## Mobile Layout (Small Screens)

\`\`\`
┌──────────────────────────┐
│  HEADER                  │
│  [☰] Logo    [🔍] [👤]  │
├──────────────────────────┤
│                          │
│  PAGE TITLE              │
│  Short description       │
│                          │
│  [Primary Action - Full Width] │
│  [Secondary Action - Full]     │
│                          │
│  ┌────────────────────┐  │
│  │  Item 1            │  │
│  │  Details           │  │
│  │  [Action]          │  │
│  └────────────────────┘  │
│                          │
│  ┌────────────────────┐  │
│  │  Item 2            │  │
│  │  Details           │  │
│  │  [Action]          │  │
│  └────────────────────┘  │
│                          │
└──────────────────────────┘

Changes from Tablet:
• Single column layout
• Full-width buttons
• Stacked cards/items
• Condensed header
\`\`\`

---

## Content Blocks

### 1. Header

**Left Side:**
- Logo (clickable → home)
- [Mobile: Hamburger menu icon]

**Center:**
- Search bar (expandable on mobile)

**Right Side:**
- Notifications icon (with badge count if unread)
- Help/Support link
- User avatar (clickable → dropdown menu)

**Behavior:**
- Stays visible when scrolling
- Mobile: Search becomes icon, expands on tap

---

### 2. Page Title Section

**Content:**
- Main heading (H1): [Specific title]
- Subtitle/description: [Brief explanation of page purpose]
- [Optional] Metadata: Last updated, status indicator

**Purpose:** Orient user to current location and purpose

---

### 3. Primary Actions

**Buttons Displayed:**
- Primary: [Main action - e.g., "Create Post", "Save Changes"]
- Secondary: [Alternative - e.g., "Cancel", "View All"]

**Placement:**
- Desktop: Top right or below title
- Mobile: Full width, below title

**Behavior:**
- Primary action: [What happens] → [Where it goes]
- Secondary action: [What happens]

---

### 4. Main Content Area

[Describe each content section with its purpose]

**Section 1: [Name]**

**Purpose:** [What this section shows]

**Content:**
- [Data point 1]
- [Data point 2]
- [Data point 3]

**Layout:** [3 cards | Table | List | Form]

**Actions:** [What users can do here]

---

**Section 2: [Name]**

[Same format for each section]

---

### 5. Sidebar Navigation (Desktop)

**Structure:**
- Section headers (categories)
- Navigation items (with icons)
- Current page highlighted

**Sections:**
- [Section 1 name]
  - Nav item 1
  - Nav item 2
  - Current page (marked)
- [Section 2 name]
  - Nav item 3
  - Nav item 4

**Behavior:**
- Click item → Navigate to page
- Active item visually distinct
- Desktop: Always visible
- Tablet/Mobile: Hidden, accessible via menu

---

## Interactive Elements

### User Actions Map

| Element | Action | Result |
|---------|--------|--------|
| Logo | Click | Return to home page |
| Search bar | Type + Enter | Navigate to search results |
| Notification icon | Click | Open notifications dropdown |
| User avatar | Click | Show dropdown menu (Profile, Settings, Logout) |
| [Primary button] | Click | [Specific action from IA] |
| [Item card] | Click | Navigate to detail page |
| [Edit button] | Click | Open edit view/modal |

---

### Navigation Flow

**Entry Points:**
- From: [Previous page in user journey]
- How: [Link/button that brings user here]

**Exit Points:**
- Success path: [Where user goes after completing action]
- Cancel path: [Where user goes if they abandon]
- Alternative paths: [Other navigation options]

**Example for Post Create:**
- Entry: Dashboard → "Create Post" button
- Success: /posts/[new-id] → After publish
- Cancel: /dashboard → Cancel button or back

---

## States & Variations

### Default State
[The normal view when page loads with data]

**Shows:**
- All content populated
- All actions available
- Standard layout

---

### Loading State

**Shows:**
- Skeleton placeholders for content
- Disabled action buttons
- Loading indicator

**Layout:**
\`\`\`
┌─────────────────────────┐
│  ████████ (title)       │
│  ████ (subtitle)        │
│                         │
│  ▓▓▓▓▓  ▓▓▓▓▓  ▓▓▓▓▓  │
│  (loading cards)        │
└─────────────────────────┘
\`\`\`

---

### Empty State

**Shows:**
- Illustration or icon
- Message: "No [items] yet"
- Call to action: "Create your first [item]"

**Example:**
\`\`\`
┌─────────────────────────┐
│        [Icon]           │
│  No posts yet           │
│  Get started by         │
│  creating your first    │
│  post!                  │
│                         │
│  [Create Post]          │
└─────────────────────────┘
\`\`\`

---

### Error State

**Shows:**
- Error icon/illustration
- Error message (user-friendly)
- Recovery action: "Try Again" button
- Alternative: "Go Back" or "Contact Support"

---

## Forms (If Applicable)

[Only include this section if page has forms]

**Form Layout:**
\`\`\`
Field Label
┌─────────────────────────┐
│  Input box              │
└─────────────────────────┘
Helper text here

Field Label 2
┌─────────────────────────┐
│  Input box              │
└─────────────────────────┘
Error message if invalid

[ ] Checkbox option
[ ] Another checkbox

[Save]  [Cancel]
\`\`\`

**Fields:**
1. [Field name] - [Type] - [Required/Optional]
   - Purpose: [What this collects]
   - Validation: [Any rules]

2. [Field name] - [Type] - [Required/Optional]
   - Purpose: [What this collects]

**Actions:**
- Submit → [What happens]
- Cancel → [Where user goes]

---

## Tables (If Applicable)

[Only include if page has data tables]

**Desktop View:**
\`\`\`
┌────────────────────────────────────────────┐
│  Column 1    │  Column 2   │  Column 3   │ Actions │
├──────────────┼─────────────┼─────────────┼─────────┤
│  Data        │  Data       │  Data       │ [Edit]  │
│  Data        │  Data       │  Data       │ [Edit]  │
└────────────────────────────────────────────┘
[Showing 1-10 of 245]      [< 1 2 3 4 5 >]
\`\`\`

**Mobile View:**
\`\`\`
┌─────────────────────┐
│  Item 1             │
│  Key info displayed │
│  [View Details ▼]   │
├─────────────────────┤
│  Item 2             │
│  Key info           │
│  [View Details ▼]   │
└─────────────────────┘
\`\`\`

**Columns:**
1. [Column name] - [What data] - [Sortable? Yes/No]
2. [Column name] - [What data] - [Sortable? Yes/No]

**Actions:**
- Row actions: [Edit, Delete, View, etc.]
- Bulk actions: [If multiple rows can be selected]
- Pagination: [How many per page]

---

## Responsive Strategy

**How Layout Adapts:**

| Element | Desktop | Tablet | Mobile |
|---------|---------|---------|--------|
| Navigation | Sidebar visible | Hamburger menu | Hamburger menu |
| Content width | Max 1200px, centered | Full width, padding | Full width, minimal padding |
| Cards | 3 columns | 2 columns | 1 column (stacked) |
| Buttons | Inline | Inline | Full width, stacked |
| Tables | Full table | Scrollable | Card layout |
| Forms | Max 600px, centered | Max 600px | Full width |

**Breakpoint Behavior:**
- Large → Medium: Sidebar collapses to menu
- Medium → Small: Multi-column → Single column
- All sizes: Touch-friendly tap targets on smaller screens

---

## Accessibility Considerations

**Keyboard Navigation:**
- All interactive elements reachable by Tab key
- Logical tab order (top to bottom, left to right)
- Enter/Space activates buttons
- Escape closes modals/dropdowns

**Screen Reader Support:**
- Page has descriptive title
- Proper heading hierarchy (H1 → H2 → H3)
- Form fields have labels
- Images have alt text
- Error messages announced

**Visual:**
- Clear focus indicators on interactive elements
- Sufficient color contrast for text
- Text remains readable when zoomed 200%

---

## Content Requirements

**Data Needed:**
[List what data this page displays]

From: [API endpoint or data source]

**Example for Dashboard:**
- User name (from auth)
- Total posts count (from stats API)
- Recent activity (from activity API):
  - Activity type
  - Timestamp
  - Related item

**Static Content:**
- Page title: [Text]
- Description: [Text]
- Button labels: [List]
- Help text: [Text]

---

## Design Notes

**Visual Hierarchy:**
1. [Most important element] - Largest, most prominent
2. [Second priority] - Secondary emphasis
3. [Supporting content] - Standard size
4. [Tertiary info] - Smaller, less prominent

**Spacing:**
- Large gap between major sections
- Medium gap between related items
- Small gap within grouped content

**Emphasis:**
- Primary action: Most visually prominent
- Current page in nav: Clearly marked
- Active elements: Distinct from inactive

[Note: Specific sizes, colors, fonts defined in design system]

---

## Validation Checklist

- [ ] Layout supports primary user goal
- [ ] All content from IA is included
- [ ] Interactive elements have clear actions
- [ ] Responsive behavior makes sense
- [ ] Empty/loading/error states defined
- [ ] Keyboard navigation possible
- [ ] Addresses pain points from user journey
- [ ] Clear next steps for users

---

## Next Steps

After reviewing this wireframe:

1. **Get feedback** from team/users
2. **Create wireframes** for related pages
3. **Define design system** (visual styling)
4. **List components** needed (from all wireframes)
5. **Build components** and assemble page

---

## Related Documents

- Information Architecture: `tasks/information_architecture.md`
- User Journey: `tasks/user_journeys.md`
- [Other wireframes]: `tasks/wireframes/[page].md`

```
