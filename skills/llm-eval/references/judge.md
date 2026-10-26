# The LLM Judge

A judge is a second model that grades the first model's output. It can read meaning, so it grades
what code can't: "does this note describe the contradiction we planted?", "does this title promise
anything the body doesn't deliver?". It is also an LLM, so it can be wrong — never trust one you
haven't checked against your own labels.

Use it only where code can't (EV-2). A code check is free, instant and never wrong about what it
checks; a judge costs tokens, takes seconds, and is sometimes wrong.

## Rules that make a judge useful

1. **Yes/no, never 1–10.** Nobody, including the judge, knows a 6 from a 7. "Does this note
   describe the planted problem? pass or fail, one sentence of reason."
2. **One question per call.** "Accurate, short, catchy and SEO-friendly?" blurs; a fail tells you
   nothing. Ask one thing; drop the parts code can check (`mb_strlen() <= 60`).
3. **Reason first, verdict second.** Put the `reason` property before `pass` in the response class;
   the model "thinks" as it writes the reason and the verdict improves.
4. **Give the reference when you have one.** For a planted defect you know the answer — hand the
   judge the `planted` sentence. Reference-based judging ("does a note match THIS problem?") is far
   more reliable than asking the judge to hunt for problems itself.
5. **A different model family from the one under test.** Models like their own family's writing
   (self-preference). Check runs on OpenAI → judge on Anthropic, or the reverse. (EV-9)

### The Verdict class and the call

```php
/** One judge answer. reason first, so the model argues before it decides. */
final readonly class Verdict
{
    public function __construct(public string $reason, public bool $pass) {}
}
```

The judge is dev-only test infrastructure: `#[When(env: 'dev')]`, injects a platform directly
(`ai.platform.anthropic`), and calls `->invoke(model, bag, options)->asObject()` with
`response_format => Verdict::class`. It does NOT need an `ai.yaml` agent entry — the bundle
registers the structured-output subscriber on every platform. Pass the reference and the output
through `template_vars` (see `runner-symfony.md` for the gotchas: notes go in as ONE imploded
string, and placeholder names must not appear in the data).

## Known biases

| Bias | What happens | Fix |
|---|---|---|
| Position | In "A or B?" prefers the first (or second) | Run twice with A/B swapped; count only if both agree. |
| Length | Prefers longer answers | Tell it length doesn't matter; check against your labels. |
| Self-preference | Prefers its own family's output | Different family. |
| Leniency | Says "pass" too easily | Calibrate the threshold; add fail examples to the rubric. |

## Calibration — prove the judge (EV-9)

A judge you haven't checked is a guess. Before you trust it, check it against the only real truth:
your own labels.

1. **Collect ~30 verdicts** with a mix of pass and fail. The runner's `--judge` run already dumps
   each `{planted, notes, judge, reason}` to the report's `judged` list. To get fails, include runs
   from a weak model (it misses more).
2. **Label them yourself.** For each, **decide before you read the judge's reason** (or it
   convinces you), and write `"human": true|false`. If *you* can't decide, the rubric is unclear —
   fix the rubric. Save as `evals/labels/judge_calibration.json`:
   `[{"planted": "...", "notes": [{"section": "...", "problem": "..."}], "human": true}]`.
3. **Compare two rates, not plain agreement.** With 27 of 30 labels "pass", a judge that always
   passes agrees 90% and catches zero fails. So:
   ```
   judge on your passes (TPR) = TP / (TP + FN)
   judge on your fails  (TNR) = TN / (TN + FP)
   ```
   Both must be **≥ 0.85**. Print the counts next to the rate ("9 of 10"): ten fails is thin
   proof (Wilson 0.59–0.98 at 9 of 10), so grow the fails when the judge decides something that
   matters.
4. **Fix the rubric, not your labels — on the tuning labels only.** Split the labels before you
   start: ~20 to tune on (`judge_calibration.json`), ~10 held out (`judge_holdout.json`) with both
   passes and fails. Read each tuning disagreement for a pattern and add a rubric line ("Notes about
   other real problems do not count", "in any words, it need not quote exactly"). Re-run. Every
   rubric edit fitted to the same labels inflates the rates on them — the same overfitting as a
   prompt tuned on its dev cases. When the tuning rates pass, run the held-out labels **once**;
   those are the rates you report. The `app:eval:calibrate` command does one file in one shot and
   keeps it as a guard against a silent judge-model change.

A calibrated judge is defensible: "I checked it against 10 labels it was never tuned on; it agreed
on 5 of 5 passes and 4 of 5 fails." That is the sentence a client needs.

## System One / nimble as a cheap first-pass judge

System One decision models (`nimble` on local Ollama, `POST /v1/systemone`) answer typed questions
with a probability — a `noul` answer is P(yes) — and generate no text. They fit several judge jobs
and are free on local hardware.

Maps onto the rules: yes/no is native (threshold the noul, e.g. ≥ 0.5 → pass); reference-based fits
(`state = {planted, notes}`); many atomic questions batch into one request; nimble (Qwen-based) is
a different family from OpenAI/Claude. **But:**

- **No reason text** → rule 3 breaks; you can't debug a disagreement during calibration. Workaround:
  send low-confidence or failed cases to a text judge for the reason.
- **~8K-token limit per question prompt** → a full long article won't fit; use it on notes, not
  whole articles.
- **Weak at math, dates, negation, quantifiers.** A contradiction about "3 vs 5 retries" is a
  number — verify carefully.
- **Confidence means peaked, not correct.** Still calibrate exactly like a text judge: 30 labels,
  TPR/TNR ≥ 0.85, and pick the noul threshold from those labels.

Symfony AI does not wrap the `/v1/systemone` endpoint — call it with Symfony `HttpClient`. Use it
as a free first pass, with a text judge as the fallback for the uncertain middle. The
`system-one` skill has the request shape and the failure modes.
