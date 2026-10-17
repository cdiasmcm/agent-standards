# Block 7 — Evals & Data Quality

*How we prove the agent works, before and after every change.* How-to: `EVALS.md` E1–E7.
The success criteria below **are** the test: each one is a yes/no statement with a metric, a method, a
dataset and a threshold per stage. Thresholds only go up.

## Failure modes (E1)
| ID | Failure mode | Definition | Example | Tier |
|----|--------------|------------|---------|------|
| FM1 | TODO | TODO | TODO | [L] |

## Success criteria (5 layers)
| ID | Layer | Criterion (yes/no statement) | Metric | Method | MVP | Pilot | Scale | Tier |
|----|-------|------------------------------|--------|--------|-----|-------|-------|------|
| SC1 | L1 Output contract | Output passes every check in `io/OUTPUT.md` | % valid | Deterministic check | 100% | 100% | 100% | [L] |
| SC2 | L2 Task quality | TODO | TODO | TODO (binary judge / SME) | TODO | TODO | TODO | [L] |
| SC3 | L3 Business impact | TODO | TODO | TODO | TODO | TODO | TODO | [S] |
| SC4 | L4 Operations | p95 latency ≤ TODO s; cost per task ≤ TODO; escalation rate ≤ TODO % | TODO | Tracing | TODO | TODO | TODO | [S] |
| SC5 | L5 Safety | Zero critical violations; every critical and injection case passes individually | count | Guardrail logs + red-team cases | 0 | 0 | 0 | [L] |

- [L] **Primary criterion:** TODO (the one number that says it does its job)
- [L] **Baseline** (current process or human on the same cases): TODO

## Data quality metrics (tracked over time)
- [L] **Input DQ pass rate** (checks in `io/INPUT.md`): target TODO %
- [L] **Output DQ pass rate** (checks in `io/OUTPUT.md`): target TODO %
- [S] **Where they're tracked and who watches them:** TODO

## Graders (E3)
- [L] **Deterministic checks** for everything that can be checked by rule: TODO
- [L] **LLM judge:** model TODO · family TODO (on high stakes, different from the agent's family) · scoring binary / categorical
- [S] **Judge calibrated against SME labels:** agreement TODO % (target ≥ 90%), date TODO
- [S] **SME reviewers:** TODO
- [if: high stakes] **Independent auditor** (read-only, different model family, runs automatically): TODO

## Running the evals (E5–E6)
- [L] **Runs on every change** to prompt, model, tools or data: TODO (how)
- [S] **Each case run k times** (k = 3 to start); critical cases reviewed one by one: TODO
- [S] **Model choice:** candidates compared on the golden set; cheapest passing model = TODO
- [S] **Rollback trigger tied to evals** (e.g. canary quality below baseline by X): TODO

## Production loop (E7)
- [S] **Sample rate for the judge on live traffic:** TODO %
- [S] **Flags reviewed:** guardrail hits, judge failures, thumbs-down, out-of-scope, human overrides: TODO
- [S] **Diagnosis recorded as prompt / model / tool / data** before fixing: TODO
- [S] **New cases added to `GOLDEN-SET.md`** (PII scrubbed): TODO (cadence)
