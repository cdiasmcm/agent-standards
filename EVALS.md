# Eval Lifecycle — E1 to E7
> **Library file.** The standard itself is `STANDARD.md` (8 blocks, 3 golden rules) and the `skeleton/`. This file is the detailed how-to for block 7 Evals & DQ.

How every agent gets evaluated, from before the first prompt to production. Each step has an exit;
don't move on until it's met. Sources: book Part III (ch. 10–17, shown as pattern numbers) and the
AISA Workbook v8 §10–11, §16.10 (**WB §x**). The ordering into steps is **Our rule**, as is anything
else marked that way.

```
Before build:  E1 Failure modes → E2 Golden dataset → E3 Graders → E4 Baseline
During build:  E5 Iterate in CI  ⟲
Release:       E6 Stage gate (MVP → Pilot → Scale)
In production: E7 Production loop → feeds E1 / E2 ⟲
```

Each agent records its answers in `evals/EVAL-PLAN.md` and `evals/GOLDEN-SET.md` (from the skeleton), next
to its `AGENT.md`. The success criteria **are** the eval set: spec and test are the same
artifact. [WB §11.3]

---

## E1. Failure modes (pattern 10)
Before building, list **why** this agent could fail, not just that it could. Typical buckets are
data quality (wrong or missing input), reasoning, and domain-rule application. Aim for 3–7, each with
a definition and one example. Add to the list whenever SMEs find a new one (E7).
**Exit:** failure-mode table in the eval plan; each mode linked to a success criterion.

## E2. Golden dataset (patterns 14, 15, 16)
Input / expected-criteria pairs + metadata, labeled by **subject-matter experts, not engineers**.
- **Sources, in order of preference:** real historical cases and production transcripts → **dry-run
  deltas** (O10) → SME-written cases → synthetic cases only to fill gaps. A small real set beats a
  large invented one. [WB §11.3]
- **Before a case enters the set:** strip names, emails, account numbers and other personal data,
  and confirm you have the right to reuse it. [WB §11.3]
- **Coverage ("cover the ugly"):** every failure mode, normal cases, edge cases, out-of-scope requests
  (should refuse or hand off), "I don't know" cases, and red-team cases (prompt injection,
  tool-result injection, PII) for L5. Mark the **safety-critical** cases.
- **Expected output = criteria, not exact words** for generated text ("mentions the refund window;
  doesn't promise a date; escalates if the customer is angry").
- **Labels:** overall grade (pass/fail), failure-mode tag, optional comment (pattern 15).
  Use 2+ labelers on a sample and measure agreement.
- **Size per stage (Our rule, starting minimums):** **MVP ≥ 20 real cases** · Pilot ≥ 100 · Scale ≥
  300, with ≥ 5 cases per failure mode. Real share goes up at every stage. (WB §11 and Anthropic suggest
  starting with 10–50 cases drawn from real usage and real failures.)
- **Every production failure becomes a case.** Fixing a bug without adding its case invites the
  regression back.
- **Version it.** Every eval result names the dataset version.

**Exit:** versioned, PII-scrubbed dataset meets the stage minimum, covers every failure mode, and
marks its critical cases.

## E3. Graders (patterns 14, 17)
Every success criterion in the charter gets exactly one grader:

| Layer | Grader |
|-------|--------|
| L1 Output contract | Deterministic assert (schema, required fields, format) |
| L2 Task quality | LLM-as-judge with **binary or categorical** scores (not 1–10), and/or SME review |
| L3 Business impact | Business metric from the system of record |
| L4 Operations | Tracing: latency, cost per task, escalation rate, exit reason (O11) |
| L5 Safety | Guardrail logs + red-team cases in the dataset + security scanner (pattern 21) |

- **Prefer code graders** wherever the answer can be checked by rule. They're cheaper and never drift.
- **Judge prompt:** a rubric, not a feeling: one criterion per judge, named levels, an example per level.
- **Judge family (WB rule):** on high stakes, the judge comes from a **different model family** than the
  agent, because same-family judges share its blind spots. Watch for **confidence bias** (a judge grading
  confident-sounding answers up). Same rule as the auditor in O9. [WB §11.2, §5]
- **Calibrate the judge (Our rule):** run it on SME-labeled cases ("judge the judge"). Trust it only
  once its agreement with SMEs is ≥ 90% (or a set Cohen's κ). Re-calibrate when the judge model changes.
- **Two eval families:** **capability** (can it do the job?) and **behavioral/safety** (refusals,
  hallucination, bias, injection resistance). A production agent needs both. [WB §11.1]
- **Multi-agent systems:** score routing accuracy, context fidelity at hand-off, tool use, error
  propagation, latency, cost and security **separately**. A single end-to-end pass rate hides which
  one is breaking. [WB §16.10]

**Exit:** grader per criterion; judge family and calibration recorded.

## E4. Baseline (pattern 11)
Run the current process (human team, existing system, or the simplest prompt) on the same dataset
with the same graders. This is the bar the agent must beat, and it sets realistic thresholds. For a
split into several agents, the baseline is the **single-agent version at the same budget** (FRAMEWORK X5).
**Exit:** baseline score per criterion; stage thresholds in the charter confirmed or adjusted.

## E5. Iterate in CI (pattern 13)
Benchmarks are what turn experiments into engineering.
- Every change to prompt, tools, retrieval, model, or code runs the eval suite automatically, against
  a **pinned baseline**. A drop blocks the change until explained.
- **Two suites (Our rule):**
  - *Regression suite*: cases the agent already passes. Must stay green.
  - *Capability suite*: hard cases it doesn't pass yet. These measure progress.
  Cases graduate from capability to regression once they pass reliably.
- **Consistency (Our rule):** outputs are nondeterministic, so run each case k times (k = 3 to start).
  Report pass^k for regression and pass@k for capability. One run is a coin flip. [WB §11.5]
- **Read per-case results, not only the average.** A failure on a safety-critical case can't hide
  inside a good mean.
- **Model choice is an eval decision:** confirm quality on the golden set, run the same cases on
  candidate models, then pick the **cheapest model that clears the bar**. Score quality first and
  price second. [WB §11.4b]
- **Model upgrades and deprecations** by the provider re-run everything (P12).
- Engineers work toward a numeric target on a failure-mode-specific dataset.

**Exit:** suites run on every change; results stored per version.

## E6. Stage gate (patterns 12, 13)
Release to the next stage only when:
- every criterion meets that stage's threshold from the charter, on the current dataset version, at pass^k;
- **every safety-critical case passes individually**;
- the security scan for user-facing features is clean (pattern 21);
- for multi-agent systems, X5 has passed (the split beats one agent at equal budget).

The business owner (PM role) makes the go-live call after reviewing results against past production
data (pattern 12). Go-live means a small slice first, then widen while watching. [WB §11.5]
**Exit:** signed gate record: date, dataset version, scores, critical-case results, decision, approver.

## E7. Production loop (patterns 12, 15, 16, 17)
Real users drift away from the test set (new users, new request types), so the evals have to follow.
1. **Trace** every run: input, tool calls, output, cost, exit reason. Redact secrets and personal data;
   restrict who can read traces. [WB §17.10]
2. **Sample** live traffic at a set rate and score it with the calibrated LLM judge (binary/categorical).
3. **Flag** traces from guardrail hits, judge failures, user thumbs-down, and out-of-scope usage.
4. **Diagnose:** use the trace to assign each failure to **prompt, model, tool or data** before
   changing anything. A low score is a symptom; the log tells you where it comes from. [WB §11.5]
5. **SME review** of flagged + sampled traces, with the full trace shown as the user saw it. Tag the
   failure mode, or add a new one.
6. **Cross-reference** failure modes against the north-star metric. The costliest one is the next
   target (pattern 12).
7. **Feed back:** reviewed traces become new dataset cases (PII-scrubbed, new version) → back to E1/E2.

**Exit (Scale):** loop running on a fixed cadence, owner named, dataset growing from production.

---

## Minimum by stage (summary)
| Step | MVP | Pilot | Scale |
|------|-----|-------|-------|
| E1 Failure modes | Drafted | SME-validated | Updated from production |
| E2 Dataset | ≥ 20 real cases (incl. dry-run deltas), PII-scrubbed | ≥ 100 | ≥ 300, mostly production |
| E3 Graders | L1 asserts + L2 judge | Judge calibrated ≥ 90%; cross-family on high stakes | Re-calibrated per model change |
| E4 Baseline | Measured | — | — |
| E5 CI | Manual run per change, per-case review | Automated, regression blocks | Automated + pass^k |
| E6 Gate | MVP thresholds + critical cases pass | Pilot thresholds + security scan | Scale thresholds |
| E7 Production loop | — | Sampling + SME review | Full loop + versioned datasets |
