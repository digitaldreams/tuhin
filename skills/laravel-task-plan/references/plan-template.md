# Implementation Plan — Document Template

# Implementation Plan: <task-id>

**Generated**: [Date]
**Epic**: [Epic Name]
**Complexity**: [Simple | Medium | Complex]
**Estimated Time**: [Hours]

---

## Task Overview

**What You're Building**:
[Clear description of what needs to be implemented]

**Acceptance Criteria**:
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

**Dependencies**:
- Prerequisites: [TASK-XXX must be completed first]
- Related: [TASK-YYY similar implementation]

---

## Architecture Context

**Project Structure**: [VSA / Layered / Modular Monolith]
**Code Location**: [Where files should go based on architecture]

**Example** (adapt based on actual architecture):
- VSA: `app/[Module]/Features/[Feature]/`
- Layered: `app/Http/Controllers/`, `app/Services/`, `app/Models/`
- Modular: `app/Modules/[Module]/Http/Controllers/`

---

## Files to Create

### 1. Database (if needed)

#### Migration
**File**: `database/migrations/YYYY_MM_DD_HHMMSS_create_[table]_table.php`

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('[table_name]', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->string('field_name');
            $table->text('description')->nullable();
            $table->enum('status', ['active', 'inactive'])->default('active');
            $table->timestamps();

            // Indexes for performance
            $table->index(['user_id', 'status']);
            $table->index('created_at');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('[table_name]');
    }
};
```

**Run**: `php artisan make:migration create_[table]_table`

#### Model (if new)
**File**: `app/Models/[ModelName].php`

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class [ModelName] extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'user_id',
        'field_name',
        'description',
        'status',
    ];

    protected function casts(): array
    {
        return [
            'created_at' => 'datetime',
        ];
    }

    // Relationships
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // Scopes (if needed)
    public function scopeActive($query)
    {
        return $query->where('status', 'active');
    }
}
```

---

### 2. Controller

**File**: [Location based on architecture]

**For Simple Tasks** (REST resource):
```php
<?php

namespace App\Http\Controllers;

use App\Http\Requests\Store[Resource]Request;
use App\Http\Resources\[Resource]Resource;
use App\Models\[Model];

class [Resource]Controller extends Controller
{
    public function index()
    {
        $items = [Model]::query()
            ->with('relationships')  // Prevent N+1
            ->when(request('status'), fn($q, $status) => $q->where('status', $status))
            ->paginate(15);

        return [Resource]Resource::collection($items);
    }

    public function store(Store[Resource]Request $request)
    {
        $item = [Model]::create($request->validated());

        return new [Resource]Resource($item);
    }

    public function show([Model] $item)
    {
        return new [Resource]Resource($item->load('relationships'));
    }

    public function update(Update[Resource]Request $request, [Model] $item)
    {
        $this->authorize('update', $item);

        $item->update($request->validated());

        return new [Resource]Resource($item);
    }

    public function destroy([Model] $item)
    {
        $this->authorize('delete', $item);

        $item->delete();

        return response()->json(['message' => 'Deleted successfully']);
    }
}
```

**For Complex Tasks** (with Service Layer):
```php
<?php

namespace App\Http\Controllers;

use App\Http\Requests\[Action]Request;
use App\Http\Resources\[Resource]Resource;
use App\Services\[Service];

class [Resource]Controller extends Controller
{
    public function __construct(
        private [Service] $service
    ) {}

    public function [action]([Action]Request $request)
    {
        $result = $this->service->[method]($request->validated());

        return new [Resource]Resource($result);
    }
}
```

**Artisan**: `php artisan make:controller [Resource]Controller --resource`

---

### 3. Form Request (Validation)

**File**: `app/Http/Requests/Store[Resource]Request.php`

```php
<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class Store[Resource]Request extends FormRequest
{
    public function authorize(): bool
    {
        return true; // Or check permissions
    }

    public function rules(): array
    {
        return [
            'field_name' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string'],
            'status' => ['required', 'in:active,inactive'],

            // For updates, make fields optional
            // 'field_name' => ['sometimes', 'required', 'string', 'max:255'],
        ];
    }

    public function messages(): array
    {
        return [
            'field_name.required' => 'The field name is required.',
        ];
    }
}
```

**Artisan**: `php artisan make:request Store[Resource]Request`

---

### 4. API Resource (Response Format)

**File**: `app/Http/Resources/[Resource]Resource.php`

```php
<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class [Resource]Resource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'field_name' => $this->field_name,
            'description' => $this->description,
            'status' => $this->status,

            // Include relationships when loaded
            'user' => $this->whenLoaded('user', fn() => [
                'id' => $this->user->id,
                'name' => $this->user->name,
            ]),

            'created_at' => $this->created_at?->toISOString(),

            // Don't expose: updated_at, deleted_at (unless needed)
        ];
    }
}
```

**Artisan**: `php artisan make:resource [Resource]Resource`

---

### 5. Service Layer (if complex logic)

**File**: `app/Services/[Service].php`

```php
<?php

namespace App\Services;

use App\Models\[Model];
use Illuminate\Support\Facades\DB;

class [Service]
{
    public function [method](array $data): [Model]
    {
        return DB::transaction(function () use ($data) {
            // Create main record
            $item = [Model]::create($data);

            // Perform additional operations
            // - Attach relationships
            // - Dispatch events
            // - Call external APIs

            // Event::dispatch(new [Event]($item));

            return $item;
        });
    }
}
```

**When to use Service Layer**:
- Multiple database operations
- Business logic beyond CRUD
- External API calls
- Event dispatching
- Complex calculations

**When NOT to use**:
- Simple CRUD operations (keep in controller)
- Single database query
- No business logic

---

### 6. Policy (Authorization)

**File**: `app/Policies/[Model]Policy.php`

```php
<?php

namespace App\Policies;

use App\Models\[Model];
use App\Models\User;

class [Model]Policy
{
    public function viewAny(User $user): bool
    {
        return true;
    }

    public function view(User $user, [Model] $item): bool
    {
        return true; // Or check ownership
    }

    public function create(User $user): bool
    {
        return $user->email_verified_at !== null;
    }

    public function update(User $user, [Model] $item): bool
    {
        return $user->id === $item->user_id;
    }

    public function delete(User $user, [Model] $item): bool
    {
        return $user->id === $item->user_id;
    }
}
```

**Artisan**: `php artisan make:policy [Model]Policy --model=[Model]`

---

### 7. Routes

**File**: `routes/api.php`

```php
use App\Http\Controllers\[Resource]Controller;

// Public routes
Route::get('/[resources]', [[Resource]Controller::class, 'index']);
Route::get('/[resources]/{item}', [[Resource]Controller::class, 'show']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/[resources]', [[Resource]Controller::class, 'store']);
    Route::put('/[resources]/{item}', [[Resource]Controller::class, 'update']);
    Route::delete('/[resources]/{item}', [[Resource]Controller::class, 'destroy']);
});

// Or use resource route
Route::apiResource('[resources]', [Resource]Controller::class)
    ->middleware('auth:sanctum')
    ->except(['index', 'show']);
```

---

## Events & Listeners (if needed)

### When to Use Events:
- Cross-feature communication
- Logging user actions
- Sending notifications
- Updating related data

### Event
**File**: `app/Events/[Event].php`

```php
<?php

namespace App\Events;

use App\Models\[Model];
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class [Event]
{
    use Dispatchable, SerializesModels;

    public function __construct(
        public [Model] $item
    ) {}
}
```

### Listener
**File**: `app/Listeners/[Listener].php`

```php
<?php

namespace App\Listeners;

use App\Events\[Event];

class [Listener]
{
    public function handle([Event] $event): void
    {
        // Handle the event
        // Send email, update records, etc.
    }
}
```

**Register in**: `app/Providers/EventServiceProvider.php`
```php
protected $listen = [
    [Event]::class => [
        [Listener]::class,
    ],
];
```

**Artisan**:
```bash
php artisan make:event [Event]
php artisan make:listener [Listener] --event=[Event]
```

---

## Testing

### Feature Test
**File**: `tests/Feature/[Resource]ControllerTest.php`

```php
<?php

namespace Tests\Feature;

use App\Models\[Model];
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class [Resource]ControllerTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_list_resources()
    {
        [Model]::factory()->count(3)->create();

        $response = $this->getJson('/api/[resources]');

        $response->assertOk()
            ->assertJsonCount(3, 'data');
    }

    public function test_can_create_resource()
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)
            ->postJson('/api/[resources]', [
                'field_name' => 'Test',
                'status' => 'active',
            ]);

        $response->assertCreated()
            ->assertJsonPath('data.field_name', 'Test');

        $this->assertDatabaseHas('[table]', [
            'field_name' => 'Test',
        ]);
    }

    public function test_cannot_update_others_resource()
    {
        $owner = User::factory()->create();
        $other = User::factory()->create();
        $item = [Model]::factory()->for($owner)->create();

        $response = $this->actingAs($other)
            ->putJson("/api/[resources]/{$item->id}", [
                'field_name' => 'Updated',
            ]);

        $response->assertForbidden();
    }

    public function test_validation_fails_for_invalid_data()
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)
            ->postJson('/api/[resources]', [
                // Missing required fields
            ]);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['field_name']);
    }
}
```

**Run**: `php artisan test --filter [Resource]ControllerTest`

---

## Implementation Checklist

### Database
- [ ] Create migration
- [ ] Add indexes for performance
- [ ] Run migration: `php artisan migrate`
- [ ] Create/update model with $fillable and casts
- [ ] Define relationships
- [ ] Add scopes (if needed)

### API Layer
- [ ] Create controller
- [ ] Create Form Request for validation
- [ ] Create API Resource for responses
- [ ] Add routes to api.php
- [ ] Test routes: `php artisan route:list`

### Business Logic (if complex)
- [ ] Create service class
- [ ] Inject dependencies
- [ ] Use database transactions
- [ ] Dispatch events (if needed)

### Authorization
- [ ] Create policy
- [ ] Add authorization checks in controller
- [ ] Test with different user roles

### Testing
- [ ] Write feature tests for all endpoints
- [ ] Test authentication/authorization
- [ ] Test validation errors
- [ ] Test N+1 queries with Debugbar
- [ ] Run: `php artisan test`

### Performance
- [ ] Add eager loading for relationships
- [ ] Check for N+1 queries
- [ ] Add database indexes
- [ ] Consider caching (if needed)

### Documentation
- [ ] Add PHPDoc blocks
- [ ] Update API documentation
- [ ] Add comments for complex logic

---

## Common Pitfalls & Solutions

### N+1 Query Problem
```php
// ❌ Bad (1 + N queries)
$items = [Model]::all();
foreach ($items as $item) {
    echo $item->user->name;  // Query per item
}

// ✅ Good (2 queries)
$items = [Model]::with('user')->get();
foreach ($items as $item) {
    echo $item->user->name;
}
```

### Mass Assignment Vulnerability
```php
// ❌ Dangerous
[Model]::create($request->all());

// ✅ Safe
[Model]::create($request->validated());
```

### Missing Authorization
```php
// ❌ Anyone can update
public function update(Request $request, [Model] $item)
{
    $item->update($request->validated());
}

// ✅ Check ownership
public function update(Request $request, [Model] $item)
{
    $this->authorize('update', $item);
    $item->update($request->validated());
}
```

### Resource Property Access
```php
// ❌ Wrong (can break)
public function toArray($request): array
{
    return [
        'id' => $this->id,  // Wrong
    ];
}

// ✅ Correct
public function toArray($request): array
{
    return [
        'id' => $this->resource->id,  // Or just $this->id works in simple cases
    ];
}
```

---

## Artisan Commands Summary

```bash
# Generate files
php artisan make:migration create_[table]_table
php artisan make:model [Model] -mfsc  # Model, migration, factory, seeder, controller
php artisan make:controller [Resource]Controller --resource
php artisan make:request Store[Resource]Request
php artisan make:resource [Resource]Resource
php artisan make:policy [Model]Policy --model=[Model]
php artisan make:event [Event]
php artisan make:listener [Listener] --event=[Event]
php artisan make:service [Service]  # If custom command exists

# Run migrations
php artisan migrate
php artisan migrate:rollback

# Testing
php artisan test
php artisan test --filter [Test]

# Check routes
php artisan route:list
php artisan route:list --path=api/[resources]

# Verify policies
php artisan policy:show [Model]
```

---

## Next Steps

After completing this task:
1. Test all acceptance criteria manually
2. Run automated tests
3. Check for N+1 queries (Laravel Debugbar)
4. Review code for security issues
5. Update API documentation
6. Move to next task: [TASK-XXX]

---

## Questions/Clarifications Needed

[List any ambiguous requirements or design decisions that need confirmation]

---

Adapt this plan based on task complexity. Simple CRUD? Skip service layer and events. Complex workflow? Add more detail.
