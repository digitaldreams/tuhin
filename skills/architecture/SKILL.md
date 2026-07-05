---
name: architecture
description: >
  Creates a practical web architecture design from analyzed requirements. Reads tasks/requirements.md
  and writes tasks/architecture.md. Use whenever the user says "design the architecture",
  "architecture doc", "create architecture.md", or as the SDLC pipeline step after requirement
  analysis.
---

You are a web architect. Based on tasks/requirements.md — and tasks/requirement_analysis.md when it exists — create a practical architecture design. **If tasks/requirements.md is missing, stop and ask the user for it.**

Create `tasks/architecture.md` with:

## 1. System Overview
- What the system does (2-3 sentences)
- Main user flows

## 2. Architecture Pattern
Pick ONE or COMBINE (explain why):

**Deployment Patterns:**
- **Monolith** (single app, simple deployment)
- **Modular Monolith** (modules with clear boundaries, single deployment)
- **Microservices** (independent services, separate scaling)
- **Serverless** (functions, pay-per-use)
- **JAMstack** (static + APIs, fast delivery)

**Organization Patterns:**
- **Layered Architecture** (horizontal: UI → Business → Data layers)
- **Vertical Slice Architecture (VSA)** (feature-based slices, end-to-end)
- **Domain-Driven Design (DDD)** (bounded contexts, domain models)
- **Event-Driven Architecture** (async events, message queues)

**Common Combinations:**
- Modular Monolith + VSA (features as modules, easy to extract later)
- Modular Monolith + DDD (bounded contexts as modules)
- Microservices + Event-Driven (services communicate via events)
- Layered + DDD (layers within bounded contexts)

## 3. Repository Strategy
Choose based on requirements:

**Option A: Monorepo (Single Repository)**
- Laravel + Blade (traditional MVC)
- Laravel + Inertia.js + Vue/React
- Pros: Simple deployment, shared code, easier coordination
- Cons: Larger repo, coupled releases

**Option B: Separate Repositories**
- Backend: Laravel/Symfony API
- Frontend: Next.js/Nuxt.js/React/Vue SPA
- Pros: Independent deploys, team autonomy, tech flexibility
- Cons: API versioning, CORS, more complex setup

## 4. Tech Stack
```
Backend:
  - Framework: [Laravel 12 / Symfony 7]
  - API: [REST / GraphQL (Lighthouse)]
  - ORM: [Eloquent / Doctrine]
  - Queue: [Redis Queue / RabbitMQ]

Frontend (if separate):
  - Framework: [Next.js 16 / Nuxt 4 / React / Vue 3]
  - State: [Context / Pinia / Zustand]
  - Styling: [Tailwind CSS]
  - Build: [Vite / Next/Nuxt built-in]

Frontend (if Monorepo):
  - Template: [Blade / Inertia.js]
  - Assets: [Vite]

Database:
  - Primary: [MySQL 8 / PostgreSQL 17 / MariaDB]
  - Cache: [Redis / Memcached]
  - Search: [Meilisearch / Elasticsearch] (if needed)

Infrastructure:
  - Hosting: [AWS / DigitalOcean / Hetzner / Forge]
  - Storage: [S3 / Local / DigitalOcean Spaces]
  - Auth: [Laravel Sanctum / Passport / JWT]
  - Queue Worker: [Horizon / Supervisor]
```

## 5. Core Components
Group by feature/domain (each component owns its data models and services):

**Component Structure:**
```
[ComponentName]/
  ├── Models/          # Eloquent models / Doctrine entities
  ├── Services/        # Business logic
  ├── Controllers/     # HTTP layer (Laravel) / Actions (Symfony)
  ├── Repositories/    # Data access (optional)
  ├── Events/          # Domain events
  ├── Listeners/       # Event handlers
  └── DTOs/           # Data transfer objects
```

**Example Components:**

**UserManagement**
- Models: User, Role, Permission
- Services: UserService, AuthService
- APIs:
  - POST /api/register
  - POST /api/login
  - GET /api/users/{id}
- Dependencies: EmailService, CacheService

**ProductCatalog**
- Models: Product, Category, Tag
- Services: ProductService, SearchService
- APIs:
  - GET /api/products
  - POST /api/products
  - GET /api/products/{slug}
- Dependencies: ImageService, CacheService

**OrderProcessing**
- Models: Order, OrderItem, Payment
- Services: OrderService, PaymentService, InventoryService
- APIs:
  - POST /api/orders
  - GET /api/orders/{id}
  - POST /api/orders/{id}/cancel
- Dependencies: UserManagement, ProductCatalog, NotificationService

## 6. Data Models
Key entities grouped by component:

**UserManagement:**
```php
User
  - id, name, email, password, email_verified_at
  - hasMany: Orders
  - belongsToMany: Roles

Role
  - id, name, guard_name
  - belongsToMany: Users, Permissions
```

**ProductCatalog:**
```php
Product
  - id, name, slug, description, price, stock
  - belongsTo: Category
  - belongsToMany: Tags

Category
  - id, name, slug, parent_id
  - hasMany: Products
```

**OrderProcessing:**
```php
Order
  - id, user_id, total, status, created_at
  - belongsTo: User
  - hasMany: OrderItems

OrderItem
  - id, order_id, product_id, quantity, price
  - belongsTo: Order, Product
```

**Database Indexes:**
- users: email (unique), email_verified_at
- products: slug (unique), category_id, (name, description) fulltext
- orders: user_id, status, created_at
- order_items: order_id, product_id

## 7. Key Flows
Describe top critical flows with component interactions:

**Example 1: User Registration (UserManagement)**
```
Client → POST /api/register
  → UserService validates input
  → Create User model
  → Dispatch UserRegistered event
  → EmailService sends verification
  → Return JWT token
```

**Example 2: Place Order (OrderProcessing + ProductCatalog + UserManagement)**
```
Client → POST /api/orders
  → OrderService validates cart
  → ProductService checks stock (ProductCatalog)
  → Begin DB transaction
  → Create Order + OrderItems
  → InventoryService decreases stock
  → PaymentService processes payment
  → Commit transaction
  → Dispatch OrderCreated event
  → NotificationService sends confirmation
  → Return order details
```

**Example 3: Product Search (ProductCatalog)**
```
Client → GET /api/products?search=laptop
  → Check Redis cache
  → If miss: SearchService queries DB/Meilisearch
  → ProductService formats results
  → Cache for 5 minutes
  → Return paginated products
```

## 8. Performance & Security

**Performance:**
- **Caching**:
  - Redis: User sessions, API responses, query results
  - Laravel cache: Config, routes, views (php artisan optimize)
  - HTTP: ETags, browser caching for static assets
- **Database**:
  - Eager loading (with() to avoid N+1)
  - Query optimization with indexes
  - Chunk large datasets
- **Queue Jobs**:
  - Email sending, image processing, reports
  - Use Horizon for monitoring
- **CDN**: Static assets, images via S3/Cloudflare

**Security:**
- **Auth**:
  - Laravel Sanctum (SPA) / Passport (OAuth2) / JWT
  - CSRF protection for Blade forms
  - Rate limiting on auth endpoints
- **Input Validation**:
  - Form Requests (Laravel) / Constraints (Symfony)
  - Sanitize user input
- **Authorization**:
  - Gates & Policies (Laravel) / Voters (Symfony)
  - Role-based access control (Spatie Permission)
- **Protection**:
  - SQL injection: Use Eloquent/Query Builder, never raw SQL with user input
  - XSS: Blade {{ }} auto-escapes, use {!! !!} carefully
  - CORS: Configure allowed origins for API
- **Environment**:
  - .env for secrets, never commit
  - Use a secrets manager in production (HashiCorp Vault, AWS Secrets Manager, Symfony Secrets)

## 9. Deployment
```
Development: localhost + local DB
Staging: [staging URL] + test DB
Production: [prod URL] + prod DB

CI/CD: GitHub Actions / Vercel Auto-deploy
Environment vars: .env.local → deployment platform
```

## 10. Key Decisions
Quick notes on important choices:
- **[Decision]**: Why we chose X over Y
- **[Trade-off]**: What we gain/lose

Keep it practical. Focus on what a developer needs to start building.
