# React Component Patterns (Example Implementations)

These are **React + Tailwind CSS v4.1+** reference implementations. When the detected project uses a different framework (Vue, Svelte, Blade/Livewire, plain JS), keep the same principles — pattern choice, variants/flags, real accessibility, focus states — and translate the code to that framework's idioms.

## Core Principles

1. **Start simple, add complexity only when needed**
2. **No code the user didn't ask for**
3. **Real accessibility, not checkboxes**
4. **Use Tailwind v4.1+ utilities exclusively**
5. **Server Components by default**

---

## Tailwind v4.1+ Requirements

**IMPORTANT:** Use latest v4.1+ utilities and approach:

✅ **Use These:**
- `focus-visible:outline` (not `focus:outline`)
- `focus-visible:outline-2`
- Text shadows: `text-shadow-sm`, `text-shadow-lg`
- Container queries: `@container`, `@sm:`, `@lg:`
- 3D transforms: `rotate-x-*`, `rotate-y-*`, `scale-z-*`
- Modern utilities from v4.1

❌ **Don't Use:**
- Old focus styles (`focus:ring` - use `focus-visible:outline` instead)
- Deprecated utilities
- v3-only features

---

## Component Generation Steps

### Step 1: Understand the Request

Parse user input: `the design-component skill with argument <name> [flags]`

**Example inputs:**
- `button` → Basic button component
- `button --variants=primary,secondary` → Button with specific variants
- `modal --with-portal` → Modal using React portal
- `input --with-validation` → Input with form validation

**Default behavior if no flags:**
- Generate minimal working component
- Server Component (no 'use client')
- No variants system (just accept className prop)
- No loading states, icons, or extra features

---

### Step 2: Choose Component Pattern

**Simple Components** (Button, Input, Link):
```javascript
// Server Component (default)
export function Button({ children, className = '', ...props }) {
  return (
    <button
      className={`inline-flex items-center justify-center rounded-md px-4 py-2 text-sm font-medium transition-colors hover:opacity-90 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 disabled:pointer-events-none disabled:opacity-50 ${className}`}
      {...props}
    >
      {children}
    </button>
  )
}
```

**Interactive Components** (Modal, Dropdown, Tabs):
```javascript
'use client'
import { useState } from 'react'

export function Modal({ children, trigger, title }) {
  const [open, setOpen] = useState(false)

  return (
    <>
      <button onClick={() => setOpen(true)}>
        {trigger}
      </button>

      {open && (
        <div
          className="fixed inset-0 z-50 bg-black/50 flex items-center justify-center p-4"
          onClick={() => setOpen(false)}
        >
          <div
            className="bg-white dark:bg-gray-800 rounded-xl shadow-2xl max-w-lg w-full p-6"
            onClick={(e) => e.stopPropagation()}
          >
            <h2 className="text-xl font-semibold mb-4">{title}</h2>
            {children}
            <button
              onClick={() => setOpen(false)}
              className="mt-4 px-4 py-2 bg-gray-200 rounded-md"
            >
              Close
            </button>
          </div>
        </div>
      )}
    </>
  )
}
```

**Data Components** (Table, List, Card Grid):
```javascript
// Server Component
export function Table({ data, columns }) {
  return (
    <div className="overflow-x-auto">
      <table className="min-w-full divide-y divide-gray-200">
        <thead className="bg-gray-50 dark:bg-gray-800">
          <tr>
            {columns.map(col => (
              <th key={col.key} className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                {col.label}
              </th>
            ))}
          </tr>
        </thead>
        <tbody className="bg-white dark:bg-gray-900 divide-y divide-gray-200 dark:divide-gray-700">
          {data.map((row, idx) => (
            <tr key={idx} className="hover:bg-gray-50 dark:hover:bg-gray-800">
              {columns.map(col => (
                <td key={col.key} className="px-6 py-4 whitespace-nowrap text-sm text-gray-900 dark:text-gray-100">
                  {col.render ? col.render(row[col.key], row) : row[col.key]}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}
```

---

### Step 3: Add Features Based on Flags

**Only add these if user requests them:**

#### `--variants=<list>`
```javascript
const variants = {
  primary: 'bg-blue-600 text-white hover:bg-blue-700',
  secondary: 'bg-gray-200 text-gray-900 hover:bg-gray-300',
  destructive: 'bg-red-600 text-white hover:bg-red-700',
}

export function Button({ variant = 'primary', className = '', ...props }) {
  return (
    <button
      className={`${variants[variant]} px-4 py-2 rounded-md ${className}`}
      {...props}
    />
  )
}
```

#### `--with-loading`
```javascript
export function Button({ loading = false, children, ...props }) {
  return (
    <button disabled={loading} {...props}>
      {loading ? (
        <span className="inline-block size-4 animate-spin rounded-full border-2 border-current border-r-transparent" />
      ) : (
        children
      )}
    </button>
  )
}
```

#### `--with-validation` (for inputs)
```javascript
'use client'
import { useState } from 'react'

export function Input({ validate, ...props }) {
  const [error, setError] = useState('')

  const handleBlur = (e) => {
    if (validate) {
      const err = validate(e.target.value)
      setError(err || '')
    }
  }

  return (
    <div>
      <input
        className={`border rounded-md px-3 py-2 ${error ? 'border-red-500' : 'border-gray-300'}`}
        onBlur={handleBlur}
        {...props}
      />
      {error && <p className="text-sm text-red-600 mt-1">{error}</p>}
    </div>
  )
}
```

---

### Step 4: Real Accessibility

**Don't just say "add ARIA attributes." Actually add them:**

#### Buttons
```javascript
export function Button({ loading, children, ...props }) {
  return (
    <button
      aria-busy={loading}
      aria-disabled={loading}
      className="focus-visible:outline focus-visible:outline-2 focus-visible:outline-blue-500 focus-visible:outline-offset-2"
      {...props}
    >
      {loading && <span className="sr-only">Loading</span>}
      {children}
    </button>
  )
}
```

#### Modals
```javascript
export function Modal({ open, onClose, title, children }) {
  return (
    <div
      role="dialog"
      aria-modal="true"
      aria-labelledby="modal-title"
      className={open ? 'fixed inset-0 z-50' : 'hidden'}
    >
      <h2 id="modal-title" className="text-xl font-semibold">
        {title}
      </h2>
      {children}
      <button
        onClick={onClose}
        aria-label="Close dialog"
        className="focus-visible:outline focus-visible:outline-2"
      >
        ×
      </button>
    </div>
  )
}
```

#### Forms
```javascript
export function Input({ label, error, id, ...props }) {
  const inputId = id || `input-${Math.random().toString(36).slice(2, 9)}`

  return (
    <div>
      <label htmlFor={inputId} className="block text-sm font-medium mb-1">
        {label}
      </label>
      <input
        id={inputId}
        aria-invalid={!!error}
        aria-describedby={error ? `${inputId}-error` : undefined}
        className="focus-visible:outline focus-visible:outline-2 focus-visible:outline-blue-500"
        {...props}
      />
      {error && (
        <p id={`${inputId}-error`} className="text-sm text-red-600 mt-1">
          {error}
        </p>
      )}
    </div>
  )
}
```

---

### Step 5: File Structure

```
frontend/src/components/ui/<component-name>/
├── {{ComponentName}}.jsx
└── index.js
```

**That's it.** No test files unless requested. No story files. No 12 variants of the same thing.

---

### Step 6: Documentation

Add this at the top of the component file:

```javascript
/**
 * {{ComponentName}}
 *
 * A {{brief description}}.
 *
 * @example
 * // Basic usage
 * <ComponentName>Content</ComponentName>
 *
 * @example
 * // With props
 * <ComponentName variant="primary" onClick={handleClick}>
 *   Click me
 * </ComponentName>
 */
```

**Don't write:**
- Full TypeDef for every prop (they can read the code)
- Lists of all possible variants (they're in the code)
- Installation instructions for React (they have React installed)

---

## Output Format

Provide exactly 3 files:

**1. Component file:**
```javascript
// frontend/src/components/ui/{{name}}/{{Name}}.jsx
[Full component code with Tailwind v4.1+ utilities]
```

**2. Index file:**
```javascript
// frontend/src/components/ui/{{name}}/index.js
export { {{Name}} } from './{{Name}}'
```

**3. Usage example (in response text, not a file):**
```javascript
// In your page or component:
import { {{Name}} } from '@/components/ui/{{name}}'

export default function Page() {
  return <{{Name}}>...</{{Name}}>
}
```

**4. Dependencies (only if needed):**
"This component requires: [package name]
Install: npm install [package]"

---

## Quality Checklist

Before outputting, verify:
- [ ] Component has exactly the features requested (no more, no less)
- [ ] Uses Server Component unless interactivity requires 'use client'
- [ ] Has real accessibility attributes (not just comments)
- [ ] Uses Tailwind v4.1+ utilities (focus-visible, not focus:ring)
- [ ] No console.logs, TODOs, or placeholder comments
- [ ] Works as a standalone component (no missing dependencies)
- [ ] Includes one realistic usage example
- [ ] Dark mode support with dark: prefix where appropriate

---

## Tailwind v4.1+ Specific Features

### Use These New Features When Appropriate:

**Text Shadows (NEW):**
```javascript
<h1 className="text-shadow-lg text-white">
  Heading with shadow
</h1>
```

**Container Queries (NEW):**
```javascript
<div className="@container">
  <div className="grid grid-cols-1 @sm:grid-cols-2 @lg:grid-cols-3">
    {/* Responsive to container size */}
  </div>
</div>
```

**3D Transforms (NEW):**
```javascript
<div className="rotate-x-12 rotate-y-45 transition-transform hover:rotate-x-0">
  3D card flip
</div>
```

**Mask Utilities (NEW in v4.1):**
```javascript
<div className="mask-linear-to-b">
  Fades out at bottom
</div>
```

---

## Examples

### User: `the design-component skill with argument button`

Output:
```javascript
// frontend/src/components/ui/button/Button.jsx

/**
 * Button
 *
 * A simple button component with hover and focus states.
 *
 * @example
 * <Button onClick={() => alert('clicked')}>
 *   Click me
 * </Button>
 */
export function Button({ children, className = '', ...props }) {
  return (
    <button
      className={`inline-flex items-center justify-center rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white transition-colors hover:bg-blue-700 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-blue-500 disabled:pointer-events-none disabled:opacity-50 ${className}`}
      {...props}
    >
      {children}
    </button>
  )
}
```

### User: `the design-component skill with argument button --variants=primary,secondary,outline`

Output:
```javascript
// frontend/src/components/ui/button/Button.jsx

/**
 * Button with variant support
 *
 * @example
 * <Button variant="primary">Primary</Button>
 * <Button variant="secondary">Secondary</Button>
 */

const variants = {
  primary: 'bg-blue-600 text-white hover:bg-blue-700 focus-visible:outline-blue-500',
  secondary: 'bg-gray-200 text-gray-900 hover:bg-gray-300 focus-visible:outline-gray-400',
  outline: 'border-2 border-blue-600 text-blue-600 hover:bg-blue-50 focus-visible:outline-blue-500',
}

export function Button({
  variant = 'primary',
  className = '',
  ...props
}) {
  return (
    <button
      className={`inline-flex items-center justify-center rounded-md px-4 py-2 text-sm font-medium transition-colors focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 disabled:pointer-events-none disabled:opacity-50 ${variants[variant]} ${className}`}
      {...props}
    />
  )
}
```

### User: `the design-component skill with argument input --with-validation`

Output:
```javascript
// frontend/src/components/ui/input/Input.jsx
'use client'
import { useState } from 'react'

/**
 * Input with validation support
 *
 * @example
 * <Input
 *   label="Email"
 *   validate={(value) => !value.includes('@') ? 'Invalid email' : null}
 * />
 */
export function Input({
  label,
  error: externalError,
  validate,
  id,
  className = '',
  ...props
}) {
  const [internalError, setInternalError] = useState('')
  const error = externalError || internalError
  const inputId = id || `input-${Math.random().toString(36).slice(2, 9)}`

  const handleBlur = (e) => {
    if (validate) {
      const validationError = validate(e.target.value)
      setInternalError(validationError || '')
    }
  }

  return (
    <div className="space-y-2">
      {label && (
        <label
          htmlFor={inputId}
          className="block text-sm font-medium text-gray-700 dark:text-gray-300"
        >
          {label}
        </label>
      )}
      <input
        id={inputId}
        aria-invalid={!!error}
        aria-describedby={error ? `${inputId}-error` : undefined}
        className={`w-full px-3 py-2 border rounded-md bg-white dark:bg-gray-800 text-gray-900 dark:text-white placeholder-gray-500 dark:placeholder-gray-400 transition-colors focus-visible:outline focus-visible:outline-2 focus-visible:outline-blue-500 disabled:bg-gray-100 disabled:cursor-not-allowed ${error ? 'border-red-500 focus-visible:outline-red-500' : 'border-gray-300 dark:border-gray-600'} ${className}`}
        onBlur={handleBlur}
        {...props}
      />
      {error && (
        <p id={`${inputId}-error`} className="text-sm text-red-600 dark:text-red-400">
          {error}
        </p>
      )}
    </div>
  )
}
```

---

## Special Cases

### If component is complex (e.g., data table with sorting, filtering):
Ask the user to clarify:
"Table component can include: sorting, filtering, pagination, row selection. Which features do you need?"

### If component needs external library (e.g., date picker):
Suggest the library and ask:
"For a production date picker, I recommend using react-day-picker. Should I generate a wrapper component, or would you prefer a different approach?"

### If component needs server/client hybrid:
Explain the pattern:
"This component needs data from the server. I'll generate:
1. Server component to fetch data
2. Client component for interactivity
3. Example showing both together"

---

## Important: Tailwind v4.1+ Focus States

**Always use `focus-visible:` instead of `focus:`**

✅ **Correct:**
```javascript
className="focus-visible:outline focus-visible:outline-2 focus-visible:outline-blue-500"
```

❌ **Wrong (v3 style):**
```javascript
className="focus:outline-none focus:ring-2 focus:ring-blue-500"
```

**Why:** `focus-visible:` only shows focus indicator for keyboard navigation, not mouse clicks. Better UX!

---

Generate production-ready code that solves the specific problem. No library of unused variants.
