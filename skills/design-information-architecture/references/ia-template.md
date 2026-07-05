# Information Architecture — Document Template


```markdown
# Information Architecture

**Project:** [Name from requirements]
**Generated:** [Current Date]
**Purpose:** Define the structure, navigation, and content organization of the application

---

## Executive Summary

**Core Finding:** [One sentence - e.g., "Users need 3 primary paths: content creation, discovery, and management"]

**Key Structural Decisions:**
1. [Decision 1 - e.g., "Dashboard-centric design for logged-in users"]
2. [Decision 2 - e.g., "Public content browsing without registration"]
3. [Decision 3 - e.g., "Role-based admin section separate from user flows"]

**Critical Pages:** [List 3-5 most important pages that enable core user journeys]

---

## Sitemap

### Visual Hierarchy

\`\`\`
┌─────────────────────────────────────────────────┐
│                   HOME (/)                      │
│         [Public - Marketing/Landing]            │
└─────────────────────────────────────────────────┘
                      │
        ┌─────────────┼─────────────┐
        │             │             │
    ┌───▼───┐    ┌───▼────┐   ┌───▼────┐
    │ About │    │ Pricing│   │Features│
    │ /about│    │/pricing│   │/features│
    └───────┘    └────────┘   └────────┘

┌─────────────────────────────────────────────────┐
│           AUTHENTICATION (/auth)                │
│              [Public Access]                    │
└─────────────────────────────────────────────────┘
        │
        ├─── /auth/login
        ├─── /auth/register
        ├─── /auth/forgot-password
        └─── /auth/reset-password

┌─────────────────────────────────────────────────┐
│            DASHBOARD (/dashboard)               │
│         [Requires: Authentication]              │
└─────────────────────────────────────────────────┘
        │
        ├─── /dashboard (Overview)
        ├─── /dashboard/activity (Recent Activity)
        └─── /dashboard/quick-actions

┌─────────────────────────────────────────────────┐
│              POSTS (/posts)                     │
│    [List: Public | Detail: Public | Create: Auth]│
└─────────────────────────────────────────────────┘
        │
        ├─── /posts (Browse all)
        ├─── /posts/[id] (View single post)
        ├─── /posts/create [Auth Required]
        ├─── /posts/[id]/edit [Auth Required + Owner]
        └─── /posts/my-posts [Auth Required]

┌─────────────────────────────────────────────────┐
│            USER PROFILE (/profile)              │
│         [Requires: Authentication]              │
└─────────────────────────────────────────────────┘
        │
        ├─── /profile (View own profile)
        ├─── /profile/edit
        ├─── /profile/settings
        │    ├─── /profile/settings/account
        │    ├─── /profile/settings/security
        │    └─── /profile/settings/notifications
        └─── /profile/[username] (View other profiles)

┌─────────────────────────────────────────────────┐
│              ADMIN (/admin)                     │
│          [Requires: Admin Role]                 │
└─────────────────────────────────────────────────┘
        │
        ├─── /admin (Admin Dashboard)
        ├─── /admin/users
        │    ├─── /admin/users (List)
        │    ├─── /admin/users/[id] (View/Edit)
        │    └─── /admin/users/create
        ├─── /admin/posts
        │    ├─── /admin/posts (Moderation Queue)
        │    └─── /admin/posts/[id] (Moderate)
        └─── /admin/analytics
             ├─── /admin/analytics/overview
             ├─── /admin/analytics/users
             └─── /admin/analytics/content
\`\`\`

---

## Page Inventory

### Public Pages (No Authentication Required)

#### 1. Home (/)
**Purpose:** Landing page, value proposition, drive sign-ups

**Target User:** Visitors discovering the product

**From User Journey:** [Reference journey stage - e.g., "Discovery stage in User Registration journey"]

**Content Blocks:**
- Hero section with primary CTA
- Key features overview (3-4 features)
- Social proof (testimonials/stats)
- Secondary CTA
- Footer with links

**Primary Actions:**
- Sign Up button → /auth/register
- Login link → /auth/login
- Learn More → /about or /features

**Success Metric:** Sign-up conversion rate > 10%

---

#### 2. About (/about)
**Purpose:** Build trust,explain mission/team

**Content Blocks:**
- Mission statement
- Team section
- Company values
- Contact information

**Primary Actions:**
- Contact Us → /contact
- Join Us → /careers (if applicable)

---

#### 3. Posts List (/posts)
**Purpose:** Browse all published content

**Target User:** Anonymous visitors and logged-in users

**From User Journey:** [Reference - e.g., "Content discovery in Browse Posts journey"]

**Content Blocks:**
- Search bar
- Filter/Sort controls
- Post cards (title, excerpt, author, date)
- Pagination
- Sidebar (optional): Categories, Popular tags

**Primary Actions:**
- Click post → /posts/[id]
- Search → Filter results
- Create Post (if logged in) → /posts/create

**Data Source:** Laravel API: GET /api/v1/posts

**Success Metric:** Users view 3+ posts per session

---

### Authentication Pages

#### 4. Login (/auth/login)
**Purpose:** Authenticate existing users

**From User Journey:** "First Login" stage in Registration journey

**Content Blocks:**
- Email input
- Password input
- "Remember me" checkbox
- Forgot password link
- Social login buttons (optional)
- Sign up link

**Primary Actions:**
- Login → /dashboard (on success)
- Forgot password → /auth/forgot-password
- Sign up → /auth/register

**Data Flow:** POST /api/v1/auth/login → Return token → Store in httpOnly cookie

**Success Metric:** Login completion rate > 95%

---

#### 5. Register (/auth/register)
**Purpose:** Create new user account

**From User Journey:** "Registration" stage

**Content Blocks:**
- Name input
- Email input
- Password input (with strength indicator)
- Terms acceptance checkbox
- Social registration (optional)
- Login link

**Primary Actions:**
- Register → /auth/verify-email or /dashboard
- Login → /auth/login

**Data Flow:** POST /api/v1/auth/register → Send verification email → /dashboard

**Success Metric:** Registration completion rate > 80%

---

### Authenticated Pages (Login Required)

#### 6. Dashboard (/dashboard)
**Purpose:** Central hub for logged-in users, show personalized overview

**Target User:** All authenticated users

**From User Journey:** "Dashboard Landing" stage

**Content Blocks:**
- Welcome message (personalized)
- Key stats (3-4 metrics relevant to user)
- Recent activity feed
- Quick actions (prominent CTAs)
- Onboarding checklist (for new users)

**Primary Actions:**
- Create Post → /posts/create
- View All Posts → /posts/my-posts
- Edit Profile → /profile/edit

**Data Source:**
- GET /api/v1/dashboard/stats
- GET /api/v1/activity/recent

**Success Metric:** 60%+ users complete first action within 5 minutes

---

#### 7. Post Create (/posts/create)
**Purpose:** Create and publish new content

**From User Journey:** "Creating First Post" journey

**Content Blocks:**
- Title input
- Rich text editor (content)
- Tags/categories selector
- Featured image upload
- Publish settings (public/draft, schedule)
- Auto-save indicator

**Primary Actions:**
- Save Draft → Stay on page, show saved toast
- Publish → /posts/[new-id] (view published post)
- Cancel → /dashboard or /posts/my-posts

**Data Flow:**
- Auto-save: POST /api/v1/posts/draft (every 30s)
- Publish: POST /api/v1/posts → Redirect to post detail

**Success Metric:** Post creation completion rate > 70%

---

#### 8. Post Detail (/posts/[id])
**Purpose:** Read full post content

**Access:** Public (but show extra actions if logged in)

**Content Blocks:**
- Post title
- Author info (avatar, name, date)
- Post content (formatted)
- Engagement (likes, comments count)
- Share buttons
- Related posts (sidebar)
- Comments section
- Edit button (if owner or admin)

**Primary Actions:**
- Like post → Update count via API
- Comment → Add comment via API
- Share → Open share modal
- Edit (if owner) → /posts/[id]/edit

**Data Source:** GET /api/v1/posts/{id}

---

#### 9. Profile Edit (/profile/edit)
**Purpose:** Update user information

**Content Blocks:**
- Avatar upload
- Name, bio, location fields
- Email (with verification if changed)
- Social links
- Privacy settings

**Primary Actions:**
- Save Changes → Update via API, show success
- Cancel → /profile
- Change Password → /profile/settings/security

**Data Flow:** PUT /api/v1/user/profile

---

### Admin Pages (Admin Role Required)

#### 10. Admin Dashboard (/admin)
**Purpose:** Overview of system health and key metrics

**Target User:** Administrators

**Content Blocks:**
- System stats (users, posts, activity)
- Recent user registrations
- Flagged content queue
- Quick actions (create user, moderate post)

**Primary Actions:**
- Manage Users → /admin/users
- Moderate Content → /admin/posts
- View Analytics → /admin/analytics

**Data Source:** GET /api/v1/admin/dashboard

---

#### 11. User Management (/admin/users)
**Purpose:** Search, view, edit, and manage user accounts

**From User Journey:** "Admin Managing Users" journey

**Content Blocks:**
- Search bar (by name, email)
- Advanced filters (role, status, registration date)
- User table (name, email, role, status, actions)
- Pagination
- Bulk actions

**Primary Actions:**
- Search → Filter table
- Click user → /admin/users/[id]
- Edit user → Inline edit or modal
- Delete user → Confirmation modal

**Data Source:** GET /api/v1/admin/users?search=X&filter=Y

**Success Metric:** Admin can find and edit user in < 2 minutes

---

## Navigation Structure

### Primary Navigation (All Users)

**Desktop Header:**
```
[Logo]  [Search]                    [Notifications] [Avatar ▼]
                                                     ├─ Dashboard
                                                     ├─ Profile
                                                     ├─ Settings
                                                     ├─ Admin (if admin)
                                                     └─ Logout
```

**Mobile Header:**
```
[☰ Menu]  [Logo]              [Search 🔍] [Avatar]
```

**Mobile Menu (Drawer):**
```
┌─────────────────────┐
│ [Avatar] User Name  │
│ user@email.com      │
├─────────────────────┤
│ → Dashboard         │
│ → My Posts          │
│ → Create Post       │
│ → Profile           │
│ → Settings          │
│ → Admin (if admin)  │
├─────────────────────┤
│ → Help & Support    │
│ → Logout            │
└─────────────────────┘
```

---

### Secondary Navigation (Context-Specific)

**Dashboard Sidebar:**
- Overview (default)
- My Activity
- Notifications
- Quick Actions

**Admin Sidebar:**
- Dashboard
- Users
- Posts (Moderation)
- Analytics
- Settings

**Profile Tabs:**
- Profile
- Settings
  - Account
  - Security
  - Notifications
  - Privacy

---

### Breadcrumbs

Show breadcrumbs on nested pages:

```
Home > Admin > Users > Edit User
Dashboard > Posts > Create Post
Profile > Settings > Security
```

**Implementation:** Use Next.js dynamic routes + metadata

---

## User Flows

### Flow 1: New User Sign-Up & First Action

\`\`\`
1. Land on Home (/)
   ↓ [Click "Sign Up"]
2. Register (/auth/register)
   ↓ [Submit form]
3. Verify Email (check inbox)
   ↓ [Click verification link]
4. Dashboard (/dashboard)
   ↓ [See onboarding checklist]
5. Create First Post (/posts/create)
   ↓ [Fill form, publish]
6. View Published Post (/posts/[id])
   ↓ [Success! User is activated]
\`\`\`

**Pain Points from Journey Map:**
- Email verification friction → Solution: Auto-login after verification
- Empty dashboard → Solution: Onboarding checklist

---

### Flow 2: Content Discovery & Engagement

\`\`\`
1. Browse Posts (/posts)
   ↓ [Search or scroll]
2. Post Detail (/posts/[id])
   ↓ [Read content]
3. Like & Comment
   ↓ [Engage]
4. View Author Profile (/profile/[username])
   ↓ [Discover more content]
5. Follow Author (optional)
   ↓ [Return to feed with personalized content]
\`\`\`

---

### Flow 3: Admin User Management

\`\`\`
1. Admin Dashboard (/admin)
   ↓ [Click "Manage Users"]
2. User List (/admin/users)
   ↓ [Search for user]
3. User Detail (/admin/users/[id])
   ↓ [Review info]
4. Edit User (inline or modal)
   ↓ [Update role/status]
5. Confirm Changes
   ↓ [Success toast, return to list]
\`\`\`

**Optimization from Journey Map:**
- Add inline editing to reduce clicks
- Implement fast search (< 500ms response)

---

## Access Control Matrix

| Page/Feature | Public | Authenticated | Admin |
|--------------|--------|---------------|-------|
| Home | ✅ | ✅ | ✅ |
| About | ✅ | ✅ | ✅ |
| Posts List | ✅ | ✅ | ✅ |
| Post Detail | ✅ | ✅ | ✅ |
| Login/Register | ✅ | ❌ (redirect to dashboard) | ❌ |
| Dashboard | ❌ | ✅ | ✅ |
| Create Post | ❌ | ✅ | ✅ |
| Edit Own Post | ❌ | ✅ (owner only) | ✅ |
| Profile Edit | ❌ | ✅ (own only) | ✅ (any) |
| Admin Dashboard | ❌ | ❌ | ✅ |
| User Management | ❌ | ❌ | ✅ |
| Analytics | ❌ | ❌ | ✅ |

**Implementation:**
- Next.js Middleware for route protection
- Laravel Policies for API authorization
- Role-based redirects (non-admin accessing /admin → 403)

---

## Content Strategy

### Content Hierarchy

**Homepage:**
1. Hero (primary value prop) - H1
2. Features (secondary benefits) - H2
3. Social Proof - H2
4. CTA - Large button

**Dashboard:**
1. Welcome Message - H1
2. Key Stats - Large numbers
3. Activity Feed - H2
4. Quick Actions - Prominent buttons

**Post Detail:**
1. Post Title - H1
2. Author Info - Smaller, secondary
3. Content - Body text
4. Engagement - Below content
5. Comments - H2

---

### Microcopy Guidelines

**Empty States:**
- Posts list (no results): "No posts found. Try adjusting your search."
- Dashboard (new user): "Welcome! Let's get you started." + Checklist
- Activity feed (empty): "No recent activity. Start exploring!"

**Success Messages:**
- Post published: "Your post is live! View post or share it now."
- Profile updated: "Changes saved successfully."
- User created (admin): "User account created. Invitation email sent."

**Error Messages:**
- Login failed: "Email or password incorrect. Try again or reset password."
- Post creation failed: "Couldn't save your post. Please try again."
- Permission denied: "You don't have access to this page."

---

## Search & Filtering

### Global Search (Header)

**Scope:** Posts (content, titles, authors)

**Features:**
- Autocomplete suggestions
- Recent searches
- Keyboard shortcut: Cmd/Ctrl + K

**Results Page:** /search?q={query}

---

### Page-Specific Filters

**Posts List (/posts):**
- Category dropdown
- Date range
- Sort: Recent, Popular, Trending

**Admin Users (/admin/users):**
- Role filter
- Status (active, suspended, pending)
- Registration date range
- Search by name/email

---

## Responsive Breakpoints

| Breakpoint | Width | Layout Changes |
|------------|-------|----------------|
| Mobile | < 640px | Single column, hamburger menu, stacked cards |
| Tablet | 640px - 1024px | Two column, condensed sidebar, hybrid nav |
| Desktop | > 1024px | Full sidebar, multi-column, expanded nav |

**Critical Responsive Patterns:**
- Navigation: Header → Drawer menu on mobile
- Dashboard stats: 3 columns → 2 columns → 1 column
- Data tables: Horizontal scroll on mobile
- Forms: Full width on mobile, max-width centered on desktop

---

## Performance Considerations

**Page Load Strategy:**

**Static Generation (SSG):**
- Home (/)
- About (/about)
- Marketing pages

**Incremental Static Regeneration (ISR):**
- Posts List (/posts) - Revalidate every 60s
- Post Detail (/posts/[id]) - Revalidate on publish

**Server-Side Rendering (SSR):**
- Dashboard (personalized data)
- Admin pages (real-time data)

**Client-Side Rendering (CSR):**
- Search results (interactive)
- Infinite scroll feeds

---

## SEO & Metadata

**Page-Specific Meta Tags:**

```javascript
// Home
{
  title: "App Name - Tagline",
  description: "Brief description of value proposition (150-160 chars)",
  openGraph: { image: "/og-home.png" }
}

// Post Detail
{
  title: "{Post Title} - App Name",
  description: "{Post Excerpt}",
  openGraph: {
    image: "{Post Featured Image}",
    type: "article"
  }
}

// Dashboard (noindex)
{
  title: "Dashboard - App Name",
  robots: "noindex, nofollow"
}
```

---

## URL Structure

**Rules:**
- Lowercase only
- Use hyphens (not underscores)
- Keep short and descriptive
- Include relevant keywords for SEO

**Examples:**
- ✅ `/posts/how-to-build-saas`
- ❌ `/posts/12345`
- ❌ `/p/how_to_build_SaaS`

**Dynamic Routes:**
- `/posts/[slug]` - Post by slug (SEO-friendly)
- `/admin/users/[id]` - User by UUID (admin only, not SEO)
- `/profile/[username]` - Public profile (SEO-friendly)

---

## Integration Points

**With Backend (Laravel API):**

| Frontend Page | API Endpoint | Method | Purpose |
|--------------|--------------|--------|---------|
| /posts | /api/v1/posts | GET | Fetch posts list |
| /posts/[id] | /api/v1/posts/{id} | GET | Fetch single post |
| /posts/create | /api/v1/posts | POST | Create new post |
| /dashboard | /api/v1/dashboard/stats | GET | Get user stats |
| /admin/users | /api/v1/admin/users | GET | List users |

**Authentication Flow:**
- Login → POST /api/v1/auth/login → Store token in httpOnly cookie
- Protected routes → Middleware checks cookie → API validates token

---

## Analytics & Tracking

**Page View Events:**
- Home view
- Post view (track post_id)
- Dashboard view
- Admin page views

**Interaction Events:**
- Sign up started
- Sign up completed
- Post created
- Post published
- Search performed
- Filter applied

**Conversion Funnels:**
1. Home → Register → Email Verify → Dashboard
2. Posts List → Post Detail → Like/Comment
3. Dashboard → Create Post → Publish

---

## Implementation Priority

### Phase 1: Core User Flow (Week 1-2)
✅ **Must Have:**
- Home (/)
- Login (/auth/login)
- Register (/auth/register)
- Dashboard (/dashboard)
- Posts List (/posts)
- Post Detail (/posts/[id])

### Phase 2: Content Creation (Week 3)
✅ **Must Have:**
- Post Create (/posts/create)
- Post Edit (/posts/[id]/edit)
- Profile (/profile)
- Profile Edit (/profile/edit)

### Phase 3: Admin Tools (Week 4)
✅ **Should Have:**
- Admin Dashboard (/admin)
- User Management (/admin/users)

### Phase 4: Enhancement (Week 5+)
✅ **Nice to Have:**
- Analytics (/admin/analytics)
- Advanced search
- Notifications
- Settings pages

---

## Validation Checklist

Before moving to wireframes, confirm:

- [ ] Every user journey has a corresponding page/flow
- [ ] All pages have defined access control
- [ ] Navigation allows users to complete critical tasks
- [ ] Information hierarchy supports user goals
- [ ] URL structure is SEO-friendly
- [ ] Responsive strategy is defined
- [ ] API integration points are mapped
- [ ] Success metrics are identified

---

## Next Steps

1. **Create wireframes** for Phase 1 pages (use the design-wireframe skill)
2. **Define design system** (colors, typography, components)
3. **Build component inventories** based on page requirements
4. **Start frontend implementation** with core user flow

---

## Related Documents

- `tasks/user_journeys.md` - User needs that drive this structure
- `tasks/requirements.md` - Features to implement
- `tasks/architecture.md` - Technical constraints
- Design wireframes (to be created)
- Component inventory (to be created)

```

---
