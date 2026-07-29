# I Made My AI Agents Worse At Their Jobs

### What I learned building a travel booking app with a team of Claude Code agents

**What this is about.** I built a travel booking app — flight and hotel search, multi-city
itineraries, payments, refunds — using a workflow where AI agents do the planning, the
coding, and the review. This is the six restrictions I ended up putting on those agents:
specific things they are forbidden to do, and why taking capability away improved what they
produced instead of degrading it.

**Why it matters.** An agent with full capability and no boundaries does not fail loudly. It
fails by deciding for you. It fills a gap in your spec, answers its own question, fixes the
bug it was supposed to report, or proceeds on a config value it could not read. Nothing
crashes. The work looks finished, the log looks clean, and you find out in week three when
the thing it silently decided turns out to be wrong. Every hour it saved you goes back into
the rebuild.

**What you will learn.** Six rules, each one a line you can put into a `CLAUDE.md`, an agent
definition, or a slash command today — plus what each one actually caught on a real project.
Nothing to install, no framework required.

1. **[Never let an agent answer its own question](#rule-1-never-let-an-agent-answer-its-own-question)** — make it write the hole down, so you can
   tell a decision apart from an invention.
2. **[Agents talk through files, never to each other](#rule-2-agents-talk-through-files-never-to-each-other)** — why a conversation between two
   agents quietly deletes your work, and what to use instead.
3. **[A blank answer is not consent](#rule-3-a-blank-answer-is-not-consent)** — the one-line fix for a bug that is in almost every agent
   loop, including the one you are running now.
4. **[Whatever finds the problem must not fix it](#rule-4-whatever-finds-the-problem-must-not-fix-it)** — why your reviewer should be unable to
   correct a typo it is looking straight at.
5. **[Cap the retry loop, then narrow it](#rule-5-cap-the-retry-loop-then-narrow-it)** — otherwise it finds six new things every round and
   nothing ever lands.
6. **[Irreversible actions fail closed](#rule-6-irreversible-actions-fail-closed)** — missing config means off, never "probably fine".

In a hurry: [skip to the copy-paste version](#steal-these-six-lines).

*(The examples come from a plugin I wrote. It is MIT and this is not a pitch — the part worth
writing down is that almost none of the value came from what the agents can do.)*

---

## Capability was never the bottleneck

Early on I asked for the booking flow. Forty minutes later I had one — form requests,
policies, feature tests, formatter clean. Genuinely good code.

I threw all of it away. The app supports multi-city itineraries, and the flow it built
assumed one origin and one destination. Nobody had told it otherwise, so it picked the
reasonable interpretation and committed to it in the schema.

That is the failure mode worth designing against, and note what it is not: the code was
fine. The problem is that somewhere between my vague request and its confident output,
roughly a dozen decisions got made, and I made none of them. Dates in whose timezone.
Whether a held seat expires. What happens to a refund when one leg of a trip is cancelled.

More capability makes that worse, not better. A more capable agent fills more gaps, faster,
with more conviction. What helped was going the other way — finding every place the agent
was quietly deciding something and forbidding it.

Six of those turned out to matter.

---

## Rule 1: Never let an agent answer its own question

**The failure.** You hand over an ambiguous requirement. The agent notices the ambiguity —
they usually do — resolves it with something reasonable, and continues. The output is
coherent. Nothing marks the spot where it guessed.

Three weeks later you cannot tell which parts of the design you decided and which parts the
model decided for you. Both are written in the same confident tone.

**The rule.** When a requirement is ambiguous, the agent writes the question down and stops.
It does not choose.

In my setup the requirements skill opens with *"you are not a consultant, you are not a
cheerleader"*, and its hard limit is that it may never answer its own question. It rewrites
anything untestable — my *"search should feel fast"* came back as *"first result rendered
under 800ms for a 3-city itinerary"* — and then it asks. On the search feature it asked three
things I had not thought about, including whose timezone a departure date is in when the
traveller is booking from a different country. I did not have an answer. It did not invent
one: the question went into the report as an open item with an if/then branch and sat there,
visible and unresolved, until I decided.

It also cannot edit the requirements file. It writes its analysis somewhere else and hands
back a rewrite for me to paste. The edit stays mine.

**Why the refusal is worth more than the answer.** An agent that resolves its own questions
produces a document with no holes in it. That is exactly the problem — you cannot audit a
document with no holes. One that writes the holes down produces something uglier and far more
useful, because every hole has your name on it.

The same restriction shows up in the architecture step. It recommends a stack, a pattern, a
repo strategy, each with the reasoning attached — and then stops. *"The user's answers are
binding."* It also records every default it took **without** asking, which is the part that
matters four months later when you want to know why something is the way it is.

**What to write:**

> *"When a requirement is ambiguous, write the question and a proposed default into the plan
> file and stop. Do not choose."*

---

## Rule 2: Agents talk through files, never to each other

**The failure.** This one is architectural, and it is where I disagree with most multi-agent
work being built right now.

Agent A messages agent B. B replies. They negotiate, converge, and produce something. It
demos beautifully. Then the context window fills, or a process dies, or you close the laptop
and come back on Monday — and the coordination is gone. Not degraded. Gone. There is no
artifact to resume from and no record of what was agreed.

**The rule.** No agent messages another agent. Ever. Everything one agent needs to tell
another goes into something you can open and read: a status, a plan file, a diff, a review
comment.

I run six agents and there is not one conversation between them. The layout is two surfaces
with one owner each:

```
project/
├── tasks.md      ← I write here. That is my entire surface.
└── workflow/     ← agents write here. Gitignored. Deletable at any time.
```

A task line carries a tag when I already know what needs doing:

```
- [ ] TASK-14 [backend] Hold a seat for 15 minutes during checkout, with test — status: todo
```

And no tag when I know the outcome but not the change:

```
- [ ] TASK-21 Tell travellers when a cheaper fare appears on a trip they saved — status: todo
      Only trips still in the future. One email per traveller per day, never more.
```

An untagged line is not a task, it is a requirement. It goes to an agent whose job is to read
the code before it reads the request — every claim it makes about current behaviour must cite
a `file:line`, so it cannot bluff about what already exists. It writes a plan, and the plan
names the files. That file list is the single most valuable thing it produces, because it is
what stops the next agent re-exploring the whole repo.

The implementers work in separate git worktrees, on separate branches, and cannot edit the
board or reach each other's work. If the plan is wrong they stop and say so rather than
improvising.

**The trade.** File-passing is slower than a conversation and more verbose. What you buy is
that a crash costs one step instead of the whole task, and that six months later you can read
what was decided. I think that is worth it. This is the rule I am least certain about, and
the one I would most like to be argued with on.

**What to write:**

> *"Write your output to `<file>`. Do not wait on another agent. The next stage reads your
> file."*

---

## Rule 3: A blank answer is not consent

This is the bug I am proudest of catching, and I caught it on a whiteboard before it ever
ran.

**The failure.** The agent asks two questions, each with a sensible default, and stops. Your
loop ticks every few minutes. You go to lunch. Four minutes later the loop wakes up, sees two
blank answers, treats blank as "use the default", takes both, and carries on.

You come back to a finished feature built on two decisions you never made — and a tidy record
showing you were consulted.

**The rule.** Blank is not an answer. Nothing resumes until there is an explicit confirming
line.

```
      Q1: Flexible dates means ±3 days, or the whole month? (default: ±3 days)
      A1:
      Q2: Does a price drop on one leg alert a multi-city trip? (default: no)
      A2:
      answered:
```

The loop skips this task entirely until I write `answered: yes`. Then blanks do mean
defaults — but as *recorded* assumptions, written to a file, because I explicitly said go.

That is the whole fix. One required token. Without it the gate exists but the loop satisfies
it on its own schedule, which is worse than having no gate at all, because it produces a
paper trail suggesting you approved something.

**Check your own setup for this.** If any loop you run can proceed on an empty or missing
answer, it will, and it will do it about four minutes after asking.

**What to write:**

> *"An empty answer is not consent. Do not resume until the line `answered: yes` is present."*

---

## Rule 4: Whatever finds the problem must not fix it

**The failure.** You ask an agent to review a change. It finds a typo. It fixes the typo,
because it can, and because fixing is helpful. Then it finds a small logic issue and fixes
that too. By the end it has written part of the change it is reviewing, and it cannot see
that part clearly any more.

This is not an AI problem. Every developer has watched a human reviewer start "just fixing a
couple of small things" and end up owning half the patch. A reviewer who fixes is
co-authoring, and then nobody is reviewing.

**The rule.** The agent that inspects cannot edit. Not a typo. Not a missing semicolon it is
staring directly at.

The important detail: **this is a tool restriction, not a prompt.** Do not ask an agent to be
objective — remove `Edit` and `Write` from its tool list. An agent that can edit will
eventually edit, however firmly you asked it not to.

It runs the deterministic checks first (formatter, static analysis, tests), then reads the
diff, then reports findings anchored to `file:line` and citing rule ids from a standards file.
Judgement is reserved for what tools cannot catch: does this match the plan, what test is
missing, what happens at the trust boundary, which query is N+1 at a thousand rows.

The same split runs through everything that inspects rather than builds:

- The performance pass sketches fixes and applies none. Findings need evidence — *"itinerary
  list runs 1+2N queries; 50 trips → 101 queries"* is a finding, "this could be slow" is not.
- The impact tracer sorts everything a change touches into breaks / needs update / unaffected
  and refuses to make the change.
- The comprehension pass builds a mental model of a module and will not propose a single edit
  while doing it.
- The log analyser reads one entry at a time, never opens a vendor file, and if it cannot
  read `APP_ENV` it assumes production and writes a report instead of touching code.
- The security pass is a deliberately different persona — *"you are an attacker who just got
  the source code"* — and hands anything non-exploitable to the quality pass rather than
  padding its own report.
- The quality pass runs a standing sweep every time: double-submit, run every state
  transition twice, look for the window between check and write. That sweep is what caught two
  travellers booking the last seat on the same flight in the same second, both succeeding, on
  a code path I had already reviewed myself. It wrote a
  failing test to prove it and **refused to commit it**, because a red test does not belong in
  a commit. Fixing is a separate session, and that session commits it green.

**What to write:**

> *"This agent has no write tools. Report findings with file:line. Never apply a fix,
> including trivial ones."*

---

## Rule 5: Cap the retry loop, then narrow it

**The failure.** Reviewer finds problems. Developer fixes them. Reviewer reviews again — and
because it is reading the whole change fresh, it finds six new things. All six are fair. The
developer fixes those. Reviewer finds five more.

I lost nine days to exactly this once, with human reviewers. Unbounded reviewers do not
converge. Agents converge even less, because they never get tired of being thorough.

**The rule.** Two parts, and the second matters more than the first.

Cap the rounds — three, then it stops and hands the work to a human. That is the obvious
half.

The half people miss: **from round two the reviewer's scope narrows.** It may only check
whether the previous findings were fixed and whether the fixes broke anything. Anything new
it notices goes to a backlog file, not into this change.

Without the narrowing, the cap just moves the failure. You hit round three with a fresh set
of findings and a change that is no closer to landing than it was on round one.

**What to write:**

> *"Round 2+: verify only the previous round's findings and any regressions from the fixes.
> New unrelated findings go to `backlog.md`, not into this change."*

---

## Rule 6: Irreversible actions fail closed

**The failure.** Config is missing, or unreadable, or you typed the key wrong. The code reads
it, gets nothing, falls through to the default branch — and the default branch was the one
that does the thing.

**The rule.** Anything you cannot undo — merge, deploy, delete, send, charge — defaults to
*no*. A missing config value means off. An unparseable file means off. An unexpected state
means off.

My auto-merge is off unless every one of these holds: review passed, gates green, round count
under the cap, no migration in the diff, nothing under a protected path. On the travel app the
protected paths are payments, refunds and anything that talks to a booking provider — the
three places where a mistake costs a real person real money. If the config file is
missing or I typed the value wrong, merging is off and it says which condition stopped it.

This is a few lines of logic. It is the difference between a system that fails safe and one
that fails in whichever direction the bug happened to point.

**What to write:**

> *"If the config is missing or unreadable, treat the destructive option as disabled. Never
> default to the irreversible branch."*

---

## What this costs

It would be dishonest to end on the wins.

**It stops more.** Six or seven times a day something is waiting on me — a question, a plan
to approve, a gate gone red. Each stop is small. Together they are why this is not the "walk
away and come back to a finished feature" story that sells well.

**There is more to read.** Plans, assumptions, findings. Most of it I skim. All of it exists
because an agent was forbidden to decide something and had to write the question down.

**One restriction did not survive.** I had a plan-approval gate on every change, including
one-file ones. For a week I approved them without reading, which is worse than not having the
gate — it manufactures consent. So I made it configurable by change size: large and medium
stop, small flows through. Not every refusal is worth its cost, and the honest move was to
price that one and drop it rather than pretend it was free.

**It is slower per task.** It is only faster across a week, and only because things do not get
built twice.

The forty-minute booking flow is still the fastest thing I have ever had built for me. It is
also the only part of that app I threw away entirely.

---

## Steal these six lines

Paste into a `CLAUDE.md`, an agent definition, or a slash command. None of this needs my
plugin.

1. **[Never answer your own question](#rule-1-never-let-an-agent-answer-its-own-question)** → *"When a requirement is ambiguous, write the question
   and a proposed default into the plan file and stop. Do not choose."*
2. **[Talk through files](#rule-2-agents-talk-through-files-never-to-each-other)** → *"Write your output to `<file>`. Do not wait on another agent.
   The next stage reads your file."*
3. **[A blank is not consent](#rule-3-a-blank-answer-is-not-consent)** → *"An empty answer is not consent. Do not resume until the line
   `answered: yes` is present."*
4. **[Split finding from fixing](#rule-4-whatever-finds-the-problem-must-not-fix-it)** → *"This agent has no write tools. Report findings with
   file:line. Never apply a fix, including trivial ones."*
5. **[Cap, then narrow](#rule-5-cap-the-retry-loop-then-narrow-it)** → *"Round 2+: verify only the previous findings and regressions. New
   findings go to `backlog.md`."*
6. **[Fail closed](#rule-6-irreversible-actions-fail-closed)** → *"If the config is missing or unreadable, treat the destructive option as
   disabled."*

Rules [1](#rule-1-never-let-an-agent-answer-its-own-question) and [3](#rule-3-a-blank-answer-is-not-consent) are the two I would add first. Between them they cover
almost every "why did it build that?" I used to have.

---

## Appendix: the same six rules wearing job titles

The plugin these came from is a set of specialists, each defined by what it may not do. If
you want the long version, this is the whole thing on one page.

| The moment you feel it | What you run | What it refuses to do |
|---|---|---|
| The spec reads fine and tests nothing | `requirements` | Answer its own questions |
| You are about to pick a stack by accident | `architecture` | Decide for you |
| "Who gets the last seat when two people book at once?" | `system-design` | Re-argue architecture, or draw a diagram |
| You cannot explain the lifecycle out loud | `system-modeling` | Draw anything it was not told |
| Another team is about to guess your API | `api-contract` | Name a controller or an ORM |
| Nobody has walked through what you designed | `user-journey-map` | Invent a metric for an unbuilt product |
| Screens exist, homes do not | `information-architecture` | Leave an orphan page or step |
| You are arguing about layout in a call | `wireframe` | Use a colour or a pixel value |
| Every button is a slightly different button | `design-system` | Ship a variant no wireframe uses |
| Docs are done, the work is not defined | `task-breakdown` | Write the task board |
| A paragraph has to become a plan | `requirement-intake` · `task-requirement-engineer` | Write application code |
| A plan has to become a PR | `task-workflow` · `task-backend` · `task-frontend` | Touch the board or another branch |
| Something needs a second pair of eyes | `review` · `task-reviewer` | Fix what it finds |
| Before writing any code, ever | `code-standards` | State a rule you cannot check by reading |
| "Where does this class go?" | `vsa` | Imitate a violation that is already there |
| You are about to change shared code | `blast-radius` | Apply the change |
| You do not know how this module works | `understand` | Propose a fix |
| A stack trace and no theory | `log-analyzer` | Touch code when the environment is unknown |
| A bug is confirmed and you want it gone | `red-first` | Fix before the test is red |
| It works and it reads badly | `readability-sweep` | Rename anything silently |
| Pages are slow and you have a hunch | `performance-audit` | Report without evidence, or apply a fix |
| A week before launch | `quality-audit` | Commit a red test, or trust the docs |
| A week before launch, again | `security-audit` | Report a bug that is not exploitable |
| A non-technical person must verify it | `manual-test-cases` | Reference an entity not in the seeders |
| Shipping on Friday | `deployment` | Deploy without a written rollback |
| All of the above, and you do not want to choose | `tuhin` | Plan before it has read the code |

Every "refuses to" in that table is one of the [six rules](#steal-these-six-lines) with a job
title on it.

---

*`/plugin marketplace add digitaldreams/tuhin`, then `/tuhin:task-init` in a Laravel project.
MIT. If you disagree with [Rule 2](#rule-2-agents-talk-through-files-never-to-each-other) I would genuinely like to hear why — it is the
decision I am least sure about.*
