---
name: next-vsa-plan
description: >
  Generates a complete Vertical Slice Architecture folder structure for Next.js 15 based on the
  information architecture. Use whenever the user says "VSA plan", "slice structure", or "organize the
  Next.js folders". Laravel slice placement questions go to the vsa skill instead.
---

You are a senior architect designing a Vertical Slice Architecture (VSA) for a Next.js 15 application.

## Core Principles of VSA

1. **Feature-based organization** - Group by feature, not by technical layer
2. **Self-contained slices** - Each feature has its own components, hooks, utils
3. **Clear boundaries** - Easy to understand what belongs where
4. **Scalable** - Add new features without touching existing code
5. **Co-location** - Related code lives together

---

## Your Task

Generate a complete VSA folder structure based on:
- Information architecture (pages and features)
- Component inventory (which components each page needs)
- User journeys (feature groupings)

**Output:** A complete directory structure with file hierarchy

---

## Source Files to Analyze

Read these files using `read_file`:
1. `design/information_architecture.md` - All pages and routes
2. `design/component_inventory.md` - Components needed
3. `tasks/user_journeys.md` - Feature groupings
4. `tasks/requirements.md` - Application features
5.  `design/wireframes/*.md` - Page Wireframe

---

## Output File

Create: `design/vsa_structure.md`

---

## VSA Structure Template

```markdown
# VSA Architecture - Next.js 15

**Project:** [Name from requirements]
**Generated:** [Current Date]
**Architecture:** Vertical Slice Architecture (Feature-based)

---

## Overview

**What is VSA?**
Vertical Slice Architecture organizes code by **feature/page** rather than by technical layer. Each feature is a self-contained "slice" with its own components, logic, and utilities.

**Benefits:**
- ✅ Easy to find code (everything for a feature in one place)
- ✅ Easy to add features (no cross-cutting changes)
- ✅ Easy to delete features (remove one folder)
- ✅ Clear boundaries between features
- ✅ Scales well with team size

---

## High-Level Structure

\`\`\`
frontend/
├── src/
│   ├── app/                    # Next.js 15 App Router (routes only)
│   ├── features/               # Feature slices (VSA core)
│   ├── components/             # Shared UI components
│   ├── lib/                    # Shared utilities
│   ├── hooks/                  # Shared hooks
│   ├── styles/                 # Global styles
│   └── types/                  # Shared TypeScript types
├── public/                     # Static assets
└── package.json
\`\`\`

---

## Detailed Structure

### 1. App Router (Routes Only)

**Purpose:** Define routes, delegate to feature slices

\`\`\`
src/app/
├── layout.jsx                  # Root layout
├── page.jsx                    # Home page (delegates to features/home)
├── loading.jsx                 # Global loading
├── error.jsx                   # Global error
├── not-found.jsx               # 404 page
│
├── (public)/                   # Route group: Public pages
│   ├── about/
│   │   └── page.jsx           # → features/about
│   ├── pricing/
│   │   └── page.jsx           # → features/pricing
│   └── contact/
│       └── page.jsx           # → features/contact
│
├── (auth)/                     # Route group: Authentication
│   ├── login/
│   │   ├── page.jsx           # → features/auth/login
│   │   └── loading.jsx
│   ├── register/
│   │   ├── page.jsx           # → features/auth/register
│   │   └── loading.jsx
│   ├── forgot-password/
│   │   └── page.jsx           # → features/auth/forgot-password
│   └── reset-password/
│       └── page.jsx           # → features/auth/reset-password
│
├── (app)/                      # Route group: Authenticated app
│   ├── layout.jsx             # App layout (with sidebar/header)
│   │
│   ├── dashboard/
│   │   ├── page.jsx           # → features/dashboard
│   │   ├── loading.jsx
│   │   └── error.jsx
│   │
│   ├── posts/
│   │   ├── page.jsx           # List → features/posts/list
│   │   ├── [id]/
│   │   │   ├── page.jsx       # Detail → features/posts/detail
│   │   │   └── edit/
│   │   │       └── page.jsx   # Edit → features/posts/edit
│   │   └── create/
│   │       └── page.jsx       # Create → features/posts/create
│   │
│   ├── profile/
│   │   ├── page.jsx           # → features/profile/view
│   │   ├── edit/
│   │   │   └── page.jsx       # → features/profile/edit
│   │   └── settings/
│   │       ├── page.jsx       # → features/profile/settings
│   │       ├── account/
│   │       │   └── page.jsx
│   │       ├── security/
│   │       │   └── page.jsx
│   │       └── notifications/
│   │           └── page.jsx
│   │
│   └── search/
│       └── page.jsx           # → features/search
│
└── (admin)/                    # Route group: Admin only
    ├── layout.jsx             # Admin layout
    ├── admin/
        ├── page.jsx           # Admin dashboard → features/admin/dashboard
        │
        ├── users/
        │   ├── page.jsx       # User list → features/admin/users/list
        │   ├── [id]/
        │   │   ├── page.jsx   # User detail → features/admin/users/detail
        │   │   └── edit/
        │   │       └── page.jsx
        │   └── create/
        │       └── page.jsx
        │
        ├── posts/
        │   ├── page.jsx       # Post moderation → features/admin/posts
        │   └── [id]/
        │       └── page.jsx
        │
        └── analytics/
            ├── page.jsx       # → features/admin/analytics
            ├── users/
            │   └── page.jsx
            └── content/
                └── page.jsx
\`\`\`

**Key Points:**
- Route files are **thin** - they just import from features
- Route groups `(name)` for organization (don't affect URLs)
- Each route has its own loading/error states

---

### 2. Features (VSA Core)

**Purpose:** Self-contained feature slices with all related code

\`\`\`
src/features/
│
├── home/                       # Landing page feature
│   ├── index.js               # Main component (default export)
│   ├── HeroSection.jsx
│   ├── FeaturesSection.jsx
│   ├── TestimonialsSection.jsx
│   ├── CTASection.jsx
│   ├── useHomeData.js         # Feature-specific hook
│   └── home.module.css        # Feature-specific styles (if needed)
│
├── auth/                       # Authentication features
│   ├── login/
│   │   ├── index.js           # LoginPage component
│   │   ├── LoginForm.jsx
│   │   ├── SocialLoginButtons.jsx
│   │   └── loginSchema.js     # Validation schema
│   │
│   ├── register/
│   │   ├── index.js           # RegisterPage component
│   │   ├── RegisterForm.jsx
│   │   ├── RegistrationSteps.jsx
│   │   └── registerSchema.js
│   │
│   ├── forgot-password/
│   │   ├── index.js
│   │   ├── ForgotPasswordForm.jsx
│   │
│   └── shared/                # Shared within auth feature
│       ├── AuthLayout.jsx
│       ├── PasswordStrength.jsx
│
├── dashboard/                  # Dashboard feature
│   ├── index.js               # DashboardPage component
│   ├── DashboardHeader.jsx
│   ├── StatCards.jsx
│   ├── StatCard.jsx
│   ├── RecentActivity.jsx
│   ├── ActivityItem.jsx
│   ├── QuickActions.jsx
│   └── dashboardUtils.js      # Feature-specific utilities
│
├── posts/                      # Posts feature
│   ├── list/
│   │   ├── index.js           # PostListPage component
│   │   ├── PostGrid.jsx
│   │   ├── PostCard.jsx
│   │   ├── PostFilters.jsx
│   │   ├── PostSearch.jsx
│   │   └── postListUtils.js
│   │
│   ├── detail/
│   │   ├── index.js           # PostDetailPage component
│   │   ├── PostHeader.jsx
│   │   ├── PostContent.jsx
│   │   ├── PostAuthor.jsx
│   │   ├── PostComments.jsx
│   │   ├── CommentForm.jsx
│   │   ├── CommentItem.jsx
│   │   ├── RelatedPosts.jsx
│   │
│   ├── create/
│   │   ├── index.js           # PostCreatePage component
│   │   ├── PostEditor.jsx
│   │   ├── PostForm.jsx
│   │   ├── ImageUpload.jsx
│   │   ├── TagSelector.jsx
│   │   ├── PublishOptions.jsx
│   │   └── postSchema.js
│   │
│   ├── edit/
│   │   ├── index.js           # PostEditPage component
│   │   ├── usePostEdit.js
│   │   └── (reuses components from create/)
│   │
│   └── shared/                # Shared within posts feature
│       ├── PostMeta.jsx
│       ├── PostStatus.jsx
│       └── postUtils.js
│
├── profile/                    # User profile features
│   ├── view/
│   │   ├── index.js           # ProfilePage component
│   │   ├── ProfileHeader.jsx
│   │   ├── ProfileInfo.jsx
│   │   ├── ProfileStats.jsx
│   │   ├── ProfileTabs.jsx
│   │   ├── UserPosts.jsx│   │
│   ├── edit/
│   │   ├── index.js           # ProfileEditPage component
│   │   ├── ProfileEditForm.jsx
│   │   ├── AvatarUpload.jsx
│   │   └── profileSchema.js
│   │
│   ├── settings/
│   │   ├── index.js           # SettingsPage component
│   │   ├── SettingsTabs.jsx
│   │   ├── AccountSettings.jsx
│   │   ├── SecuritySettings.jsx
│   │   ├── NotificationSettings.jsx
│   │   ├── PrivacySettings.jsx
│   │   └── settingsSchema.js
│   │
│   └── shared/
│       └── ProfileLayout.jsx
│
├── search/                     # Search feature
│   ├── index.js               # SearchPage component
│   ├── SearchBar.jsx
│   ├── SearchFilters.jsx
│   ├── SearchResults.jsx
│   ├── SearchResultItem.jsx
│   └── searchUtils.js
│
└── admin/                      # Admin features
    ├── dashboard/
    │   ├── index.js
    │   ├── AdminStats.jsx
    │   ├── SystemHealth.jsx
    │   ├── RecentActions.jsx
    │
    ├── users/
    │   ├── list/
    │   │   ├── index.js       # UserListPage
    │   │   ├── UserTable.jsx
    │   │   ├── UserFilters.jsx
    │   │   ├── UserActions.jsx
    │   │
    │   ├── detail/
    │   │   ├── index.js       # UserDetailPage
    │   │   ├── UserInfo.jsx
    │   │   ├── UserActivity.jsx
    │   │   ├── UserActions.jsx
    │   │
    │   └── shared/
    │       ├── RoleSelector.jsx
    │       └── userAdminUtils.js
    │
    ├── posts/
    │   ├── index.js           # PostModerationPage
    │   ├── ModerationQueue.jsx
    │   ├── ModerationItem.jsx
    │   ├── ModerationActions.jsx
    │
    ├── analytics/
    │   ├── index.js           # AnalyticsPage
    │   ├── AnalyticsDashboard.jsx
    │   ├── UserAnalytics.jsx
    │   ├── ContentAnalytics.jsx
    │   ├── Charts.jsx
    │
    └── shared/                # Shared admin components
        ├── AdminLayout.jsx
        ├── AdminSidebar.jsx
        └── adminUtils.js
\`\`\`

**Feature Slice Pattern:**

Each feature follows this structure:
\`\`\`
features/<feature-name>/
├── index.js                   # Main component (default export)
├── Component1.jsx             # Feature-specific components
├── Component2.jsx
├── useFeatureHook.js          # Feature-specific hooks
├── featureUtils.js            # Feature-specific utilities
├── featureSchema.js           # Validation schemas
└── feature.module.css         # Feature-specific styles (optional)
\`\`\`

---

### 3. Shared Components (UI Library)

**Purpose:** Reusable UI components used across features

\`\`\`
src/components/
├── ui/                        # Base UI components
│   ├── button/
│   │   ├── Button.jsx
│   │   └── index.js
│   │
│   ├── input/
│   │   ├── Input.jsx
│   │   └── index.js
│   │
│   ├── card/
│   │   ├── Card.jsx
│   │   └── index.js
│   │
│   ├── modal/
│   │   ├── Modal.jsx
│   │   └── index.js
│   │
│   ├── table/
│   │   ├── Table.jsx
│   │   └── index.js
│   │
│   ├── alert/
│   │   ├── Alert.jsx
│   │   └── index.js
│   │
│   ├── badge/
│   │   ├── Badge.jsx
│   │   └── index.js
│   │
│   ├── spinner/
│   │   ├── Spinner.jsx
│   │   └── index.js
│   │
│   ├── avatar/
│   │   ├── Avatar.jsx
│   │   └── index.js
│   │
│   ├── dropdown/
│   │   ├── Dropdown.jsx
│   │   └── index.js
│   │
│   ├── tabs/
│   │   ├── Tabs.jsx
│   │   └── index.js
│   │
│   ├── pagination/
│   │   ├── Pagination.jsx
│   │   └── index.js
│   │
│   ├── toast/
│   │   ├── Toast.jsx
│   │   ├── ToastContainer.jsx
│   │   └── index.js
│   │
│   └── [other UI components from inventory]
│
└── layout/                    # Layout components
    ├── Header.jsx
    ├── Footer.jsx
    ├── Sidebar.jsx
    ├── Container.jsx
    └── index.js
\`\`\`

---

### 4. Shared Utilities

\`\`\`
src/lib/
├── api/                       # API client
│   ├── client.js             # Axios/Fetch wrapper
│   ├── endpoints.js          # API endpoint constants
│   └── interceptors.js       # Request/response interceptors
│
├── auth/                      # Authentication utilities
│   ├── authClient.js         # Auth logic
│   ├── authContext.jsx       # Auth context provider
│   └── authUtils.js          # Token management, etc.
│
├── utils/                     # General utilities
│   ├── format.js             # Date, number formatting
│   ├── validation.js         # Common validations
│   ├── string.js             # String utilities
│   ├── array.js              # Array utilities
│   └── cn.js                 # Tailwind class merger (clsx + twMerge)
│
└── constants/                 # App-wide constants
    ├── routes.js             # Route constants
    ├── config.js             # App configuration
    └── status.js             # Status codes, enums
\`\`\`

---

### 5. Shared Hooks

\`\`\`
src/hooks/
├── useAuth.js                # Authentication hook
├── useApi.js                 # API call hook
├── useDebounce.js            # Debounce hook
├── useLocalStorage.js        # LocalStorage hook
├── useMediaQuery.js          # Responsive hook
├── useClickOutside.js        # Click outside detection
├── useInfiniteScroll.js      # Infinite scroll
├── usePagination.js          # Pagination logic
└── useToast.js               # Toast notifications
\`\`\`

---

### 6. Styles

\`\`\`
src/styles/
├── globals.css               # Global styles + Tailwind
│   ├── @import "tailwindcss"
│   ├── @theme { ... }
│   └── Base styles
│
└── themes/                   # Theme configurations (if needed)
    ├── light.css
    └── dark.css
\`\`\`

---

### 7. Types (if using TypeScript)

\`\`\`
src/types/
├── index.d.ts                # Global types
├── api.d.ts                  # API response types
├── user.d.ts                 # User types
├── post.d.ts                 # Post types
└── common.d.ts               # Common types
\`\`\`

---

## Complete Directory Tree

\`\`\`
frontend/
├── public/
│   ├── images/
│   ├── icons/
│   └── favicon.ico
│
├── src/
│   ├── app/                           # Next.js 15 App Router
│   │   ├── layout.jsx
│   │   ├── page.jsx
│   │   ├── loading.jsx
│   │   ├── error.jsx
│   │   ├── not-found.jsx
│   │   │
│   │   ├── (public)/
│   │   │   ├── about/page.jsx
│   │   │   ├── pricing/page.jsx
│   │   │   └── contact/page.jsx
│   │   │
│   │   ├── (auth)/
│   │   │   ├── login/page.jsx
│   │   │   ├── register/page.jsx
│   │   │   ├── forgot-password/page.jsx
│   │   │   └── reset-password/page.jsx
│   │   │
│   │   ├── (app)/
│   │   │   ├── layout.jsx
│   │   │   ├── dashboard/page.jsx
│   │   │   ├── posts/
│   │   │   │   ├── page.jsx
│   │   │   │   ├── [id]/page.jsx
│   │   │   │   ├── [id]/edit/page.jsx
│   │   │   │   └── create/page.jsx
│   │   │   ├── profile/
│   │   │   │   ├── page.jsx
│   │   │   │   ├── edit/page.jsx
│   │   │   │   └── settings/page.jsx
│   │   │   └── search/page.jsx
│   │   │
│   │   └── (admin)/
│   │       ├── layout.jsx
│   │       └── admin/
│   │           ├── page.jsx
│   │           ├── users/page.jsx
│   │           ├── users/[id]/page.jsx
│   │           ├── posts/page.jsx
│   │           └── analytics/page.jsx
│   │
│   ├── features/                      # VSA Feature Slices
│   │   ├── home/
│   │   │   ├── index.js
│   │   │   ├── HeroSection.jsx
│   │   │   ├── FeaturesSection.jsx
│   │   │   └── useHomeData.js
│   │   │
│   │   ├── auth/
│   │   │   ├── login/
│   │   │   │   ├── index.js
│   │   │   │   ├── LoginForm.jsx
│   │   │   │   └── useLogin.js
│   │   │   ├── register/
│   │   │   │   ├── index.js
│   │   │   │   ├── RegisterForm.jsx
│   │   │   │   └── useRegister.js
│   │   │   └── shared/
│   │   │       └── AuthLayout.jsx
│   │   │
│   │   ├── dashboard/
│   │   │   ├── index.js
│   │   │   ├── StatCards.jsx
│   │   │   ├── RecentActivity.jsx
│   │   │   └── useDashboardData.js
│   │   │
│   │   ├── posts/
│   │   │   ├── list/
│   │   │   │   ├── index.js
│   │   │   │   ├── PostGrid.jsx
│   │   │   │   └── usePostList.js
│   │   │   ├── detail/
│   │   │   │   ├── index.js
│   │   │   │   ├── PostContent.jsx
│   │   │   │   └── usePostDetail.js
│   │   │   ├── create/
│   │   │   │   ├── index.js
│   │   │   │   ├── PostEditor.jsx
│   │   │   │   └── usePostCreate.js
│   │   │   └── shared/
│   │   │       └── PostMeta.jsx
│   │   │
│   │   ├── profile/
│   │   │   ├── view/
│   │   │   ├── edit/
│   │   │   └── settings/
│   │   │
│   │   ├── search/
│   │   │
│   │   └── admin/
│   │       ├── dashboard/
│   │       ├── users/
│   │       ├── posts/
│   │       └── analytics/
│   │
│   ├── components/                    # Shared UI Components
│   │   ├── ui/
│   │   │   ├── button/
│   │   │   │   ├── Button.jsx
│   │   │   │   └── index.js
│   │   │   ├── input/
│   │   │   ├── card/
│   │   │   ├── modal/
│   │   │   ├── table/
│   │   │   └── [other components]
│   │   │
│   │   └── layout/
│   │       ├── Header.jsx
│   │       ├── Footer.jsx
│   │       └── Sidebar.jsx
│   │
│   ├── lib/                           # Shared Utilities
│   │   ├── api/
│   │   │   ├── client.js
│   │   │   └── endpoints.js
│   │   ├── auth/
│   │   │   ├── authClient.js
│   │   │   └── authContext.jsx
│   │   ├── utils/
│   │   │   ├── format.js
│   │   │   ├── validation.js
│   │   │   └── cn.js
│   │   └── constants/
│   │       ├── routes.js
│   │       └── config.js
│   │
│   ├── hooks/                         # Shared Hooks
│   │   ├── useAuth.js
│   │   ├── useApi.js
│   │   ├── useDebounce.js
│   │   └── useToast.js
│   │
│   ├── styles/                        # Global Styles
│   │   └── globals.css
│   │
│   └── types/                         # TypeScript Types (optional)
│       ├── index.d.ts
│       └── api.d.ts
│
├── .env.local                         # Environment variables
├── .eslintrc.json                     # ESLint config
├── .gitignore
├── next.config.js                     # Next.js config
├── package.json
├── postcss.config.js                  # PostCSS config
├── tailwind.config.js                 # Tailwind config (if not using v4 CSS-first)
└── tsconfig.json                      # TypeScript config (if using TS)
\`\`\`

---

## How VSA Works in Practice

### Example 1: Adding a New Feature

**Task:** Add a "Notifications" feature

**Steps:**
1. Create `src/features/notifications/` folder
2. Add `index.js`, components, hooks
3. Add route in `src/app/(app)/notifications/page.jsx`
4. Done! No changes to existing features

\`\`\`
src/features/notifications/
├── index.js                 # NotificationsPage
├── NotificationList.jsx
├── NotificationItem.jsx
├── NotificationFilters.jsx
├── useNotifications.js
└── notificationUtils.js
\`\`\`

---

### Example 2: Page File Structure

**Route file (thin):**
\`\`\`javascript
// src/app/(app)/dashboard/page.jsx
import DashboardPage from '@/features/dashboard'

export const metadata = {
  title: 'Dashboard - App Name',
}

export default function Dashboard() {
  return <DashboardPage />
}
\`\`\`

**Feature file (thick):**
\`\`\`javascript
// src/features/dashboard/index.js
'use client' // if needed

import { Card } from '@/components/ui/card'
import { StatCards } from './StatCards'
import { RecentActivity } from './RecentActivity'
import { useDashboardData } from './useDashboardData'

export default function DashboardPage() {
  const { stats, activity, loading } = useDashboardData()

  if (loading) return <div>Loading...</div>

  return (
    <div className="container mx-auto py-8">
      <h1>Dashboard</h1>
      <StatCards stats={stats} />
      <RecentActivity items={activity} />
    </div>
  )
}
\`\`\`

---

### Example 3: Component Usage

**From feature (specific):**
\`\`\`javascript
// src/features/posts/list/index.js
import { PostCard } from './PostCard'  // Feature-specific
import { Button } from '@/components/ui/button'  // Shared UI
\`\`\`

**From shared component:**
\`\`\`javascript
// src/components/ui/modal/Modal.jsx
import { Button } from '@/components/ui/button'  // Other shared component
\`\`\`

---

## Import Patterns

### Absolute Imports (Recommended)

Configure in `tsconfig.json` or `jsconfig.json`:
\`\`\`json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"],
      "@/components/*": ["./src/components/*"],
      "@/features/*": ["./src/features/*"],
      "@/lib/*": ["./src/lib/*"],
      "@/hooks/*": ["./src/hooks/*"]
    }
  }
}
\`\`\`

**Usage:**
\`\`\`javascript
import { Button } from '@/components/ui/button'
import { useAuth } from '@/hooks/useAuth'
import DashboardPage from '@/features/dashboard'
import { api } from '@/lib/api/client'
\`\`\`

---

## Feature Slice Guidelines

### What Goes in a Feature?

✅ **Include:**
- Components used ONLY in this feature
- Hooks used ONLY in this feature
- Utils used ONLY in this feature
- Types/schemas specific to this feature

❌ **Don't Include:**
- Shared UI components (Button, Input, etc.) → `components/ui`
- Shared hooks (useAuth, useApi, etc.) → `hooks/`
- Shared utils (formatting, validation) → `lib/utils`

---

### When to Create a Feature?

Create a new feature when:
- It's a distinct page or user flow
- It has unique business logic
- It will grow over time
- It's independent from other features

---

### Feature Dependencies

Features should:
- Import from `@/components` (shared UI)
- Import from `@/hooks` (shared hooks)
- Import from `@/lib` (shared utils)
- **NOT import from other features**

If you need to share between features, move it to `shared/` or `lib/`.

---

## Migration from Flat Structure

If you have an existing flat structure:

**Old:**
\`\`\`
components/
├── Button.jsx
├── LoginForm.jsx
├── Dashboard.jsx
├── PostCard.jsx
└── UserProfile.jsx
\`\`\`

**New (VSA):**
\`\`\`
components/ui/
└── button/Button.jsx                # Shared

features/
├── auth/login/
│   └── LoginForm.jsx                # Feature-specific
├── dashboard/
│   └── index.js                     # Feature page
├── posts/list/
│   └── PostCard.jsx                 # Feature-specific
└── profile/view/
    └── index.js                     # Feature page
\`\`\`

---

## Benefits of This Structure

### 1. **Easy to Find Code**
Looking for login logic? → `features/auth/login/`
Looking for dashboard stats? → `features/dashboard/StatCards.jsx`

### 2. **Easy to Add Features**
New messaging feature? Create `features/messaging/` - done!

### 3. **Easy to Delete Features**
Remove notifications? Delete `features/notifications/` folder

### 4. **Clear Boundaries**
Each feature is self-contained. No guessing where code belongs.

### 5. **Scales Well**
Works for 10 pages or 100 pages. Add features independently.

### 6. **Team-Friendly**
Multiple developers can work on different features without conflicts.

---

## Common Questions

### Q: Where do I put API calls?

**A:** Feature-specific hooks in the feature folder.

\`\`\`javascript
// features/posts/list/usePostList.js
export function usePostList() {
  const [posts, setPosts] = useState([])

  useEffect(() => {
    fetch('/api/posts').then(r => r.json()).then(setPosts)
  }, [])

  return { posts }
}
\`\`\`

---

### Q: What if multiple features need the same component?

**A:** If used by 2+ features, move to `components/ui/` or create in `features/shared/`.

\`\`\`javascript
// If used everywhere:
components/ui/post-card/PostCard.jsx

// If used by multiple post features only:
features/posts/shared/PostCard.jsx
\`\`\`

---

### Q: What about forms that appear in multiple places?

**A:** Shared forms go in `components/ui/`, feature-specific forms stay in features.

\`\`\`javascript
// Login form (only in auth):
features/auth/login/LoginForm.jsx

// Contact form (used in multiple places):
components/ui/contact-form/ContactForm.jsx
\`\`\`

---

### Q: Where do I put context providers?

**A:**
- Auth context (global) → `lib/auth/authContext.jsx`
- Feature context → `features/<feature>/FeatureContext.jsx`

---

### Q: How do features communicate?

**A:** Through URL navigation or shared state (context/zustand/redux).

\`\`\`javascript
// From feature A, navigate to feature B
router.push('/posts/123')

// Or through shared context
const { user } = useAuth()  // Shared context
\`\`\`

---

## File Naming Conventions

### Component Files
- **PascalCase:** `LoginForm.jsx`, `StatCard.jsx`, `PostGrid.jsx`
- **index.js:** Default export for feature entry point

### Hooks
- **camelCase with use prefix:** `usePostList.js`, `useAuth.js`

### Utils
- **camelCase:** `postUtils.js`, `dashboardUtils.js`

### Schemas
- **camelCase:** `loginSchema.js`, `postSchema.js`

### Styles
- **kebab-case with module:** `home.module.css` (if needed)

---

## VSA vs Traditional Architecture

| Aspect | VSA | Traditional |
|--------|-----|-------------|
| Organization | By feature | By technical layer |
| Finding code | Go to feature folder | Search across folders |
| Adding features | New folder, done | Touch many files |
| Deleting features | Delete folder | Hunt down scattered code |
| Team scaling | Parallel work | Merge conflicts |
| Learning curve | Low (feature-based) | Higher (patterns) |

---

## Validation Checklist

After generating the structure, verify:

- [ ] Every page in IA has a route in app/
- [ ] Every route delegates to a feature slice
- [ ] Every feature is self-contained
- [ ] Shared components are truly shared (2+ uses)
- [ ] No circular dependencies between features
- [ ] Import paths use absolute imports (@/)
- [ ] File naming follows conventions
- [ ] Hooks follow useXxx pattern

---

## Next Steps

1. **Review structure** with team
2. **Create base folders** with package.json
3. **Set up absolute imports** in tsconfig/jsconfig
4. **Implement first feature** (e.g., auth)
5. **Document patterns** as team conventions emerge

---

## Related Documents

- Component Inventory: `design/component_inventory.md`
- Design System: `design/design_system.md`
- Information Architecture: `design/information_architecture.md`

```

---

## Output Confirmation

After generating, respond with:

"✅ Created VSA Architecture for Next.js 15

**Structure:**
- [X] route groups identified
- [Y] feature slices created
- [Z] shared components cataloged

**Key decisions:**
- Co-location strategy: [explain]
- Shared threshold: [explain]

**Next step:** Implement first feature slice"
