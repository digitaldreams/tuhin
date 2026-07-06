# tuhin

Tuhin Bepari's dev identity as a Claude Code plugin. It gives you three things:

- a **spec pipeline** — skills that turn one vague sentence into build-ready docs
- a **task workflow** — agents that plan, code, test, and open draft PRs (you merge)
- a **toolbox** — skills for daily work: debugging, audits, refactoring

This README is not a table of skills. It is a short story. We follow one imaginary
product — a **small online store** — from one sentence to production. Each skill does
its job and hands over to the next.

## Install

```
/plugin marketplace add digitaldreams/tuhin
/plugin install tuhin@tuhin-marketplace
```

Then, inside your Laravel project:

```
/tuhin:task-init
```

Non-destructive: your existing `tasks.md`, `docs/*`, and `AGENTS.md` content always wins.

**You need:**

- a Laravel app in a git repository
- `gh` CLI logged in (for draft PRs)
- `laravel/pint` + Pest (or PHPUnit) — the quality gates
- [Laravel Boost](https://github.com/laravel/boost) — the knowledge layer
  (`composer require laravel/boost --dev && php artisan boost:install`)
- optional: `phpstan/larastan` — used automatically as an extra gate

Boost knows your app (schema, routes, conventions). This plugin runs the workflow
(board, plans, worktrees, gates, PRs). No overlap.

---

## The pipeline

Someone gives you one sentence:

> "Customers should order our products online. Checkout should be simple.
> Never sell an item that is out of stock."

Create a `tasks/` folder in your Laravel project root — next to `app/`, `config/`,
and `routes/` — and save the sentence as `tasks/requirements.md`:

```
my-store/            # your Laravel app
├── app/
├── config/
├── routes/
└── tasks/
    └── requirements.md   # ← the pipeline starts here
```

Every skill in the pipeline reads and writes inside this `tasks/` folder.
Now watch what happens to that sentence.

Every step below is one command. (Plain words work too — saying
"design the architecture" runs the same skill.)

### 1. requirements

```console
> /tuhin:requirements
```

This skill is not polite to your document. It checks every line:

- "Checkout should be simple" — not testable. It gets rewritten into something a test can check.
- It finds what is missing: *What happens when payment fails? Who can cancel an order?*
- It asks **you** the top 3 blocking questions. It never answers them itself.
- Every requirement gets a MoSCoW tag: Must / Should / Could / Won't.

> Store example: "Never sell out-of-stock items" survives. "Simple checkout" becomes
> *"Guest checkout in 3 steps or less."*

Output: `requirement_analysis.md` — plus a rewritten spec you can paste back.

### 2. architecture

```console
> /tuhin:architecture
```

The big decisions. The skill recommends, **you** choose:

- Which ecosystem? (Laravel recommended, with reasons from your requirements)
- Which pattern? (Modular Monolith fits ~90% of projects)
- One repo or two? Blade, Inertia, or separate SPA?

Every answer is saved as a small decision record: context → options → choice →
trade-off. So six months later you still know *why*.

> Store example: Laravel modular monolith, vertical slices, Blade monorepo.

Output: `architecture.md`. Frozen. No skill after this re-argues it.

### 3. system-design

```console
> /tuhin:system-design
```

Architecture said what shape. This says **how it behaves**:

- what each component does, and what it exposes to others
- the key flows as numbered steps
- failure handling: what is retried, what rolls back, what the user sees
- which design patterns are used, and where (framework-first — Eloquent events before
  GoF Observer, and no `UserRepository` that just wraps `User::query()`)

> Store example: two customers buy the last item in the same second. This doc decides
> who wins, and what the loser sees.

Output: `system_design.md`. After this, two developers build the same feature the same way.

### 4. system-modeling

```console
> /tuhin:system-modeling
```

Draws the design. Never invents:

- sequence diagrams from the key flows
- a state diagram for anything with a lifecycle
- class diagram + conceptual ERD

> Store example: order lifecycle — `pending → paid → shipped → delivered`,
> with `cancelled` and `refunded` as exits.

Output: `system_model.md`.

### 5. api-contract

```console
> /tuhin:api-contract
```

Only when your architecture has an API (SPA or mobile client). It writes the contract
both sides build against **before any code exists**: endpoints, error format,
versioning. Every endpoint must trace back to a requirement.

> Blade monorepo with no API? Skip this step. The pipeline doesn't mind.

### 6. user-journey-map

```console
> /tuhin:user-journey-map
```

Nothing is built yet — so this skill is honest about it:

- first, how customers order **today** (WhatsApp messages, phone calls) — that pain is real
- then the flows you are designing — where friction is *predicted*, never "measured"
- every step names its **screen**; failure steps included (payment declined, empty cart)

> No fake numbers. "40% abandon here" is impossible — nothing exists to abandon yet.

Output: `user_journeys.md`, ending with a list of every screen and its states.

### 7. information-architecture

```console
> /tuhin:information-architecture
```

Every journey step gets a home:

- sitemap and URL rules
- page inventory: purpose, content blocks, states (empty / loading / error)
- access matrix: guest, customer, admin
- orphan check both ways: a step with no page, a page with no step — both flagged

> Store example: `/orders/{id}` is customer-only, owner-only. The admin order list
> lives somewhere else.

Output: `information_architecture.md`.

### 8. wireframe

```console
> /tuhin:wireframe checkout
```

One page at a time, as ASCII layout:

- desktop + mobile (tablet only if it is really different)
- every state the IA listed — the empty cart, the out-of-stock product page
- global header/nav drawn **once** in the IA, only referenced here
- structure only: no colors, no pixels

Output: `wireframes/<page>.md`.

### 9. design-system

```console
> /tuhin:design-system
```

Counts before it decides:

- how many forms, tables, card types the wireframes really contain — that many patterns, no more
- a palette picked for **this** store, with a reason — never default-blue
- `@theme` tokens, component states, dark mode, accessibility rules

Output: `design_system.md`.

### 10. task-breakdown

```console
> /tuhin:task-breakdown
```

The last translation. Docs become work:

- epics = the components from architecture
- tasks = vertical slices: one visible behavior each (migration + model + page + test), one sitting in size
- tests live **inside** each task's acceptance criteria — never a separate "write tests" task
- traceability: every Must-have has a task; every task has a source

Output: `epics.md`.

## The workflow

`epics.md` is not the board. The **task-manager** agent (the only writer of
`tasks.md`) converts it into board tasks. Then the **task-workflow** loop runs:

```console
> /tuhin:task-next          # claim next task, plan, implement
> /tuhin:task-status        # see the board
> /tuhin:task-review TASK-3 # re-run review on a task's PR
```

1. `/tuhin:task-next` — an agent claims a task and writes a plan
2. it **stops and waits for your approval**
3. approved → isolated git worktree → implementation
4. gates: Pint, Pest, PHPStan — before every commit
5. draft PR → `review` skill gives a PASS/FAIL verdict, anchored to diff lines
6. **you merge. Always.**

Statuses: `todo → planning → plan-review → doing → review → done`, or `blocked`
after two failed fix cycles.

Hands-off, when you trust it:

```
/loop 15m /tuhin:task-next                                      # in-session
*/30 * * * * cd /path/to/app && claude -p "/tuhin:task-next"    # cron
```

## While you build

Daily-life skills, in the moment you need them.

**understand** — build a mental model of a module first. Read-only. No fixes.

```console
> /tuhin:understand app/Modules/Order
```

**blast-radius** — before you touch shared code: what breaks, ranked options, no edits.

```console
> /tuhin:blast-radius safe to delete OrderService::recalculate()?
```

**code-standards** — ~30 numbered rules (CS-1…CS-30). Agents read them before
writing code; reviewers cite them by number.

```console
> /tuhin:code-standards
```

**vsa** — which slice does this class belong in? And audits for cross-slice leaks.

```console
> /tuhin:vsa where does the RefundRequested event belong?
```

**log-analyzer** — reads `laravel.log` to a root cause, not a guess.

```console
> /tuhin:log-analyzer customers report a 500 on checkout since morning
```

**red-first** — bug fixing with proof: failing test first, red, then fix, then green.

```console
> /tuhin:red-first order total is wrong after a partial refund
```

**readability-sweep** — deletes narrating comments, extracts intent-named methods,
challenges bad names.

```console
> /tuhin:readability-sweep app/Modules/Catalog
```

## Before you ship

Four auditors. None of them polite.

**quality-audit** — the veteran tester. Buys the last item from two browsers at the
same second. Double-clicks every button. Replays every state change twice. Findings
ranked *mandatory* vs *optional*, top ones proven with failing tests.

```console
> /tuhin:quality-audit checkout
```

**security-audit** — the attacker with your source code. Can customer A open
customer B's order? Which route skipped its policy? What does `composer audit` say?

```console
> /tuhin:security-audit
```

**performance-audit** — N+1 queries, missing indexes, work that belongs in a queue.

```console
> /tuhin:performance-audit
```

**manual-test-cases** — click-paths a shop owner can follow word by word. Every
button label real, every test entity confirmed in the seeders, a PASS/FAIL line per case.

```console
> /tuhin:manual-test-cases orders
```

Then **deployment** writes a release procedure so boring nothing can surprise you:

```console
> /tuhin:deployment
```

- env diff (placeholders, never real secrets)
- migration safety — destructive changes ship in two releases
- zero-downtime sequence, `queue:restart` included
- smoke checks + a watch window
- rollback plan with its trigger decided **before** the deploy

> The rule: if rollback is not written down, the deploy does not happen.

## The crown: the tuhin agent

Everything above is a skill you call. The **tuhin agent** is the one who calls them.

It is a digital twin of Tuhin Bepari — an implementation agent that works the way he
works. Give it any task — implement, extend, refactor, fix — and it follows the same
reflexes the skills codify:

- it **understands first** — reads the code before planning anything (`understand`)
- it **maps the blast radius** before touching shared code (`blast-radius`)
- it writes to the **code standards** and places classes by the **vsa** rules
- a bug report starts with a **failing regression test**, never a blind fix (`red-first`)
- it delivers in **small reviewable parts**, runs the tests before and after every change
- and it **never over-builds** — no speculative abstractions, no "for later" scaffolding

```console
> use the tuhin agent: customers want a wishlist — add it to the store
```

And it can drive the whole pipeline from one sentence. This request walks the SDLC
skills in order — requirements analysis, architecture (it will stop and ask you the
big decisions), system design, modeling, and the task breakdown:

```console
> use the tuhin agent: I dropped a rough spec in tasks/requirements.md —
  take it from analysis to a ready task board
```

Each skill in this repo makes the agent stronger: the pipeline docs give it frozen
decisions to respect, the standards give it rules to follow, the audits check its
work. The skills are the playbook. The agent is the player.

## The team

The tuhin agent is not alone. The plugin ships a complete agent team for the Laravel
ecosystem — each one with a single job and a hard boundary:

- **task-manager** — the project manager. Decomposes features into tagged board
  tasks and keeps `tasks.md` honest. It is the **only** writer of the board, and it
  never writes application code.
- **task-backend** — the backend developer. Takes `[backend]` tasks: routes,
  controllers, Eloquent, migrations, jobs, Pest tests. Works only inside a task
  worktree, only on a plan you approved.
- **task-frontend** — the frontend developer. Takes `[frontend]` tasks: Blade,
  Livewire/Inertia, Vite, Tailwind, forms and validation UX. Same worktree, same
  approved-plan rule.
- **task-reviewer** — the reviewer. Runs the gates, reads the diff, posts findings
  as PR comments, returns PASS or FAIL. Read-only toward code — it reports, it never
  pushes fixes.

The boundaries are the design:

> One writer for the board. No agent-to-agent chat — communication is task statuses,
> plan comments, and PR reviews. Developers never review their own work. Reviewers
> never fix. And a human always merges.

Seed the board, run `/tuhin:task-next`, and the team plays its positions.

## Codex / Gemini CLI

`task-init` writes the same workflow rules into `AGENTS.md` and `GEMINI.md`.
Best-effort: no native subagents or hooks there — back the gates with CI.

## License

MIT
