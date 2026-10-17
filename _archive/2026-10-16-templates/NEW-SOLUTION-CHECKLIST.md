# New Agentic Solution — Standards Review

Copy this file to `reviews/<solution>-YYYY-MM-DD.md` and fill it in. Pattern numbers refer to `PATTERNS.md`.
Mark each item ✅ done · ⚠️ partial · ❌ missing · N/A (with reason).

**Solution:**  **Owner:**  **Date:**  **Target stage:** MVP / Pilot / Scale

---

## 0. Scope
- Problem being solved (one sentence):
- Task selection (D0, O7): zone Green / R&D · desired H-level · capability _/5 · blockers:
- Users and user types:
- Stack / framework / model(s):
- Risk tier (FRAMEWORK D1): Lite / Standard / Critical. Critical means money, health, legal, personal data, or irreversible/external actions. The tier decides which rows below are required.
- North-star metric (11):

## 1. Design gate (MVP)
| # | Check | Status | Evidence / note |
|---|-------|--------|-----------------|
| O7 | Task is Green Light (or a labeled R&D experiment); blockers cleared; Red Light tasks named | | |
| O1 | Decomposition done (FRAMEWORK D1–D4): outcome, process map with H-levels, every step tagged C/L/W/A/H | | |
| O1 | Every A (agent) step has a written reason why code / LLM call / workflow can't do it | | |
| O2 | Starts as **one agent**; every extra agent has a D4 reason (1–4) and X5 evidence planned | | |
| O2 | Every agent passes S1–S7 (incl. S4 distinct tools) and sprawl check X1–X4 | | |
| O3 | Every agent has a charter (`AGENT-CHARTER.md`) with trigger, stop condition, failure behavior, 5-layer success contract and a primary criterion | | |
| O3 | Baseline measured; thresholds set for the target stage | | |
| O11 | Stop condition, iteration/time/budget caps, exit-reason logging, plan-change limit | | |
| O13 | If several agents: topology named with a reason; A2A only across trust boundaries | | |
| P24 | Handoff files exist: charter, STATE.md (Resume here), DECISIONS.md | | |
| 1 | Capability list → grouped → candidate agents with tools, ranked | | |
| 3 | If several user types: runtime config table (prompt/tools/memory/model per signal) | | |
| 4 | Every action has an H-level and a checkpoint type; reviewer named; capacity vs. volume estimated | | |

## 2. Context gate (MVP → Pilot)
| # | Check | Status | Evidence / note |
|---|-------|--------|-----------------|
| 5–6 | Parallel branches proven independent, or run linearly | | |
| O12 | Delegation briefs: objective, output format, tools/sources, boundaries; no credentials | | |
| 7 | Context budget per call; top-K retrieval; large outputs offloaded to files; context file curated | | |
| 7 | Poisoning / distraction / confusion / clash / rot reviewed; date/timezone/business rules injected | | |
| 8 | Long tasks: compression trigger + never-summarize list | | |
| 9 | Tool/code errors fed back to the model; retry cap; recurring errors promoted to prompt | | |

## 3. Evaluation gate
| # | Check | Status | Evidence / note |
|---|-------|--------|-----------------|
| O4 | Every agent has an `EVAL-PLAN.md` (EVALS E1–E7) | | |
| O10 | Dry run done on real data before acting; deltas added as eval cases | | |
| O4 | Golden dataset meets the stage minimum (20 real / 100 / 300), PII-scrubbed, covers every failure mode, critical cases marked | | |
| O4 | LLM judge calibrated against SME labels (≥ 90%); different model family on high stakes | | |
| O9 | High-stakes outputs checked by a read-only, cross-family auditor (Critical tier: before MVP) | | |
| O4 | Capability + behavioral/safety evals; multi-agent dimensions scored separately (if several agents) | | |
| O4 | Regression suite blocks changes; pass^k; critical cases pass individually | | |
| 13 | Model choice backed by an eval (cheapest passing model) | | |
| O4 | Stage gate record signed (date, dataset version, scores, critical cases, approver) | | |
| O4 | Production loop live: trace → sample → judge + SME → diagnose (prompt/model/tool/data) → new cases (Pilot+) | | |
| 10 | 3–7 named failure modes, each with a definition and example | | |
| 11 | Accuracy + domain outcome + human-baseline metrics; target set | | |
| 15 | SMEs named; label schema; review UI shows full trace | | |
| 12 | Failure-mode × north-star view drives the backlog (Scale) | | |
| 16 | Tracing on; versioned datasets built from production (Scale) | | |
| 17 | LLM judge on sampled live traffic, binary/categorical scores (Scale) | | |

## 4. Security gate (MVP, always)
**Lethal trifecta table (18)**

| Leg | What this solution has | Removed in code? How? |
|-----|------------------------|-----------------------|
| Private data access | | |
| Untrusted content exposure (incl. what read tools bring back) | | |
| External communication / exfiltration | | |

| # | Check | Status | Evidence / note |
|---|-------|--------|-----------------|
| P21 | Every "must never" rule is enforced in code / config / approval, not only in a prompt | | |
| 18 | At least one trifecta leg removed **in code**; filters/tags only as backup; injection cases in evals | | |
| O8 | Every write tool: preview → commit, service-side ceiling, idempotency key, compensating action or human gate, audit record, unattended-failure answer | | |
| 19 | Generated code runs only in a sandbox meeting pattern 19's spec (not a default container), no secrets | | |
| 20 | Tool × permission matrix; vault-issued scoped credentials; secret scanner; plan (read-only) mode | | |
| 21 | Input/output guards; tool allow-list + argument schemas; redacted, access-controlled logs | | |
| 21 | Security scanner run on this release (user-facing) | | |
| P25 | Autonomy plan: dry run → draft-only → loosen one permission at a time | | |

## 5. Platform gate (`PLATFORM.md`; Lite: registry row only)
| # | Check | Status | Evidence / note |
|---|-------|--------|-----------------|
| P18 | Every agent has a row in `REGISTRY.md` with business + tech owner | | |
| P18 | Reuse check done: existing tools, guardrails, judges and harness used, or a reason to build new | | |
| P18 | Agent-to-agent hand-offs use typed, versioned contracts and briefs | | |
| O5 | Standard hooks wired in: pre-model, pre-tool, post-tool, post-model, session-end | | |
| O6 | All model calls go through the AI gateway; no provider keys in agents; budgets enforced (not just observed) | | |
| O6 | All tool calls go through the tool/MCP gateway with per-tool permissions and audit | | |
| P18 | Durable queue for multi-agent jobs; idempotent, authenticated triggers/webhooks | | |
| P18 | Unattended runs hosted off the laptop; prompts, tools, contracts and datasets versioned | | |

## 6. Scale readiness
| Check | Status | Note |
|-------|--------|------|
| Every gate for the target stage is ✅ or N/A with a reason | | |
| Cost and latency per task measured and budgeted | | |
| Eval suite re-run on model upgrade; scaffolding the new model no longer needs is removed (P12) | | |
| Every multi-agent split proven at equal budget (X5); otherwise merged back | | |
| Architecture can add an agent without rewriting others (P2) | | |

## Verdict
- **Ready for:** MVP / Pilot / Scale / Not yet
- **Blocking gaps (fix before next stage):**
- **Non-blocking improvements:**
