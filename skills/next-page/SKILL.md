---
name: next-page
description: >
  Generates a complete Next.js 15 page using existing UI components, based on wireframes
  (tasks/user_journeys.md) and information architecture. Use whenever the user says "generate the X
  page" or "build the page" in a Next.js project. Pass the page name as the argument.
---

You are a senior frontend developer generating production-ready Next.js 15 pages.

## Core Principles

1. **Use existing components** - Import from component library, don't recreate
2. **Follow wireframe layout** - Match the wireframe exactly
3. **Server Components first** - Use 'use client' only when needed
4. **Real data integration** - Show API endpoints and data fetching
5. **Tailwind v4.1+** - Use latest utilities
6. **Accessibility built-in** - Proper semantic HTML and ARIA

---

## Your Task

Generate a complete, production-ready page for: **$ARGUMENTS**

The page should:
- **Match the wireframe layout** from wireframes file
- **Import and use existing components** from component library
- **Fetch data properly** (Server Component or client-side)
- **Handle loading/error states**
- **Be fully responsive**
- **Include proper metadata** (SEO)
- **Follow design system** patterns

---

## Source Files to Analyze

Read these files using `read_file`:
1. `design/wireframes/{{page-name}}.md` - Layout specifications
2. `design/information_architecture.md` - Page details (URL, purpose, access)
3. `design/component_inventory.md` - Available components
4. `design/design_system.md` - Styling patterns
5. `tasks/user_journeys.md` - User goals for this page

---

## Output Files

Generate these files:

### 1. Page Component
**File:** `frontend/src/app/{{page-route}}/page.jsx`

### 2. Loading State (if needed)
**File:** `frontend/src/app/{{page-route}}/loading.jsx`

### 3. Error State (if needed)
**File:** `frontend/src/app/{{page-route}}/error.jsx`

---

## Page Generation Steps

### Step 1: Analyze Requirements

From wireframes and IA, determine:
- ✅ Page route (URL path)
- ✅ Access level (public, authenticated, admin)
- ✅ Layout type (with/without sidebar, header)
- ✅ Components needed (from inventory)
- ✅ Data requirements (API endpoints)
- ✅ Interactive elements (forms, modals, etc.)

---

### Step 2: Determine Page Type

**Static Page (Server Component):**
- No user interaction
- No form submissions
- Data can be fetched at build time
- Example: About, Landing, Marketing pages

**Dynamic Page (Server Component with Data):**
- Fetches data server-side
- No client interactivity
- SEO-friendly
- Example: Blog post, User profile (view-only), Product detail

**Interactive Page (Client Component):**
- Has forms, buttons with state
- Real-time updates
- User interactions
- Example: Dashboard, Settings, Admin panel, Form pages

**Hybrid (Server + Client):**
- Server Component wraps Client Components
- Data fetched server-side, interactivity on client
- Best of both worlds
- Example: Dashboard with interactive widgets

---

### Step 3: Generate Page Structure

**For Server Component Pages:**

\`\`\`javascript
// app/{{route}}/page.jsx
import { ComponentA } from '@/components/ui/component-a'
import { ComponentB } from '@/components/ui/component-b'

// Server-side data fetching
async function getData() {
  const res = await fetch('http://localhost:8000/api/v1/endpoint', {
    cache: 'no-store', // or 'force-cache' for static
    // next: { revalidate: 60 } // ISR: revalidate every 60 seconds
  })

  if (!res.ok) {
    throw new Error('Failed to fetch data')
  }

  return res.json()
}

// Page metadata
export const metadata = {
  title: 'Page Title - App Name',
  description: 'Page description for SEO',
}

// Server Component
export default async function PageName() {
  const data = await getData()

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      {/* Page content using components */}
      <ComponentA data={data} />
      <ComponentB />
    </div>
  )
}
\`\`\`

---

**For Client Component Pages:**

\`\`\`javascript
// app/{{route}}/page.jsx
'use client'

import { useState } from 'react'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'

export default function PageName() {
  const [state, setState] = useState(null)

  const handleAction = async () => {
    // Client-side logic
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      {/* Interactive content */}
      <Button onClick={handleAction}>Click me</Button>
    </div>
  )
}
\`\`\`

---

**For Hybrid Pages:**

\`\`\`javascript
// app/{{route}}/page.jsx
import { InteractiveComponent } from './interactive-component'

// Server Component (fetches data)
async function getData() {
  const res = await fetch('http://localhost:8000/api/v1/endpoint')
  return res.json()
}

export default async function PageName() {
  const data = await getData()

  return (
    <div>
      {/* Static content */}
      <h1>Page Title</h1>

      {/* Client Component with server data */}
      <InteractiveComponent initialData={data} />
    </div>
  )
}

// app/{{route}}/interactive-component.jsx
'use client'

export function InteractiveComponent({ initialData }) {
  const [data, setData] = useState(initialData)

  // Client-side interactivity
  return <div>{/* Interactive UI */}</div>
}
\`\`\`

---

### Step 4: Implement Layout

**Match the wireframe structure exactly:**

\`\`\`javascript
export default function PageName() {
  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">

      {/* Header (if in wireframe) */}
      <Header />

      {/* Main content area */}
      <main className="container mx-auto px-4 py-8">
        <div className="max-w-7xl mx-auto">

          {/* Page Header */}
          <div className="mb-8">
            <h1 className="text-4xl font-bold text-gray-900 dark:text-white mb-2">
              Page Title
            </h1>
            <p className="text-lg text-gray-600 dark:text-gray-300">
              Page description
            </p>
          </div>

          {/* Content sections from wireframe */}
          <div className="space-y-8">
            {/* Section 1 */}
            <section>
              {/* Components */}
            </section>

            {/* Section 2 */}
            <section>
              {/* Components */}
            </section>
          </div>

        </div>
      </main>

      {/* Footer (if in wireframe) */}
      <Footer />

    </div>
  )
}
\`\`\`

---

### Step 5: Add Loading State

\`\`\`javascript
// app/{{route}}/loading.jsx
import { Spinner } from '@/components/ui/spinner'

export default function Loading() {
  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900 flex items-center justify-center">
      <div className="text-center">
        <Spinner size="lg" />
        <p className="mt-4 text-gray-600 dark:text-gray-300">
          Loading...
        </p>
      </div>
    </div>
  )
}
\`\`\`

Or skeleton loader:

\`\`\`javascript
// app/{{route}}/loading.jsx
export default function Loading() {
  return (
    <div className="container mx-auto px-4 py-8">
      <div className="max-w-7xl mx-auto space-y-8">
        {/* Skeleton matching page layout */}
        <div className="animate-pulse">
          <div className="h-10 bg-gray-200 dark:bg-gray-700 rounded w-1/3 mb-4"></div>
          <div className="h-4 bg-gray-200 dark:bg-gray-700 rounded w-1/2 mb-8"></div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="h-32 bg-gray-200 dark:bg-gray-700 rounded"></div>
            <div className="h-32 bg-gray-200 dark:bg-gray-700 rounded"></div>
            <div className="h-32 bg-gray-200 dark:bg-gray-700 rounded"></div>
          </div>
        </div>
      </div>
    </div>
  )
}
\`\`\`

---

### Step 6: Add Error Handling

\`\`\`javascript
// app/{{route}}/error.jsx
'use client'

import { Button } from '@/components/ui/button'
import { Alert } from '@/components/ui/alert'

export default function Error({ error, reset }) {
  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900 flex items-center justify-center px-4">
      <div className="max-w-md w-full">
        <Alert variant="error">
          <h2 className="text-lg font-semibold mb-2">
            Something went wrong!
          </h2>
          <p className="text-sm mb-4">
            {error.message || 'An unexpected error occurred.'}
          </p>
          <div className="flex gap-3">
            <Button onClick={() => reset()} variant="primary">
              Try again
            </Button>
            <Button onClick={() => window.location.href = '/'} variant="secondary">
              Go home
            </Button>
          </div>
        </Alert>
      </div>
    </div>
  )
}
\`\`\`

---

### Step 7: Add Metadata

\`\`\`javascript
// For static metadata
export const metadata = {
  title: 'Page Title - App Name',
  description: 'Page description for SEO (150-160 characters)',
  openGraph: {
    title: 'Page Title',
    description: 'Description for social sharing',
    images: ['/og-image.jpg'],
  },
}

// For dynamic metadata
export async function generateMetadata({ params }) {
  const data = await getData(params.id)

  return {
    title: `${data.title} - App Name`,
    description: data.description,
  }
}
\`\`\`

---

## Common Page Patterns

### Dashboard Page

\`\`\`javascript
// app/dashboard/page.jsx
import { Card } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'

async function getStats() {
  const res = await fetch('http://localhost:8000/api/v1/dashboard/stats', {
    cache: 'no-store',
  })
  return res.json()
}

export const metadata = {
  title: 'Dashboard - App Name',
}

export default async function DashboardPage() {
  const stats = await getStats()

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <main className="container mx-auto px-4 py-8">
        <div className="max-w-7xl mx-auto space-y-8">

          {/* Page Header */}
          <div>
            <h1 className="text-4xl font-bold text-gray-900 dark:text-white mb-2">
              Dashboard
            </h1>
            <p className="text-lg text-gray-600 dark:text-gray-300">
              Welcome back! Here's your overview.
            </p>
          </div>

          {/* Stat Cards */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <Card>
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-600 dark:text-gray-400">
                    Total Users
                  </p>
                  <p className="text-3xl font-bold text-gray-900 dark:text-white mt-2">
                    {stats.totalUsers}
                  </p>
                </div>
                <Badge variant="success">+12%</Badge>
              </div>
            </Card>

            {/* More stat cards */}
          </div>

          {/* Recent Activity */}
          <Card>
            <h2 className="text-2xl font-semibold text-gray-900 dark:text-white mb-4">
              Recent Activity
            </h2>
            {/* Activity list */}
          </Card>

        </div>
      </main>
    </div>
  )
}
\`\`\`

---

### Form Page (Login/Register)

\`\`\`javascript
// app/login/page.jsx
'use client'

import { useState } from 'react'
import { useRouter } from 'next/navigation'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { Alert } from '@/components/ui/alert'

export default function LoginPage() {
  const router = useRouter()
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const [formData, setFormData] = useState({
    email: '',
    password: '',
  })

  const handleSubmit = async (e) => {
    e.preventDefault()
    setLoading(true)
    setError('')

    try {
      const res = await fetch('http://localhost:8000/api/v1/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData),
      })

      if (!res.ok) {
        const data = await res.json()
        throw new Error(data.message || 'Login failed')
      }

      const data = await res.json()
      // Store token (example - use proper auth library in production)
      localStorage.setItem('token', data.token)

      router.push('/dashboard')
    } catch (err) {
      setError(err.message)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900 flex items-center justify-center px-4">
      <div className="max-w-md w-full">

        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white mb-2">
            Welcome back
          </h1>
          <p className="text-gray-600 dark:text-gray-300">
            Sign in to your account
          </p>
        </div>

        {/* Error Alert */}
        {error && (
          <Alert variant="error" className="mb-6">
            {error}
          </Alert>
        )}

        {/* Login Form */}
        <form onSubmit={handleSubmit} className="space-y-6">
          <Input
            type="email"
            label="Email Address"
            value={formData.email}
            onChange={(e) => setFormData({ ...formData, email: e.target.value })}
            required
            disabled={loading}
          />

          <Input
            type="password"
            label="Password"
            value={formData.password}
            onChange={(e) => setFormData({ ...formData, password: e.target.value })}
            required
            disabled={loading}
          />

          <Button
            type="submit"
            variant="primary"
            className="w-full"
            loading={loading}
          >
            Sign In
          </Button>
        </form>

        {/* Footer Links */}
        <div className="mt-6 text-center text-sm">
          <a href="/forgot-password" className="text-blue-600 hover:text-blue-700 dark:text-blue-400">
            Forgot password?
          </a>
          <span className="mx-2 text-gray-400">·</span>
          <a href="/register" className="text-blue-600 hover:text-blue-700 dark:text-blue-400">
            Create account
          </a>
        </div>

      </div>
    </div>
  )
}
\`\`\`

---

### List Page with Table

\`\`\`javascript
// app/admin/users/page.jsx
import { Table } from '@/components/ui/table'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'

async function getUsers() {
  const res = await fetch('http://localhost:8000/api/v1/admin/users', {
    cache: 'no-store',
  })
  return res.json()
}

export const metadata = {
  title: 'User Management - Admin',
}

export default async function UsersPage() {
  const users = await getUsers()

  const columns = [
    {
      key: 'name',
      label: 'Name',
      sortable: true,
    },
    {
      key: 'email',
      label: 'Email',
      sortable: true,
    },
    {
      key: 'role',
      label: 'Role',
      render: (value) => (
        <Badge variant={value === 'admin' ? 'info' : 'default'}>
          {value}
        </Badge>
      ),
    },
    {
      key: 'status',
      label: 'Status',
      render: (value) => (
        <Badge variant={value === 'active' ? 'success' : 'warning'}>
          {value}
        </Badge>
      ),
    },
    {
      key: 'actions',
      label: 'Actions',
      render: (value, row) => (
        <div className="flex gap-2">
          <Button variant="outline" size="sm">
            Edit
          </Button>
          <Button variant="destructive" size="sm">
            Delete
          </Button>
        </div>
      ),
    },
  ]

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-900">
      <main className="container mx-auto px-4 py-8">
        <div className="max-w-7xl mx-auto space-y-6">

          {/* Header */}
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-4xl font-bold text-gray-900 dark:text-white">
                User Management
              </h1>
              <p className="text-gray-600 dark:text-gray-300 mt-2">
                Manage user accounts and permissions
              </p>
            </div>
            <Button variant="primary">
              Add User
            </Button>
          </div>

          {/* Table */}
          <div className="bg-white dark:bg-gray-800 rounded-lg shadow">
            <Table
              columns={columns}
              data={users.data}
              loading={false}
            />
          </div>

        </div>
      </main>
    </div>
  )
}
\`\`\`

---

## Authentication & Authorization

### Protected Routes

\`\`\`javascript
// app/dashboard/page.jsx
import { redirect } from 'next/navigation'
import { getServerSession } from 'next-auth'

export default async function DashboardPage() {
  const session = await getServerSession()

  if (!session) {
    redirect('/login')
  }

  // Page content for authenticated users
  return <div>Dashboard</div>
}
\`\`\`

### Role-Based Access

\`\`\`javascript
// app/admin/page.jsx
import { redirect } from 'next/navigation'
import { getServerSession } from 'next-auth'

export default async function AdminPage() {
  const session = await getServerSession()

  if (!session) {
    redirect('/login')
  }

  if (session.user.role !== 'admin') {
    redirect('/403') // Forbidden
  }

  // Admin content
  return <div>Admin Panel</div>
}
\`\`\`

---

## API Integration Patterns

### Server-Side Fetching (Recommended)

\`\`\`javascript
async function getData() {
  const res = await fetch('http://localhost:8000/api/v1/endpoint', {
    cache: 'no-store', // Always fresh
    // cache: 'force-cache', // Cache forever (static)
    // next: { revalidate: 60 }, // ISR: revalidate every 60s
  })

  if (!res.ok) {
    throw new Error('Failed to fetch')
  }

  return res.json()
}
\`\`\`

### Client-Side Fetching (When Needed)

\`\`\`javascript
'use client'

import { useState, useEffect } from 'react'

export default function PageName() {
  const [data, setData] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    fetch('/api/endpoint')
      .then(res => res.json())
      .then(setData)
      .catch(setError)
      .finally(() => setLoading(false))
  }, [])

  if (loading) return <div>Loading...</div>
  if (error) return <div>Error: {error.message}</div>

  return <div>{/* Render data */}</div>
}
\`\`\`

### Using SWR (Recommended for Client)

\`\`\`javascript
'use client'

import useSWR from 'swr'

const fetcher = (url) => fetch(url).then(r => r.json())

export default function PageName() {
  const { data, error, isLoading } = useSWR('/api/endpoint', fetcher)

  if (isLoading) return <div>Loading...</div>
  if (error) return <div>Error loading data</div>

  return <div>{/* Render data */}</div>
}
\`\`\`

---

## Output Format

Provide these files:

### 1. Main Page File

\`\`\`javascript
// frontend/src/app/{{route}}/page.jsx
[Complete page code]
\`\`\`

### 2. Loading State

\`\`\`javascript
// frontend/src/app/{{route}}/loading.jsx
[Loading component]
\`\`\`

### 3. Error State

\`\`\`javascript
// frontend/src/app/{{route}}/error.jsx
[Error boundary]
\`\`\`

### 4. Additional Files (if needed)

- Client components extracted from page
- Utility functions
- Type definitions

---

## Implementation Checklist

Before outputting, verify:

- [ ] Matches wireframe layout exactly
- [ ] Uses existing components from inventory
- [ ] Includes proper metadata for SEO
- [ ] Has loading state
- [ ] Has error handling
- [ ] Is responsive (mobile, tablet, desktop)
- [ ] Uses Tailwind v4.1+ utilities
- [ ] Includes proper accessibility (ARIA, semantic HTML)
- [ ] Server Component by default (unless interactivity needed)
- [ ] Data fetching implemented correctly
- [ ] Follows design system patterns
- [ ] Dark mode support included

---

## Output Confirmation

After generating, respond with:

"✅ Generated {{page-name}} page

**Files created:**
- \`app/{{route}}/page.jsx\` - Main page component
- \`app/{{route}}/loading.jsx\` - Loading state
- \`app/{{route}}/error.jsx\` - Error boundary

**Page type:** [Server Component / Client Component / Hybrid]

**Components used:**
- [List components imported]

**Data sources:**
- API: [List endpoints]
- Fetching: [Server-side / Client-side / Hybrid]

**Features included:**
- [List key features]

**Access level:** [Public / Authenticated / Admin]

**Responsive:** ✅ Mobile, Tablet, Desktop

**Next steps:**
1. Test the page: \`npm run dev\` and visit \`/{{route}}\`
2. Verify data fetching works
3. Test loading and error states
4. Check responsive behavior
5. Verify accessibility

**To customize:**
- Modify \`app/{{route}}/page.jsx\`
- Adjust API endpoints as needed
- Update metadata for SEO"
