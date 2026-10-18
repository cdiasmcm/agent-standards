# The Agent Standard — 8 blocks, 3 golden rules

**Every agent we build has the same 8 blocks.** Each block is a principle: *"every agent has a
defined …"*. The skeleton (`skeleton/`) gives each block a fixed place, so a new agent starts complete
and an existing one can be audited for what's missing (`deploy/audit-agent.ps1`).

> **How this framework is used.** agent-standards is a **reusable, read-only framework**. Agents call
> it to review their own patterns and adjust **their own folder structure**. The framework **must not
> change** because of any audit, review, creation or gate of another agent. No results, reports,
> registry rows or logs about other agents are ever written or committed here: they all go into that
> agent's own folder. The framework changes only when its maintainer deliberately improves the
> standard itself.

The detailed how-to for each block lives in the library files (FRAMEWORK, EVALS, PLATFORM,
PATTERNS, PRINCIPLES). This page is the version you explain to someone.

## The 3 golden rules (apply to every block)
1. **Simplest first.** Code before AI, one agent before many. (P14, P23)
2. **Prompts steer, code enforces.** Anything that must always hold lives in code, config or an approval. (P21)
3. **Autonomy is earned.** Dry run, then draft, then execute, loosening one permission at a time. (P25)

## The 8 blocks
| # | Block | Every agent has… | Where in the skeleton | How-to |
|---|-------|------------------|-----------------------|--------|
| 1 | **Purpose** | The right task (Green Light), a one-sentence job, a north-star metric and baseline, a risk tier, owners, and an AI-disclosure / data-protection check | `AGENT.md` §1 | FRAMEWORK D0–D1 · patterns O7, 11 |
| 2 | **Steps** | A process map with each step tagged code / LLM / workflow / agent / human, a stop condition with caps, an escalation rule, one agent unless a split is proven, and its instructions to the model (role, system prompt, examples) | `AGENT.md` §2 + `PROMPT.md` | FRAMEWORK D2–D5 · patterns 1–2, O1, O2, O11, O13 |
| 3 | **Input** | The standard input envelope, its own payload fields, and **input data-quality checks** (complete, valid, fresh, no duplicates, trusted vs untrusted), and its reference files (naming conventions, code lists, mappings) as versioned CSV/Markdown | `io/INPUT.md` + `knowledge/` | AGENT-IO · patterns 7–8, 18, O12 |
| 4 | **Output** | The standard output envelope, its own result fields, and **output data-quality checks** (schema-valid, required fields, grounded/cited) | `io/OUTPUT.md` | AGENT-IO · patterns O3 (L1), O8 |
| 5 | **Tools & Access** | Distinct, namespaced tools with read/write rights; its own identity with short-lived credentials; safe writes; the trifecta broken in code; vetted third-party tools | `AGENT.md` §5 | patterns 3, 18–20, O8 · PLATFORM §4b |
| 6 | **Controls** | A human-control level (H1–H5) per action, "must never" rules enforced in code, an autonomy plan, guardrails, and a kill switch | `AGENT.md` §6 | patterns 4, 21, O5, O10 · OWASP Agentic |
| 7 | **Evals & DQ** | Testable success criteria (5 layers), a golden set of real cases, graders, a baseline, stage thresholds, and data-quality metrics tracked over time | `evals/` | EVALS E1–E7 · patterns 10–17, O3, O4, O9 |
| 8 | **Operations** | Model and enforced budget, redacted logs, version history, rollout and rollback, a human-decision log, handoff files, and a registry entry | `AGENT.md` §8 + `CHANGELOG.md`, `DECISIONS.md`, `STATE.md`, `reviews/` | PLATFORM · patterns O6 · P24 |

## How much applies: the risk tier
Every field in the skeleton is tagged **[L]**, **[S]** or **[C]**:
- **Lite [L]**: internal, low risk, read-only, no personal data, reversible. Fill the [L] fields only.
- **Standard [S]**: the default for anything people rely on. Fill [L] + [S].
- **Critical [C]**: money, health, legal, personal data, irreversible or external actions. Fill everything.

**[if: …]** fields apply only when the condition holds (e.g. "if the agent writes"). Otherwise mark them
`N/A (reason)`.

## Lifecycle stages
`Design → MVP → Pilot → Scale`. Each stage raises the thresholds in block 7 (golden set: 20 real cases
at MVP, 100 at Pilot, 300 at Scale) and is passed through a gate recorded in `CHANGELOG.md`.

## Using it
- **New agent:** "Read START-HERE.md and create a new agent for <problem>". The advisor copies the
  skeleton and fills blocks 1 → 8 with you, one at a time.
- **Existing agent:** run `deploy/audit-agent.ps1 <agent folder>` for a block-by-block gap report,
  then ask the advisor for the judgment review.

---

## Where this comes from
The 8 blocks regroup the workbook's 12-part Agent PRD [WB §10] and add task selection, data quality,
the standard envelope and the registry. Sources: the book *Patterns for Building AI Agents* [ch.],
the AISA Bootcamp Workbook v8 [WB §], and external best practice [EXT] (researched 2026-10-16).

| Block | WB §10 PRD parts | Other support | Ours |
|-------|------------------|---------------|------|
| 1 Purpose | 1 Identity & job | Stanford WORKBank (H1–H5, zones); WB §1; book ch. 11; [EXT] EU AI Act Art. 50 disclosure | Risk tier |
| 2 Steps | 6 Control flow + stop condition | WB §10 decision matrix; book ch. 1–2; [EXT] OpenAI guide (escalation) | C/L/W/A/H tags |
| 3 Input | 2 Trigger, 3 Inputs & context | WB §16.2 brief; WB §15.7, §17.10 | Envelope; input DQ; data contracts |
| 4 Output | 7 Outputs | WB §11.2 programmatic scorers; WB §16.6 task states | Envelope; output DQ |
| 5 Tools & Access | 4 Tools + permission levels | Book ch. 19–20; WB §15.7, §17.10; [EXT] Anthropic tool design, agent identity, OWASP ASI04 | — |
| 6 Controls | 8 Guardrails | Book ch. 4, 18, 21; WB §3.0; [EXT] kill switch, OWASP Agentic Top 10 | — |
| 7 Evals & DQ | 9 Success criteria, 10 Failure modes | Book Part III; WB §11 | DQ metrics trended |
| 8 Operations | 5 Model & config, 11 State/memory, 12 Budget & observability | WB §10 PRD folder, §25.3, §7.7; [EXT] shadow/canary/rollback, OpenTelemetry GenAI | Registry; human-decision log |

**[EXT] sources:** [OWASP Top 10 for Agentic Applications 2026](https://genai.owasp.org/resource/owasp-top-10-for-agentic-applications-for-2026) ·
[OpenTelemetry GenAI agent spans](https://opentelemetry.io/docs/specs/semconv/gen-ai/gen-ai-agent-spans) (status to verify) ·
[Anthropic: Writing tools for agents](https://www.anthropic.com/engineering/writing-tools-for-agents) ·
[OpenAI: A practical guide to building agents](https://cdn.openai.com/business-guides-and-resources/a-practical-guide-to-building-agents.pdf) ·
[Shadow / canary / A-B for LLMs](https://tianpan.co/blog/2026-04-09-llm-gradual-rollout-shadow-canary-ab-testing) ·
[Prompt version rollback](https://www.arthur.ai/column/version-rollback-prompts-llm-agents) ·
[Agent identity and kill switch](https://virtualizationreview.com/articles/2026/09/15/ai-governance-expert-give-every-agent-its-own-identity-and-a-kill-switch.aspx) ·
[EU AI Act transparency, Aug 2026](https://www.cooley.com/news/insight/2026/2026-08-03-eu-ai-act-transparency-obligations-take-effect-2-august-2026).
The rollout thresholds in vendor blogs are illustrative starting points, not industry standards.
