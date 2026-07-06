# Design System — Document Template

```markdown
# Design System

**Project:** [Name]
**Type:** [SaaS Dashboard | E-commerce | Content Platform | etc.]
**Version:** 1.0
**Framework:** Tailwind CSS v4.1+
**Generated:** [Date]

---

## Executive Summary

**What This System Is For:**
[2-3 sentences about the project type and design needs]

Example: "A SaaS analytics dashboard with heavy data visualization, multiple forms, and real-time updates. Design prioritizes clarity, quick scanning, and trust. Users are data analysts spending 4+ hours per day in the app."

**Key Design Decisions:**
1. [Decision with reasoning] - "Using blue as primary because it signals trust and tech, critical for financial data"
2. [Decision] - "Generous spacing in forms because 80% of user time is data entry"
3. [Decision] - "Muted color palette to reduce eye strain during long sessions"
4. [Decision] - "Dark mode uses soft grays, not pure black, based on user research"

**Design Priorities:**
1. [Priority] - Clarity over aesthetics
2. [Priority] - Scanning speed over visual flair
3. [Priority] - Consistency over flexibility

---

## Project Analysis

**Type:** [Classification with evidence]
- Forms identified: [X] forms
- Data tables: [Y] tables
- Cards: [Z] variations
- User sessions: [Average length from requirements]
- Primary user actions: [List from user journeys]

**Visual Complexity:** [Sparse | Medium | Dense]
**Information Density:** [Low | Medium | High]
**Interaction Patterns:** [List patterns found in wireframes]

**This Means:**
- [Implication] - "High form count means validation patterns are critical"
- [Implication] - "Data tables need robust styling and states"
- [Implication] - "Long session times require comfortable colors"

---

## Tailwind v4.1 Setup

### Installation

\`\`\`bash
npm install tailwindcss@latest
\`\`\`

### Configuration (CSS-First)

Create `src/styles/design-system.css`:

\`\`\`css
@import "tailwindcss";

/* ============================================
   CUSTOM DESIGN SYSTEM
   Based on analysis of [X] wireframes
   ============================================ */

@theme {
  /* === BRAND COLORS === */
  /* Primary: [Reasoning for choice] */
  --color-primary-50: #eff6ff;
  --color-primary-100: #dbeafe;
  --color-primary-200: #bfdbfe;
  --color-primary-300: #93c5fd;
  --color-primary-400: #60a5fa;
  --color-primary-500: #3b82f6;  /* Main brand color */
  --color-primary-600: #2563eb;  /* Hover state */
  --color-primary-700: #1d4ed8;  /* Active state */
  --color-primary-800: #1e40af;
  --color-primary-900: #1e3a8a;
  --color-primary-950: #172554;

  /* === SEMANTIC COLORS === */
  /* Success - Used for: [specific uses from wireframes] */
  --color-success-50: #f0fdf4;
  --color-success-100: #dcfce7;
  --color-success-500: #22c55e;  /* Main */
  --color-success-600: #16a34a;  /* Hover */
  --color-success-700: #15803d;  /* Active */

  /* Error - Used for: [specific uses] */
  --color-error-50: #fef2f2;
  --color-error-100: #fee2e2;
  --color-error-500: #ef4444;
  --color-error-600: #dc2626;
  --color-error-700: #b91c1c;

  /* Warning - Used for: [specific uses] */
  --color-warning-50: #fffbeb;
  --color-warning-100: #fef3c7;
  --color-warning-500: #f59e0b;
  --color-warning-600: #d97706;
  --color-warning-700: #b45309;

  /* === TYPOGRAPHY === */
  /* Display font for [use case] */
  --font-display: "Inter", ui-sans-serif, system-ui, sans-serif;

  /* Body font for [use case] */
  --font-body: ui-sans-serif, system-ui, sans-serif;

  /* Mono font for [use case] */
  --font-mono: "Fira Code", ui-monospace, monospace;

  /* === CUSTOM SPACING === */
  /* Semantic spacing based on layout analysis */
  --spacing-field: 1rem;      /* 16px - between form fields */
  --spacing-section: 3rem;    /* 48px - between sections */
  --spacing-card: 1.5rem;     /* 24px - card padding */
  --spacing-inline: 0.5rem;   /* 8px - icon gaps */

  /* === SHADOWS === */
  /* Elevation system for [context] */
  --shadow-card: 0 1px 3px 0 rgb(0 0 0 / 0.1);
  --shadow-overlay: 0 20px 25px -5px rgb(0 0 0 / 0.1);
  --shadow-focus: 0 0 0 3px rgb(59 130 246 / 0.5);

  /* === BORDER RADIUS === */
  --radius-button: 0.375rem;  /* 6px */
  --radius-card: 0.5rem;      /* 8px */
  --radius-input: 0.375rem;   /* 6px */
  --radius-modal: 0.75rem;    /* 12px */
}

/* === CUSTOM UTILITIES === */
/* Only add utilities that are used 3+ times */

@utility focus-ring {
  outline: 2px solid theme(--color-primary-500);
  outline-offset: 2px;
}

@utility btn-base {
  font-weight: 500;
  border-radius: theme(--radius-button);
  transition: all 150ms ease;
  &:focus-visible {
    @apply focus-ring;
  }
}
\`\`\`

### Import in App

\`\`\`javascript
// Next.js: app/layout.tsx
import '@/styles/design-system.css'
\`\`\`

---

## Color System

### Philosophy

[Explain the color strategy based on project type]

Example: "Primary blue signals trust and technology, critical for a financial dashboard. Success green is reserved for positive metrics and completed actions only. Error red is exclusively for destructive actions and critical alerts to maintain its weight."

### Primary Color - [Color Name]

**Why This Color:**
[Reasoning based on project] - "Blue chosen because [industry standard for trust], tested well with [target users], and provides excellent contrast for accessibility."

**Usage:**
- Main actions (CTA buttons)
- Links and navigation
- Focus states
- Brand moments

**Shades:**
\`\`\`html
<div class="bg-primary-50">Lightest - backgrounds</div>
<div class="bg-primary-100">Light - hover backgrounds</div>
<div class="bg-primary-500">Main - primary actions</div>
<div class="bg-primary-600">Hover - button hover</div>
<div class="bg-primary-700">Active - button active</div>
\`\`\`

### Semantic Colors

#### Success (Green)
**Used for:** [Specific list from wireframes]
- Successful form submission
- Completed tasks
- Positive metrics (↑ revenue, ↑ users)
- Available status

**DO NOT use for:** Neutral actions (use primary)

\`\`\`html
<!-- Success alert -->
<div class="bg-success-50 border-l-4 border-success-500 p-4">
  <p class="text-success-700">Data saved successfully</p>
</div>

<!-- Success badge -->
<span class="bg-success-100 text-success-700 px-2 py-1 rounded">
  Active
</span>
\`\`\`

#### Error (Red)
**Used for:** [Specific list]
- Form validation errors
- Failed operations
- Destructive actions (Delete button)
- Critical alerts
- Negative metrics

\`\`\`html
<!-- Error input -->
<input class="border-error-500 focus:ring-error-500" />
<p class="text-error-600 text-sm mt-1">Email is required</p>

<!-- Destructive button -->
<button class="bg-error-600 hover:bg-error-700 text-white">
  Delete Account
</button>
\`\`\`

#### Warning (Amber)
**Used for:** [Specific list]
- Non-critical warnings
- Pending status
- Approaching limits

\`\`\`html
<div class="bg-warning-50 border-l-4 border-warning-500 p-4">
  <p class="text-warning-700">Storage is 80% full</p>
</div>
\`\`\`

### Neutral Colors (Grays)

**Strategy:** [Explain gray choices]
- Using slate (blue undertone) because it complements primary blue
- True grays would look dead against colored elements
- Warmer grays avoided to maintain professional feel

\`\`\`html
<!-- Light mode -->
<div class="bg-white text-gray-900">Content</div>
<div class="bg-gray-50 text-gray-900">Subtle background</div>
<div class="bg-gray-100">Cards, hover states</div>

<!-- Dark mode -->
<div class="dark:bg-gray-900 dark:text-white">Content</div>
<div class="dark:bg-gray-800">Cards</div>
<div class="dark:bg-gray-700">Hover states</div>
\`\`\`

### Data Visualization Colors

[Only if project has charts/graphs]

**Chart Palette:** Designed for clarity and accessibility

\`\`\`css
--color-chart-1: #3b82f6;  /* Blue */
--color-chart-2: #10b981;  /* Green */
--color-chart-3: #f59e0b;  /* Amber */
--color-chart-4: #ef4444;  /* Red */
--color-chart-5: #8b5cf6;  /* Violet */
--color-chart-6: #ec4899;  /* Pink */
\`\`\`

**Why these colors:** Distinguishable for colorblind users, work in light/dark mode, adequate contrast.

---

## Typography

### Font Strategy

**Display Font: [Font Name]**
[Why chosen] - "Inter for its excellent readability at all sizes, extensive weight range, and tech-forward aesthetic that matches our SaaS positioning."

**Body Font: System Fonts**
[Why chosen] - "Using system font stack for instant loading and native feel. Reserves Inter for headings where brand personality matters."

**Monospace: [Font Name]**
[Why chosen] - "Fira Code for displaying data, code snippets, and timestamps. Supports ligatures for better code readability."

### Type Scale

**Based on:** [Project needs]
"Scale is tighter than typical marketing sites because this is a data-dense dashboard. Users scan content rather than read long-form. Headlines are informative, not decorative."

\`\`\`html
<!-- Page Title (H1) -->
<h1 class="text-2xl font-semibold text-gray-900 dark:text-white">
  Dashboard Overview
</h1>

<!-- Section Title (H2) -->
<h2 class="text-xl font-semibold text-gray-900 dark:text-white mb-4">
  Recent Activity
</h2>

<!-- Subsection (H3) -->
<h3 class="text-lg font-medium text-gray-900 dark:text-white">
  User Stats
</h3>

<!-- Card Title (H4) -->
<h4 class="text-base font-medium text-gray-900 dark:text-white">
  Total Revenue
</h4>

<!-- Body Text -->
<p class="text-sm text-gray-600 dark:text-gray-300 leading-relaxed">
  Standard body text for descriptions and content.
</p>

<!-- Small Text -->
<p class="text-xs text-gray-500 dark:text-gray-400">
  Secondary information, timestamps, captions.
</p>
\`\`\`

**Why these sizes:**
- H1 at 24px (not 48px) - it's a label, not marketing copy
- Body at 14px - optimal for scanning dense information
- Small at 12px - still readable, used heavily for metadata

### Font Weights

\`\`\`html
<span class="font-normal">400 - Body text (default)</span>
<span class="font-medium">500 - Form labels, emphasis</span>
<span class="font-semibold">600 - Headings, buttons</span>
<span class="font-bold">700 - Strong emphasis only</span>
\`\`\`

**Usage guidelines:**
- Default to font-normal (400) for all body text
- Use font-medium (500) for labels and subtle emphasis
- Reserve font-semibold (600) for headings and buttons
- Rarely use font-bold (700) - it's too heavy for long sessions

---

## Spacing System

### Philosophy

[Explain spacing decisions] - "Spacing is tighter than typical consumer apps because users need to see more information at once. However, form fields use generous spacing to reduce errors."

### Base Unit: 4px

Standard spacing scale:
- 1 = 4px
- 2 = 8px
- 4 = 16px ← Most common
- 6 = 24px ← Card padding
- 8 = 32px
- 12 = 48px ← Section gaps

### Semantic Spacing Tokens

Use these for consistency:

\`\`\`html
<!-- Form field spacing -->
<form class="space-y-[--spacing-field]">
  <!-- 16px between fields -->
</form>

<!-- Card padding -->
<div class="p-[--spacing-card]">
  <!-- 24px padding -->
</div>

<!-- Section gaps -->
<section class="space-y-[--spacing-section]">
  <!-- 48px between sections -->
</section>

<!-- Inline gaps (icon + text) -->
<button class="flex items-center gap-[--spacing-inline]">
  <Icon />
  <span>Text</span>
</button>
\`\`\`

### Common Patterns

\`\`\`html
<!-- Button padding -->
<button class="px-4 py-2">Standard button</button>
<button class="px-3 py-1.5">Small button</button>

<!-- Input padding -->
<input class="px-3 py-2" />

<!-- Card -->
<div class="p-6">Standard card</div>

<!-- Modal -->
<div class="p-8">Modal content</div>

<!-- Page container -->
<main class="px-4 py-8 md:px-6 md:py-12">
  <!-- More padding on desktop -->
</main>
\`\`\`

---

## Component Patterns

[Only include components actually needed from wireframes]

### Buttons

**Variants needed:** [Based on wireframe analysis]
- Primary (main actions) - used [X] times across wireframes
- Secondary (alternative actions) - used [Y] times
- Destructive (delete/remove) - used [Z] times

[DO NOT include outline, ghost, link variants if not used in wireframes]

#### Primary Button

**Use for:** Main actions, form submissions, primary CTAs
**Used in:** [List actual pages] - Login form, Create button, Save changes

\`\`\`html
<button class="
  /* Base styles */
  inline-flex items-center justify-center gap-2
  px-4 py-2

  /* Colors */
  bg-primary-600 hover:bg-primary-700 active:bg-primary-800
  text-white

  /* Shape */
  rounded-[--radius-button]
  font-medium text-sm

  /* States */
  transition-colors duration-150
  focus-visible:outline focus-visible:outline-2
  focus-visible:outline-primary-500 focus-visible:outline-offset-2

  disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:bg-primary-600
">
  Primary Action
</button>

<!-- With loading state -->
<button disabled class="...">
  <svg class="animate-spin h-4 w-4" viewBox="0 0 24 24">
    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none"/>
    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"/>
  </svg>
  Loading...
</button>

<!-- With icon -->
<button class="...">
  <PlusIcon class="h-4 w-4" />
  Add Item
</button>
\`\`\`

#### Secondary Button

**Use for:** Alternative actions, cancel buttons
**Used in:** [List actual uses]

\`\`\`html
<button class="
  px-4 py-2
  bg-gray-100 hover:bg-gray-200 active:bg-gray-300
  dark:bg-gray-700 dark:hover:bg-gray-600 dark:active:bg-gray-500
  text-gray-900 dark:text-white
  rounded-[--radius-button]
  font-medium text-sm
  transition-colors duration-150
  focus-visible:outline focus-visible:outline-2
  focus-visible:outline-gray-500 focus-visible:outline-offset-2
">
  Cancel
</button>
\`\`\`

#### Destructive Button

**Use for:** Delete, remove, destructive actions
**Always confirm:** Pair with confirmation modal

\`\`\`html
<button class="
  px-4 py-2
  bg-error-600 hover:bg-error-700 active:bg-error-800
  text-white
  rounded-[--radius-button]
  font-medium text-sm
  transition-colors duration-150
  focus-visible:outline focus-visible:outline-2
  focus-visible:outline-error-500 focus-visible:outline-offset-2
">
  Delete Account
</button>
\`\`\`

---

### Form Inputs

[Complete pattern with all states]

#### Text Input

\`\`\`html
<!-- Default state -->
<div class="space-y-2">
  <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
    Email Address
  </label>
  <input
    type="email"
    class="
      w-full px-3 py-2
      bg-white dark:bg-gray-800
      border border-gray-300 dark:border-gray-600
      rounded-[--radius-input]
      text-gray-900 dark:text-white
      text-sm
      placeholder:text-gray-400 dark:placeholder:text-gray-500

      focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent

      disabled:bg-gray-50 dark:disabled:bg-gray-900
      disabled:text-gray-500 disabled:cursor-not-allowed
    "
    placeholder="you@example.com"
  />
  <p class="text-xs text-gray-500 dark:text-gray-400">
    We'll never share your email.
  </p>
</div>

<!-- Error state -->
<div class="space-y-2">
  <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
    Email Address
  </label>
  <input
    type="email"
    aria-invalid="true"
    aria-describedby="email-error"
    class="
      w-full px-3 py-2
      border-2 border-error-500
      rounded-[--radius-input]
      text-gray-900 dark:text-white
      focus:outline-none focus:ring-2 focus:ring-error-500
    "
  />
  <p id="email-error" class="text-sm text-error-600 dark:text-error-400">
    Please enter a valid email address
  </p>
</div>

<!-- Success state (after validation) -->
<div class="space-y-2">
  <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
    Email Address
  </label>
  <div class="relative">
    <input
      type="email"
      class="
        w-full px-3 py-2 pr-10
        border-2 border-success-500
        rounded-[--radius-input]
      "
    />
    <div class="absolute inset-y-0 right-0 flex items-center pr-3">
      <svg class="h-5 w-5 text-success-500" fill="currentColor" viewBox="0 0 20 20">
        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
      </svg>
    </div>
  </div>
</div>
\`\`\`

---

### Cards

[Based on card usage in wireframes]

**Types found:**
- Stat cards ([X] instances) - Dashboard metrics
- Content cards ([Y] instances) - List items
- Interactive cards ([Z] instances) - Clickable items

#### Stat Card

**Pattern:** Used for dashboard KPIs

\`\`\`html
<div class="
  bg-white dark:bg-gray-800
  border border-gray-200 dark:border-gray-700
  rounded-[--radius-card]
  p-6
  shadow-sm
">
  <div class="flex items-center justify-between">
    <div>
      <p class="text-sm font-medium text-gray-600 dark:text-gray-400">
        Total Revenue
      </p>
      <p class="text-2xl font-semibold text-gray-900 dark:text-white mt-2">
        $45,231
      </p>
      <p class="text-sm text-success-600 dark:text-success-400 mt-2">
        <span class="inline-flex items-center gap-1">
          <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M5.293 9.707a1 1 0 010-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 01-1.414 1.414L11 7.414V15a1 1 0 11-2 0V7.414L6.707 9.707a1 1 0 01-1.414 0z" clip-rule="evenodd"/>
          </svg>
          12% from last month
        </span>
      </p>
    </div>
    <div class="h-12 w-12 bg-primary-100 dark:bg-primary-900/30 rounded-full flex items-center justify-center">
      <svg class="h-6 w-6 text-primary-600 dark:text-primary-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
      </svg>
    </div>
  </div>
</div>
\`\`\`

### Badges & Status

**Badge:**
\`\`\`html
<span class="
  inline-flex items-center
  px-2.5 py-0.5 rounded-full
  text-xs font-medium
  bg-blue-100 text-blue-800
  dark:bg-blue-900 dark:text-blue-200
">
  Badge
</span>
\`\`\`

**Status Indicators:**
\`\`\`html
<!-- Success -->
<span class="px-2 py-1 text-xs rounded-full bg-green-100 text-green-800">
  Active
</span>

<!-- Warning -->
<span class="px-2 py-1 text-xs rounded-full bg-amber-100 text-amber-800">
  Pending
</span>

<!-- Error -->
<span class="px-2 py-1 text-xs rounded-full bg-red-100 text-red-800">
  Inactive
</span>
\`\`\`

---

### Alerts

**Info Alert:**
\`\`\`html
<div class="bg-blue-50 border-l-4 border-blue-500 p-4 rounded-r-md">
  <p class="text-sm text-blue-700">
    Informational message here
  </p>
</div>
\`\`\`

**Success Toast:**
\`\`\`html
<div class="bg-green-50 border border-green-200 rounded-lg shadow-lg p-4">
  <p class="text-sm font-medium text-green-800">
    Success! Action completed.
  </p>
</div>
\`\`\`

---

### Modals

**Modal Overlay:**
\`\`\`html
<div class="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
  <div class="
    bg-white dark:bg-gray-800
    rounded-xl shadow-2xl
    max-w-lg w-full
    p-6
  ">
    <h2 class="text-xl font-semibold mb-4">Modal Title</h2>
    <p class="text-gray-600 dark:text-gray-300 mb-6">Modal content</p>
    <div class="flex justify-end gap-3">
      <button class="px-4 py-2 bg-gray-200 rounded-md">Cancel</button>
      <button class="px-4 py-2 bg-blue-600 text-white rounded-md">Confirm</button>
    </div>
  </div>
</div>
\`\`\`

---

## Borders & Shadows

### Border Radius

- `rounded-sm` (2px) - Subtle
- `rounded` (4px) - Slight
- `rounded-md` (6px) - Medium ← **Inputs/Buttons**
- `rounded-lg` (8px) - Large ← **Cards**
- `rounded-xl` (12px) - Extra large ← **Modals**
- `rounded-2xl` (16px) - Very round
- `rounded-full` (9999px) - Pills/Avatars

### Shadows

- `shadow-sm` - Subtle elevation
- `shadow` - Default card ← **Most common**
- `shadow-md` - Raised
- `shadow-lg` - Modals, dropdowns ← **Overlays**
- `shadow-xl` - Maximum elevation
- `shadow-2xl` - Dramatic

**New in v4.1: Colored Shadows**
\`\`\`html
<button class="shadow-lg shadow-blue-500/50">
  Glowing button
</button>
\`\`\`

---

### Text Shadows (NEW in v4.1!)

**Finally available!**

\`\`\`html
<h1 class="text-shadow-sm">Subtle shadow</h1>
<h1 class="text-shadow-md">Medium shadow</h1>
<h1 class="text-shadow-lg">Large shadow</h1>
\`\`\`

**Use for:**
- Headings over images
- Text visibility on busy backgrounds
- Visual hierarchy

---

## Responsive Design

### Breakpoints (Mobile-First)

- `sm:` - 640px and up
- `md:` - 768px and up
- `lg:` - 1024px and up
- `xl:` - 1280px and up
- `2xl:` - 1536px and up

**Custom breakpoints:**
\`\`\`css
@theme {
  --breakpoint-3xl: 1920px;
}
\`\`\`

Then use: `3xl:text-6xl`

---

### Container Queries (NEW in v4!)

**Built-in, no plugin needed!**

\`\`\`html
<div class="@container">
  <div class="grid grid-cols-1 @sm:grid-cols-2 @lg:grid-cols-3">
    <!-- Responds to container size, not viewport! -->
  </div>
</div>
\`\`\`

**Max-width queries:**
\`\`\`html
<div class="@container">
  <div class="grid grid-cols-3 @max-md:grid-cols-1">
    <!-- 3 columns, 1 when container is small -->
  </div>
</div>
\`\`\`

**Why this matters:** Components adapt to their parent size, making them truly modular!

---

### Responsive Patterns

**Grid:**
\`\`\`html
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
  <!-- 1 → 2 → 3 columns -->
</div>
\`\`\`

**Typography:**
\`\`\`html
<h1 class="text-3xl md:text-4xl lg:text-5xl">
  <!-- Grows on larger screens -->
</h1>
\`\`\`

**Spacing:**
\`\`\`html
<section class="py-8 md:py-12 lg:py-16">
  <!-- More padding on desktop -->
</section>
\`\`\`

**Visibility:**
\`\`\`html
<div class="hidden md:block">Desktop only</div>
<div class="md:hidden">Mobile only</div>
\`\`\`

---

## Advanced Features (v4+)

### 3D Transforms (NEW in v4!)

\`\`\`html
<!-- Rotate in 3D space -->
<div class="rotate-x-12 rotate-y-45">3D rotation</div>

<!-- Scale in Z axis -->
<div class="scale-z-150">Depth scaling</div>

<!-- Translate in Z -->
<div class="translate-z-12">Move forward</div>
\`\`\`

---

### Mask Utilities (NEW in v4.1!)

\`\`\`html
<!-- Mask with gradient -->
<div class="mask-linear-to-b">
  Fades out at bottom
</div>

<!-- Mask with image -->
<div class="mask-image-[url('/mask.svg')]">
  Custom mask shape
</div>
\`\`\`

---

## Accessibility

### Focus States

**Always include:**
\`\`\`html
<button class="
  focus-visible:outline
  focus-visible:outline-2
  focus-visible:outline-blue-500
  focus-visible:outline-offset-2
">
  Accessible button
</button>
\`\`\`

### Color Contrast

- Normal text: 4.5:1 minimum
- Large text (18px+): 3:1 minimum
- Interactive elements: 3:1 minimum

### Touch Targets

\`\`\`html
<!-- Minimum 44x44px on mobile -->
<button class="min-h-11 min-w-11 md:px-4 md:py-2">
  Mobile-friendly
</button>
\`\`\`

---

## Dark Mode Implementation

### Setup

\`\`\`javascript
// Add class to <html> element
function toggleDarkMode() {
  document.documentElement.classList.toggle('dark')
}
\`\`\`

### Common Patterns

\`\`\`html
<!-- Background & Text -->
<div class="bg-white dark:bg-gray-900 text-gray-900 dark:text-white">
  Content
</div>

<!-- Borders -->
<div class="border border-gray-200 dark:border-gray-700">
  Content
</div>

<!-- Cards -->
<div class="bg-gray-50 dark:bg-gray-800">
  Card background
</div>

<!-- Hover States -->
<button class="bg-blue-600 hover:bg-blue-700 dark:bg-blue-500 dark:hover:bg-blue-600">
  Button
</button>
\`\`\`

---

## Custom Utilities (v4 Approach)

### Using @utility Directive

\`\`\`css
@import "tailwindcss";

@utility btn-primary {
  background-color: theme(--color-blue-600);
  color: white;
  padding: theme(--spacing-2) theme(--spacing-4);
  border-radius: theme(--radius-md);
}
\`\`\`

**Use in HTML:**
\`\`\`html
<button class="btn-primary">Custom utility</button>
\`\`\`

---

## Migration from v3

### Key Changes

1. **No tailwind.config.js**
   - Move config to CSS with @theme

2. **CSS Import**
   - Replace `@tailwind` with `@import "tailwindcss"`

3. **Automatic Content Detection**
   - Remove `content: []` array

4. **New Utilities**
   - text-shadow-*, mask-*, 3D transforms

### Quick Migration

\`\`\`bash
# Use official upgrade tool
npx @tailwindcss/upgrade@latest
\`\`\`

---

## Component Library Checklist

Based on wireframes, you'll need:

### Essential
- [ ] Button (primary, secondary, outline, destructive)
- [ ] Input (with label, error states)
- [ ] Card (basic, clickable)
- [ ] Badge (status indicators)
- [ ] Alert (info, success, warning, error)
- [ ] Modal
- [ ] Loading Spinner

### Secondary
- [ ] Dropdown Menu
- [ ] Table (with sorting)
- [ ] Tabs
- [ ] Breadcrumbs
- [ ] Pagination
- [ ] Toast Notifications

---

## Performance Tips

1. **Let Tailwind auto-detect content** - No manual configuration
2. **Use container queries** - Better than media queries for components
3. **Leverage v4's speed** - Incremental builds in microseconds
4. **Minimal custom CSS** - Use utility classes for everything

---

## Resources

**Official Docs:**
- v4 Announcement: https://tailwindcss.com/blog/tailwindcss-v4
- v4.1 Release: https://tailwindcss.com/blog/tailwindcss-v4-1
- Upgrade Guide: https://tailwindcss.com/docs/upgrade-guide
- @theme Directive: https://tailwindcss.com/docs/theme

**What's New:**
- Container queries built-in
- Text shadows
- 3D transforms
- Mask utilities
- Automatic content detection
- 5x faster builds

```

---
