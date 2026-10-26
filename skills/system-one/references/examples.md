# System One — worked examples

Condensed from TypeSafe's docs and cookbooks (docs.typesafe.ai/cookbooks). Cookbooks pin `jev-1.12` and use a helper lib `cooksafe` (JsonCache, make_playground_link) — not needed for the pattern. Python SDK shown; the JSON wire shape is identical for Ollama (`model: "nimble"`, no auth).

## 1. Speculative fan-out (one call, route in code)

Ask every question any path might need; ignore irrelevant answers.

```python
questions = {
    "category": Choice(instructions="Determine the broad category of this support ticket", criteria={
        "bug_report": "The user is reporting something broken or producing errors",
        "billing": "Charges, invoices, refunds, subscriptions",
        "feature_request": "The user is requesting new functionality",
        "account": "Login, permissions, profile, security"}),
    "bug_severity": Score(instructions="How severe is the reported issue", criteria=[
        "Cosmetic; no impact to functionality",
        "Broken or degraded feature; workaround exists",
        "Blocking issue; no workaround exists"]),
    "has_reproducible_steps": Noul(instructions="The user describes specific steps to reproduce the issue"),
    "refund_requested": Noul(instructions="The user is explicitly asking for a refund or credit"),
    "frustration": Score(instructions="How frustrated the user appears",
                         criteria=["Calm, matter-of-fact", "Frustrated but civil", "Very angry"]),
}
a = client.system_one(state=ticket, questions=questions).answers
if a["category"].choice == "bug_report":
    if a["bug_severity"].score > 1.5 and a["has_reproducible_steps"].noul > 0.6:
        escalate_to_engineering(ticket_id, severity="high")
    else:
        add_to_bug_backlog(ticket_id)
elif a["category"].choice == "billing":
    route_to_billing(ticket_id, refund_likely=a["refund_requested"].noul > 0.7)
if a["frustration"].score > 1.5:
    flag_for_priority_response(ticket_id)
```

Measured (Parallel questions cookbook): 13 questions over the GDPR Wikipedia article — one call vs 13 calls, same answers, ~12× cheaper, ~10× faster.

## 2. Confidence-gated routing (threshold scales with risk)

```python
action = client.system_one(state=user_message, questions={"intent": Choice(
    instructions="What action is the user requesting?",
    criteria={"check_balance": "Check the balance of an account",
              "approve_transfer": "Approve the pending transfer request",
              "other": "Something else"})}).answers["intent"]

if action.confidence < 0.6:              route_to_support_agent(account_id)
elif action.choice == "check_balance":   show_balance(account_id)          # low stakes
elif action.choice == "approve_transfer":
    if action.confidence > 0.85:          approve_transfer(account_id)      # high stakes, high confidence
    else:                                 ask_user_to_confirm(...)
else:                                     route_to_support_agent(account_id)
```

Variants:
- Second team gets a copy if its probability > 0.25 (`for team, p in department.probabilities.items()`).
- Classification using confidence: 75 SEC industry groups as one Choice; confidence ≥ 0.9 → report group, else report the parent division (computed in code).
- Noul three-way band: `< 0.2` no, `> 0.8` yes, between → human review (also 0.3/0.7).

## 3. Composite scoring (decompose, normalize, weight)

```python
def normalized(answers, qid):
    return answers[qid].score / (len(QUESTIONS[qid].criteria) - 1)

priority = 0.6*normalized(a, "severity") + 0.3*normalized(a, "frustration") + 0.1*normalized(a, "report_quality")
# resume screening, 5-level scales (/4): senior IC vs engineering-manager weights over the same four Scores
ic = 0.40*py + 0.10*lead + 0.40*arch + 0.10*general
em = 0.15*py + 0.40*lead + 0.20*arch + 0.25*general
```

Spam as weighted nouls:
```python
spam_risk = 0.45*a["requests_credentials"].noul + 0.30*a["sender_identity_mismatch"].noul + 0.25*a["unexpected_reward"].noul
if 0.4 < spam_risk < 0.6 or a["topic"].confidence < 0.75: route_to_human_review(ticket)
elif spam_risk >= 0.6: quarantine_as_spam(ticket)
```

## 4. Intent routing (cheap classifier in front of expensive handlers)

`intent` Choice (order_status / product_question / return_exchange / complaint) + `complexity` Score (3 levels). Confidence < 0.5 → human. order_status → deterministic lookup. product/returns → specialist LLM. complaint → human if `complexity.score > 1` or `complexity.confidence < 0.5`, else complaint LLM.

## 5. Structured instructions built in code (one noul per DB record)

```python
SAME_PERSON = "Is the resume for the same person as `potential_duplicate`?"
questions = {
    f"same_as_record_{c['id']}": Noul(instructions={
        "potential_duplicate": {k: c[k] for k in ("name", "location", "last_employer")},
        "question": SAME_PERSON})
    for c in candidates}
r = client.system_one(state={"resume": resume}, questions=questions)
dupes = [qid for qid, ans in r.answers.items() if ans.noul > 0.7]
```
Recorded: Jon Smith/Oakland/Google → 0.74; John Smith/Austin/other → 0.09; John Smithers/Oakland/other → 0.08.

## 6. Contrastive Choice options

```python
Choice(instructions={"question": "Which team should handle this message?",
                     "focus": "Classify the customer's primary request, not every topic mentioned."},
       criteria={
         "billing": {"what": "Charges, invoices, refunds, or subscriptions",
                     "not_for": "Order tracking or account access",
                     "examples": ["I was charged twice", "Where is my refund?"]},
         "orders":  {"what": "Order status, delivery, cancellation, or returns",
                     "not_for": "Charges or account access",
                     "examples": ["Where is my package?", "Cancel my order"]}})
```
Score levels can be objects too: `{"what": "...", "examples": [...]}` — only helps when examples resemble real inputs (matching example: conf 0.35 → 0.96; unrelated example: no change).

## 7. Guardrails (input + output screening)

Per message, one call: nouls `jailbreak`, `harmful_request`, `medical_advice`, `self_harm` (output side: `broke_policy` instead of jailbreak) + Score `severity` (No harm / Mild / Serious / Severe).
```python
HAZARD_ACTION = {"jailbreak": "block", "broke_policy": "block", "harmful_request": "block",
                 "medical_advice": "review", "self_harm": "support"}
PRECEDENCE = ["support", "block", "review", "pass"]
POLICIES = {"strict": {"review_threshold": 0.35, "action_threshold": 0.70, "severity_block": 2.0},
            "permissive": {"review_threshold": 0.35, "action_threshold": 0.85, "severity_block": 2.0}}
def route(nouls, severity, policy):
    triggered = []
    for hazard, p in nouls.items():
        if p >= policy["action_threshold"]: triggered.append(HAZARD_ACTION[hazard])
        elif p >= policy["review_threshold"]: triggered.append("review")
    if severity >= policy["severity_block"]:
        triggered = ["block" if t == "review" else t for t in triggered]
    return next((t for t in PRECEDENCE if t in triggered), "pass")
```
Same probabilities, different policy → different decision. Thresholds live in one dict.

## 8. RAG passage gating

Per retrieved passage, state `{"query": q, "passage": {id, title, text, source_type}}`, four nouls: `is_relevant`, `contains_answer_evidence`, `contradicts_query_premise`, `contains_prompt_injection`.
```python
THRESHOLDS = {"injection_max": 0.70, "contradicts_min": 0.70, "relevant_min": 0.45, "evidence_min": 0.55}
def route(a, t=THRESHOLDS):
    if a["contains_prompt_injection"] > t["injection_max"]: return "exclude"
    if a["contradicts_query_premise"] > t["contradicts_min"]: return "conflicting_evidence"
    if a["is_relevant"] < t["relevant_min"]: return "exclude"
    if a["contains_answer_evidence"] > t["evidence_min"]: return "include"
    return "exclude"
```
Included + conflicting passages go into the LLM prompt in separate blocks.

## 9. Citation check

Code finds the quote verbatim in the source (whitespace/quote-normalized) → missing = "fabricated", no model call. Else one Choice over the section: `supports` / `contradicts` / `says_nothing` → verified / contradicted / unsupported. Auto-accept at confidence ≥ 0.8, else review.

## 10. Extraction: model picks, code owns the string

Pre-parsed values:
```python
NONE = "none"
def pick(document, candidates, question):
    criteria = {c: None for c in candidates} | {NONE: "None of these is the requested value."}
    a = client.system_one(state=document, questions={"pick": Choice(instructions=question, criteria=criteria)}).answers["pick"]
    return a.choice, a.confidence
emails = EMAIL_RE.findall(doc)                       # regex = recall
receipt, conf = pick(doc, emails, "Which email address does the sender want their receipt sent to?")
```
Phone: pick the mobile, Choice the country (US/GB/…), normalize with `phonenumbers` to E.164 in code. Money: pick amount, Choice currency, Noul "is this a credit not a charge?", `Decimal` in code.

Dates: seven Choices per role — `mode` (absolute/relative/none), `month` (12 + none), `day` (1–31 + none), `year` (1900–2050 + `out_of_range` + `none`), `day_anchor` (today/tomorrow/day_after/weekday/none), `weekday`, `week_offset` (current/next/none). Code assembles the date, infers missing year, rejects impossible dates, confidence = min of parts used, review below 0.60.

SDE cascade: cheap LLM extracts JSON → per-field Noul battery with structured instructions `{"field_spec": {...}, "extracted_field": value, "main_question": ...}` (name_desc_mismatch, type_mismatch, unreasonable, hallucinated, off_target, incomplete, format_violation; `absence_wrong` for empty fields) → any P > 0.7 escalates to a reasoning model. Schema-valid ≠ correct.

## 11. Big Choice lists

- Line search: prefix lines `L000| …`, one Choice with every line id as an option (218), plus a Noul "does any line answer this?" (≥0.7 answered, <0.35 absent). Rank lines by `probabilities`.
- Skill suggestion: request 1 = Choice over 182 skills + 3 gate nouls (mean < 0.30 → suggest nothing); request 2 = Choice over top 3 with full descriptions + one `fits::<name>` noul each (best < 0.30 → nothing).
- Structure recovery: pass 1 one Noul per line ("does this line pick up mid-sentence?" — beats "same paragraph?"); merge in code; pass 2 per block: type Choice (heading/paragraph/list_item/quote/code/callout) + companion questions (heading level, ordered step, callout kind) — all blocks in one request.

## 12. Re-ranking with the probability itself

```python
nouls = {c: client.system_one(state={"query_excerpt": q, "candidate_passage": corpus[c]},
                              questions={"is_cited_source": question}).answers["is_cited_source"].noul
         for c in shortlist}                         # BM25 top 30, thread pool
reranked = sorted(shortlist, key=lambda c: -nouls[c])
```
CLERC legal citations: top-1 5% → 18%, top-10 38% → 62%. Questions serialize with `question.model_dump_json(exclude_none=True)`.

## 13. Hierarchical classification (beam search)

One Choice per level; options keyed `c0..cN` with the label as description (avoids long/odd keys):
```python
def choose(state, labels):
    if len(labels) == 1: return {labels[0]: 1.0}
    keys = {f"c{i}": label for i, label in enumerate(labels)}
    p = client.system_one(state=state, questions={"child": Choice(
        instructions="Which direct child category best matches this document?", criteria=keys)}).answers["child"].probabilities
    return {label: p[k] for k, label in keys.items()}
```
Beam K=3, path score = geometric mean of decision probabilities, expand beams in parallel. Beats greedy on CPC patents, Shopify, MeSH, file trees. Alternative: put subtrees in option values (`{"Sporting Goods": {"Cycling": [...]}}`) so the model sees what's under a branch.

## 14. Count in code, not in the model

```python
r = client.system_one({"items": items},
    {f"item_{i}": Noul(instructions=f"Is `items[{i}]` the name of a fruit?") for i in range(len(items))})
count = sum(r.nouls[f"item_{i}"].noul > 0.5 for i in range(len(items)))
```

## 15. Features for classical ML

Autoresearch cookbook: one request per document, Score/Noul questions as features (keep full `probabilities`), train CatBoost on them; LLM proposes new questions from model errors. Expected value from a Score: `sum(k*v for k, v in a.probabilities.items())`.

## 16. Self-consistency

Repeated runs (15×) of a 14-noul insurance-claim rubric and a moderation Choice rubric vs Claude/GPT at various temperatures: System One values stay stable across runs; route the 0.3–0.7 band to review instead of forcing yes/no.

## Pairing with an LLM

- Noul "does this request contain more than one action?" → LLM splits it → System One evaluates each part.
- Choice says "general conversation" → hand off to a chat LLM. System One latency (~100 ms typical) is negligible next to it.
