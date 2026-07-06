# Component Inventory — Document Template

```markdown
# Component Inventory

**Project:** [Name from requirements]
**Generated:** [Current Date]
**Purpose:** Prioritized list of all UI components needed for implementation

---

## Executive Summary

**Total Components:** [X]
- Must Have (Phase 1): [Y] components
- Should Have (Phase 2): [Z] components
- Nice to Have (Phase 3): [N] components

**Estimated Build Time:** [X] weeks
- Phase 1: [Y] days
- Phase 2: [Z] days
- Phase 3: [N] days

**Critical Path:** [List 3-5 components that are blocking others]

---

## Analysis Summary

**Based on wireframe analysis:**
- Scanned [X] wireframe files
- Identified [Y] unique component patterns
- Found [Z] variations of existing components
- Mapped to [N] design system patterns

**Component breakdown by type:**
- Form elements: [X]
- Layout components: [Y]
- Data display: [Z]
- Navigation: [N]
- Feedback: [M]
- Interactive: [P]

---

## Phase 1: Must Have (MVP Components)

**Goal:** Enable core user flows identified in user journey map

**Build order:** 1-2 weeks

### 1.1 Foundation Components

These are the building blocks used by everything else. Build these FIRST.

#### Button
**Priority:** 🔴 Critical - Blocks everything
**Complexity:** ⭐ Simple
**Build Time:** 2 hours

**Variants needed:**
- Primary (bg-blue-600)
- Secondary (bg-gray-200)
- Outline (border-blue-600)
- Destructive (bg-red-600)

**Props:**
- variant: 'primary' | 'secondary' | 'outline' | 'destructive'
- size: 'sm' | 'md' | 'lg'
- loading: boolean
- disabled: boolean
- children: ReactNode
- className: string

**Design system reference:** Button patterns (Section X)

**Used in:**
- All forms
- All pages
- Navigation
- Modals
- [List specific pages from IA]

**Dependencies:** None

**Build command:**
\`\`\`bash
/gen-ui-component button --variants=primary,secondary,outline,destructive
\`\`\`

---

#### Input
**Priority:** 🔴 Critical - Blocks all forms
**Complexity:** ⭐⭐ Medium
**Build Time:** 4 hours

**Types needed:**
- Text input
- Email input
- Password input
- Number input
- Textarea

**Features:**
- Label support
- Error state
- Helper text
- Disabled state
- Validation states
- Dark mode

**Props:**
- type: 'text' | 'email' | 'password' | 'number'
- label: string
- error: string
- helperText: string
- disabled: boolean
- required: boolean
- placeholder: string
- value: string
- onChange: (value: string) => void

**Design system reference:** Form Inputs (Section X)

**Used in:**
- Login form
- Registration form
- Profile edit
- Post creation
- Search bars
- [List specific wireframes]

**Dependencies:** None (but pairs well with FormField wrapper)

**Build command:**
\`\`\`bash
/gen-ui-component input --with-validation
\`\`\`

---

#### Card
**Priority:** 🔴 Critical - Primary layout component
**Complexity:** ⭐ Simple
**Build Time:** 2 hours

**Variants needed:**
- Basic card
- Clickable card (with hover)
- Card with header
- Card with footer

**Props:**
- variant: 'default' | 'clickable'
- title: string (optional)
- subtitle: string (optional)
- footer: ReactNode (optional)
- children: ReactNode
- onClick: () => void (for clickable)
- className: string

**Design system reference:** Cards (Section X)

**Used in:**
- Dashboard (stat cards)
- Post list
- User list
- Settings sections
- [List pages from wireframes]

**Dependencies:** None

**Build command:**
\`\`\`bash
/gen-ui-component card
\`\`\`

---

[Continue for all Phase 1 components]

### 1.2 Form Components

#### FormField (Wrapper)
**Priority:** 🔴 Critical
**Complexity:** ⭐ Simple
**Build Time:** 1 hour

**Purpose:** Wraps Input with consistent label, error, helper text layout

**Props:**
- label: string
- error: string
- helperText: string
- required: boolean
- children: ReactNode (Input component)

**Dependencies:** None

**Build command:**
\`\`\`bash
/gen-ui-component form-field
\`\`\`

---

#### Select (Dropdown)
**Priority:** 🟡 High
**Complexity:** ⭐⭐ Medium
**Build Time:** 3 hours

**Used in:**
- Filters
- Category selection
- Settings dropdowns
- [Specific wireframes]

**Dependencies:** None

---

#### Checkbox
**Priority:** 🟡 High
**Complexity:** ⭐ Simple
**Build Time:** 1 hour

**Used in:**
- Terms agreement
- Settings toggles
- Multi-select lists
- [Specific wireframes]

**Dependencies:** None

---

### 1.3 Feedback Components

#### Alert
**Priority:** 🟡 High
**Complexity:** ⭐ Simple
**Build Time:** 2 hours

**Variants:**
- Info (blue)
- Success (green)
- Warning (amber)
- Error (red)

**Props:**
- variant: 'info' | 'success' | 'warning' | 'error'
- title: string (optional)
- message: string
- dismissible: boolean
- onDismiss: () => void

**Design system reference:** Alerts (Section X)

**Used in:**
- Form validation feedback
- Page-level messages
- Inline warnings
- [Specific pages]

**Dependencies:** None

**Build command:**
\`\`\`bash
/gen-ui-component alert --variants=info,success,warning,error
\`\`\`

---

#### LoadingSpinner
**Priority:** 🟡 High
**Complexity:** ⭐ Simple
**Build Time:** 1 hour

**Variants:**
- Small (16px)
- Medium (24px)
- Large (48px)

**Props:**
- size: 'sm' | 'md' | 'lg'
- color: string (Tailwind color)

**Used in:**
- Button loading states
- Page loading
- Data fetching states
- [Throughout app]

**Dependencies:** None

**Build command:**
\`\`\`bash
/gen-ui-component spinner
\`\`\`

---

#### Badge
**Priority:** 🟡 High
**Complexity:** ⭐ Simple
**Build Time:** 1 hour

**Variants:**
- Status badges (active, pending, inactive)
- Count badges (notifications)
- Category badges

**Props:**
- variant: 'success' | 'warning' | 'error' | 'info' | 'default'
- children: ReactNode
- size: 'sm' | 'md'

**Design system reference:** Badges (Section X)

**Used in:**
- User status
- Notification counts
- Post categories
- Table status columns
- [Specific locations]

**Dependencies:** None

**Build command:**
\`\`\`bash
/gen-ui-component badge --variants=success,warning,error,info
\`\`\`

---

### 1.4 Layout Components

#### Container
**Priority:** 🟡 High
**Complexity:** ⭐ Simple
**Build Time:** 30 minutes

**Purpose:** Consistent max-width container with responsive padding

**Props:**
- maxWidth: 'sm' | 'md' | 'lg' | 'xl' | 'full'
- children: ReactNode

**Used in:**
- All pages
- Content wrapping

**Dependencies:** None

---

#### Avatar
**Priority:** 🟢 Medium
**Complexity:** ⭐ Simple
**Build Time:** 1 hour

**Features:**
- Image avatar
- Fallback initials
- Status indicator (online/offline)

**Props:**
- src: string
- alt: string
- size: 'sm' | 'md' | 'lg'
- fallback: string (initials)
- status: 'online' | 'offline' | null

**Used in:**
- User menu
- Comment sections
- User lists
- Profile pages

**Dependencies:** None

---

### Phase 1 Summary

**Total components:** [X]
**Estimated time:** 1-2 weeks
**Build order:**
1. Button (2h)
2. Input (4h)
3. Card (2h)
4. FormField (1h)
5. LoadingSpinner (1h)
6. Alert (2h)
7. Badge (1h)
8. Select (3h)
9. Checkbox (1h)
10. Container (30m)
11. Avatar (1h)

**After Phase 1, you can build:**
- ✅ Login page
- ✅ Registration page
- ✅ Basic dashboard
- ✅ Profile page (view only)
- ✅ Simple forms

---

## Phase 2: Should Have (Enhanced Experience)

**Goal:** Complete all planned features, add polish

**Build order:** 2-3 weeks

### 2.1 Navigation Components

#### Header
**Priority:** 🟡 High
**Complexity:** ⭐⭐ Medium
**Build Time:** 4 hours

**Features:**
- Logo
- Desktop navigation
- Mobile hamburger menu
- User menu dropdown
- Notifications icon
- Search bar integration

**Props:**
- logo: ReactNode
- navItems: Array<{label: string, href: string}>
- user: {name: string, avatar: string} | null
- notificationCount: number
- onSearch: (query: string) => void

**Design system reference:** Navigation (Section X)

**Used in:**
- All authenticated pages
- Public pages

**Dependencies:**
- Button
- Avatar
- Dropdown (to be built)

**Wireframe reference:** [All wireframes show header]

---

#### Sidebar
**Priority:** 🟡 High (for admin/dashboard)
**Complexity:** ⭐⭐ Medium
**Build Time:** 3 hours

**Features:**
- Collapsible
- Active state highlighting
- Icon + text
- Section headers

**Props:**
- items: Array<{label: string, href: string, icon: ReactNode}>
- collapsed: boolean
- onToggle: () => void

**Used in:**
- Dashboard
- Admin pages
- Settings

**Dependencies:**
- Button (for toggle)

---

#### Breadcrumbs
**Priority:** 🟢 Medium
**Complexity:** ⭐ Simple
**Build Time:** 1 hour

**Props:**
- items: Array<{label: string, href: string}>
- separator: ReactNode (default: '/')

**Used in:**
- Nested pages
- Admin sections
- Multi-step flows

**Dependencies:** None

---

#### Tabs
**Priority:** 🟡 High
**Complexity:** ⭐⭐ Medium
**Build Time:** 3 hours

**Features:**
- Horizontal tabs
- Active state
- Keyboard navigation
- Controlled/uncontrolled modes

**Props:**
- tabs: Array<{label: string, value: string}>
- activeTab: string
- onChange: (value: string) => void
- children: ReactNode

**Used in:**
- Profile pages (Info, Settings, Security)
- Admin sections
- Multi-view pages

**Dependencies:** None

---

### 2.2 Advanced Form Components

#### DatePicker (Optional - consider library)
**Priority:** 🟢 Medium
**Complexity:** ⭐⭐⭐ Complex
**Build Time:** 8 hours (or use library)

**Recommendation:** Use `react-day-picker` library wrapped in custom component

**Props:**
- value: Date
- onChange: (date: Date) => void
- minDate: Date
- maxDate: Date
- disabled: boolean

**Used in:**
- Scheduling features
- Date filters
- Booking forms

**Dependencies:**
- Input (for display)
- Consider library: react-day-picker

---

#### FileUpload
**Priority:** 🟢 Medium
**Complexity:** ⭐⭐ Medium
**Build Time:** 4 hours

**Features:**
- Drag and drop
- File preview
- Upload progress
- Multiple files support
- File type validation

**Props:**
- accept: string (file types)
- multiple: boolean
- maxSize: number (bytes)
- onUpload: (files: File[]) => void
- preview: boolean

**Used in:**
- Profile avatar upload
- Post image upload
- Document uploads

**Dependencies:**
- Button
- LoadingSpinner

---

### 2.3 Data Display Components

#### Table
**Priority:** 🟡 High
**Complexity:** ⭐⭐⭐ Complex
**Build Time:** 6 hours

**Features:**
- Sortable columns
- Pagination
- Row selection
- Loading state
- Empty state
- Responsive (card view on mobile)

**Props:**
- columns: Array<{key: string, label: string, sortable: boolean, render: Function}>
- data: Array<Object>
- onSort: (column: string, direction: 'asc' | 'desc') => void
- loading: boolean
- emptyMessage: string
- rowsPerPage: number
- currentPage: number
- onPageChange: (page: number) => void

**Design system reference:** Tables (Section X)

**Used in:**
- Admin user list
- Post list (admin view)
- Data dashboards
- [Specific wireframes]

**Dependencies:**
- Button (pagination)
- LoadingSpinner
- Badge (for status columns)

**Build command:**
\`\`\`bash
/gen-ui-component table --with-sorting --with-pagination
\`\`\`

---

#### Pagination
**Priority:** 🟡 High
**Complexity:** ⭐⭐ Medium
**Build Time:** 2 hours

**Features:**
- Page numbers
- Previous/Next buttons
- Jump to page
- Total count display

**Props:**
- currentPage: number
- totalPages: number
- onPageChange: (page: number) => void
- showPageNumbers: boolean
- maxPageNumbers: number (default: 5)

**Used in:**
- Tables
- List views
- Search results

**Dependencies:**
- Button

---

#### EmptyState
**Priority:** 🟢 Medium
**Complexity:** ⭐ Simple
**Build Time:** 1 hour

**Features:**
- Icon/illustration
- Message
- Action button

**Props:**
- icon: ReactNode
- title: string
- message: string
- action: {label: string, onClick: Function} (optional)

**Used in:**
- Empty lists
- No search results
- New user states

**Dependencies:**
- Button

---

### 2.4 Interactive Components

#### Modal/Dialog
**Priority:** 🟡 High
**Complexity:** ⭐⭐⭐ Complex
**Build Time:** 4 hours

**Features:**
- Backdrop with click-outside to close
- ESC key to close
- Focus trap
- Scroll lock
- Size variants

**Props:**
- open: boolean
- onClose: () => void
- title: string
- children: ReactNode
- size: 'sm' | 'md' | 'lg' | 'xl'
- closeOnBackdrop: boolean

**Design system reference:** Modals (Section X)

**Used in:**
- Confirmations
- Forms in overlay
- Image preview
- [Specific interactions]

**Dependencies:**
- Button (close, actions)

**Build command:**
\`\`\`bash
/gen-ui-component modal --with-portal
\`\`\`

---

#### Dropdown Menu
**Priority:** 🟡 High
**Complexity:** ⭐⭐⭐ Complex
**Build Time:** 4 hours

**Features:**
- Keyboard navigation
- Auto-positioning
- Click outside to close
- Dividers
- Icons in menu items

**Props:**
- trigger: ReactNode
- items: Array<{label: string, onClick: Function, icon: ReactNode, divider: boolean}>
- position: 'bottom-left' | 'bottom-right' | 'top-left' | 'top-right'

**Used in:**
- User menu
- Action menus
- Context menus
- Settings

**Dependencies:**
- Button (trigger)

---

#### Toast/Notification
**Priority:** 🟡 High
**Complexity:** ⭐⭐ Medium
**Build Time:** 3 hours

**Features:**
- Auto-dismiss
- Stacking multiple toasts
- Position control
- Variants (success, error, info)
- Close button

**Props:**
- message: string
- variant: 'success' | 'error' | 'info' | 'warning'
- duration: number (ms, default: 3000)
- position: 'top-right' | 'top-left' | 'bottom-right' | 'bottom-left'
- onClose: () => void

**Used in:**
- Form submission feedback
- Action confirmations
- Error notifications
- Throughout app

**Dependencies:**
- Alert (for styling)

**Note:** Consider using library like `react-hot-toast` or `sonner`

---

#### Tooltip
**Priority:** 🟢 Medium
**Complexity:** ⭐⭐ Medium
**Build Time:** 2 hours

**Features:**
- Auto-positioning
- Hover trigger
- Keyboard accessible

**Props:**
- content: string | ReactNode
- children: ReactNode (trigger)
- position: 'top' | 'bottom' | 'left' | 'right'
- delay: number (ms)

**Used in:**
- Icon buttons
- Help text
- Truncated content
- Information hints

**Dependencies:** None

---

### Phase 2 Summary

**Total components:** [X]
**Estimated time:** 2-3 weeks
**Build order:**
1. Modal (4h)
2. Dropdown Menu (4h)
3. Header (4h)
4. Sidebar (3h)
5. Tabs (3h)
6. Table (6h)
7. Pagination (2h)
8. Toast (3h)
9. Tooltip (2h)
10. FileUpload (4h)
11. EmptyState (1h)
12. Breadcrumbs (1h)

**After Phase 2, you can build:**
- ✅ Complete dashboard with sidebar
- ✅ Admin pages with tables
- ✅ Full navigation system
- ✅ Complex forms with file upload
- ✅ Rich user interactions

---

## Phase 3: Nice to Have (Polish & Enhancement)

**Goal:** Premium experience, advanced features

**Build order:** 1-2 weeks (or ongoing)

### 3.1 Advanced Components

#### Command Palette
**Priority:** 🔵 Low
**Complexity:** ⭐⭐⭐ Complex
**Build Time:** 6 hours

**Features:**
- Fuzzy search
- Keyboard shortcuts (⌘K)
- Recent searches
- Categories

**Props:**
- items: Array<{label: string, action: Function, category: string}>
- onSelect: (item) => void

**Used in:**
- Power user features
- Quick navigation
- Search enhancement

**Dependencies:**
- Modal
- Input

---

#### Skeleton Loader
**Priority:** 🟢 Medium
**Complexity:** ⭐ Simple
**Build Time:** 2 hours

**Variants:**
- Text lines
- Circle (avatar)
- Rectangle (card)
- Custom shapes

**Props:**
- variant: 'text' | 'circle' | 'rectangle'
- width: string
- height: string
- count: number (for multiple lines)

**Used in:**
- Loading states
- Perceived performance
- Better UX during data fetching

**Dependencies:** None

---

#### Progress Bar
**Priority:** 🟢 Medium
**Complexity:** ⭐ Simple
**Build Time:** 1 hour

**Features:**
- Determinate (with percentage)
- Indeterminate (loading)
- Color variants

**Props:**
- value: number (0-100)
- indeterminate: boolean
- variant: 'default' | 'success' | 'warning' | 'error'
- size: 'sm' | 'md' | 'lg'

**Used in:**
- File uploads
- Multi-step forms
- Task completion
- Profile completion

**Dependencies:** None

---

#### Accordion/Collapsible
**Priority:** 🟢 Medium
**Complexity:** ⭐⭐ Medium
**Build Time:** 3 hours

**Features:**
- Single/multiple open
- Animated expand/collapse
- Keyboard navigation

**Props:**
- items: Array<{title: string, content: ReactNode}>
- allowMultiple: boolean
- defaultOpen: string[] (item keys)

**Used in:**
- FAQs
- Settings sections
- Filters

**Dependencies:**
- Button (toggle)

---

#### Popover
**Priority:** 🔵 Low
**Complexity:** ⭐⭐ Medium
**Build Time:** 3 hours

**Features:**
- Auto-positioning
- Click or hover trigger
- Arrow pointer

---

## Component Dependencies

### Critical Path (Build First)

```
component library setup
  ├── Button
  ├── Input
  ├── Form
  └── Label
      └── LoginForm (can be built)
          └── loginAction (Server Action)
              └── Login flow complete ✅
```

### Dependency Graph

**No Dependencies (Build First):**
- Button
- Input
- Card
- Label
- Badge
- Avatar
- Skeleton

**Depends on Foundation:**
- Form (needs Button, Input, Label)
- Alert (needs Button for dismiss)
- Dialog (needs Button)
- Dropdown Menu (needs Button)

**Depends on Multiple:**
- Table (needs Button, Badge, Skeleton)
- LoginForm (needs Form, Input, Button, Label)
- ProfileForm (needs Form, Input, Textarea, Button, Label)

---


---

## Testing Strategy

### Unit Tests (Priority Components)
- Form validation schemas (Yup)
- Server Actions (mock responses)
- Shared components (Button, Input, Card)

### Integration Tests
- Form submission flows
- Auth flow (login → dashboard)
- Navigation flow
- Server/Client data passing

### E2E Tests
- Complete user journeys
- Multi-step forms
- Error handling

---


---

## Build Order

Sequence components so nothing blocks: foundation (buttons, inputs, typography) → forms → feedback (toasts, alerts, empty/loading states) → layout → navigation → data display → interactive extras. Within each phase, build dependencies first (see Component Dependencies). State a rough time estimate per phase based on the complexity ratings.

## Success Criteria

- Every unique UI pattern in the wireframes maps to exactly one component (with variants, not duplicates)
- Each component lists: purpose, variants, states, complexity, dependencies, and which pages use it
- Phases are honest: MVP phase alone must be enough to ship the core user journeys
