# Laravel Security Audit — Playbook & Report Template

# Laravel Security Audit Report

**Generated**: [Date]
**Laravel Version**: [Detect from composer.json]
**Scan Scope**: Configuration, Routes, Controllers, Models, Middleware, Views

---

## Executive Summary

**Total Issues Found**: [Count]
- 🔴 Critical: [Count]
- 🟠 High: [Count]
- 🟡 Medium: [Count]
- 🟢 Low: [Count]

**Top Risks**:
1. [Most critical issue found]
2. [Second critical issue]
3. [Third critical issue]

---

## Scan Instructions

Analyze these areas of the Laravel application:

### 1. Environment & Configuration

**Check**:
- `.env` file (if accessible, check for exposed secrets)
- `config/app.php` - APP_DEBUG, APP_ENV
- `config/cors.php` - CORS configuration
- `config/session.php` - Session security
- `config/sanctum.php` - API authentication
- `config/database.php` - Database credentials

**Look for**:
- `APP_DEBUG=true` in production
- Weak `APP_KEY`
- Missing `SESSION_SECURE_COOKIE` in production
- Overly permissive CORS settings
- Hardcoded credentials
- Exposed API keys

**Report format**:
```
### ❌ Issue: APP_DEBUG Enabled in Production
**Severity**: 🔴 Critical
**File**: `.env` or `config/app.php`
**Current**:
```
APP_DEBUG=true
```

**Risk**:
Exposes sensitive information (stack traces, database queries, environment variables) to users. Attackers can use this to understand your application structure.

**Fix**:
```
APP_DEBUG=false
APP_ENV=production
```

**Why**: Production environments must never expose debug information.
```

---

### 2. Routes Security

**Scan**: `routes/web.php`, `routes/api.php`

**Check for**:
- Unauthenticated admin routes
- Missing CSRF protection on web routes
- Missing authentication middleware
- API routes without rate limiting
- Publicly accessible sensitive endpoints

**Look for patterns like**:
```php
// ❌ Bad: Admin route without auth
Route::get('/admin/users', [AdminController::class, 'index']);

// ❌ Bad: No rate limiting on API
Route::post('/api/login', [AuthController::class, 'login']);

// ❌ Bad: Sensitive action without middleware
Route::delete('/users/{id}', [UserController::class, 'destroy']);
```

**Report format**:
```
### ❌ Issue: Unprotected Admin Routes
**Severity**: 🔴 Critical
**File**: `routes/web.php` (Line 45)
**Current Code**:
```php
Route::get('/admin/users', [AdminController::class, 'index']);
Route::post('/admin/users/{id}/delete', [AdminController::class, 'destroy']);
```

**Risk**:
Anyone can access admin functionality without authentication. This allows unauthorized users to view/modify/delete user accounts.

**Fix**:
```php
Route::middleware(['auth', 'admin'])->prefix('admin')->group(function () {
    Route::get('/users', [AdminController::class, 'index']);
    Route::delete('/users/{id}', [AdminController::class, 'destroy']);
});
```

**Additional**:
- Create admin middleware: `php artisan make:middleware AdminMiddleware`
- Add policy checks: `$this->authorize('viewAny', User::class);`
```

---

### 3. Controllers

**Scan**: `app/Http/Controllers/**/*.php`

**Check for**:
- Missing validation
- Missing authorization checks
- Raw SQL queries (SQL injection risk)
- Mass assignment vulnerabilities
- Direct file uploads without validation
- Returning sensitive data

**Look for patterns like**:
```php
// ❌ Bad: No validation
public function store(Request $request) {
    User::create($request->all());
}

// ❌ Bad: No authorization
public function update(Request $request, Post $post) {
    $post->update($request->all());
}

// ❌ Bad: SQL injection
public function search(Request $request) {
    DB::select("SELECT * FROM users WHERE name = '{$request->query}'");
}

// ❌ Bad: Exposing sensitive data
public function show(User $user) {
    return response()->json($user);  // Includes password hash
}
```

**Report format**:
```
### ❌ Issue: Missing Input Validation
**Severity**: 🟠 High
**File**: `app/Http/Controllers/PostController.php` (Line 23-27)
**Current Code**:
```php
public function store(Request $request)
{
    $post = Post::create($request->all());
    return response()->json($post, 201);
}
```

**Risk**:
Unvalidated input can lead to:
- Invalid data in database
- Application crashes
- Security vulnerabilities (XSS, injection)
- Mass assignment issues

**Fix**:
```php
public function store(StorePostRequest $request)
{
    $post = Post::create($request->validated());
    return response()->json($post, 201);
}
```

**Create Form Request**:
```bash
php artisan make:request StorePostRequest
```

```php
// app/Http/Requests/StorePostRequest.php
public function rules(): array
{
    return [
        'title' => 'required|string|max:255',
        'content' => 'required|string',
        'status' => 'in:draft,published',
    ];
}
```
```

---

### 4. Models

**Scan**: `app/Models/**/*.php`

**Check for**:
- Missing `$fillable` or `$guarded` (mass assignment)
- Sensitive attributes not in `$hidden`
- Missing password hashing
- No soft deletes on user data
- Relationships without constraints

**Look for patterns like**:
```php
// ❌ Bad: No fillable/guarded
class User extends Model {
    // Anyone can mass-assign any field
}

// ❌ Bad: Password visible in JSON
class User extends Model {
    protected $fillable = ['name', 'email', 'password'];
}

// ❌ Bad: No password hashing
class User extends Model {
    protected $fillable = ['password'];
}
```

**Report format**:
```
### ❌ Issue: Mass Assignment Vulnerability
**Severity**: 🔴 Critical
**File**: `app/Models/User.php` (Line 10)
**Current Code**:
```php
class User extends Authenticatable
{
    use HasFactory, Notifiable;

    // No $fillable or $guarded defined
}
```

**Risk**:
Attackers can inject additional fields in requests to modify protected attributes like `is_admin`, `role`, `email_verified_at`.

Example attack:
```javascript
fetch('/api/users', {
  body: JSON.stringify({
    name: 'John',
    email: 'john@example.com',
    is_admin: true  // ← Attacker adds this
  })
})
```

**Fix**:
```php
class User extends Authenticatable
{
    use HasFactory, Notifiable;

    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }
}
```
```

---

### 5. Authentication & Authorization

**Check for**:
- Weak password requirements
- Missing email verification
- No rate limiting on login
- Missing policies
- No authorization checks in controllers

**Scan**:
- `app/Http/Controllers/Auth/**/*.php`
- `app/Policies/**/*.php`
- `app/Providers/AuthServiceProvider.php`

**Report format**:
```
### ❌ Issue: Weak Password Requirements
**Severity**: 🟠 High
**File**: `app/Http/Requests/Auth/RegisterRequest.php` (Line 15)
**Current Code**:
```php
public function rules(): array
{
    return [
        'password' => 'required|min:6|confirmed',
    ];
}
```

**Risk**:
Weak passwords are easily brute-forced. 6-character passwords can be cracked in minutes.

**Fix**:
```php
use Illuminate\Validation\Rules\Password;

public function rules(): array
{
    return [
        'name' => 'required|string|max:255',
        'email' => 'required|email|max:255|unique:users',
        'password' => [
            'required',
            'confirmed',
            Password::min(12)
                ->letters()
                ->mixedCase()
                ->numbers()
                ->symbols()
                ->uncompromised()
        ],
    ];
}
```

**Why**:
- Min 12 characters (industry standard)
- Mixed case letters
- Numbers and symbols
- Check against leaked password databases
```

---

### 6. Database & Migrations

**Scan**: `database/migrations/**/*.php`

**Check for**:
- Missing indexes on foreign keys
- No unique constraints on emails
- Plain text password fields
- Missing soft deletes on user data
- No timestamps

**Report format**:
```
### ❌ Issue: Missing Index on Foreign Key
**Severity**: 🟡 Medium
**File**: `database/migrations/xxxx_create_posts_table.php` (Line 18)
**Current Code**:
```php
Schema::create('posts', function (Blueprint $table) {
    $table->id();
    $table->unsignedBigInteger('user_id');
    $table->string('title');
    $table->text('content');
    $table->timestamps();
});
```

**Risk**:
Poor query performance when fetching user's posts. Without index, database does full table scan.

**Fix**:
```php
Schema::create('posts', function (Blueprint $table) {
    $table->id();
    $table->foreignId('user_id')->constrained()->cascadeOnDelete();
    $table->string('title');
    $table->text('content');
    $table->timestamps();

    // Add indexes for common queries
    $table->index(['user_id', 'created_at']);
});
```

**Performance Impact**:
Queries on 1M+ records: 5000ms → 50ms with index.
```

---

### 7. Middleware

**Scan**: `app/Http/Middleware/**/*.php`

**Check for**:
- Custom auth middleware instead of Laravel's
- Missing CSRF verification
- Improper role checking
- No rate limiting

**Report format**:
```
### ⚠️ Issue: Custom Authentication Middleware
**Severity**: 🟡 Medium
**File**: `app/Http/Middleware/CheckAuth.php`
**Current Code**:
```php
public function handle($request, Closure $next)
{
    if (!session('user_id')) {
        return redirect('/login');
    }
    return $next($request);
}
```

**Risk**:
Reinventing authentication is error-prone. Laravel's built-in auth is battle-tested.

**Fix**:
Remove custom middleware and use Laravel's:
```php
// In routes/web.php
Route::middleware('auth')->group(function () {
    Route::get('/dashboard', [DashboardController::class, 'index']);
});
```

**Delete**: `app/Http/Middleware/CheckAuth.php`
```

---

### 8. Views (Blade Templates)

**Scan**: `resources/views/**/*.blade.php`

**Check for**:
- Raw output `{!! !!}` with user input
- Missing `@csrf` in forms
- JavaScript XSS vulnerabilities
- Exposed sensitive data

**Look for patterns**:
```blade
{{-- ❌ Bad: Raw user input --}}
{!! $user->bio !!}

{{-- ❌ Bad: Missing CSRF --}}
<form method="POST" action="/update">
    <input name="name">
</form>

{{-- ❌ Bad: Inline script with user data --}}
<script>
    var userName = "{{ $user->name }}";
</script>
```

**Report format**:
```
### ❌ Issue: XSS Vulnerability via Raw Output
**Severity**: 🟠 High
**File**: `resources/views/profile/show.blade.php` (Line 34)
**Current Code**:
```blade
<div class="bio">
    {!! $user->bio !!}
</div>
```

**Risk**:
If user sets bio to `<script>alert('XSS')</script>`, it executes in other users' browsers.

Attackers can:
- Steal session cookies
- Redirect to phishing sites
- Deface the page

**Fix**:
```blade
<div class="bio">
    {{ $user->bio }}
</div>
```

Or if HTML is needed:
```blade
<div class="bio">
    {!! Purifier::clean($user->bio) !!}
</div>
```

Install HTML Purifier:
```bash
composer require mews/purifier
```
```

---

### 9. API Security

**Check**:
- Rate limiting configuration
- API authentication
- CORS settings
- Input validation on API routes

**Report format**:
```
### ❌ Issue: Missing Rate Limiting on API
**Severity**: 🟠 High
**File**: `routes/api.php` (Line 20-25)
**Current Code**:
```php
Route::post('/api/login', [AuthController::class, 'login']);
Route::post('/api/register', [AuthController::class, 'register']);
```

**Risk**:
Brute force attacks on login endpoint. Attackers can try thousands of passwords per minute.

**Fix**:
```php
Route::middleware('throttle:5,1')->group(function () {
    Route::post('/api/login', [AuthController::class, 'login']);
    Route::post('/api/register', [AuthController::class, 'register']);
});

// Allow only 5 attempts per minute per IP
```

**Custom Rate Limit** (if needed):
```php
// app/Providers/RouteServiceProvider.php
RateLimiter::for('auth', function (Request $request) {
    return Limit::perMinute(5)->by($request->ip());
});
```
```

---

### 10. File Uploads

**Scan**: Controllers with file upload logic

**Check for**:
- Missing MIME type validation
- No file size limits
- Storing in public directory
- Predictable filenames

**Report format**:
```
### ❌ Issue: Insecure File Upload
**Severity**: 🔴 Critical
**File**: `app/Http/Controllers/UploadController.php` (Line 12)
**Current Code**:
```php
public function upload(Request $request)
{
    $file = $request->file('avatar');
    $path = $file->store('public/uploads');
    return response()->json(['path' => $path]);
}
```

**Risk**:
Attackers can upload:
- PHP scripts (code execution)
- Malicious executables
- Large files (DoS)

**Fix**:
```php
public function upload(UploadRequest $request)
{
    $request->validate([
        'avatar' => 'required|file|mimes:jpg,png,jpeg|max:2048',
    ]);

    $filename = Str::uuid() . '.' . $request->file('avatar')->extension();

    $path = $request->file('avatar')->storeAs(
        'avatars',
        $filename,
        'private'  // Not publicly accessible
    );

    return response()->json(['path' => $path]);
}

// To serve file with auth check:
public function download($filename)
{
    $this->authorize('download', $filename);
    return Storage::disk('private')->download($filename);
}
```
```

---

## Automated Checks to Run

```bash
# 1. Check for known vulnerabilities
composer audit

# 3. Static analysis
composer require --dev larastan/larastan
./vendor/bin/phpstan analyse

# 4. Code style & security (Laravel Pint)
composer require --dev laravel/pint
./vendor/bin/pint --test

# 5. Check .env for exposed secrets
grep -r "password\|secret\|key" .env
```

---

## Priority Action Items

Based on severity, fix in this order:

### 🔴 Critical (Fix Immediately)
1. [List all critical issues found]
2. [With file references]

### 🟠 High (Fix This Week)
1. [List all high issues]
2. [With file references]

### 🟡 Medium (Fix This Sprint)
1. [List medium issues]

### 🟢 Low (Technical Debt)
1. [List low priority issues]

---

## Security Hardening Checklist

After fixing vulnerabilities, implement:

### Configuration
- [ ] APP_DEBUG=false in production
- [ ] Strong APP_KEY generated
- [ ] .env not in git (check .gitignore)
- [ ] HTTPS enforced
- [ ] Session cookies secure & httpOnly

### Authentication
- [ ] Password rules: min 12 chars, mixed case, numbers, symbols
- [ ] Email verification required
- [ ] Rate limiting on auth endpoints (5/min)
- [ ] Account lockout after failed attempts

### Authorization
- [ ] Policies for all models
- [ ] Authorization checks in all controllers
- [ ] Admin middleware on admin routes
- [ ] API authentication (Sanctum)

### Input Validation
- [ ] Form Requests on all POST/PUT endpoints
- [ ] Validation rules for all inputs
- [ ] File upload validation (MIME, size)

### Database
- [ ] Foreign key constraints
- [ ] Indexes on frequently queried columns
- [ ] Soft deletes on user data
- [ ] Encrypted sensitive fields

### Output Protection
- [ ] Use {{ }} not {!! !!} by default
- [ ] CSRF on all forms
- [ ] Sanitize HTML if raw output needed

### Logging & Monitoring
- [ ] Log failed login attempts
- [ ] Log admin actions
- [ ] Monitor for suspicious patterns
- [ ] Set up error tracking (Sentry)

---

## Next Steps

1. **Review this report** with the development team
2. **Prioritize fixes** based on severity
3. **Create tasks** for each issue in your task tracker
4. **Fix critical issues** immediately
5. **Re-run audit** after fixes
6. **Schedule regular audits** (monthly)

---

Scan the Laravel application thoroughly and provide specific, actionable security recommendations with file/line references.
