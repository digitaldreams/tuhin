# Code Review — Document Template

# Code Review: <task-id>

**Reviewed**: [Date]
**Reviewer**: Automated Review
**Status**: [✅ Approved | ⚠️ Needs Changes | ❌ Rejected]

---

## Task Summary

**Epic**: [Epic Name]
**Description**: [What was required]

**Acceptance Criteria**:
- [ ] [Criterion 1]
- [ ] [Criterion 2]

---

## Acceptance Criteria Check

### ✅ Met Criteria

**1. [Criterion]**
- Implementation: [How it was done]
- Location: [File/line]

**2. [Criterion]**
- Implementation: [How it was done]
- Location: [File/line]

### ❌ Unmet Criteria

**1. [Criterion]**
- Status: Not implemented / Partially implemented
- Impact: [What functionality is missing]
- Action: [What needs to be added]

### ⚠️ Partially Met

**1. [Criterion]**
- What works: [Describe]
- What's missing: [Describe]
- Recommendation: [How to complete]

---

## Code Quality Analysis

### 🔴 Critical Issues (Must Fix)

#### Issue 1: [Issue Title]
**Severity**: Critical
**File**: `path/to/file.php` (Line X)

**Problem**:
```php
// Current code
public function store(Request $request)
{
    User::create($request->all());
}
```

**Issue**: Mass assignment vulnerability - allows any field to be set.

**Fix**:
```php
// Use Form Request validation
public function store(StoreUserRequest $request)
{
    User::create($request->validated());
}

// In StoreUserRequest
public function rules(): array
{
    return [
        'name' => 'required|string|max:255',
        'email' => 'required|email|unique:users',
    ];
}
```

**Why**: Prevents attackers from setting unauthorized fields like `is_admin`.

---

#### Issue 2: [Issue Title]
[Same format...]

---

### 🟠 Important Issues (Should Fix)

#### Issue 1: N+1 Query Problem
**File**: `app/Http/Controllers/PostController.php` (Line 23)

**Problem**:
```php
public function index()
{
    $posts = Post::all();
    return view('posts.index', compact('posts'));
}

// In Blade:
@foreach($posts as $post)
    {{ $post->user->name }}  <!-- Triggers query per post -->
@endforeach
```

**Impact**: 100 posts = 101 queries (1 for posts + 100 for users)

**Fix**:
```php
public function index()
{
    $posts = Post::with('user')->get();
    return view('posts.index', compact('posts'));
}
```

**Result**: 100 posts = 2 queries (1 for posts + 1 for all users)

---

#### Issue 2: Missing Authorization
**File**: `app/Http/Controllers/PostController.php` (Line 45)

**Problem**:
```php
public function update(Request $request, Post $post)
{
    $post->update($request->all());
}
```

**Issue**: Any authenticated user can update any post.

**Fix**:
```php
public function update(UpdatePostRequest $request, Post $post)
{
    $this->authorize('update', $post);
    $post->update($request->validated());
}

// Create Policy
php artisan make:policy PostPolicy --model=Post

// In PostPolicy
public function update(User $user, Post $post): bool
{
    return $user->id === $post->user_id;
}
```

---

### 🟡 Code Quality Issues (Good to Fix)

#### Issue 1: Missing API Resource
**File**: `app/Http/Controllers/Api/UserController.php`

**Current**:
```php
public function show(User $user)
{
    return response()->json($user);
}
```

**Issue**: Exposes all model attributes including timestamps, internal IDs.

**Better**:
```php
public function show(User $user)
{
    return new UserResource($user);
}

// Create Resource
php artisan make:resource UserResource

// In UserResource
public function toArray($request): array
{
    return [
        'id' => $this->id,
        'name' => $this->name,
        'email' => $this->email,
    ];
}
```

---

#### Issue 2: Validation Rules as Strings
**File**: `app/Http/Requests/StorePostRequest.php`

**Current**:
```php
public function rules(): array
{
    return [
        'title' => 'required|string|max:255',
    ];
}
```

**Better** (Laravel 13 style):
```php
public function rules(): array
{
    return [
        'title' => ['required', 'string', 'max:255'],
        'content' => ['required', 'string'],
        'status' => ['required', 'in:draft,published'],
    ];
}
```

**Why**: Array format is easier to read, modify, and add conditional rules.

---

### 🟢 Minor Suggestions (Optional)

#### Suggestion 1: Extract Query to Scope
**File**: `app/Http/Controllers/PostController.php`

**Current**:
```php
$posts = Post::where('status', 'published')
    ->where('published_at', '<=', now())
    ->orderBy('published_at', 'desc')
    ->get();
```

**Better**:
```php
// In Post model
public function scopePublished($query)
{
    return $query->where('status', 'published')
        ->where('published_at', '<=', now())
        ->orderBy('published_at', 'desc');
}

// In controller
$posts = Post::published()->get();
```

**Benefit**: Reusable, testable, cleaner controller.

---

## Security Check

### ✅ Secure Practices Found
- Using FormRequest validation
- CSRF protection enabled
- Password hashing with bcrypt
- API routes protected with Sanctum

### ⚠️ Security Concerns

**1. File Upload Without Validation**
**File**: `app/Http/Controllers/UploadController.php`

**Issue**:
```php
public function upload(Request $request)
{
    $path = $request->file('file')->store('uploads');
}
```

**Risk**: User can upload PHP scripts, execute code.

**Fix**:
```php
public function upload(Request $request)
{
    $request->validate([
        'file' => 'required|file|mimes:jpg,png,pdf|max:2048',
    ]);

    $filename = Str::uuid() . '.' . $request->file('file')->extension();
    $path = $request->file('file')->storeAs('uploads', $filename, 'private');
}
```

---

## Performance Check

### ⚡ Optimization Opportunities

**1. Add Database Indexes**
**File**: `database/migrations/xxxx_create_posts_table.php`

**Current**: No indexes on frequently queried columns.

**Add**:
```php
$table->index('user_id');
$table->index(['status', 'published_at']);
$table->index('created_at');
```

**Impact**: Faster queries on large datasets.

---

**2. Implement Caching**
**File**: `app/Http/Controllers/PostController.php`

**Current**: Database hit on every request.

**Add**:
```php
use Illuminate\Support\Facades\Cache;

public function index()
{
    $posts = Cache::remember('posts.published', 3600, function () {
        return Post::published()->with('user')->get();
    });

    return PostResource::collection($posts);
}

// Clear cache when posts change
protected static function booted()
{
    static::created(fn() => Cache::forget('posts.published'));
    static::updated(fn() => Cache::forget('posts.published'));
}
```

---

## Testing Status

### ✅ Tests Found
- `tests/Feature/PostControllerTest.php` (5 tests)
- `tests/Unit/PostModelTest.php` (3 tests)

### ❌ Missing Tests

**1. Update Post Authorization**
No test verifying users can't update others' posts.

**Add**:
```php
public function test_user_cannot_update_others_post()
{
    $user = User::factory()->create();
    $otherUser = User::factory()->create();
    $post = Post::factory()->for($otherUser)->create();

    $response = $this->actingAs($user)
        ->putJson("/api/posts/{$post->id}", [
            'title' => 'Updated',
        ]);

    $response->assertForbidden();
}
```

**2. Input Validation Test**
No test for required fields validation.

**Add**:
```php
public function test_title_is_required()
{
    $user = User::factory()->create();

    $response = $this->actingAs($user)
        ->postJson('/api/posts', [
            'content' => 'Content',
        ]);

    $response->assertStatus(422)
        ->assertJsonValidationErrors('title');
}
```

---

## Documentation

### ✅ Well Documented
- Clear method names
- Type hints present
- Return types specified

### ⚠️ Missing Documentation

**1. No PHPDoc Blocks**
**File**: Multiple controllers

**Add**:
```php
/**
 * Display a listing of published posts.
 *
 * @return \Illuminate\Http\Resources\Json\AnonymousResourceCollection
 */
public function index()
{
    // ...
}
```

**2. No API Documentation**
Consider adding OpenAPI/Swagger docs:
```bash
composer require darkaonline/l5-swagger
php artisan l5-swagger:generate
```

---

## What Works Well

### ✅ Good Practices Observed

**1. Clean Controller Structure**
Controllers are slim, delegate to services/models appropriately.

**2. Consistent Naming**
Variable names, methods, and classes follow Laravel conventions.

**3. Proper Use of Resources**
API responses use Resource classes for consistent formatting.

**4. Database Migrations**
Well-structured migrations with proper field types and relationships.

---

## Summary

### Overall Assessment
**Status**: ⚠️ Needs Changes

**Strengths**:
- Core functionality works as expected
- Code structure follows Laravel conventions
- Basic validation in place

**Weaknesses**:
- Critical security issue (mass assignment)
- Performance concern (N+1 queries)
- Missing authorization checks
- Test coverage incomplete

**Recommendation**: Address critical and important issues before deployment.

---

## Action Items

**Priority 1 (Before Merge)**:
1. Fix mass assignment vulnerability in UserController
2. Add eager loading to prevent N+1 queries
3. Implement authorization checks for update/delete

**Priority 2 (This Sprint)**:
4. Add file upload validation
5. Create missing Policy classes
6. Add database indexes
7. Write authorization tests

**Priority 3 (Technical Debt)**:
8. Convert validation rules to array format
9. Add PHPDoc blocks
10. Implement caching strategy
11. Extract queries to model scopes

---

## Estimated Rework Time
**Critical fixes**: 2-3 hours
**All Priority 1-2 items**: 1 day
**Complete polish**: 2 days

---

## Notes

Remember to:
- Run `php artisan test` after fixes
- Check for new N+1 queries with Laravel Debugbar
- Update `.env.example` if new config added
- Test on staging before production deploy

---

Be constructive and educational. Focus on helping developers improve, not criticizing them.
For each issue, explain WHY it matters and HOW to fix it.
Reference Laravel docs when relevant.
Prioritize issues by severity: Critical → Important → Quality → Minor.
