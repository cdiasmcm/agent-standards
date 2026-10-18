# Patterns
> **Library file.** The standard itself is `STANDARD.md` (8 blocks, 3 golden rules) and the `skeleton/`. This file is the detailed how-to for every block; each pattern names the block it fills.

The "how". The 21 patterns of *Patterns for Building AI Agents* (Bhagwat & Gienow, Oct 2025) as short
citations (5 and 6 merged) with the *AISA Bootcamp Workbook v8* (Oct 2026,
**WB §x**), plus 13 patterns of our own (O1–O13). Principles they serve: see `PRINCIPLES.md`.

**Stage** says when the pattern becomes mandatory (our rule, not the sources'):
- **MVP**: before the first real user touches it
- **Pilot**: before more than a handful of real users, or any real business decision rides on it
- **Scale**: before broad rollout, multiple user types, or high volume
- **If**: only when the condition holds

| # | Pattern | Part | Stage |
|---|---------|------|-------|
| 1 | Whiteboard Agent Capabilities | Configure | MVP |
| 2 | Evolve Your Agent Architecture | Configure | MVP |
| 3 | Dynamic Agents | Configure | If: several user types |
| 4 | Human-in-the-Loop | Configure | MVP if risky actions, else Pilot |
| 5–6 | Parallelize Carefully & Share Context (merged) | Context | If: subagents |
| 7 | Avoid Context Failure Modes | Context | Pilot |
| 8 | Compress Context | Context | If: long-running tasks |
| 9 | Feed Errors Into Context | Context | MVP |
| 10 | List Failure Modes | Evaluate | Pilot |
| 11 | List Critical Business Metrics | Evaluate | MVP |
| 12 | Cross-Reference Failure Modes & Metrics | Evaluate | Scale |
| 13 | Iterate Against Your Evals | Evaluate | Pilot |
| 14 | Create an Eval Test Suite | Evaluate | Pilot |
| 15 | Have SMEs Label Data | Evaluate | Pilot |
| 16 | Create Datasets from Production Data | Evaluate | Scale |
| 17 | Evaluate Production Data | Evaluate | Scale |
| 18 | Prevent the Lethal Trifecta | Secure | MVP (always) |
| 19 | Sandbox Code Execution | Secure | If: agent runs code |
| 20 | Granular Agent Access Control | Secure | Pilot |
| 21 | Agent Guardrails | Secure | Pilot if user-facing |
| O1 | Decompose the Process (ours) | Configure | MVP (before build) |
| O2 | Single-Responsibility Agent (ours) | Configure | MVP |
| O3 | Success Criteria Contract (ours) | Evaluate | MVP |
| O4 | Eval Lifecycle (ours) | Evaluate | MVP (E1–E6), Pilot+ (E7) |
| O5 | Standard Hooks (ours) | Secure / Platform | MVP: pre-tool + post-model; Pilot: all |
| O6 | AI & Tool Gateways (ours) | Platform | Pilot (Critical tier: MVP) |
| O7 | Task Selection (ours) | Configure | MVP (before D1) |
| O8 | Safe Writes (ours) | Secure | MVP if the agent writes anything |
| O9 | Producer / Auditor (ours) | Evaluate | Pilot; Critical tier: MVP |
| O10 | Dry Run First (ours) | Evaluate | MVP if the agent acts on real data |
| O11 | Stop Conditions & Mission Guard (ours) | Configure | MVP |
| O12 | Delegation Brief (ours) | Context | If: subagents |
| O13 | Topology Choice (ours) | Platform | If: more than one agent |

---


## Source patterns (book, updated with the workbook)
Short citations only: pattern name, one-line idea, source, and **how we apply it** (our rule). For the
full reasoning and examples, read the sources (see `reference/README.md`).

| # | Pattern [source] | One-line idea | How we apply it (our rule) |
|---|------------------|---------------|----------------------------|
| 1 | Whiteboard Agent Capabilities [ch. 1; WB §12] | List every capability, group them by data, role or process step, then rank | Groups are *candidate* agents only (FRAMEWORK D4); write input, tools, output and failure behavior for each |
| 2 | Evolve Your Agent Architecture [ch. 2; WB §16.3–16.5] | Solve one burning problem first; add, split or route agents as needs appear | One agent first; a split needs a named failure and an equal-budget eval (P23, X5) |
| 3 | Dynamic Agents [ch. 3] | Configure prompt, tools, memory and model at runtime by user or context | Runtime config table per signal; evals cover each variant |
| 4 | Human-in-the-Loop [ch. 4; WB §1.2] | Put humans where risk or judgment requires; prefer non-blocking review | H-level (H1–H5) per action, checkpoint type, named reviewer, capacity checked |
| 5–6 | Parallelize Carefully & Share Context [ch. 5–6; WB §16.2–16.3] | Parallelize only independent work; hand off enough context | Delegation brief (O12); dependent reasoning stays in one thread |
| 7 | Avoid Context Failure Modes [ch. 7; WB §4] | Too much or wrong context degrades results (poisoning, distraction, confusion, clash, rot) | Context budget per call; compact, offload, isolate, retrieve; inject facts the model can't know |
| 8 | Compress Context [ch. 8; WB §4] | Summarize history on long tasks | Compression trigger + a list of what must never be summarized away |
| 9 | Feed Errors Into Context [ch. 9] | Give the agent its errors so it can self-correct | Errors returned to the model; retry cap; recurring errors promoted to the prompt |
| 10 | List Failure Modes [ch. 10; WB §11.5] | Know *why* the agent fails, not just that it fails | 3–7 named failure modes; diagnose prompt / model / tool / data first |
| 11 | List Critical Business Metrics [ch. 11] | Tie quality to business outcomes | One north star + baseline + target (block 7, `evals/EVAL-PLAN.md`) |
| 12 | Cross-Reference Failure Modes & Metrics [ch. 12] | Fix the failures that move the north star most | Failure mode × north star view drives the backlog (Scale) |
| 13 | Iterate Against Your Evals [ch. 13; WB §11.4] | Benchmark every change | Pinned baseline in CI; model choice is an eval decision |
| 14 | Create an Eval Test Suite [ch. 14; WB §11.1–11.3] | Expected behaviors as a test suite with graders | Golden set of real cases, criteria not exact wording, capability + safety families |
| 15 | Have SMEs Label Data [ch. 15; WB §11.2] | Domain experts define ground truth | SMEs label and calibrate the LLM judge |
| 16 | Create Datasets from Production Data [ch. 16; WB §11.3] | Turn traces into versioned datasets | PII scrubbed and reuse rights checked before a case enters |
| 17 | Evaluate Production Data [ch. 17; WB §11.2] | Judge a sample of live traffic | Binary/categorical scores; judge from a different model family on high stakes |
| 18 | Prevent the Lethal Trifecta [ch. 18; WB §17.4] | Private data + untrusted content + an outbound channel = exfiltration risk | Remove a leg **in code**; filters only as backup; injection cases in evals |
| 19 | Sandbox Code Execution [ch. 19; WB §17.4] | Run agent code in isolation | Real sandbox spec (not a default container), no secrets inside |
| 20 | Granular Agent Access Control [ch. 20; WB §17.10] | Finer-grained access for agents than for people | Per-tool permissions, vault-issued scoped credentials, plan/read-only mode |
| 21 | Agent Guardrails [ch. 21; WB §17.10] | Live input and output checks | Tool allow-lists, argument schemas, redacted logs, security scan per release |

---

## Our patterns

### O1. Decompose the Process
- **Problem:** agents get scoped from a wishlist or a vague goal, so steps that need code, a single
  LLM call, or a human end up inside an agent.
- **Pattern:** run `FRAMEWORK.md` D0–D4. Select the task (O7), write the outcome and north star, map
  the process step by step, tag each step C / L / W / A / H using the lowest level that works, and
  group only the A steps into candidate agents.
- **Builds on:** patterns 1, 2, 4.
- **Checklist:** ☐ task selected (D0) ☐ outcome + north star + baseline ☐ numbered process map ☐ every step tagged ☐ every A has a written reason

### O2. Single-Responsibility Agent
- **Problem:** agents drift into doing several jobs. Tool errors rise, evals blur, and nobody can say
  whether the agent works. The opposite failure is splitting too early.
- **Pattern:** every agent passes the D5 test (S1–S7: one mission, one output, one owner, distinct
  tools, one judge, testable alone, clear boundary) **and** the sprawl check (X1–X5, including an
  equal-budget benchmark against one agent). Routers and coordinators have one job too.
- **Builds on:** patterns 2, 5–6; P23.
- **Checklist:** ☐ S1–S7 pass ☐ X1–X5 pass ☐ re-tested whenever a tool or task is added

### O3. Success Criteria Contract
- **Problem:** "it works" means something different to each stakeholder, so there's no ship / no-ship line.
- **Pattern:** each agent's `evals/EVAL-PLAN.md` (skeleton block 7) holds criteria across five layers:
  L1 output contract, L2 task quality, L3 business impact, L4 operations, L5 safety. Each is a yes/no
  statement with metric, method, dataset, and MVP / Pilot / Scale thresholds. One is primary. The
  criteria are the eval set. [WB §10, §11.3]
- **Checklist:** ☐ all 5 layers ☐ every criterion testable ☐ baseline measured ☐ primary named ☐ thresholds per stage

### O4. Eval Lifecycle
- **Problem:** the eval patterns are separate chapters with no order. Teams build first and bolt evals on later.
- **Pattern:** follow `EVALS.md` E1–E7 with one `evals/EVAL-PLAN.md` (skeleton) per agent.
- **Builds on:** patterns 10–17, O9, O10.
- **Checklist:** ☐ eval plan per agent ☐ dataset meets stage minimum ☐ judge calibrated ☐ CI blocks regressions ☐ critical cases pass individually ☐ gate record signed ☐ production loop live (Pilot+)

### O5. Standard Hooks
- **Problem:** guardrails, approvals, error handling and logging are rebuilt per agent, or left to the
  prompt, where the model can ignore them (P21).
- **Pattern:** five standard interception points: **pre-model, pre-tool, post-tool, post-model,
  session-end** (`PLATFORM.md` §4). Hooks are code, so they don't depend on the model behaving.
- **Builds on:** patterns 4, 7, 8, 9, 18, 20, 21; O8.
- **Checklist:** ☐ pre-tool permission + HITL + safe-write hook ☐ post-model guard + schema check ☐ post-tool error feedback ☐ session-end trace export ☐ from the shared library

### O6. AI & Tool Gateways
- **Problem:** each agent holds its own keys, picks its own model and calls tools directly. Nobody can
  enforce budgets, permissions or the trifecta rule across the portfolio.
- **Pattern:** every model call goes through an **AI gateway** (routing, fallback, key custody, rate
  limits, **enforced** cost budgets, logging). Every tool call goes through a **tool/MCP gateway**
  (auth, per-tool permissions, audit, trifecta enforcement). A usage dashboard only observes;
  enforcement lives here or at the provider. [WB §7.7] `PLATFORM.md` §5.
- **Checklist:** ☐ no provider keys in agents ☐ all model calls routed ☐ all tool calls routed ☐ budgets enforced per agent ☐ audit log on

### O7–O13. Our patterns informed by the workbook
Short form: our rule, the check, and the source that informed it. These practices are widely used; the
wording and the checks are ours.

| # | Pattern | Our rule | Check | Informed by |
|---|---------|----------|-------|-------------|
| O7 | **Task Selection** | Before design, score each task on how much people want it automated (H1–H5) and how capable AI is today. Build only tasks that are both wanted and feasible; name the ones people choose to keep human; record blockers | Task scored, zone recorded, blockers named (FRAMEWORK D0) | Stanford SALT Lab, *Future of Work with AI Agents* (WORKBank, 2025, arXiv:2506.06576); WB §1 |
| O8 | **Safe Writes** | Every write is previewed before it's committed, limited by the service itself, protected against retries (idempotency key), reversible (a named undo action) or approved by a person, and logged. Write down the **unattended-failure test**: what happens if it misfires with nobody watching? | Each write tool has these six controls (PLATFORM §4b) | General API engineering practice; MCP spec security guidance; WB §15.7 |
| O9 | **Producer / Auditor** | High-stakes outputs are checked automatically by a read-only reviewer from a different model family | Auditor family ≠ producer family; runs automatically | WB §5 |
| O10 | **Dry Run First** | Before acting on real data, the agent reports what it would do; a person checks it; the differences become eval cases | Dry run reviewed; deltas in the golden set | WB §10 |
| O11 | **Stop Conditions & Mission Guard** | A written "done when", caps on iterations, time and spend, the exit reason logged, and a limit on how far the agent may change its own plan | All four present in `AGENT.md` §2 | WB §10 |
| O12 | **Delegation Brief** | Every hand-off states objective, output format, tools/sources and boundaries; no credentials in briefs; results validated by the caller | Brief template; result validation step | Anthropic multi-agent research system (2025); WB §16.2 |
| O13 | **Topology Choice** | Hierarchical by default; peer-to-peer only with a validator; fixed steps in code; swarms need a durable queue; agent-to-agent protocol (A2A) only across trust boundaries | Topology named with a reason | Google Research, *Towards a Science of Scaling Agent Systems* (2026); A2A spec; WB §16 |

## Watch list (not patterns yet)
- **Simulations** to tune prompts and retrieval settings automatically, once the eval harness is strong. [Book 22]
- **Agent learning** so the 1,000th task goes better than the first. Corrections written back into
  skills are the current form. [Book 22; WB §25.6]
- **Synthetic evals** written by eval-writing agents. [Book 22]
