# Decomposition Framework — from problem to one-job agents
> **Library file.** The standard itself is `STANDARD.md` (8 blocks, 3 golden rules) and the `skeleton/`. This file is the detailed how-to for blocks 1 Purpose and 2 Steps.

How we choose the task and break a solution into steps and agents, so that **each agent does one
job** and **no agent exists without evidence that it's needed**. Run it before any build, and again
whenever the solution grows.

Built on book patterns 1 (Whiteboard) and 2 (Evolve Your Architecture), Anthropic's *Building
Effective Agents* (the book's source for pattern 2), and the AISA Workbook v8 (**WB §x**: task selection
§1, agents §10, multi-agent §16). Everything else is **Our rule**.

```
D0 Select the task → D1 Outcome + tier → D2 Process map → D3 Classify each step
   → D4 Candidate agents → D5 Single-responsibility + sprawl checks → D6 Charter + success criteria
   → D7 Build order (one agent first) → Eval loop (EVALS.md E1–E7)
```

---

## D0. Select the task (pattern O7)
Before designing anything, check that this is the right task to automate. The H1–H5 scale and the
four zones come from the Stanford SALT Lab WORKBank study (*Future of Work with AI Agents*, 2025,
arXiv:2506.06576); the workshop form of it is described in WB §1.

| Task | Hrs/week | Desired H-level (H1–H5) | AI capability today (1–5) | Zone | Blocker |
|----------------|----------|-------------------------|---------------------------|------|---------|

- **H-levels:** H1 full automation · H2 AI executes, human reviews · H3 equal partner · H4 AI assists,
  human leads · H5 human essential.
- **Zones:** **Green Light** (wanted + capable) → build · **R&D Opportunity** (wanted, not yet capable) → experiment
  only, labeled as such · **Red Light** (capable, but kept human by choice) → don't automate, and name
  it · **Low priority** → drop.
- **Blocker:** data, sign-off or a system owned by someone else. A blocked Green Light task is a
  conversation to have, not a build to start.
- Score capability honestly, and attach a reason to each score. Inflated scores produce failed deployments.

**Exit:** the task is Green Light (or a labeled R&D experiment), with no open blockers, and its
H-level is known.

## D1. Outcome
Write one sentence: *"<Who> gets <what result> so that <business value>."*
Name the **north-star metric** (pattern 11) and the current baseline: how it's done today, how long it
takes, what it costs, how often it's wrong. For automations, "hours actually reclaimed per week vs.
estimate" is a good default.
**Set the risk tier** from the risk facts in `AGENT.md` §1 (the AI does this; the rule is in `STANDARD.md`). The tier sets how much of the standard applies, so small automations aren't
buried in process:

| Tier | When | What's required |
|------|------|-----------------|
| **Lite** | Internal, low risk, read-only, no personal data, reversible | D0–D7, charter core (identity & job, control flow + stop condition, outputs, guardrails, success criteria), eval plan E1–E4, security gate, registry entry |
| **Standard** | Default for anything users rely on | Everything for the target stage |
| **Critical** | Money, health, legal, personal data, irreversible or external actions | Standard + Safe Writes (O8) and HITL on every write, cross-family judge/auditor (O9) before MVP, red-team set in E2, Critical sign-off at every gate |

When in doubt, pick the higher tier.
**Exit:** one outcome sentence (the Role in `PROMPT.md`), one north star and one baseline (`evals/EVAL-PLAN.md`), one tier.

## D2. Process map
Map the end-to-end process as it runs today (or should run): **trigger → steps → final output.**
For each step note its input, output, data sources, the person or department doing it now, decision
points, and its H-level.
Keep asking "what are we missing?" (pattern 1). Keep each step small: one verb, one object.
**Exit:** numbered step list (table below).

| # | Step (verb + object) | Input | Output | Data / systems | Owner today | Decision? | H-level |
|---|----------------------|-------|--------|----------------|-------------|-----------|---------|

## D3. Classify each step: use the simplest thing that works
Give each step the **lowest** level that can do it reliably:

| Level | Use when | Example |
|-------|----------|---------|
| **C — Code** | Rules are fixed and fully known | Validate a date, call an API, compute a total, strip formatting |
| **L — Single LLM call** | One-shot language task, no tools, no loop | Classify a ticket, extract fields, summarize |
| **W — Workflow** | Known sequence of LLM/code steps (chain, route, parallel, evaluator-optimizer) | Draft → check → fix |
| **A — Agent** | Path can't be known in advance; needs tools in a loop and judgment | Investigate a discrepancy across systems |
| **H — Human** | H4/H5 steps: judgment, accountability, legal/ethical call, missing org context | Approve a payment |

Rules:
- **An agent is the most expensive and least predictable option.** Every **A** needs a written reason
  why C, L or W can't do the job. [WB §10 decision matrix]
- **Model tiering:** note per step the cheapest model tier likely to pass. An eval confirms it later
  (P14). Irreversible actions are gated in code whatever the model.

**Exit:** every step tagged C / L / W / A / H.

## D4. Candidate agents
Group only the **A** steps (and the L/W steps that serve them) using the book's criteria:
shared data source · same job role · same API · same process stage · same task type
(fetch vs. synthesize vs. act). Keep C steps as tools or plain code. Keep H steps as checkpoints.
For each candidate, write its input, tools, output and failure behavior ("draw before you build",
WB §12).

These are **candidates**. By default they are built as **one agent with distinct tools** (P23). A
candidate becomes its own agent only for one of these reasons [WB §10, §16.3, §16.5]:
1. **Independent subtasks** that can be evaluated on their own (and parallelism matters)
2. **Conflicting roles** that shouldn't share one prompt (e.g. producer vs. auditor, advocate vs. critic)
3. **Context overflow:** the combined work exceeds one context window
4. **Org or trust boundary:** different owner, permissions or company (across companies: A2A, O13)

A chain of dependent reasoning steps is **not** a reason to split.
**Exit:** candidate list, and for each one either "part of agent #1" or the reason (1–4) it stands alone.

## D5. Single-responsibility and sprawl checks
**Single responsibility.** Every agent must pass all of these. Any "no" means narrow it, or demote it
to a workflow.

| # | Test | Pass when |
|---|------|-----------|
| S1 | One mission | Mission fits one sentence: one verb + one object + for whom. No "and". |
| S2 | One output | Produces one primary output type with a defined schema |
| S3 | One owner | Maps to one business owner / process stage |
| S4 | Distinct tools | No two tools overlap in name, description or parameters; each tool has a precise description; tool-selection accuracy is checked by an eval (count alone is not the test, WB §16.3) |
| S5 | One judge | Success can be judged by one primary criterion (D6) |
| S6 | Testable alone | Can be evaluated in isolation with its own dataset |
| S7 | Clear boundary | Inputs come from, and outputs go to, named agents/steps/humans, via a brief (O12) |

Routers and coordinators count as agents too. Their one job is *routing*, *preparing context* or
*validating results*, never doing the work.

**Sprawl check (the opposite failure).** Every extra agent adds tokens (multi-agent runs about 15×
a chat), a round-trip of latency, and a place to lose context [WB §16.3, §16.5]. For every agent
beyond the first:

| # | Test | If it fails |
|---|------|-------------|
| X1 | Different owner, data or timing from its neighbor (not just always called in sequence)? | Merge them, or make one a workflow step |
| X2 | Does the hand-off keep the context the next agent needs (brief + shared store)? | Fix the brief (O12), or merge |
| X3 | Is it really an A (not code, a single LLM call, or a workflow)? | Demote it |
| X4 | Fewer agents than distinct owners and outputs? | Re-group (D4) |
| X5 | **Evidence:** a named failure of the single-agent version, and an eval at the **same budget** where the split wins? | Keep one agent |

X5 can't be answered on paper. Before build, mark it "pending". It must pass before the split ships.
**Exit:** agents that pass S1–S7 and X1–X4, with X5 planned.

## D6. Charter + success criteria
Fill the agent's skeleton (`skeleton/`: `AGENT.md`, `io/`, `evals/`), including trigger, control flow and
**stop condition** (O11), failure behavior, and the success criteria contract (5 layers). No charter,
no build. The charter is the agent's PRD. Together with STATE and DECISIONS files it makes the agent
handoff-ready (P24).

**Success criteria standard (every agent, every layer):**

| Layer | What it proves | How measured | Typical threshold |
|-------|----------------|--------------|-------------------|
| L1 Output contract | Output is well-formed and complete | Deterministic assert (schema, required fields) | 100% |
| L2 Task quality | It did its one job correctly | Binary LLM judge (other model family on high stakes) and/or SME label against golden set, per failure mode | Pilot ≥ human/current baseline |
| L3 Business impact | It moves the north star | Business metric (hours reclaimed, error cost, conversion…) | Target set in D1 |
| L4 Operations | It is viable at scale | p95 latency, cost per task, human-escalation rate, exit reasons (O11) | Budget set per solution |
| L5 Safety | It stays within bounds | Guardrail hits, out-of-scope actions, injection cases, trifecta check | 0 critical violations; every critical case passes individually |

Writing rules for criteria:
- Each criterion is a **yes/no statement** you can test: *"Agent X returns Y with Z in ≥ 95% of the golden set."*
- No "good", "accurate", or "fast" without a number, a dataset, and a method.
- Pin **criteria, not exact wording**, for generated text (WB §11.3).
- Prefer binary or categorical judging over 1–10 scores (pattern 17).
- Thresholds are set **per stage** (MVP / Pilot / Scale) and only go up.

Each criterion gets a grader and a dataset in the agent's `evals/EVAL-PLAN.md` (skeleton) (`EVALS.md` E1–E4).
**Exit:** a charter + eval plan per agent, with every criterion measurable.

## D7. Build order: one agent first
Build **one agent** first: the burning problem (pattern 2), with distinct tools. Before it touches
real data, **dry run** it (O10). Ship it to its MVP criteria. Split off a second agent only when D5's
X5 passes: a named failure, plus an equal-budget eval where the split wins. Add a router only when
there are two or more agents, and choose the topology deliberately (O13).
**Exit:** ordered build list. Agent #1 has a charter, an eval plan, a golden dataset (real cases),
a baseline, and a dry-run plan.

**Then build inside the eval loop:** iterate in CI (E5), release by stage gate (E6), learn from
production (E7). Loosen permissions one at a time as the agent proves itself (P25). See `EVALS.md`.

---

### Quick reference: signs an agent is doing more than one job
- Its prompt has sections for unrelated tasks
- It often picks the wrong tool, or two of its tools look alike
- Its eval set mixes unrelated case types
- Different stakeholders judge its output by different criteria
- One failure mode dominates for only one type of request

### Quick reference: signs you split too early
- Agents always run in the same order, with the same owner and the same data
- Hand-offs keep losing details, so the next agent re-asks or guesses
- Token cost jumped with no measured quality gain
- Nobody can name the failure the split was meant to fix
