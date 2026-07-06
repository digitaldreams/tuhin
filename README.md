# tuhin

Tuhin Bepari's dev identity as a Claude Code plugin: a spec-driven SDLC pipeline, an
autonomous Laravel task workflow, and a personal toolbox of engineering skills — all
markdown, running on your coding CLI.

Instead of listing the skills in a table, this README walks them in the order you'd
actually use them, following one imaginary product — a **gym class booking app** —
from a single vague sentence to production.

## Install

```
/plugin marketplace add digitaldreams/tuhin
/plugin install tuhin@tuhin-marketplace
```

Then, inside your Laravel project:

```
/tuhin:task-init
```

Non-destructive: existing `tasks.md`, `docs/*`, `AGENTS.md` content always wins.

**Prerequisites:** a Laravel app in a git repository; `gh` CLI authenticated (draft
PRs); `laravel/pint` + Pest (or PHPUnit) as quality gates;
[Laravel Boost](https://github.com/laravel/boost) as the knowledge layer
(`composer require laravel/boost --dev && php artisan boost:install`); optionally
`phpstan/larastan` — picked up automatically as an extra gate.

Boost owns knowledge (schema, routes, framework conventions). This plugin owns
workflow (roles, board, plan checkpoints, worktrees, gates, PRs, review). No overlap.

---

## The pipeline

Someone hands you a sentence: *"Members should be able to book gym classes online.
Booking should be easy. Classes fill up, so maybe a waitlist."* That sentence is now
`tasks/requirements.md`. Here is what happens to it.

### requirements

The first skill is deliberately hostile. It tears the document apart: "booking should
be easy" is untestable and dies on the spot, rewritten as something a test can verify.
It pins the target context (who books, on what device), asks you the three questions
that actually change what gets built — *what happens to the waitlist when someone
cancels?* — and refuses to answer them itself. Out comes `requirement_analysis.md`
with MoSCoW-tagged, testable requirements, a competitor check, and a drop-in rewritten
spec. The garbage sentence never reaches the next stage.

### architecture

Now the strategic decisions — and they are yours, not the model's. The skill derives a
recommendation from the requirements (team size, scale, domain complexity) and asks:
which ecosystem, which pattern, which repo strategy — three options each, one
recommended, with the signals cited. For the gym app: Laravel modular monolith with
vertical slices, Blade monorepo. Every answer lands as an ADR-lite entry —
context, options, choice, trade-off — so month-six-you remembers *why*.
`architecture.md` is frozen from here on; nothing downstream re-argues it.

### system-design

Architecture said what shape; this says how it behaves. Component contracts, endpoint
tables, the key flows as numbered steps, and — the part everyone skips until
production teaches them — failure handling: what happens when two members grab the
last spot in the same second, which steps share a transaction, what is safe to retry.
It also pins the applied patterns table (framework-first: Eloquent observers before
GoF Observer, and no `UserRepository` wrapping `User::query()`). After
`system_design.md`, two developers build the same feature the same way.

### system-modeling

Renders the frozen design as diagrams — it never re-derives. Sequence diagrams from
the key flows, a class diagram of the domain, a conceptual ERD, and state diagrams for
anything with a real lifecycle: `booked → attended`, `booked → cancelled →
waitlist-promoted`. If a diagram needs information the design doesn't have, that's a
flagged gap, not an improvisation.

### api-contract

When the architecture chose an API (SPA or mobile client), this writes the contract
both sides build against before any code exists: conventions once, endpoint tables,
error envelope, and a traceability rule — every feature maps to an endpoint, every
endpoint traces back to a requirement. Blade monorepo with no API? Skip it; the
pipeline doesn't mind.

### user-journey-map

The design pipeline starts with honesty about what exists: nothing. So it maps two
things — how members book today (the paper sheet at the front desk, and its very real
pain) and the intended flows you're designing, where friction is *predicted*, never
"measured". Every step names its screen, failure branches are steps too, and the
rollup at the end lists every screen with the states it needs. No invented "40% abandon
here" — nothing exists to abandon yet.

### information-architecture

Every journey step gets a home. Sitemap, URL rules, page inventory (purpose, content
blocks, states), navigation, and the access matrix — member, trainer, admin — because
the trainer's schedule page and the member's booking page are different worlds. It
validates both directions: a journey step with no page and a page serving no journey
are both flagged orphans.

### wireframe

One page at a time, it draws the IA entry: content blocks as ASCII layout, desktop and
mobile, every state the inventory listed — the class list when every class is full,
the empty week, the failed-payment branch. Global chrome is referenced once from the
IA, not redrawn on every page. No pixels, no colors; structure only.

### design-system

Counts before it decides: how many forms, tables, card types the wireframes actually
contain — then defines exactly that many patterns, no speculative variants. The
palette is chosen for this product and defended in a sentence, never default-blue by
inertia. Out comes `design_system.md`: `@theme` tokens, per-component state
requirements, dark mode strategy, accessibility non-negotiables.

### task-breakdown

The last translation: frozen docs into epics (one per component) and tasks as
vertical slices — migration, model, page, validation, test, one user-visible behavior
each, sized to one sitting. Tests live inside every task's acceptance criteria, never
as a trailing "write tests" task. A traceability section proves every Must-have
requirement became a task and every task traces back to a source.

## The workflow

`epics.md` isn't the board. The task-manager agent — the only writer of `tasks.md` —
converts it into board tasks. Then the loop (`/tuhin:task-next`, or the
`task-workflow` skill) takes over: claim a task, write a plan, **stop for your
approval**, implement in an isolated git worktree, pass the gates (Pint, Pest,
PHPStan), open a *draft* PR, get a `review` verdict (deterministic tools first, LLM
judgment second, PASS/FAIL anchored to diff lines), and notify you. **You merge.
Always.**

Statuses: `todo → planning → plan-review → doing → review → done`, or `blocked` after
two failed fix cycles — with the failure attached for a human. Agents never chat with
each other; communication is the board, plan comments, and PR reviews.

Hands-off dispatch when you trust the loop:

```
/loop 15m /tuhin:task-next                          # in-session
*/30 * * * * cd /path/to/app && claude -p "/tuhin:task-next"   # cron, headless
```

Plan checkpoints still stop for approval; disable per-board with
`plan_checkpoint: off` for trusted recipe tasks.

## While you build

The pipeline gets you to a board; these skills live in the day-to-day.

Before touching anything shared, `understand` builds the mental model — read-only, no
fixes, just how the thing actually works — and `blast-radius` traces what a change or
deletion touches before you make it, with ranked options instead of edits.

While writing, `code-standards` is the contract: ~30 numbered, checkable rules (CS-n)
that generation agents read before writing code and reviewers cite by id — naming,
structure, no speculative abstractions, PSR-12 via Pint, PHPStan clean. `vsa` guards
the folder structure: which slice a class belongs in, and audits for cross-slice
imports when boundaries start to leak.

When something breaks, `log-analyzer` reads `laravel.log` to a root cause instead of a
guess, and `red-first` enforces the discipline: reproduce, write the failing
regression test, watch it go red, *then* fix. A bug without a red test was never
proven to exist.

And periodically, `readability-sweep` deletes the comments that narrate code, extracts
intent-named methods, and challenges every name — because the next reader is an agent
too, and names are all it has.

## Before you ship

Four auditors, none of them polite.

`quality-audit` is the veteran tester: it books the last spot from two browsers in the
same second, double-clicks every submit button, replays every state transition twice,
and writes findings ranked mandatory-vs-optional — top findings proven with failing
tests left uncommitted for the fix session. `security-audit` is the attacker with your
source code: can member A read member B's bookings, which route skipped its policy,
what does `composer audit` say — severity-ranked with attack scenarios.
`performance-audit` sweeps for the N+1s, missing indexes, and queue candidates before
your users find them. And `manual-test-cases` writes the click-paths a gym owner can
follow verbatim — every button label real, every named entity confirmed in the
seeders, a PASS/FAIL line per case.

Then `deployment` writes the release procedure boring enough that nothing surprising
can happen: env diff, migration safety (destructive changes ship in two releases),
zero-downtime sequence, smoke checks, and a rollback plan with its trigger decided
*before* the deploy — because if rollback is not written down, the deploy does not
happen.

## Codex / Gemini CLI

`task-init` writes managed blocks into `AGENTS.md` and `GEMINI.md` carrying the same
workflow rules — best-effort tier: no native subagents or hooks there, so back the
gates with CI.

## License

MIT
