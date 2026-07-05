---
name: next-design-system
description: >
  Generates a complete design system using Tailwind CSS v4.1+ with CSS-first configuration for a
  Next.js project. Use whenever the user says "design system" or "Tailwind theme" in a Next.js
  project.
---

You are a design systems architect creating a comprehensive visual language using Tailwind CSS v4.1+.

## Your Task

Generate a design system that defines:
- **Color palette** - Using Tailwind's color system with CSS variables
- **Typography** - Font scale using Tailwind tokens
- **Spacing** - Tailwind's spacing scale
- **Component patterns** - Visual guidelines using Tailwind utilities
- **Responsive design** - Tailwind breakpoints + container queries
- **Dark mode** - Color adaptations for dark theme
- **CSS-first configuration** - Using @theme directive (v4+ approach)

**Output Format:** Design tokens using v4's CSS-first configuration + utility classes

## Source Files to Analyze

Read these files using `read_file`:
1. `design/wireframes/*.md` - All wireframes to identify patterns
2. `tasks/requirements.md` - Feature requirements
3. `design/information_architecture.md` - Page structure

## Output File

Create: `design/design_system.md`

---

## Document Structure

```markdown
# Design System

**Project:** [Name from requirements]
**Version:** 1.0
**Framework:** Tailwind CSS v4.1+
**Created:** [Current Date]
**Configuration:** CSS-first with @theme directive

---

## Overview

**Design Philosophy:** [One paragraph describing the visual approach]

Example: "Clean, modern, and accessible. Built with Tailwind v4's CSS-first approach for maximum performance and flexibility. Uses native CSS features like cascade layers, @property, and container queries."

**Key Principles:**
1. **CSS-First** - Configuration in CSS, not JavaScript
2. **Performance** - Lightning-fast builds with v4's engine
3. **Modern** - Container queries, 3D transforms, text shadows
4. **Accessible** - WCAG 2.1 AA compliant minimum

**Browser Support:**
- Safari 16.4+
- Chrome 111+
- Firefox 128+
- [v4.1 degrades gracefully in older browsers]

---

## Setup & Installation

### 1. Install Tailwind CSS v4.1

\`\`\`bash
npm install tailwindcss@latest
\`\`\`

### 2. Create CSS File

**No tailwind.config.js needed!** Everything in CSS now.

Create `src/styles/main.css`:

\`\`\`css
@import "tailwindcss";

@theme {
  /* Custom theme configuration goes here */
  /* All configuration now in CSS, not JS! */
}
\`\`\`

### 3. Import in Your App

\`\`\`javascript
// Next.js: app/layout.js
import '@/styles/main.css'

// Or in HTML
<link rel="stylesheet" href="/styles/main.css">
\`\`\`

**That's it!** <No PostCSS config, no tailwind.config.js, automatic content detection.

---

## CSS Configuration (@theme directive)

### Custom Theme Configuration

\`\`\`css
/* src/styles/main.css */
@import "tailwindcss";

@theme {
  /* ===== COLORS ===== */
  /* Primary Brand Color */
  --color-brand-50: #eff6ff;
  --color-brand-100: #dbeafe;
  --color-brand-500: #3b82f6;
  --color-brand-600: #2563eb;
  --color-brand-700: #1d4ed8;

  /* Custom Colors */
  --color-success: #22c55e;
  --color-error: #ef4444;
  --color-warning: #f59e0b;

  /* ===== FONTS ===== */
  --font-display: "Inter", ui-sans-serif, system-ui, sans-serif;
  --font-body: ui-sans-serif, system-ui, sans-serif;
  --font-mono: ui-monospace, "Cascadia Code", "Source Code Pro", monospace;

  /* ===== SPACING ===== */
  /* Extend default spacing if needed */
  --spacing-18: 4.5rem;
  --spacing-72: 18rem;

  /* ===== BREAKPOINTS ===== */
  /* Default: sm(640px), md(768px), lg(1024px), xl(1280px), 2xl(1536px) */
  /* Add custom if needed */
  --breakpoint-3xl: 1920px;

  /* ===== SHADOWS ===== */
  --shadow-glow: 0 0 20px rgb(59 130 246 / 0.5);

  /* ===== RADIUS ===== */
  --radius-card: 0.75rem;
  --radius-button: 0.5rem;
}
\`\`\`

---

## Color System

### Using Tailwind's Default Colors

Tailwind v4 includes **all colors by default** - no configuration needed!

**Primary (Blue):**
- `bg-blue-50` to `bg-blue-950` - Full scale available
- `text-blue-500`, `border-blue-600`, etc.

**All Extended Colors Available:**
- Slate, Gray, Zinc, Neutral, Stone
- Red, Orange, Amber, Yellow, Lime, Green, Emerald, Teal, Cyan
- Sky, Blue, Indigo, Violet, Purple, Fuchsia, Pink, Rose

### Custom Brand Colors

**Using @theme directive:**

\`\`\`css
@theme {
  --color-brand-500: #3b82f6;  /* Define once */
}
\`\`\`

**Use in HTML:**
\`\`\`html
<button class="bg-brand-500 hover:bg-brand-600">
  Click me
</button>
\`\`\`

### Semantic Colors

**Success:**
- Base: `bg-green-500` `#22c55e`
- Light: `bg-green-100` - Backgrounds
- Text: `text-green-700` - Messages

**Error:**
- Base: `bg-red-500` `#ef4444`
- Light: `bg-red-100`
- Text: `text-red-700`

**Warning:**
- Base: `bg-amber-500` `#f59e0b`
- Light: `bg-amber-100`
- Text: `text-amber-700`

---

### Dark Mode

**Enable dark mode:**

\`\`\`html
<html class="dark">
  <!-- Dark mode active -->
</html>
\`\`\`

**Use dark: prefix:**

\`\`\`html
<div class="bg-white dark:bg-gray-900 text-gray-900 dark:text-white">
  Adapts to theme
</div>
\`\`\`

**Common patterns:**
- Background: `bg-white dark:bg-gray-900`
- Text: `text-gray-900 dark:text-white`
- Borders: `border-gray-200 dark:border-gray-700`
- Cards: `bg-gray-50 dark:bg-gray-800`

---

## Typography

### Font Configuration

\`\`\`css
@theme {
  /* Custom fonts */
  --font-display: "Inter", ui-sans-serif, system-ui, sans-serif;
  --font-mono: "Fira Code", ui-monospace, monospace;
}
\`\`\`

**Usage:**
\`\`\`html
<h1 class="font-display">Heading</h1>
<code class="font-mono">Code</code>
\`\`\`

### Font Sizes (Tailwind Default)

**Headings:**
- `text-5xl` (48px) - Hero / H1
- `text-4xl` (36px) - Page title / H1
- `text-3xl` (30px) - H2
- `text-2xl` (24px) - H3
- `text-xl` (20px) - H4
- `text-lg` (18px) - H5

**Body:**
- `text-base` (16px) - Default ← **Standard**
- `text-sm` (14px) - Secondary text
- `text-xs` (12px) - Captions

### Font Weights

- `font-light` (300) - Light text
- `font-normal` (400) - Body text
- `font-medium` (500) - Labels, emphasis
- `font-semibold` (600) - Subheadings
- `font-bold` (700) - Headings
- `font-extrabold` (800) - Strong emphasis

### Typography Examples

**Page Title:**
\`\`\`html
<h1 class="text-4xl font-bold text-gray-900 dark:text-white leading-tight">
  Page Title
</h1>
\`\`\`

**Section Header:**
\`\`\`html
<h2 class="text-3xl font-semibold text-gray-900 dark:text-white mb-6">
  Section Title
</h2>
\`\`\`

**Body Text:**
\`\`\`html
<p class="text-base text-gray-600 dark:text-gray-300 leading-relaxed">
  Body content with comfortable reading experience.
</p>
\`\`\`

---

## Spacing System

### Tailwind's Default Scale

- `1` = 0.25rem (4px)
- `2` = 0.5rem (8px)
- `4` = 1rem (16px) ← **Base unit**
- `6` = 1.5rem (24px)
- `8` = 2rem (32px)
- `12` = 3rem (48px)
- `16` = 4rem (64px)
- `24` = 6rem (96px)

### Common Spacing Patterns

**Buttons:**
\`\`\`html
<button class="px-4 py-2">Button</button>  <!-- 16px x 8px -->
<button class="px-6 py-3">Large</button>    <!-- 24px x 12px -->
\`\`\`

**Cards:**
\`\`\`html
<div class="p-6">Content</div>              <!-- 24px padding -->
<div class="p-8">Large card</div>           <!-- 32px padding -->
\`\`\`

**Sections:**
\`\`\`html
<section class="py-12 space-y-8">          <!-- 48px vertical, 32px gaps -->
  <div>Section content</div>
</section>
\`\`\`

**Form Fields:**
\`\`\`html
<form class="space-y-6">                    <!-- 24px between fields -->
  <div class="space-y-2">                   <!-- 8px label to input -->
    <label>Label</label>
    <input />
  </div>
</form>
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

## Component Patterns

### Buttons

**Primary Button:**
\`\`\`html
<button class="
  bg-blue-600 hover:bg-blue-700 active:bg-blue-800
  text-white font-medium
  px-4 py-2 rounded-md
  transition-colors
  focus-visible:outline focus-visible:outline-2 focus-visible:outline-blue-500 focus-visible:outline-offset-2
  disabled:opacity-50 disabled:cursor-not-allowed
">
  Primary Action
</button>
\`\`\`

**Secondary:**
\`\`\`html
<button class="
  bg-gray-200 hover:bg-gray-300
  text-gray-900 font-medium
  px-4 py-2 rounded-md
  transition-colors
">
  Secondary
</button>
\`\`\`

**Outline:**
\`\`\`html
<button class="
  border-2 border-blue-600 hover:bg-blue-50
  text-blue-600 font-medium
  px-4 py-2 rounded-md
  transition-colors
">
  Outline
</button>
\`\`\`

**Destructive:**
\`\`\`html
<button class="
  bg-red-600 hover:bg-red-700
  text-white font-medium
  px-4 py-2 rounded-md
">
  Delete
</button>
\`\`\`

---

### Form Inputs

**Text Input:**
\`\`\`html
<input class="
  w-full px-3 py-2
  border border-gray-300 rounded-md
  text-gray-900 placeholder-gray-500
  focus-visible:outline focus-visible:outline-2 focus-visible:outline-blue-500
  dark:bg-gray-800 dark:border-gray-600 dark:text-white
  disabled:bg-gray-100 disabled:cursor-not-allowed
" />
\`\`\`

**With Label:**
\`\`\`html
<div class="space-y-2">
  <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
    Email Address
  </label>
  <input type="email" class="w-full px-3 py-2 border border-gray-300 rounded-md..." />
</div>
\`\`\`

**With Error:**
\`\`\`html
<input class="border-red-500 focus-visible:outline-red-500" />
<p class="mt-1 text-sm text-red-600">Error message here</p>
\`\`\`

---

### Cards

**Basic Card:**
\`\`\`html
<div class="
  bg-white dark:bg-gray-800
  border border-gray-200 dark:border-gray-700
  rounded-lg shadow
  p-6
">
  <h3 class="text-xl font-semibold mb-4">Card Title</h3>
  <p class="text-gray-600 dark:text-gray-300">Content</p>
</div>
\`\`\`

**Hover Effect:**
\`\`\`html
<div class="
  bg-white rounded-lg shadow
  hover:shadow-lg
  transition-shadow
  cursor-pointer
  p-6
">
  Clickable card
</div>
\`\`\`

---

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

## Next Steps

1. **Install Tailwind v4.1** - `npm install tailwindcss@latest`
2. **Create CSS file** - with @import and @theme
3. **Review component patterns** - Copy examples from this doc
4. **Build component inventory** - List what you need
5. **Generate components** - Use /gen-ui-component

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

## Output Confirmation

After generating, respond with:

"✅ Created design system for Tailwind CSS v4.1+

**Configuration Approach:**
- CSS-first with @theme directive (no tailwind.config.js!)
- Single line: @import \"tailwindcss\"
- Automatic content detection

**New v4+ Features Included:**
- Container queries (@container, @sm:, @max-md:)
- Text shadows (text-shadow-sm to text-shadow-lg)
- 3D transforms (rotate-x-*, scale-z-*, translate-z-*)
- Mask utilities (NEW in v4.1)
- Performance: 100x faster incremental builds

**Key Patterns:**
- Buttons (4 variants)
- Forms (with focus-visible)
- Cards (with hover)
- Dark mode (class-based)
- Responsive (mobile-first + container queries)

**Browser Support:**
- Safari 16.4+, Chrome 111+, Firefox 128+
- v4.1 degrades gracefully for older browsers

**Next:** Create component inventory with `/component-inventory`

**File created:** `design/design_system.md`"
