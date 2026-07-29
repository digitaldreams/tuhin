# tuhin

Tuhin Bepari's dev identity as a Claude Code plugin. It gives you three things:

- a **spec pipeline** — skills that turn one vague sentence into build-ready docs
- a **task workflow** — write a paragraph in one file; agents question it, plan it,
  build it, test it, review it, and hand you a PR
- a **toolbox** — skills for daily work: debugging, audits, refactoring

This README is not a table of skills. It is a short story. We follow one imaginary
product — a **small online store** — from one sentence to production. Each skill does
its job and hands over to the next.

> [**I Made My AI Agents Worse At Their Jobs**](article.md) — why almost every skill in this
> plugin is defined by what it is *forbidden* to do, told through one bookstore build. Ends
> with a one-page table: who to call, and what they will refuse to do.

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

The pipeline above is for a whole product. Most days you are not designing a
product — you want one thing to exist that does not exist yet.

That is what the board is for.

### You write in one file. Only one.

`tasks.md` is yours. `workflow/` belongs to the agents and is gitignored.

```
my-store/
├── tasks.md      ← you write here. that's it.
└── workflow/     ← agents write here. gitignored. delete it any time.
```

You never open `workflow/`. You may read what is in it — the board links to
everything — but you never type in it.

### Two ways to add work

**You know the change.** Tag it, and it goes straight to code:

```
- [ ] TASK-12 [backend] Add invoice export endpoint with test — status: todo
```

**You know the outcome, not the change.** Leave the tag off and write a
paragraph:

```
- [ ] TASK-13 Customers should be told when a wishlist item drops in price — status: todo
      Only for items still in stock. One email per customer per day, never more.
```

An untagged task is a *requirement*. It gets a requirement engineer first.

> Rule of thumb: if you can write the tag honestly, you already did the
> requirement engineering.

### What happens to that paragraph

```console
> /tuhin:task-auto
```

**1. It reads your code before it reads your request.** Schema, routes, existing
jobs — via Laravel Boost. Every claim it later makes about current behavior cites
a `file:line`. It checks your request against `architecture.md` and your
conventions, and tells you if it contradicts a decision you already froze.

**2. It sizes the change** with the `blast-radius` skill, and that decides how
much planning is warranted:

| size | what it means | what you get |
|---|---|---|
| SMALL | one slice, no migration | a plan |
| MEDIUM | several slices, or a migration | a plan + placement + test outline |
| LARGE | new module, or an architecture change | + architecture and model deltas |

No ceremony for a small change. No hand-waving on a big one.

**3. It asks you only what genuinely blocks it** — and only about schema,
user-visible behavior, irreversible effects, or money. Naming preferences get a
sensible default and a line in `assumptions.md`. Questions land on the board, five
at most, each with a default already chosen:

```
- [ ] TASK-13 Wishlist price-drop alerts — status: needs-answer
      Only for items still in stock. One email per customer per day, never more.
      workflow: TASK-13-wishlist-price-drop
      Q1: Alert on any drop, or only below the price when it was added? (default: below the added price)
      A1:
      Q2: Include items that went on sale before the wishlist existed? (default: no)
      A2:
      answered:
```

Answer the ones you care about, ignore the rest — every question already names its
default, and anything you leave blank becomes a line in `assumptions.md`. When you
are done, write `answered: yes` and it picks up from there.

Until you write that line, nothing moves on this task. A loop ticking every few
minutes is never allowed to answer its own questions.

**4. It writes the plan and picks the tag.** The board line becomes:

```
- [ ] TASK-13 [backend] Wishlist price-drop alerts — status: plan-review
      workflow: TASK-13-wishlist-price-drop
      plan: workflow/TASK-13-wishlist-price-drop/plan.md  (MEDIUM · 2 slices · 1 migration)
      approved:
```

You read the plan, type `approved: yes` on the board, and stop being involved.
(Whether it stops here at all is your `PLAN_GATE` setting — see below.)

**5. Then it builds it.** Worktree → implementation agent → Pint, PHPStan, Pest →
draft PR whose body carries your original paragraph, the plan, and every
assumption it made.

**6. Then it reviews it, and fixes what it finds.** The reviewer runs the gates,
reads the diff, and returns PASS or FAIL. FAIL sends the findings back to the same
implementer, in the same worktree — up to three rounds by default, then it stops
and hands you the task.

Two rules keep that from spiralling: from round two on the reviewer verifies the
*previous* findings and looks for regressions, and anything new it notices goes to
a backlog file instead of into this PR. Otherwise a fresh reader finds six new
things every round and the PR never lands.

**7. You merge.** By default the PR stays draft and waits for you. Change one line
if you want the boring ones merged for you.

Statuses: `todo → planning → (needs-answer) → plan-review → doing → review → done`,
or `blocked`.

### The knobs

`workflow/.env` is written on first run, with comments. Per developer, gitignored.

```ini
PLAN_GATE=medium          # never | small | medium | always
AUTO_MERGE=off            # off | gated
MERGE_TARGET=develop
MAX_REVIEW_ROUNDS=3
MAX_FIX_CYCLES=2
NOTIFY=osascript
```

`PLAN_GATE=medium` means you approve plans for MEDIUM and LARGE changes; SMALL
ones flow straight through. A skipped gate is not a skipped plan — the plan is
still written, still the implementer's contract, still reviewed in the PR.

`AUTO_MERGE=gated` merges into `MERGE_TARGET` **only** when the reviewer passed,
the gates are green, the rounds stayed under the cap, the diff has no migration,
the size is not LARGE, and nothing under a protected path was touched (`Sending/`,
`Shared/`, `Billing/`, `Payment/`, plus anything you list). Any condition missing
and it behaves exactly like `off` — and tells you which one stopped it. A missing
or unreadable `.env` also means `off`. The irreversible action fails closed.

### Two drivers, one board

```console
> /tuhin:task-next     # advance one phase, then stop. you decide when to fire again.
> /tuhin:task-auto     # keep advancing until something needs you.
```

Same board, same agents, same gates, same PRs. The only difference is who pulls
the trigger. `task-auto` is `task-next` on a self-paced loop: one phase per tick,
fresh context each time, all state on disk — so a crash costs one phase, never the
task.

**Never run both against one board at the same time** — they both claim "the first
actionable task". To take a task back from a running loop, set its status to
`blocked`; every driver skips `blocked` permanently, so you don't have to stop
anything.

Unattended, outside a session:

```
*/30 * * * * cd /path/to/app && claude -p "/tuhin:task-next"
```

### Suggested ramp

Do not turn everything on the first day.

| | `PLAN_GATE` | `AUTO_MERGE` | driver |
|---|---|---|---|
| week 1 | `always` | `off` | `/tuhin:task-next` — watch every phase |
| week 2 | `medium` | `off` | `/tuhin:task-auto` — hands off, you still merge |
| week 3+ | `medium` | `gated` | the boring ones merge themselves |

### Why gitignoring `workflow/` is safe

Nothing durable is allowed to die in there. A task cannot reach `done` while
something that must outlive it still lives only in `workflow/`:

| lands in | what |
|---|---|
| the PR body | your original paragraph, the plan, the assumptions |
| `tasks/architecture.md`, `tasks/system_model.md` | the deltas, applied in the worktree so one PR carries code and docs together |
| your manual test cases | updated whenever operator-visible behavior changed |
| `docs/conventions.md` | only if the task established a new project rule |

The PR is the permanent record. `workflow/` is the desk it was written on — throw
it away whenever you like.

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
- **task-requirement-engineer** — the analyst. Takes an untagged paragraph and
  turns it into an executable plan: reads the code first, validates the request
  against frozen decisions, sizes the change, asks only what genuinely blocks it,
  and writes the plan the implementer follows. It produces planning artifacts
  only — no branches, no code, no tests, not even the board line.
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

> One writer for the board. No agent-to-agent chat — communication is task
> statuses, plan comments, files, and PR reviews. Planners never code. Developers
> never review their own work. Reviewers never fix. Merging is off until you turn
> it on, and even then only for changes that cannot hurt you.

Nobody in this team can ask you a question mid-thought — subagents take a prompt
and return a result, and that is on purpose. Every question you are asked, and
every answer you give, is a line in a file. That is why a crash costs one phase
instead of a conversation, and why you can walk away in the middle.

Seed the board, run `/tuhin:task-auto`, and the team plays its positions.

## Codex / Gemini CLI

`task-init` writes the same workflow rules into `AGENTS.md` and `GEMINI.md`.
Best-effort: no native subagents or hooks there — back the gates with CI.

## License

MIT
