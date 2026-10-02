# My Article Writing Playbook

How I plan, write and ship a technical article. Taken from two of my own articles: *Mastering Symfony Service Container: Modern PHP Attributes Edition* and *Domain Driven Design in Symfony*. It also includes what I accepted and rejected while drafting them.

---

## 1. Who I Write For

- **Web developers in general, not only one framework's users.** The article's code uses a framework (e.g. Symfony), but the ideas must make sense to any web developer: Laravel, Node, Go, Rails. Explain framework-specific parts in one plain sentence ("an attribute that tells Symfony which class to use") so outsiders can follow.
- **Say who it's for early:** "This article is for web developers who already know the basics of X. The examples use Symfony, but the ideas work in any framework."
- **Respect the reader.** I don't assume they write messy code. A "fat controller" hook is unfair to them, so I don't use one.
- **Implementation over theory.** A definition is one or two sentences, given at the moment the code needs it. For the deep theory, point to a book.

### One real-world example, all the way through

- Explain every concept with **one real-world example that continues through the whole article**, e.g. an online shop, its Catalog Manager and one t-shirt product.
- The example starts before the code (a meeting, a notebook, a poster) and comes back in every section. Each new concept is a new chapter of the same story: the t-shirt gets a price (Value Object), gets published (Aggregate), gets reviews, and Inventory hears about it (Domain Event).
- Never switch to a new toy example mid-article. If a concept needs an example, find it in the running story first.
- Each definition = the concept's name + what it means **in the running example**: "A bounded context is a part of the shop with its own model: in Catalog, the t-shirt has a price; in Inventory, it has a shelf."
- The conclusion closes the story: the expert's rules, the t-shirt and the code all line up.

---

## 2. Study the Topic First

Before planning, study the topic the way an expert developer would. The article can only be as correct as this study.

**Step 1. Find the primary sources.**
- If the topic is a **framework, library, plugin or language**, find the **official documentation** for the exact version the article will use. Also read the changelog, the UPGRADE notes and the release blog posts.
- If it's a **concept or pattern** (DDD, CQRS, hexagonal architecture), find the original book or the authors' own writing, plus one or two respected references.
- Check the **current version** on the package registry (Packagist, npm, PyPI…) the day you start. Don't trust memory.

**Step 2. Learn it properly.**
- Read the parts the article will touch from start to end, not just a quick search.
- When the docs are thin or unclear, **read the source code**. It's the final truth about method names, signatures and defaults.
- Write down what is **deprecated, removed or new** in the target version. These traps make an article look outdated on day one.
- If you can, run a small snippet to confirm behavior that matters.

**Step 3. Save study notes.**
- Save them as files next to the article (e.g. `docs/<topic>-notes/`): one file per area, with **a source link for every fact** and the date checked.
- Mark anything not confirmed as **UNVERIFIED**.
- Add a short **"Feeds article section"** line to each note, so the study maps to the outline.

**Step 4. Use it wisely.**
- Take only what this article's journey needs. Expert knowledge is a filter, not a dump: one precise sentence beats a feature tour.
- Prefer the current, idiomatic way for the stated version (e.g. `#[AsAlias]` over old config, closure mapping files over the deprecated style). Mention the old way only if readers will meet it in older tutorials.
- Turn traps into short "Note:" lines that build trust ("That style is deprecated since …").
- **Re-check before publishing** (planning step 7): versions move while you write.

---

## 3. How I Plan

0. **Study the topic first** (section 2). Planning starts only after the study notes exist.
1. **Scratch my own structure first.** A rough list of layers or steps, written in my words, with questions like "Where do we call this?" in between.
2. **Discuss before writing.** I want an honest opinion on the plan, with strengths and weaknesses, not a rewrite.
3. **Lock decisions one at a time** (tech choices, example domain, what's in and what's out). Write them down so they don't get reopened.
4. **Build the core poster** in Claude Design from the approved outline. Claude Code picks the form that fits the article; plan supporting images only where they clarify a concept (see section 8).
5. **Show the intro and the first sections for approval** before the full draft.
6. **Write the full draft in one pass**, then trim or remove sections that feel extra. Then the agent runs the **Reader Review** on itself (section 12): a quick pass after each section, a full pass after the draft.
7. **Check the facts** against the current framework and library versions before publishing.
8. **Ship:** Medium draft, then images, then the repo link, then SEO, then share.

**Rule:** a big rewrite always starts with an outline or opening for me to approve. When I ask to trim about 20%, trim about 20%, not half.

---

## 4. The Article Skeleton (Section by Section)

| # | Section | What it does | Engagement device |
|---|---|---|---|
| 0 | **Title + short subtitle** | Promise + angle | Subtitle as a tagline: *"From YAML Chaos to Attribute Clarity"*, *"When Code Is Cheap, Design Is Everything"* |
| 1 | **Hook** | A pain the reader recognizes | Relatable question: "Remember the last time you…?", "If you had to move to a new framework tomorrow, how much would you touch?" |
| 2 | **Why now** | Makes the topic timely | One current angle (e.g. coding agents: "code is cheap, design is not"). Short, no hype, no false claims |
| 3 | **Who it's for + the promise** | Sets expectations | Link to my previous article, then "In this guide, we'll build…" and the journey in one sentence: "When the journey is complete, so is this article." |
| 4 | **Real-world start** | Introduces the running example that every later section reuses | A domain expert's poster/notebook, a story, a character (the Catalog Manager) and one concrete thing (a t-shirt) |
| 5 | **Core sections, one feature at a time** | The coding journey | Feature-driven headings, Steps, ❌/✅, "That's it!" |
| 6 | **Cliffhanger bridges** | Pull the reader to the next section | End a section with a question: "But who calls this? Where do we call this service?" |
| 7 | **Pause-and-look moment** | Lets the big idea land | "Let's stop for a second and look at what we built", then reveal the concept's name (e.g. "It was hexagonal all along") |
| 8 | **Loop back** | Shows real development | "Back to the Domain": add the next layer of behavior to code we already wrote |
| 9 | **Conclusion** | Recap + proof + punch | "X replaced Y" bullets, one proof (e.g. a `grep` showing zero framework imports), a punchy closing line that echoes the hook |

**Rule:** one continuous coding journey. The article ends when the journey ends. Anything that doesn't move the journey forward (extra delivery channels, side demos) is cut to one or two sentences plus "see the repo".

---

## 5. Section Recipes (My Devices)

- **Short theory first, when needed:** open a section with a few short sentences (2–4) that explain the concept before the code: what it is, why it exists, and what it means in the running example. Then go straight to the code. Skip it when the section has no new concept.
- **Feature-driven headings:** "Protect the Price using a Value Object", "Notify Admin When New Product Created using Injection". Format: *what we achieve* + *using X*.
- **Step 1. / Step 2.** inside a section when there's more than one move.
- **❌ / ✅ code comparison:** the bad way first, then the better way, in one short block.
- **"That's it!"** right after the code that solves it. Often: "That's it! No configuration needed."
- **"Note: You might be thinking, '…?' Good question!"** Answer the reader's doubt before they ask.
- **"Why this is better:"** 3 bullets, each with a short **bold label**: "**Always valid:** …".
- **"A few things to notice:"** bullets right after a code block.
- **Golden Rules:** a numbered list of practical rules. I label my own practice: *(This one is from my own practice.)*
- **Thread lines:** one sentence that repeats the hook across sections ("No `use Symfony…`. Just plain PHP.").
- **Simple analogies** for abstract ideas (islands with paper boats, a coffee maker), always tied back to the running example.
- **Framework-neutral bridge:** after a framework-specific step, one line for other stacks: "In Laravel, this is a service provider binding; the idea is the same."

---

## 6. Voice (Sentence Level)

- Short, warm, direct sentences. Simple words. I'm an ESL writer, and the text should sound like me, not like polished AI prose.
- "We" for the journey, "you" for the reader's own project.
- One idea per paragraph. 2–4 sentences per paragraph.
- Define a term in **bold** when it first appears, in one sentence.
- No hype, no exaggeration. A claim must be true ("generating code is much more efficient", not "weeks of code in minutes").
- Honest small print builds trust: if there's a catch, say it in one line (e.g. "`Doctrine\Common\Collections` is a small standalone library, not the ORM").

---

## 7. Code Rules

- **Core code only.** The rest is "see the repo".
- Keep the `namespace` line so readers know where a class lives.
- Code must be current: check deprecations for the framework version named in the article.
- One block = one idea. Show the change, not the whole file, when the file is already known.
- Mention the full project on GitHub early (in the version note) and again in the conclusion.

---

## 8. Visuals

All article images are made in **Claude Design**. There are three kinds: one cover, one core poster, and a few supporting images only where they help.

### Cover
A concept image of the article's main idea, with an SEO caption. Example: the onion layers for DDD.

### The Core Poster (always one)

The poster **highlights the core of the article**: the main idea and the few concepts that carry it. It's the real-world starting point (skeleton row 4), and the article keeps coming back to it.

**Claude Code decides the form from the article's requirements.** Pick what fits the topic and the running example, for example:
- a domain expert's notebook page, for business rules (DDD)
- a whiteboard sketch from a team meeting, for architecture or flows
- a blueprint or map, for structure, layers or systems
- a checklist or recipe card, for a process or setup guide
- a before/after board, for a refactoring or migration topic

**What every poster has, whatever the form:**
1. **The core idea first**, one short line in the running example's language, visually the strongest element (circled, underlined or centered).
2. **Only the key concepts**, 4–7 items, each one short. Not every detail of the article: just its backbone.
3. **A label for each concept** in a second "voice" (e.g. blue-pen developer notes) that names the technical concept it becomes.
4. **Article order**: concepts follow the section order, so readers can follow the poster while reading.
5. **1–2 small sketches** only where a picture beats words.
6. **No code, no framework names, no title** on the poster itself. The article does that.

**When:** right after the outline is approved, before writing the sections.
**Keep it in sync:** when the article's core changes, update the poster in the same pass.

*Example (DDD in Symfony):* a taped notebook sheet from the Catalog Manager. Pencil rules (Kalam), blue-pen notes naming each DDD concept (Caveat), red emphasis, a status-flow sketch, a context map, and the circled "Please use MY words in the code!".

### Supporting Images (only when they earn it)

Add a supporting image to a section **only if it makes that section's concept clearer and easier to explain than text or code alone**. Ask: *would a reader understand this concept faster with this picture?* If not, skip it.

Good reasons:
- a concept with **movement or flow** (messages between contexts, a request through layers)
- a **relationship or boundary** that's hard to describe (who owns what, what depends on what)
- an **abstract idea** that a real-world metaphor makes obvious (bounded contexts as islands with paper boats)

Bad reasons: decoration, breaking up text, repeating what the code already shows, or one image per section by default.

Usually 0–3 supporting images per article. Each one uses the same running example and the same visual style as the poster.

### For every image
- Export a PNG about 1400px wide (readable at about 700px on Medium) to `images/<topic>-<name>.png`.
- Alt text that describes it and names the concepts; a one-line caption that teaches something.

---

## 9. Packaging and SEO

- **Title:** the keyword phrase ("Domain Driven Design in Symfony").
- **Subtitle:** a short tagline, not a keyword list. A contrast or "From X to Y" works best.
- **Summary / SEO description:** **under 140 characters.** One hook sentence + one keyword sentence: *"Code is cheap now. Design is not. A hands-on guide to Domain Driven Design in Symfony 8 with Doctrine and Messenger."*
- **SEO title:** 40–60 characters: *"Domain Driven Design in Symfony 8: A Hands-On Guide"*.
- **Tags:** 5, from specific to broad (Symfony, Domain Driven Design, PHP, Software Architecture, Doctrine).
- **Version line** near the top: "All examples use PHP 8.5, Symfony 8.1, Doctrine ORM 3.7…"

---

## 10. Distribution

- Publish first, with the images and the repo link in place, then share.
- Start with the closest community (r/symfony), then the broader ones a day later (r/PHP, r/DomainDrivenDesign, r/softwarearchitecture).
- The post text is in my voice: 2–3 honest lines and a request for feedback on a specific part. No marketing.

---

## 11. What I Reject (Learned the Hard Way)

- Long, detailed drafts that read like documentation.
- Short drafts that are tight but don't sound like me.
- Hooks that insult the reader's code.
- False or inflated claims about tools or AI.
- Catchy lines that don't feel natural ("Same t-shirt, different talk").
- Extra sections that don't move the journey (separate API and Console walkthroughs).
- Keyword-stuffed subtitles and long summaries.
- Cutting much more than asked.

---

## 12. Reader Review (The Agent Asks Itself)

**For the writing agent (Claude Code):** ask yourself these questions **on your own, without waiting to be asked**:
- after writing each section (a quick pass on that section), and
- after the full draft (a full pass on the whole article).

Read the text **as the reader**: a web developer who has never seen the plan. Answer each question honestly, with evidence from the text. Fix small problems yourself right away.

**1. Is the concept easy to follow?**
- Can a reader explain the main idea in one sentence after reading?
- Does every new concept get 2–4 short sentences of theory, in the running example, *before* its code?
- Does each section build on what the reader already knows? No term used before it's defined, and no jump in difficulty.
- Is there any paragraph you had to read twice? Rewrite it.

**2. Does the reader want to keep reading?**
- Does the hook hit a real pain in the first 3 paragraphs?
- Does every section give a small win (a working piece, an "aha", a better way)?
- Is there a reason to continue at the end of each section (an open question, a problem, a promise)?
- Where would a busy reader stop? Cut or tighten that part.

**3. Do the section order and titles convince the reader?**
- Read only the headings, top to bottom. Do they tell the story of the journey on their own?
- Is each title feature-driven and specific ("Protect the Price using a Value Object", not "Value Objects")?
- Does the order follow how a developer would really build it?
- Would a reader skimming the headings on Medium decide to read the whole thing?

**4. Are the sections connected?**
- Does each section end with a bridge to the next ("But who calls this? Where do we call this service?")?
- Does each section start by picking up where the last one stopped?
- Do the running example, the poster and the hook thread come back across sections?
- Does the conclusion close the loops the article opened (hook → proof → closing line)?

**Output:** after the full pass, show the author a short table (question → answer → weak spot → fix you made or propose). Small fixes are already done; anything big (reordering sections, a rewrite, cutting a section) is proposed and waits for the author's OK.

---

## 13. Pre-Publish Checklist

- [ ] Study notes exist with sources; every technical fact in the article is backed by them
- [ ] Hook question in the first 3 paragraphs
- [ ] "Who is this for" (web developers, not one framework) + link to my previous article
- [ ] One running real-world example, introduced early and used in every section
- [ ] A non-Symfony developer can follow every section
- [ ] Every section with a new concept opens with 2–4 short sentences of theory before the code
- [ ] Every section heading is feature-driven
- [ ] Reader Review done: easy to follow, keeps interest, headings tell the story, sections linked
- [ ] Every section ends with a bridge to the next
- [ ] ❌/✅, "That's it!", a "Note: … Good question!" and "Why this is better" appear where they help (not forced)
- [ ] Code is current for the stated versions; core code only
- [ ] Conclusion has "X replaced Y" + proof + a closing line echoing the hook
- [ ] Core poster highlights the article's main idea and key concepts, in section order
- [ ] Every supporting image makes its concept clearer (otherwise removed)
- [ ] Images are exported, with alt text and captions
- [ ] Repo link is real
- [ ] Subtitle and SEO description are short; 5 tags
