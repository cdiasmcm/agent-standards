# Eval Plan — <Agent name>

One per agent, stored next to its `AGENT-CHARTER.md` in the solution's own folder.
Steps follow `EVALS.md` (E1–E7).

**Solution:**  **Agent:**  **Eval owner:**  **SME(s):**  **Current stage:** MVP / Pilot / Scale  **Date:**

## E1. Failure modes
| ID | Failure mode | Definition | Example | Linked criterion (charter §6) |
|----|--------------|------------|---------|-------------------------------|
| FM1 | | | | |

## E2. Golden dataset
| Item | Value |
|------|-------|
| Location / tool | |
| Current version | v_ |
| Size (stage minimum: 20 real / 100 / 300) | |
| Mix: real / dry-run deltas / SME-written / synthetic | _% / _% / _% / _% |
| PII scrubbed + reuse rights confirmed | ☐ / ☐ |
| Safety-critical cases (must pass individually) | _ cases: … |
| Cases per failure mode (≥ 5) | FM1 _ · FM2 _ · … |
| Edge / out-of-scope / "I don't know" / red-team (injection) cases | _ / _ / _ / _ |
| Label schema | pass/fail · failure-mode tag · comment |
| Labeler agreement (sample) | _% |

## E3. Graders
| Criterion (charter §6) | Layer | Grader type | Grader / judge prompt ref | Scoring |
|------------------------|-------|-------------|---------------------------|---------|
| SC1 | L1 | Assert | | pass/fail |
| SC2 | L2 | LLM judge / SME | | pass/fail or category |

**Judge:** model _ (family _; must differ from the agent's family _ on high stakes) · calibration cases _, agreement with SMEs _% (target ≥ 90%), date _
**Eval families covered:** capability ☐ · behavioral/safety ☐ · multi-agent dimensions (routing, hand-off fidelity, error propagation) ☐ N/A ☐

## E4. Baseline
| Criterion | Baseline source (human / current system / simple prompt) | Score | Date |
|-----------|----------------------------------------------------------|-------|------|

## E5. CI
- Trigger: every change to prompt / tools / retrieval / model / code ☐
- Regression suite: _ cases, pass^k with k = _. **Blocks merge on drop** ☐
- Capability suite: _ cases, pass@k
- Per-case review of critical cases on every run ☐
- Model choice: candidates compared on this set; cheapest passing model = _
- Results stored at:

## E6. Stage gate log
| Date | Stage | Dataset version | Scores vs thresholds | Critical cases | Security scan | Decision | Approver |
|------|-------|-----------------|----------------------|----------------|---------------|----------|----------|

## E7. Production loop
| Item | Value |
|------|-------|
| Tracing tool | |
| Sample rate for LLM judge | _% |
| Flag sources | guardrails ☐ judge fail ☐ thumbs-down ☐ out-of-scope ☐ |
| Traces redacted (secrets, PII) + access restricted | ☐ |
| Failure diagnosis recorded as prompt / model / tool / data | ☐ |
| SME review cadence / volume | |
| Failure mode × north-star view at | |
| Last dataset refresh | |
