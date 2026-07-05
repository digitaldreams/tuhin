---
name: design-component
description: >
  Generates a production-ready Next.js 15 UI component with JavaScript and Tailwind CSS 4.1. Use
  whenever the user says "generate component X" in a JavaScript (non-TypeScript) Next.js project. Pass
  the component name as the argument.
---

You are a frontend architect generating production components for a senior backend developer.
Generate $ARGUMENTS as a Next.js 15 component with JavaScript and Tailwind CSS 4.1.

## Component Generation Requirements:

### 1. Component Structure

**Use Next.js 15 App Router conventions**:
- Server Components by default
- Add 'use client' only when needed (interactivity, hooks, browser APIs)
- JSDoc comments for prop documentation
- Proper file organization

### 2. File Structure

```
frontend/src/components/ui/{{component-name}}/
├── {{ComponentName}}.jsx
├── {{ComponentName}}.test.jsx (optional)
└── index.js
```

### 3. Component Template

```javascript
// frontend/src/components/ui/{{component-name}}/{{ComponentName}}.jsx
'use client' // Only if needed

/**
 * @typedef {Object} ComponentProps
 * @property {'default'|'primary'|'secondary'|'outline'} [variant='default'] - Component variant
 * @property {'sm'|'md'|'lg'} [size='md'] - Component size
 * @property {string} [className=''] - Additional CSS classes
 */

/**
 * {{ComponentName}} component
 * @param {ComponentProps & React.HTMLAttributes<HTMLDivElement>} props
 */
export function {{ComponentName}}({
  variant = 'default',
  size = 'md',
  className = '',
  ...props
}) {
  return (
    <div
      className={/* Tailwind classes */}
      {...props}
    >
      {/* Component JSX */}
    </div>
  )
}
```

```javascript
// frontend/src/components/ui/{{component-name}}/index.js
export { {{ComponentName}} } from './{{ComponentName}}'
```

### 4. Common Components to Generate

**Button**:
```javascript
/**
 * @typedef {Object} ButtonProps
 * @property {'primary'|'secondary'|'outline'|'ghost'|'destructive'} [variant='primary']
 * @property {'sm'|'md'|'lg'} [size='md']
 * @property {boolean} [disabled=false]
 * @property {boolean} [loading=false]
 * @property {React.ReactNode} [leftIcon]
 * @property {React.ReactNode} [rightIcon]
 * @property {() => void} [onClick]
 */
```

**Input**:
```javascript
/**
 * @typedef {Object} InputProps
 * @property {'text'|'email'|'password'|'number'|'tel'|'url'} [type='text']
 * @property {string} [label]
 * @property {string} [error]
 * @property {string} [helperText]
 * @property {React.ReactNode} [leftAddon]
 * @property {React.ReactNode} [rightAddon]
 * @property {boolean} [disabled=false]
 * @property {boolean} [readonly=false]
 */
```

**Card**:
```javascript
/**
 * @typedef {Object} CardProps
 * @property {'default'|'bordered'|'elevated'} [variant='default']
 * @property {string} [title]
 * @property {string} [subtitle]
 * @property {React.ReactNode} [actions]
 * @property {React.ReactNode} children
 */
```

**Modal/Dialog**:
```javascript
/**
 * @typedef {Object} ModalProps
 * @property {boolean} open - Whether modal is open
 * @property {() => void} onClose - Close handler
 * @property {string} [title]
 * @property {string} [description]
 * @property {React.ReactNode} children
 */
```

**Table**:
```javascript
/**
 * @typedef {Object} Column
 * @property {string} key - Data key
 * @property {string} label - Column header
 * @property {(value: any, row: any) => React.ReactNode} [render] - Custom renderer
 * @property {boolean} [sortable=false]
 * @property {string} [width] - Column width
 *
 * @typedef {Object} TableProps
 * @property {Column[]} columns
 * @property {Object[]} data
 * @property {boolean} [loading=false]
 * @property {(column: string, direction: 'asc'|'desc') => void} [onSort]
 * @property {(page: number) => void} [onPageChange]
 */
```

### 5. Best Practices to Follow

**JSDoc Comments**:
- Document all props with @typedef
- Document component purpose
- Include usage examples in comments
- Document complex logic

**Tailwind**:
- Use design tokens from config
- Responsive classes (sm:, md:, lg:)
- Dark mode support if needed (dark:)
- No arbitrary values unless necessary

**Accessibility**:
- Semantic HTML
- ARIA attributes where needed
- Keyboard navigation
- Focus management
- Screen reader support

**Performance**:
- Server Components when possible
- Lazy loading for heavy components
- Proper React keys in lists
- Memoization for expensive computations (useMemo, useCallback)

**Code Quality**:
- Clean, readable code
- No commented-out code
- No console.logs
- Proper error handling

### 6. Integration with Backend

If component needs data from Laravel API:

```javascript
// Server Component fetching data
import { {{ComponentName}} } from '@/components/ui/{{component}}'

async function getData() {
  const res = await fetch('http://localhost:8000/api/endpoint', {
    cache: 'no-store', // or 'force-cache' for static
  })

  if (!res.ok) throw new Error('Failed to fetch')
  return res.json()
}

export default async function Page() {
  const data = await getData()
  return <{{ComponentName}} data={data} />
}
```

For client-side fetching:

```javascript
'use client'
import { useEffect, useState } from 'react'
import useSWR from 'swr'

const fetcher = (url) => fetch(url).then(r => r.json())

export function {{ComponentName}}() {
  const { data, error, isLoading } = useSWR('/api/endpoint', fetcher)

  if (isLoading) return <LoadingState />
  if (error) return <ErrorState />

  return <div>{/* Render data */}</div>
}
```

### 7. Example: Complete Button Component

```javascript
// frontend/src/components/ui/button/Button.jsx
'use client'

import { forwardRef } from 'react'
import { cn } from '@/lib/utils'

const buttonVariants = {
  primary: 'bg-primary-600 text-white hover:bg-primary-700 active:bg-primary-800',
  secondary: 'bg-gray-200 text-gray-900 hover:bg-gray-300 active:bg-gray-400',
  outline: 'border-2 border-primary-600 text-primary-600 hover:bg-primary-50',
  ghost: 'text-primary-600 hover:bg-primary-50',
  destructive: 'bg-red-600 text-white hover:bg-red-700',
}

const buttonSizes = {
  sm: 'px-3 py-1.5 text-sm',
  md: 'px-4 py-2 text-base',
  lg: 'px-6 py-3 text-lg',
}

/**
 * Button component with multiple variants and sizes
 * @typedef {Object} ButtonProps
 * @property {'primary'|'secondary'|'outline'|'ghost'|'destructive'} [variant='primary']
 * @property {'sm'|'md'|'lg'} [size='md']
 * @property {boolean} [disabled=false]
 * @property {boolean} [loading=false]
 * @property {string} [className='']
 *
 * @param {ButtonProps & React.ButtonHTMLAttributes<HTMLButtonElement>} props
 */
export const Button = forwardRef(
  (
    {
      variant = 'primary',
      size = 'md',
      className = '',
      disabled = false,
      loading = false,
      children,
      ...props
    },
    ref
  ) => {
    return (
      <button
        ref={ref}
        disabled={disabled || loading}
        className={cn(
          'inline-flex items-center justify-center rounded-lg font-medium',
          'transition-colors duration-200',
          'focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2',
          'disabled:opacity-50 disabled:cursor-not-allowed',
          buttonVariants[variant],
          buttonSizes[size],
          className
        )}
        {...props}
      >
        {loading && (
          <svg
            className="animate-spin -ml-1 mr-2 h-4 w-4"
            fill="none"
            viewBox="0 0 24 24"
          >
            <circle
              className="opacity-25"
              cx="12"
              cy="12"
              r="10"
              stroke="currentColor"
              strokeWidth="4"
            />
            <path
              className="opacity-75"
              fill="currentColor"
              d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
            />
          </svg>
        )}
        {children}
      </button>
    )
  }
)

Button.displayName = 'Button'
```

```javascript
// frontend/src/lib/utils.js
import { clsx } from 'clsx'
import { twMerge } from 'tailwind-merge'

/**
 * Merge Tailwind classes intelligently
 * @param  {...any} inputs - Class values to merge
 * @returns {string} Merged class string
 */
export function cn(...inputs) {
  return twMerge(clsx(inputs))
}
```

### 8. Output Format

Provide:
1. Complete file structure
2. All JavaScript files with full code
3. Installation instructions for dependencies (if any)
4. Usage examples with JSDoc
5. Props documentation

**Save to**: `frontend/src/components/ui/{{component-name}}/`

Generate production-ready code. No TODOs, no placeholders.
