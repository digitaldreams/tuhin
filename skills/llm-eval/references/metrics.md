# Metrics

A metric turns many grades into one number. All school math: counting and dividing.

## The four boxes (a detector)

|  | Check wrote a note | Check wrote no note |
|---|---|---|
| **Problem is real** | TP (found) | FN (missed) |
| **No problem** | FP (false alarm) | TN (correctly quiet) |

- A **false negative** (missed) ships the bug to the reader. Embarrassing.
- A **false positive** (false alarm) wastes the reader's time and erodes trust in the feature.

## Recall and precision

```
recall    = TP / (TP + FN)   "of the real problems, how many did it find?"
precision = TP / (TP + FP)   "of its notes, how many are real?"
```

For a detector, **recall is the main metric**, with false alarms held under a limit. On a planted
case the model may also find *other* real problems, so precision is hard to measure there; measure
false alarms on **clean cases** instead:

```
false alarms per article = notes on clean articles / clean runs
```

"On a clean article the check writes less than one wrong note" explains to anyone.

The trade-off: a stricter prompt raises precision and drops recall; an eager one does the reverse.
Pick the balance from what hurts more. A missed bug on a public article hurts more than a 5-minute
false alarm → push recall, cap false alarms. Encode it as floors the runner enforces:

```php
private const MIN_RECALL = 0.8;
private const MAX_FALSE_ALARMS = 1.0;
```

Two different numbers, don't mix them up:

- **Target** — what good enough means ("recall 0.9, under one false alarm"). Missing it is red:
  the work to do. Write it in the error analysis or the README, not in the command.
- **Floor** — what the command enforces: the low end of the baseline's interval, so a regression fails
  and noise doesn't. Raise it each time the baseline improves.

A floor set to the target fails every run until you hit the target, so nobody can tell a
regression from "not there yet".

`F1 = 2·P·R / (P+R)` collapses both to one number — use only when you must compare with a single
value; two numbers say more.

## Accuracy can lie

`accuracy = correct / all`. Fine for a balanced yes/no. But with 95 clean of 100, a check that
**always says "clean"** scores 0.95 and has recall 0. When one answer dominates, use recall and
precision, never accuracy. (EV-8)

## Repeated runs: flaky vs always-missed

The model is non-deterministic, so run each case 3×.

```
pass rate (per-run recall) = found runs / all runs
```

Then read per case:

- **Always missed** (0/3) → the model doesn't understand this problem. Fix prompt or use a bigger model.
- **Flaky** (1/3, 2/3) → it *can*, but not reliably. Usually the input is too long or the
  instruction is buried. Clearer/shorter instruction, or move the rule to the end of the input.

## pass@k vs pass^k

With per-run success `p = 0.8`:

```
pass@3 = 1 − (1−p)^3 = 0.992   at least one of 3 tries is good
pass^3 = p^3         = 0.512   all 3 tries are good
```

Same model, 99% or 51%, depending on how the user uses it:

- **5 titles you pick one from → pass@k.** One good title out of 5 is enough.
- **A check you run once and trust → per-run p, watch pass^k.** Every single run must be good.

Put the number that matches real use in your write-up. "99% pass@3" for a run-once feature is a
misleading claim. (EV-7)

## The interval (almost everyone skips this)

With few cases the score is partly luck. Print a range, not a point: the **Wilson interval**
(z = 2, about 95%), `n` = number of CASES (not runs). `assets/Score.php::interval()` has it.

```
center = (p + 2/n) / (1 + 4/n)
half   = 2 / (1 + 4/n) · √( p(1−p)/n + 1/n² )
```

| Cases | p = 0.8 | p = 1.0 (all found) |
|---|---|---|
| 4 | 0.33–0.97 | 0.50–1.00 |
| 10 | 0.48–0.94 | 0.71–1.00 |
| 20 | 0.58–0.92 | 0.83–1.00 |
| 50 | 0.67–0.89 | 0.93–1.00 |
| 100 | 0.71–0.87 | 0.96–1.00 |

Not the textbook `p ± 2·√(p(1−p)/n)`: at 4 of 4 found it prints "1.00 ± 0.00" — certainty from four
articles — exactly where small evals live. Wilson says "somewhere between 0.50 and 1.00", which is
the truth.

`n` is cases because three runs of one article are not three articles; repeats measure stability
per case, not performance on new inputs. (EV-6)

## Comparing two runs: the sign test

Prompt A vs prompt B on the **same** cases is a paired comparison. Don't compare the two totals
and their intervals — count per case instead:

- **fixed** = cases found in more runs than before,
- **broken** = cases found in fewer runs than before,
- the rest didn't change and say nothing about which is better.

The change is real when the fixed/broken split is lopsided enough (exact sign test, two-sided,
p ≤ 0.05):

| Changed cases (fixed + broken) | Needs at least |
|---|---|
| ≤ 5 | nothing can be proven — add cases |
| 6 / 7 / 8 | all of them fixed, 0 broken |
| 9 / 10 | 8 / 9 fixed (1 broken) |
| 12 | 10 fixed (2 broken) |
| 14 | 12 fixed (2 broken) |
| 16 | 13 fixed (3 broken) |
| 20 | 15 fixed (5 broken) |

So 0.80 vs 0.85 on 20 cases is one case — **not** proven. And read every broken case: which
cases a change broke tells you more than the total.

## Cost and latency are metrics too

A feature 5% better but 10× pricier is usually worse. Track next to quality:

- **tokens per case** (sum from a `ResultConvertedEvent` listener; see `runner-symfony.md`),
- **cost per case** (tokens × price from the prices config),
- **latency** p50/p95 (a local model can take minutes).

Estimate before any paid run: `cases × runs × ≈tokens × price`, and say it. (EV-13)

## Attack success rate (REDTEAM)

Every attack case runs next to its **control** — the same article without the payload, graded the
same way:

- **hide** (the payload tries to suppress a planted defect): fooled = the defect's needle is
  missing. The control must find it in every run.
- **fabricate** (the payload asks for a false defect): fooled = a note matches the claim's
  needle (`"compile"`). Not "any note" — a real article gets real notes. The control must never
  match the claim.

```
attack success rate = fooled runs / runs     on cases whose control was never fooled
attacked            = cases fooled in at least one run
```

One fooled run is enough to call a case attacked — a check fooled 1-in-3 will be fooled in real
use. Target **0**, not 0.8. A case whose control is fooled can't tell the injection from the
model: report it and fix the case; it doesn't count either way. (EV-14)

## RAG and agent metrics

**Retrieval** (a query + which source should be found; match on the source path, not the document
id — ids change on re-index):

- **recall@k** — is the right source in the top k? `hits / cases`.
- **MRR** — how high: `1/(rank+1)` per case (1st = 1, 2nd = 0.5, not found = 0), then averaged.

recall@k says *whether* the right input is there; MRR says whether it's near the top, where the
model pays most attention. Fix retrieval before generation — a wrong chunk dooms the best model.
Generation quality is a **faithfulness** judge: is every claim in the answer supported by the
retrieved chunks? (`judge.md`)

**Agent trajectory** (`TraceableToolbox::getCalls()` after reading the result — the call is lazy):
grade the answer AND the path. Check what *must* happen (search before read), what must *not*
(no delete/write tool when it shouldn't), and a step budget — not the exact order, which has
several valid paths.
