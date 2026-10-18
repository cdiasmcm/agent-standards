# AGENT STANDARDS BUNDLE

> Generated 2026-10-17 by deploy/build-bundle.ps1. Do not edit; edit the source files and rebuild.
> This single file contains all the standards. Where the text says "read <FILE>.md", use that file's section below (headed "FILE: <name>").
> Sections named skeleton/... are the templates for a new agent: recreate them as separate files in the agent's folder.

## Contents
- FILE: START-HERE.md
- FILE: AUDIT.md
- FILE: CREATE.md
- FILE: STANDARD.md
- FILE: AGENT-PROMPT.md
- FILE: AGENT-IO.md
- FILE: skeleton/AGENT.md
- FILE: skeleton/PROMPT.md
- FILE: skeleton/io/INPUT.md
- FILE: skeleton/knowledge/README.md
- FILE: skeleton/io/OUTPUT.md
- FILE: skeleton/evals/EVAL-PLAN.md
- FILE: skeleton/evals/GOLDEN-SET.md
- FILE: skeleton/CHANGELOG.md
- FILE: skeleton/DECISIONS.md
- FILE: skeleton/STATE.md
- FILE: skeleton/_archive/README.md
- FILE: FRAMEWORK.md
- FILE: EVALS.md
- FILE: PLATFORM.md
- FILE: PATTERNS.md
- FILE: PRINCIPLES.md
- FILE: REGISTRY-TEMPLATE.md

---

# FILE: START-HERE.md

# START HERE — Agent Standards Advisor

**To the LLM reading this:** you are now the **Agent Standards Advisor**. Your job is to help the user
create a new agent, or audit an existing one, against our standard: **8 blocks every agent must have**.

1. **Load the instructions.**
   - If you can open other files next to this one: read `STANDARD.md`, then `AGENT-PROMPT.md`, and follow it.
   - If you only have one file: use `dist/AGENT-STANDARDS-BUNDLE.md`, which contains everything. If you
     have neither, ask the user to attach the bundle. Don't work from memory.
2. **Pick the workflow** from the request: **Create** (default for "create / build a new agent"),
   **Adopt** ("bring my existing agent onto the standard"), **Audit** ("check / review my agent"),
   **Gate** ("ready for pilot?"), or **Improve**.
3. **For Create:** ask for the risk tier, copy `skeleton/` into the solution's folder, then fill the 8
   blocks **in order, one at a time**, starting with block 1 Purpose: is this the right task to
   automate? Wait for the user at the end of each block.
   **For Adopt** (the folder already has files): inventory them, propose a merge map, ask about every
   file you can't place, merge block by block, and move originals to `_archive/` only after the user
   approves. Never create folders that aren't in `skeleton/` (AGENT-PROMPT, workflow 2).
4. **For Audit:** run `deploy/audit-agent.ps1 -Path <agent folder>` (or apply its checks by reading the
   files), then review each block's quality and list what's missing.
5. **This framework is read-only.** Write every output (skeleton copy, audit report, registry entry,
   logs) into the **agent's own folder**, never into the agent-standards folder. If you can't write
   files, output each file as a Markdown block with its path.

**Launched by URL from another agent's folder?** Follow `AUDIT.md` (audit) or `CREATE.md` (new agent).
They cover fetching this framework read-only and where to save results.

Example launches:
- *"Read START-HERE.md and create a new agent for matching supplier invoices to POs."*
- *"Read START-HERE.md and audit the agent in `../invoice-matcher`."*

---

# FILE: AUDIT.md

# Audit an agent with agent-standards

**To the AI reading this:** the user wants you to audit the agent in their current folder against the
Agent Standard (8 blocks every agent must have) and show them the results. Follow these steps in order.
Ask the user only when a step says so.

Prompt that brought you here:
`Read https://raw.githubusercontent.com/cdiasmcm/agent-standards/main/AUDIT.md and audit this agent for me.`

## Rules (apply to every step)
- **agent-standards is a read-only framework.** Never modify, commit to, or write files inside it.
- Write outputs **only** in the agent's folder (`<agent>/reviews/`). Don't change any of the agent's
  other files without asking the user first.
- Never mark a block complete without evidence from the agent's own files.
- An audit never moves, renames, merges or creates files or folders (except the report). Bringing the
  agent onto the skeleton is the **Adopt** workflow in `AGENT-PROMPT.md`, run only if the user asks.

## Step 1. Get the framework (read-only)
- If a local clone already exists (the user tells you, or `~/.agent-standards` exists), run `git pull`
  there and use it.
- Otherwise clone it: `git clone https://github.com/cdiasmcm/agent-standards ~/.agent-standards`.
- If you can't run git, read the files from `https://raw.githubusercontent.com/cdiasmcm/agent-standards/main/<file>`.
- Read `STANDARD.md` (the 8 blocks), then the **Audit** workflow in `AGENT-PROMPT.md`.

## Step 2. Identify the agent
The agent folder is the current working directory, unless the user named another one. If the folder
holds several agents, list them and ask which one to audit (or audit each).

## Step 3. Completeness check
- **Skeleton layout** (the folder has `AGENT.md`): run
  `powershell -ExecutionPolicy Bypass -File ~/.agent-standards/deploy/audit-agent.ps1 -Path <agent folder> -Save`
  (on macOS/Linux: `pwsh -File ...`). It prints a block table and saves the report in `<agent>/reviews/`.
  If PowerShell isn't available, apply the same checks by reading the files: for each block, are the
  fields required by the agent's tier filled (no `TODO`)?
- **Any other layout** (no `AGENT.md`; the script exits with code 2): map the folder's existing files
  onto the 8 blocks (Purpose, Steps, Input, Output, Tools & Access, Controls, Evals & DQ, Operations).
  Note which file gives the evidence for each block, and list files you couldn't map to any block.

## Step 4. Judgment review
For each block, check quality, not only presence (AGENT-PROMPT, Audit step 2). Is it a Green Light
task? Is every extra agent justified by evidence? Are success criteria testable yes/no statements? Is
every "must never" enforced in code? Is the trifecta broken in code? Do the data-quality checks fit this
data? Propose the risk tier if none is stated.

## Step 5. Save and show the results
1. Save `<agent folder>/reviews/standards-audit-YYYY-MM-DD.md` with:
   - a block table: `# | Block | Status (PASS / GAPS / NOT STARTED / MISSING / BLOCKED) | One line`
   - per block: the evidence found and the gaps
   - **blocking gaps** (what must be fixed before the next stage)
   - **next three actions**
   - (optional) feedback on the standard itself, written to `<agent folder>/reviews/standards-feedback-YYYY-MM-DD.md`
2. **Show the user** the block table, the blocking gaps and the next three actions in your reply, plus
   the path of the saved report.
3. Ask whether they want help fixing the gaps. Don't start changing their files on your own. If the
   agent isn't on the skeleton yet, offer **Adopt** (`AGENT-PROMPT.md` workflow 2): merge map first,
   questions about any file you can't place, no folders outside `skeleton/`, originals to `_archive/`.

---

# FILE: CREATE.md

# Create a new agent with agent-standards

**To the AI reading this:** the user wants a new agent built to the Agent Standard (8 blocks every
agent must have). You'll set up its folder from the skeleton and fill the blocks **with the user, one
at a time**. Follow these steps in order.

Prompt that brought you here:
`Read https://raw.githubusercontent.com/cdiasmcm/agent-standards/main/CREATE.md and create a new agent for <problem>.`

## Rules (apply to every step)
- **agent-standards is a read-only framework.** Never modify, commit to, or write files inside it.
- Everything you create goes into the **new agent's folder**.
- Go one block at a time and wait for the user at the end of each. Don't jump ahead to architecture.

## Step 1. Get the framework (read-only)
Same as `AUDIT.md` step 1: use an existing clone (`git pull`), or
`git clone https://github.com/cdiasmcm/agent-standards ~/.agent-standards`, or read the raw files.
Read `STANDARD.md`, then the **Create** workflow in `AGENT-PROMPT.md`.

## Step 2. Set up the folder
1. Restate the problem in one sentence and ask for: the agent's name, where its folder should go
   (default: a new folder in the current directory), and the **risk tier** (Lite / Standard / Critical).
   When in doubt, choose the higher tier.
2. If `<agent folder>` already has files, **stop**: this is an existing agent. Switch to the **Adopt**
   workflow in `AGENT-PROMPT.md` (merge, never overwrite) and tell the user.
   Otherwise copy the framework's `skeleton/` folder to `<agent folder>/`. If you can't write files, output each
   skeleton file as a Markdown block with its path.
3. Set `Tier`, `Stage: Design` and the owners in `AGENT.md`.

## Step 3. Fill the 8 blocks, in order
For each block, ask only the questions its fields need for the tier. Fields above the tier get
`N/A (tier)`. Fill the files, then confirm with the user before moving on.
1. **Purpose** (`AGENT.md` §1): start with task selection (FRAMEWORK D0). If the task isn't Green
   Light, stop and say so.
2. **Steps** (`AGENT.md` §2): one agent first; challenge every step tagged "agent". Then write the
   instructions to the model in `PROMPT.md` (role, system prompt, examples).
3. **Input** (`io/INPUT.md`): ask for any reference files the agent must follow (naming conventions,
   code lists, mappings). Save each as CSV or Markdown in `knowledge/` and list it in
   `knowledge/README.md`. → 4. **Output** (`io/OUTPUT.md`): a rule from a reference file that must
   always hold gets a DQ check against that file.
5. **Tools & Access** (`AGENT.md` §5) → 6. **Controls** (`AGENT.md` §6)
7. **Evals & DQ** (`evals/`): add a first golden-set row from the dry-run plan.
8. **Operations** (`AGENT.md` §8), plus the first `CHANGELOG.md` entry and a `STATE.md` "Resume here".

## Step 4. Check and show
Run the audit on the new folder (`AUDIT.md` steps 3–5). Show the user the block table and what's still
open, and save the report in `<agent folder>/reviews/`.

---

# FILE: STANDARD.md

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
  then ask the advisor for the judgment review. To bring it onto the skeleton, the advisor runs
  **Adopt**: it merges the agent's existing files into the skeleton (asking about any file it can't
  place), creates no folders outside the skeleton, and keeps originals in `_archive/`, which the agent
  ignores.

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

---

# FILE: AGENT-PROMPT.md

# Agent Standards Advisor — portable instructions

Tool-neutral instructions. Works in any LLM tool (Claude Code, Genie Code, ChatGPT, Gemini, Codex,
Cursor…). Load it through `START-HERE.md`, `AGENTS.md` or the `agent-standards` skill (`SKILL.md`),
or paste it as the system prompt. Setup per tool: `DEPLOY.md`.

---

## Role
You are the **Agent Standards Advisor**. The user calls you whenever they create, review or release an
agentic solution. You make sure every agent has the **8 blocks** of the standard, filled to the depth its
risk tier requires, and that it's ready to scale. You are a peer reviewer: direct, specific, and willing
to push back. Never approve something just to be agreeable.

## The standard (read first)
`STANDARD.md`: **8 blocks** (Purpose, Steps, Input, Output, Tools & Access, Controls, Evals & DQ,
Operations) and **3 golden rules** (simplest first · prompts steer, code enforces · autonomy is earned).

## Files (the standards root is the folder holding this file)
| File | Use it for |
|------|------------|
| `STANDARD.md` | The 8 blocks, tiers, stages, sources. Explain the standard from this page |
| `AUDIT.md`, `CREATE.md` | Step-by-step runbooks when launched by URL ("Read <URL> and audit / create …") |
| `skeleton/` | The template every agent starts from: `AGENT.md`, `PROMPT.md`, `io/INPUT.md`, `knowledge/`, `io/OUTPUT.md`, `evals/EVAL-PLAN.md`, `evals/GOLDEN-SET.md`, `CHANGELOG.md`, `DECISIONS.md`, `STATE.md`, `reviews/`, `_archive/` (originals after Adopt; disregarded by the agent) |
| `AGENT-IO.md` | Standard input and output envelope (blocks 3–4) |
| `deploy/audit-agent.ps1` | Completeness check per block (run it, or replicate its checks by reading the files) |
| `deploy/export-agent.ps1` | At the MVP gate: Markdown tables → JSON Schema + JSONL |
| `FRAMEWORK.md` | How-to for blocks 1–2 (D0 task selection → D7 build order) |
| `EVALS.md` | How-to for block 7 (E1–E7) |
| `PLATFORM.md` | How-to for blocks 5, 6, 8 across many agents (registry, hooks, gateways, safe writes, operating model, Databricks mapping) |
| `PATTERNS.md`, `PRINCIPLES.md` | Detailed patterns and principles, with source traceability |
| `REGISTRY-TEMPLATE.md` | Format of a portfolio registry (kept outside the framework) |
| `dist/AGENT-STANDARDS-BUNDLE.md` | Everything in one file, for tools that take a single upload |
| `reference/` | Sources (PDFs not in the repo, see its README) |

If you can't open these files in this tool, say so and ask for the bundle. **Never invent the content of
a standard.**

## Where outputs go: the framework is read-only
agent-standards is a **reusable, read-only framework**. Agents call it to review their patterns and
adjust **their own** folder structure. **It must not change because of any audit, review, creation or
gate.** Never write, edit or commit anything in the standards root during these workflows. Every
output goes into the **agent's own folder**:

| Output | Where |
|--------|-------|
| Skeleton copy and filled blocks | `<agent folder>/` |
| Audit report | `<agent folder>/reviews/standards-audit-YYYY-MM-DD.md` |
| Feedback on the standard (Improve) | `<agent folder>/reviews/standards-feedback-YYYY-MM-DD.md` |
| Registry entry | `<agent folder>/AGENT.md` §8. A portfolio registry, if any, lives outside the framework (`REGISTRY-TEMPLATE.md` gives its format) |
| Gate record, versions | `<agent folder>/CHANGELOG.md` |
| Run log | `<agent folder>/STATE.md` |
| Design decisions | `<agent folder>/DECISIONS.md` |
| Originals merged during Adopt + merge log | `<agent folder>/_archive/` |

## Workflows
Ask which one the user wants if it isn't clear. Default for "create / build a new agent" is **Create**;
if the folder already holds the agent's files, it's **Adopt**.

### 1. Create: a new agent
1. Ask for the **tier** (Lite / Standard / Critical; when in doubt, go higher) and where the solution's
   folder is.
2. Copy `skeleton/` to `<solution folder>/<agent-name>/`. If you can't write files, output each file as
   a Markdown block with its path.
3. Fill the blocks **in order, one at a time**, asking only the questions that block's fields need for the
   tier (fields tagged above the tier are marked `N/A (tier)`):
   **1 Purpose** (start with task selection, FRAMEWORK D0: if the zone isn't Green, stop and say so) →
   **2 Steps** (one agent first; challenge every "agent" step) → **3 Input** → **4 Output** →
   **5 Tools & Access** → **6 Controls** → **7 Evals & DQ** (a first golden-set row from the dry-run plan)
   → **8 Operations**.
   Wait for the user at the end of each block. Don't jump ahead to architecture.
4. Fill the registry entry in `AGENT.md` §8, write the first `CHANGELOG.md` entry and a `STATE.md`
   "Resume here", all in the agent's folder.
5. Run the audit (report saved to `<agent folder>/reviews/`) and show the gap report. Anything left
   becomes the next actions.

### 2. Adopt: bring an existing agent onto the skeleton
Use this when the agent's folder already has files (its own PRD, prompts, notes, scripts…). The goal is
to **merge** what the agent already knows into the skeleton, never to overwrite it or invent structure.
1. **Inventory** every file and folder in the agent's folder (read-only). Nothing changes yet.
2. **Propose a merge map** and show it: `existing file → skeleton target (file + section) → action`
   (merge content / move to `knowledge/` / unknown). Wait for the user.
3. **Ask** about every row marked unknown or ambiguous, and about every conflict. An existing file with a
   skeleton name (e.g. its own `AGENT.md` or `CHANGELOG.md`) is merged section by section, never
   overwritten. **If you don't know what to do with a file, ask. Don't guess.**
4. Copy in the skeleton files that don't exist yet, then merge content into them **block by block**,
   confirming each block as in Create. Mark merged fields with `(from <original path>)`.
5. Copy each merged original into `_archive/YYYY-MM-DD-pre-standard/` (same relative path) and log it in
   `_archive/README.md`. Remove originals from their old place **only after the user approves the list**.
6. **Never create folders that aren't part of the skeleton.** A file the user wants to keep active gets a
   skeleton place (usually `knowledge/`), or stays where it is if the user decides so.
7. Run the audit (step 3 below) and save the report in `<agent folder>/reviews/`.

### 3. Audit: an existing agent
1. Run `deploy/audit-agent.ps1 -Path <agent folder>`, or apply the same checks by reading the files.
   That gives completeness per block.
2. Then do the **judgment review** per block. Is it really a Green Light task? Is each split into several
   agents backed by evidence? Are the success criteria testable yes/no statements? Is every "must never"
   enforced in code? Is the trifecta broken in code? Do the DQ checks cover what can go wrong with this data?
3. Write the report to `<agent folder>/reviews/standards-audit-YYYY-MM-DD.md`: status per block,
   blocking gaps, and the next three actions. **Never mark a block complete without evidence** from the agent's own files.
4. For an agent built before this standard: map what exists onto the 8 blocks first, then list the gaps.
   An audit never moves, renames or merges files. If the user wants the agent brought onto the
   skeleton, run **Adopt**.

### 4. Gate: release an agent to the next stage
Check block 7 against the stage thresholds (golden set 20 / 100 / 300 real cases, criteria met at pass^k,
**every critical case passing individually**) and blocks 5–6 (safety, kill switch, security scan).
Run `deploy/export-agent.ps1` at the MVP gate. Record the decision as a new `CHANGELOG.md` row
(version, eval before → after, gate, approver, status `good` or `draft`).

### 5. Improve: feedback on the standard
When a session exposes a gap or a rule that doesn't work, write a proposal (file, old → new, why) to
`<agent folder>/reviews/standards-feedback-YYYY-MM-DD.md`. **Never edit the framework yourself.** Its
maintainer reviews proposals and decides whether to change the standard.

## Rules
- Keep sources apart from our rules: text marked **Our rule** is ours; everything else traces to the
  book [ch.], the workbook [WB §x] or external best practice [EXT].
- The tier sets depth: Lite = [L] fields; Standard = [L]+[S]; Critical = all. Stages raise thresholds.
- Prompts steer, code enforces: never accept a "must never" rule that lives only in a prompt.
- Simplest first: push back on extra agents as firmly as on mega-agents.
- Security fields (trifecta, guardrails, kill switch) are never N/A for a user-facing agent with data access.
- Paraphrase the sources; quote at most a short phrase.
- **The framework is read-only.** Nothing about any agent is ever written to the standards root.
- **In an agent's folder, only skeleton folders.** Never create a folder that isn't in `skeleton/`.
  Merge, never overwrite. A file you can't place: ask the user.
- After each completed workflow, append one dated line to the **agent's** `STATE.md` (Log).

---

# FILE: AGENT-IO.md

# Agent I/O Standard — the input and output envelope

Every agent receives the same **input envelope** and returns the same **output envelope**, whether a
user, a trigger or another agent calls it. Only the `payload` (input) and `result` (output) are specific
to an agent. Those are defined in the agent's own `io/INPUT.md` and `io/OUTPUT.md`.

Why: one shape means routing, logging, evals, rollback and the human-decision log work the same way for
every agent (PLATFORM §3). The pre-model hook validates the envelope before any model call (P21).

Format: Markdown tables are the source of truth. At build time `deploy/export-agent.ps1` generates
JSON Schema from them. Never hand-edit the generated JSON.

## Input envelope
Tier column: **L** = required at every tier · **S** = Standard and up · **C** = Critical.

| Field | Type | Tier | Rule |
|-------|------|------|------|
| `envelope.contract_version` | string | L | Version of this I/O contract the caller uses |
| `envelope.request_id` | string | L | Unique per call. Used to trace every hop and to link human decisions |
| `envelope.parent_request_id` | string | S | Set when another agent made the call |
| `envelope.idempotency_key` | string | L | Same key = same request; a retry must not repeat a write (O8) |
| `envelope.sent_at` | datetime | L | ISO 8601 |
| `envelope.deadline` | datetime | S | After this, stop and return `failed` with exit reason `timeout` |
| `caller.type` | enum(user\|trigger\|agent) | L | Who is calling |
| `caller.id` | string | L | User ID, trigger name or agent name |
| `caller.on_behalf_of` | string | L | Whose permissions apply. The agent never exceeds them (pattern 20) |
| `caller.role` | string | S | Drives runtime configuration (pattern 3) |
| `caller.timezone` | string | L | Injected as a fact. The model can't know it (pattern 7) |
| `task.objective` | string | L | One sentence: what to achieve |
| `task.done_when` | string | L | The stop condition (O11) |
| `task.output_contract` | string | L | Name + version of the expected output (from `io/OUTPUT.md`) |
| `input.payload` | object | L | The agent-specific fields (`io/INPUT.md`), validated before use |
| `input.attachments` | array<string> | S | References (paths, IDs, URLs), not raw content dumps |
| `context.state_ref` | string | S | Pointer to the thread or STATE record |
| `context.prior_state` | string | S | Decisions, constraints and open questions. Never the transcript (O12) |
| `context.knowledge_refs` | array<string> | S | Pointers the agent fetches when needed (pattern 7, retrieve) |
| `context.facts` | object | L | Current date, business rules and anything else the model can't know |
| `constraints.mode` | enum(dry_run\|draft\|execute) | L | Autonomy stage (P25, O10). `dry_run` and `draft` never write |
| `constraints.approval_level` | enum(H1\|H2\|H3\|H4\|H5) | L | Human-control level for this call (pattern 4) |
| `constraints.allowed_tools` | array<string> | S | Subset of the agent's tools for this call |
| `constraints.scope_out` | array<string> | S | What to refuse or hand off |
| `constraints.budget.max_iterations` | integer | L | Loop cap (O11) |
| `constraints.budget.max_cost` | number | S | Spend cap for this call, also enforced at the gateway (O6) |
| `constraints.budget.timeout_s` | integer | L | Time cap |
| `trust.parts` | array<object> | L | For each input part: `source` and `trusted` (true/false). A label only; the real control is in code (pattern 18) |

**Never in the envelope:** passwords, API keys, tokens. Each agent gets its own short-lived,
task-scoped credentials from the vault (pattern 20).

## Output envelope
| Field | Type | Tier | Rule |
|-------|------|------|------|
| `request_id` | string | L | Same as the input |
| `status` | enum(completed\|needs_input\|needs_approval\|failed\|rejected\|escalated) | L | Mirrors the A2A task states (WB §16.6) |
| `exit_reason` | enum(done\|cap\|timeout\|budget\|error\|human_gate) | L | Why it stopped. "Stopped" is not "succeeded" (O11) |
| `result` | object | L | The agent-specific fields (`io/OUTPUT.md`), present when `completed` |
| `preview` | object | L | When `needs_approval`: exactly what will change if approved (O8) |
| `questions` | array<string> | L | When `needs_input`: what the agent needs |
| `provenance` | array<string> | S | Sources used and tools called |
| `flags` | array<string> | L | Uncertainty, out-of-scope, guardrail hits, failed DQ checks |
| `dq` | object | L | Results of the output DQ checks (`io/OUTPUT.md`): passed / failed per check |
| `metrics` | object | L | `tokens`, `cost`, `latency_ms` |
| `versions` | object | L | `agent`, `prompt`, `model`, `contract`, matching a `CHANGELOG.md` version |
| `error` | object | L | When `failed`: `code`, `message`, `retryable` (true/false) |

## Rules
- The envelope is versioned (`contract_version`). A breaking change bumps the major version.
- Inside your own system, delegation uses this envelope. Across a trust boundary (another company's
  agent), map the same content onto A2A messages, tasks and artifacts (O13).
- Every human decision on a `needs_approval` output is logged with its `request_id` and `versions`
  (`AGENT.md` §8, human-decision log).

---

# FILE: skeleton/AGENT.md

# Agent: TODO-name

> Skeleton from the Agent Standard (`STANDARD.md`). Replace every `TODO`. A field that doesn't apply
> gets `N/A (reason)`. Fill only the tags your tier needs: **[L]** Lite and up · **[S]** Standard and
> up · **[C]** Critical · **[if: …]** only when the condition holds. Check it with
> `deploy/audit-agent.ps1 <this folder>`.

**Tier:** TODO (Lite / Standard / Critical)
**Stage:** Design (Design / MVP / Pilot / Scale)
**Version:** 0.1.0 (see `CHANGELOG.md`)
**Business owner:** TODO · **Tech owner:** TODO

---

## 1. Purpose
*Is this the right task, and what does success look like?* How-to: FRAMEWORK D0–D1.

- [L] **Job (one sentence, no "and"):** TODO (<verb> <object> for <whom>, so that <outcome>)
- [L] **Task selection:** zone TODO (Green / R&D) · desired H-level TODO (H1–H5) · AI capability TODO /5, because TODO
- [L] **Blockers** (data, sign-off, another team's system): TODO
- [L] **North-star metric:** TODO · **Baseline today:** TODO · **Target:** TODO
- [L] **Problem it solves:** TODO
- [if: user-facing] **AI disclosure:** how users are told they're dealing with an AI agent: TODO
- [if: personal data] **Data protection (LGPD/GDPR):** lawful basis, minimization, retention: TODO
- [C] **Regulatory / record-keeping needs:** TODO

## 2. Steps
*What happens, in what order, and when does it stop?* How-to: FRAMEWORK D2–D5, patterns O1, O11.

- [L] **Trigger:** TODO (user message / schedule / webhook / event / hand-off from agent X)

| # | Step (verb + object) | Level (C/L/W/A/H) | H-level | Why this level | Tier |
|---|----------------------|-------------------|---------|----------------|------|
| 1 | TODO | TODO | TODO | TODO | [L] |

- [L] **Done when (stop condition):** TODO
- [L] **Caps:** max iterations TODO · timeout TODO s · max cost TODO
- [L] **Escalate to a human after:** TODO failed attempts, or on: TODO
- [L] **Exit reasons logged:** done / cap / timeout / budget / error / human_gate (keep as is)
- [L] **Instructions to the model** (role, system prompt, examples) are in `PROMPT.md` (keep as is)
- [S] **Plan-change limit** (how far it may change its own plan before a checkpoint): TODO
- [S] **One agent or several?** TODO (one agent, or the D4 reason 1–4 plus the X5 evidence for each extra agent)
- [if: more than one agent] **Topology:** TODO (hierarchical / pipeline / peer-to-peer + validator / swarm; A2A only across trust boundaries)

## 5. Tools & Access
*What can it touch, and with whose permission?* How-to: patterns 3, 18–20, O8; PLATFORM §4b.

| Tool (namespaced, e.g. `crm.get_contact`) | Purpose (precise description) | Read / Write | Permission scope | Requires approval? | Tier |
|-------------------------------------------|-------------------------------|--------------|------------------|--------------------|------|
| TODO | TODO | TODO | TODO | TODO | [L] |

- [L] **Tools are distinct** (no overlapping names, descriptions or parameters); tool responses are short and errors say what to do next: TODO (yes / fix needed)
- [L] **Agent identity:** its own non-human identity TODO · credentials short-lived, task-scoped, from the vault TODO · no shared service accounts TODO
- [L] **Trifecta:** private data TODO · untrusted content TODO · outbound channel TODO → **leg removed in code:** TODO
- [if: writes] **Safe writes per write tool:** preview → commit TODO · service-side ceiling TODO · idempotency key TODO · compensating action TODO · audit record TODO
- [if: writes] **Unattended-failure test:** if it misfired with nobody watching, what's the damage, who notices, what fixes it: TODO
- [if: runs code] **Sandbox** (rootless, capabilities dropped, read-only FS, deny-by-default network): TODO
- [S] **Third-party tools / MCP servers / skills vetted** (source, permissions, version pinned): TODO

## 6. Controls
*What must never happen, and who stays in control?* How-to: patterns 4, 21, O5, O10; P21, P25.

| Action | H-level (H1–H5) | Checkpoint (in-loop / draft review / deferred) | Reviewer | Max wait | Tier |
|--------|-----------------|------------------------------------------------|----------|----------|------|
| TODO | TODO | TODO | TODO | TODO | [L] |

- [L] **Must never do** (each enforced in code / config / approval, not only in the prompt): TODO
- [L] **Autonomy plan:** dry run on real data TODO → draft-only TODO → execute TODO (each step logged in `DECISIONS.md`)
- [S] **Guardrails:** input (injection, PII, off-topic) TODO · output (leakage, hallucination, toxicity) TODO · tool allow-list + argument schemas TODO
- [S] **Kill switch:** pause / resume TODO · revoke credentials TODO · stop TODO · who can pull it TODO
- [C] **Kill switch tested** (date, result): TODO
- [S] **OWASP Agentic Top 10 check** (goal hijack, tool misuse, privilege abuse, supply chain, code execution, memory poisoning, inter-agent comms, cascading failures, human-trust exploitation, rogue agent): TODO (rows reviewed + gaps)

## 8. Operations
*How it runs, changes, and is held accountable.* How-to: PLATFORM; pattern O6; P24.

- [L] **Model** (pinned version) + reasoning effort: TODO · **why this tier** (cheapest that passed the eval): TODO
- [L] **Budget enforced at:** TODO (gateway / provider) · per run TODO · per month TODO
- [L] **Logging:** what is logged TODO · secrets and personal data redacted TODO · who can read logs TODO
- [L] **Registry entry:** agent TODO · solution TODO · mission TODO · tier/stage TODO · owners TODO · model TODO · status TODO · **portfolio registry kept at:** TODO (outside agent-standards)
- [L] **Version history** kept in `CHANGELOG.md`: release unit = prompt (`PROMPT.md`) + model + tools + memory config + I/O contract + reference files (`knowledge/`) (keep as is)
- [L] **Human-decision log** (runtime approvals, rejections, edits, overrides): stored in TODO · fields: request_id, agent version, action, preview shown, decision, decided_by, time, reason, final value (keep as is) · retention TODO · access TODO
- [S] **Edits and overrides feed evals** (`evals/GOLDEN-SET.md`): TODO (how, how often)
- [S] **Rollout:** shadow TODO → canary TODO % → full · **rollback trigger:** TODO · **rollback method:** repoint to the last good `CHANGELOG.md` version, clear caches TODO
- [S] **Tracing format:** TODO (OpenTelemetry GenAI conventions, or the tool's own)
- [S] **Where it runs:** TODO (harness for prototype; hosted runtime for anything unattended)
- [if: memory] **Memory rules:** what it may remember TODO · retention TODO · who can see or delete it TODO
- [L] **Handoff files** present: `STATE.md` (Resume here), `DECISIONS.md`, `CHANGELOG.md`, `reviews/` (keep as is)

---

# FILE: skeleton/PROMPT.md

# Prompt — the instructions the model gets

*Part of block 2 Steps: how the model is told to do its steps.* The prompt **steers**; anything that
must always hold is enforced in code (`AGENT.md` §6, `io/OUTPUT.md` DQ checks). Every change here is a
new version in `CHANGELOG.md` and re-runs the evals. No secrets, credentials or personal data in this
file.

**Prompt version:** 0.1.0

- [L] **Role** (one sentence, same job as `AGENT.md` §1): TODO
- [L] **Context it receives** each run: facts, knowledge and prior state as defined in `io/INPUT.md`, reference files from `knowledge/` (keep as is)
- [L] **Output format:** the result fields in `io/OUTPUT.md` (keep as is)
- [S] **Must-never rules, repeated as guidance** (each one is enforced in code per `AGENT.md` §6): TODO
- [S] **When unsure:** what to do instead of guessing (ask, flag, escalate): TODO

## System prompt
Write the full instructions in the block below. The audit flags it while it still says TODO.

```text
TODO
```

## Examples (few-shot)
Short, real, PII-scrubbed examples (from `io/examples/` or the golden set). Not the same cases the evals
score, or the evals stop measuring anything.

| ID | Input (short) | Expected output (short) | Tier |
|----|---------------|-------------------------|------|
| P1 | TODO | TODO | [S] |

---

# FILE: skeleton/io/INPUT.md

# Block 3 — Input

The agent receives the **standard input envelope** (`AGENT-IO.md`). This file defines only what is
specific to this agent: the `payload` fields, where the data comes from, and the data-quality checks
run **before** the agent uses it.

Types: `string` · `number` · `integer` · `boolean` · `date` · `datetime` · `enum(a\|b\|c)` (write the pipes as `\|` inside a table) ·
`array<type>` · `object`. Required: `yes` / `no`. This table is the source for the generated JSON
Schema (`deploy/export-agent.ps1`), so keep its columns.

## Payload fields
| Field | Type | Required | Rule | DQ check | Tier |
|-------|------|----------|------|----------|------|
| TODO | TODO | TODO | TODO | TODO | [L] |

## Data quality checks (before use)
- [L] **Completeness:** required fields present, no empty values: TODO
- [L] **Validity:** types, formats, allowed values, ranges: TODO
- [L] **Duplicates:** how a repeated input is detected (idempotency key, business key): TODO
- [S] **Freshness:** the oldest data acceptable, per source: TODO
- [S] **Consistency:** cross-field / cross-source rules (e.g. totals match lines): TODO
- [L] **On a failed check:** TODO (reject with `status: rejected` / ask with `needs_input` / continue with a flag)

## Sources and trust
| Source | Trusted? (internal, controlled / untrusted: email, web, uploads, other agents) | Owner | Tier |
|--------|---------------------------------------------------------------------------------|-------|------|
| TODO | TODO | TODO | [L] |

- [S] **Data contract per source** (owner, schema, freshness target, quality checks, who is told when it breaks): TODO

## Context the agent needs
Small reference files the agent always uses (naming conventions, code lists, mappings) live in
`knowledge/` and are listed in `knowledge/README.md`. The fields below say how they reach the model.

- [L] **Facts injected each run** (`context.facts`: date, timezone, business rules): TODO
- [S] **Knowledge it fetches on demand** (`context.knowledge_refs`; top-K, never everything): TODO
- [S] **Prior state it receives** (`context.prior_state`: decisions, constraints, open questions; never the transcript): TODO

---

# FILE: skeleton/knowledge/README.md

# Knowledge — reference files the agent uses

*Part of block 3 Input.* Small, reviewed reference tables and documents the agent needs to do its job:
naming conventions, code lists, mapping tables, glossaries, business rules. Put each file in this folder
and list it below.

- **Format:** CSV or Markdown, not `.xlsx` or `.docx`, so git shows every change and both the model and
  code can read it. The master can stay where its owner keeps it; this folder holds the exported copy.
- **Not here:** personal data, credentials, secrets, or large / fast-changing data. Those stay in their
  own system and are referenced from `io/INPUT.md` (`context.knowledge_refs`).
- **A change to a file here is a new agent version** (`CHANGELOG.md`) and re-runs the evals.
- **A rule that must always hold** (e.g. a naming convention) is also checked in code: the output DQ
  check in `io/OUTPUT.md` validates against the same file.

| File | What it holds | Owner | Source of truth | Refreshed | Used as (fact / knowledge_ref / DQ check) | Tier |
|------|---------------|-------|-----------------|-----------|-------------------------------------------|------|
| TODO | TODO | TODO | TODO | TODO | TODO | [if: reference files] |

No reference files? Replace the row's TODOs with `N/A (none)`.

---

# FILE: skeleton/io/OUTPUT.md

# Block 4 — Output

The agent returns the **standard output envelope** (`AGENT-IO.md`): status, exit reason, preview,
flags, metrics, versions. This file defines only what is specific to this agent: the `result` fields,
where they land, and the data-quality checks run **before** the output is released.

Same types and columns as `INPUT.md`. This table is the source for the generated JSON Schema.

**Output contract name + version:** TODO (e.g. `invoice-match-result v1`)

## Result fields
| Field | Type | Required | Rule | DQ check | Tier |
|-------|------|----------|------|----------|------|
| TODO | TODO | TODO | TODO | TODO | [L] |

## Where it lands
- [L] **Delivered to:** TODO (user / system / next agent / human reviewer)
- [if: writes] **Preview shown before commit** (`preview` field): what it contains: TODO

## Data quality checks (before release)
- [L] **Schema-valid:** every required field present and typed: TODO
- [L] **Business rules:** TODO (e.g. amounts reconcile, dates in range)
- [S] **Grounded:** each claim or value traceable to a source in `provenance`: TODO
- [S] **No leakage:** no secrets or personal data beyond what the recipient may see: TODO
- [L] **On a failed check:** TODO (retry N times / return with a flag / escalate)

---

# FILE: skeleton/evals/EVAL-PLAN.md

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

---

# FILE: skeleton/evals/GOLDEN-SET.md

# Golden set

Real cases first: production records, dry-run deltas, human overrides. SME-written next, synthetic
only to fill gaps. **Strip personal data** before a case goes in, and make sure you may reuse it.
Expected results are **criteria, not exact wording**. Cover the ugly: edge cases, out-of-scope
requests, "I don't know" cases, and injection attempts.

Minimum by stage (real cases): **MVP 20 · Pilot 100 · Scale 300**, with at least 5 per failure mode.
IDs: `G001`, `G002`, … The `EX` row shows the format. The audit doesn't count it, so delete it once
real cases exist. This table is exported to JSONL for eval tools (`deploy/export-agent.ps1`).

| ID | Input (summary or reference) | Expected (criteria) | Failure mode | Critical | Source |
|----|------------------------------|---------------------|--------------|----------|--------|
| EX | Invoice INV-123 with PO-9 attached, totals match | status completed; match = true; no flags | FM1 | no | example |

---

# FILE: skeleton/CHANGELOG.md

# Changelog — agent versions

One version = the **release unit**: prompt (`PROMPT.md`) + model + tools + memory config + I/O contract
+ reference files (`knowledge/`). Every
trace and output carries this version (`versions.agent`). Rollback = repoint to the last version
marked **good**. Newest at the top. Never edit an old row.

| Version | Date | What changed | Why (→ DECISIONS) | Eval before → after | Gate (stage, decision, approver) | Status |
|---------|------|--------------|-------------------|---------------------|-----------------------------------|--------|
| 0.1.0 | TODO | Skeleton created | First design | n/a | Design, n/a | draft |

---

# FILE: skeleton/DECISIONS.md

# Decisions — design-time human decisions

Architecture choices, splits into more agents, permission changes (dry run → draft → execute),
accepted risks. Append-only: never edit an old entry; add a new one that supersedes it.
Runtime human decisions (approvals, rejections, edits) go to the human-decision log (`AGENT.md` §8),
not here.

Format: `- YYYY-MM-DD — decision — why — who`

---

# FILE: skeleton/STATE.md

# STATE

Resume here → TODO (one concrete next action)

## Log
<!-- Append-only. Newest at the bottom. Format: - YYYY-MM-DD — who — what was done / what is pending -->

---

# FILE: skeleton/_archive/README.md

# _archive — originals kept for history (disregarded by the agent)

When an existing agent is brought onto the skeleton (the **Adopt** workflow), its original files are
merged into the skeleton files and then copied here, one dated subfolder per merge
(`_archive/YYYY-MM-DD-pre-standard/`, same relative paths as before). They are removed from their old
place only after the owner approves the list.

**This folder is disregarded by the agent.** Nothing in it is ever loaded as prompt, context, knowledge
or eval data, and the audit skips it. It's read only by people who want the history. If something here
is still needed, merge it into the right skeleton file instead of pointing the agent at it.

## Merge log
| Date | Original path | Content merged into (file, section) | Archived as | Approved by |
|------|---------------|--------------------------------------|-------------|-------------|

---

# FILE: FRAMEWORK.md

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
**Pick the risk tier.** The tier sets how much of the standard applies, so small automations aren't
buried in process:

| Tier | When | What's required |
|------|------|-----------------|
| **Lite** | Internal, low risk, read-only, no personal data, reversible | D0–D7, charter core (identity & job, control flow + stop condition, outputs, guardrails, success criteria), eval plan E1–E4, security gate, registry entry |
| **Standard** | Default for anything users rely on | Everything for the target stage |
| **Critical** | Money, health, legal, personal data, irreversible or external actions | Standard + Safe Writes (O8) and HITL on every write, cross-family judge/auditor (O9) before MVP, red-team set in E2, Critical sign-off at every gate |

When in doubt, pick the higher tier.
**Exit:** one outcome sentence, one north star, one baseline, one tier.

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

---

# FILE: EVALS.md

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

---

# FILE: PLATFORM.md

# Platform Standards — scaling across solutions
> **Library file.** The standard itself is `STANDARD.md` (8 blocks, 3 golden rules) and the `skeleton/`. This file is the detailed how-to for blocks 5 Tools & Access, 6 Controls and 8 Operations, across many agents.

`FRAMEWORK.md` makes one solution right. This file makes the **tenth** solution cheaper, safer and
easier to run than the first. All **Our rule** unless a book pattern or a workbook section (**WB §x**, AISA Bootcamp Workbook v8) is cited.

> **Scale the platform, not the agent count (P18).** Scale means more users, more volume, steady
> reliability and controlled cost. It does not mean more agents.

---

## 1. Registry
Every agent, in every solution, gets one row in the portfolio registry before it reaches MVP (format: `REGISTRY-TEMPLATE.md`; the registry itself lives outside this framework, e.g. a UC table). If it isn't in
the registry, it doesn't run.

Columns: agent · solution · mission (one line) · tier · stage · business owner · tech owner · model ·
tools / MCP servers · gateway route · eval plan link · last gate (date + result) · cost per task · status.

Uses: find reuse candidates, see who owns what, catch unowned agents, and roll up cost.

## 2. Reuse before build
Before building any tool, guardrail, judge prompt, eval harness or agent, check the registry and the
component library (below). Build new only when nothing fits, and write down why.

**Component library** (grows with each solution; lives in `components/` or a shared repo):

| Component | Examples |
|-----------|----------|
| Tools / MCP servers | Data access, document search, CRM, ERP connectors |
| Guardrails | Prompt-injection guard, PII redactor, topic guard, output leakage guard (pattern 21) |
| Judge prompts | Calibrated binary judges per common criterion (E3) |
| Eval harness | Shared runner, dataset format, CI job, report template (E5) |
| Hook set | The standard hooks in §4, ready to wire in |
| Prompt fragments | Tone, refusal, hand-off, and citation blocks |

## 3. Inter-agent contracts, briefs and topology
Agents talk through **typed, versioned contracts**, not free text:
- Input and output schema (JSON Schema or equivalent), with a version number
- **Delegation brief** (O12): objective, output format, tools/sources, boundaries, plus relevant prior
  state. Not the transcript. Larger intermediate results go in a shared store, referenced by pointer.
- **No credentials in briefs.** Each agent holds its own scoped credentials from the vault (§6).
- Error contract: what the caller gets when the agent fails, refuses or escalates. The orchestrator
  validates every result, then retries, falls back or escalates.
- Breaking change = new version. Adding an agent still touches routing, auth, schemas, observability
  and the regression evals, so budget an integration pass. [WB §16.9]

**Topology** (O13): hierarchical by default; peer-to-peer only with a final validator; pipelines keep
fixed steps in code; swarms need a durable queue.
**Protocols:** MCP connects an agent to **tools**. Delegation inside your system uses your own
contract (sub-workflow, function call, queue). **A2A** is only for agents across a trust boundary
(another company or vendor): Agent Card discovery, tasks with a lifecycle, artifacts, standard auth.
MCP is not an A2A transport, and not an agent-discovery protocol. [WB §16.6–16.7]
**Infrastructure for multi-agent jobs:** a **durable** queue (at-least-once, e.g. Redis Streams,
Kafka, a cloud queue or a job table) when retries or "runs exactly once" matter. Plain pub/sub can
drop messages, so use it only for live status. Add a scheduler/coordinator with timeouts and human
escalation, and per-agent logs keyed by request. [WB §16.10]

## 4. Hooks (pattern O5)
Standard interception points around every agent loop. The book's input processors, guardrails, error
feedback and access control (ch. 9, 18, 20, 21) all plug in here. They are named by what they do.

| Hook | Runs | Standard jobs |
|------|------|---------------|
| **pre-model** | Before every model call | Input guards (injection, jailbreak, off-topic), PII redaction, context assembly and budget (pattern 7) |
| **pre-tool** | Before every tool call | Tool allow-list, **schema validation of every argument**, permission check (pattern 20), HITL approval by H-level (pattern 4), plan-mode / dry-run block on writes (O10), safe-write preview + idempotency key (O8), trifecta check (pattern 18), iteration/budget caps (O11) |
| **post-tool** | After every tool call | Feed errors back into context (pattern 9), offload or compress large results (patterns 7–8), tag untrusted content (backup only), validate tool results |
| **post-model** | After every model call | Output guards (leakage, hallucination, toxicity), schema check (L1), retry/fallback |
| **session-end** | When a run ends | Record exit reason (O11), export the redacted trace to evals (E7), cost and latency metrics (L4), append to the agent's STATE log (P24), registry counters |

Rules: hooks are shared components (§2), not copy-pasted code. Every hook logs its decision.
A blocked action must give the user and the trace a clear reason. Hooks exist because prompts steer
and code enforces (P21).

**Logging standard** [WB §17.10]: log every tool call (time, model, user, tool, **sanitized**
arguments, result status, policy decision). Redact, hash or omit secrets, tokens, payment and personal
data. Read access to logs is itself restricted and monitored. A log that holds everything is a
second breach waiting to happen.

## 4b. Safe writes (pattern O8)
Every tool that changes something (creates, sends, publishes, charges, deletes) meets this floor
(general API engineering practice; MCP specification security guidance; see also WB §15.7):
1. **Preview → commit.** The first call returns what would change and changes nothing. The second
   commits **exactly the previewed change**, not the request again.
2. **Ceiling enforced by the service**, not by the tool description (e.g. a server that can only
   create drafts or paused campaigns). Tool descriptions are guidance; service limits are guarantees.
3. **Idempotency key** on every write, so a retry after a timeout can't do it twice.
4. **Compensating action** named per write (void, refund, cancel, correction). None available →
   a human approves the commit.
5. **Audit record:** tool, arguments, what changed, when, which instruction triggered it.
6. **Unattended-failure test** written down: damage if it misfires with nobody watching, who would notice, what puts it right.

Reads still need least privilege (read only what the task needs), a trusted/untrusted source split,
and a check of every path by which read data could leave. Triggers and webhooks are idempotent too:
real senders retry, duplicate and deliver out of order, and an unauthenticated webhook is an open
execution trigger. [WB §13]

## 5. Gateways (pattern O6)
Two chokepoints so policy lives in one place instead of in every agent:

**AI / LLM gateway: every model call goes through it**
- Model routing (cheapest model that passes each step's eval, top model for planning/judgment) and provider fallback
- API key custody: agents never hold provider keys
- Rate limits and cost budgets per agent, per solution and per user, **enforced** here or at the
  provider. Usage dashboards only observe, they don't stop spend. [WB §7.7]
- Central request/response logging into traces
- Gateway-level guardrails (PII, safety) as a backstop to the hooks

**MCP / tool gateway: every tool call goes through it**
- Authentication and per-tool, per-agent permissions (pattern 20); short-lived, scoped credentials
- Audit log of every call
- Enforcement of the trifecta rule: block outbound tools once untrusted content is in context (pattern 18)
- One place to add, version or retire a tool for all agents

Examples (choosing one is ROADMAP Step 3): Databricks AI Gateway / Unity Gateway, LiteLLM, Portkey,
Cloudflare AI Gateway, or a cloud provider's API management.

## 6. Operating model
| Item | Standard |
|------|----------|
| Ownership | Every agent has a business owner and a tech owner in the registry. No owner, no production. |
| Versioning | Prompts, tools, contracts and datasets are versioned. Every eval result and trace names the versions. |
| Model upgrades | New model = full eval re-run (E5) + gate (E6). Remove scaffolding the new model doesn't need (P12). |
| Budgets | Cost per task and p95 latency budget per agent (charter L4), enforced at the gateway |
| Observability | Tracing on from day one (input, tool calls, output, cost, latency, versions, exit reason), redacted per §4 |
| Secrets | Credentials come from a **vault at runtime**, scoped to the task; never in prompts, briefs, context files or repos; secret scanner on every push; rotate on any exposure [WB §17.10] |
| Handoff files | Every agent folder has its charter (PRD), `STATE.md` (append-only, "Resume here" line) and `DECISIONS.md` (the why), so any model or person can continue cold (P24) [WB §10, §25.3] |
| Context files | `AGENTS.md`/`CLAUDE.md` per solution: curated, a few hundred lines at most; must-hold rules go in hooks/permissions, not here (P21) |
| Autonomy progression | Dry run → draft-only → loosen one permission at a time; log each change of permission level in DECISIONS (P25) |
| Where agents run | Prototype in the harness; move anything that must run unattended (routines, schedules, webhooks) to a hosted runtime, not a laptop that sleeps [WB §10, §12] |
| Security testing | LLM security scanner (e.g. Garak) on every release of a user-facing feature; injection cases in the eval set [WB §17.9–17.10] |
| Incidents | A failure that reaches users becomes a failure mode (E1) and a dataset case (E2) |
| Retirement | Unused or ownerless agents are retired, not left running |

---

## 7. Reference-stack mapping
The standards are vendor-neutral. This table shows where each one lands on a given stack.
Databricks entries were checked against Databricks docs on 2026-10-16. Product names change often,
so re-check before building. *Preview* = not GA when checked.

| Standard | Generic | Databricks |
|----------|---------|------------|
| Advisor runtime (this folder) | Any tool that reads `AGENTS.md` / Agent Skills | **Genie Code** reads `AGENTS.md`/`CLAUDE.md` up the folder tree and loads skills from `/Users/<you>/.assistant/skills/` or `Workspace/.assistant/skills/` |
| One-problem data agent (O2) | Text-to-SQL agent over a curated domain | **Genie space / Genie Agent**, one business domain with curated tables |
| Router / supervisor (pattern 2) | Orchestrator agent | **Agent Bricks Supervisor Agent**, which coordinates agents, Genie Agents, UC functions and MCP servers |
| Golden dataset (E2) for data agents | Questions + gold answers | **Genie benchmarks**: up to 500 questions with gold SQL; Chat mode checks SQL, Agent mode uses an LLM judge |
| Graders, CI, production evals (E3, E5, E7) | Eval framework + LLM judges + tracing | **MLflow 3**: tracing, built-in LLM judges, custom scorers, expert feedback; traces storable in Unity Catalog |
| AI gateway (O6) | LLM proxy | **AI Gateway / Unity Gateway**: provider fallback, PII and safety guardrails, governs MCP servers |
| Tool gateway + access control (O6, pattern 20) | MCP gateway + IAM | **Managed MCP servers** (preview) for UC functions, Genie and AI Search, governed by **Unity Catalog** grants and policies |
| Tools as governed functions | Function registry | **Unity Catalog functions** exposed as tools via MCP |
| Registry (§1) | Spreadsheet / catalog, outside the framework | A Unity Catalog table in your workspace (format: `REGISTRY-TEMPLATE.md`) |

Sources: [Genie Code instructions](https://docs.databricks.com/aws/en/genie-code/instructions) ·
[Genie Code skills](https://docs.databricks.com/aws/en/genie-code/skills) ·
[Genie benchmarks](https://docs.databricks.com/gcp/en/genie/benchmarks) ·
[Tune Genie Agent quality](https://docs.databricks.com/aws/en/genie-agents/tune-quality) ·
[Agent Bricks](https://docs.databricks.com/aws/en/generative-ai/guide/mosaic-ai-gen-ai-capabilities) ·
[Build agents on Databricks](https://docs.databricks.com/aws/en/agents/custom-agents/build-agents) ·
[Managed MCP servers](https://docs.databricks.com/aws/en/agents/mcp-tools/managed-mcp) ·
[Data + AI Summit 2025 announcements](https://www.databricks.com/blog/mosaic-ai-announcements-data-ai-summit-2025)

**Genie limits worth knowing (from the docs):** up to 100 instructions per Genie Agent (the whole
general-instructions block counts as one); up to 500 benchmark questions per space; Databricks
advises keeping instructions focused. No hard character limit for text instructions was documented.

---

# FILE: PATTERNS.md

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
| 11 | List Critical Business Metrics [ch. 11] | Tie quality to business outcomes | One north star + baseline + target (block 1) |
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

---

# FILE: PRINCIPLES.md

# Principles
> **Library file.** The standard itself is `STANDARD.md` (8 blocks, 3 golden rules) and the `skeleton/`. This file is the detailed how-to for every block; the 3 golden rules are P14/P23, P21 and P25.

The "why" behind every agentic solution we build. P1–P12 are short citations of two sources (read them
for the full reasoning; see `reference/README.md`); P13–P25 are our own rules.
- **Book:** *Patterns for Building AI Agents* (Bhagwat & Gienow, Oct 2025): [ch.]
- **WB:** *AI Start Academy, Modern AI Bootcamp Workbook* v8 (Oct 2026): [WB §x]

## Source principles (short citations)
| # | Principle | Source | Our rule |
|---|-----------|--------|----------|
| P1 | Design agents like an organization: group capabilities into focused roles | ch. 1 | Groups are *candidate* agents; P23 decides splits |
| P2 | Discover the architecture; solve one problem first | ch. 2 | Every extra agent or router needs a written reason |
| P3 | Distinct tools, clear choices: overlap hurts more than count | ch. 2; WB §10, §16.3 | Distinct, well-described tools; measure selection accuracy |
| P4 | One agent, many users: configure at runtime | ch. 3 | Config table per runtime signal, tested per variant |
| P5 | Autonomy is earned; humans where risk or judgment requires | ch. 4; WB §1.2 | H1–H5 per action (see P25) |
| P6 | Context is a budget, not a dumping ground | ch. 7–8; WB §4 | Compact, offload, isolate, retrieve; act early |
| P7 | Consistency beats parallelism when outputs must fit together | ch. 5–6; WB §16.2 | Parallelize only independent work; brief every hand-off |
| P8 | Errors are context | ch. 9 | Feed errors back; promote recurring ones to the prompt |
| P9 | If you can't measure it, you can't ship it | ch. 10–14; WB §11 | Failure modes + north star + eval gate on every change |
| P10 | Domain experts are the judges | ch. 15–17 | SMEs label real outputs; refresh from production |
| P11 | Security through strategic constraints (lethal trifecta) | ch. 18–21; WB §17 | Remove a leg in code; filters are backup only |
| P12 | Build for the curve: invest in what survives model upgrades | ch. 22 | Re-run evals on every upgrade; delete unneeded scaffolding |

---

## Our principles
Our own standards. They build on the sources above but go further. All **Our rule**, citing the
source each one leans on.

## P13. Break it down before you build it
Every solution goes through the Decomposition Framework (`FRAMEWORK.md`, D0–D7): task selection →
outcome → process map → classify each step → group → test → charter → build order. Nothing is built
from a wishlist.

## P14. Use the simplest thing that works
Code before an LLM call, an LLM call before a workflow, a workflow before an agent. An agent is the most
expensive and least predictable option, so each one needs a written reason. **Model tiering:** each
step gets the cheapest model that clears its eval bar. Irreversible actions are gated in code,
whatever model proposed them. [WB §10, §11.4b]

## P15. One agent, one job
Each agent has one mission (one verb, one object, no "and"), one output, one owner, distinct tools,
and one primary success criterion. "One job" defines an agent's boundary. It is not a reason to
split early (P23).

## P16. Success is defined before the first prompt
Every agent has a charter with a 5-layer success contract: output contract, task quality, business
impact, operations, and safety. Each criterion is a testable yes/no statement with a metric, method,
dataset, and per-stage threshold. "Done" means the criteria pass, not that it "looks good". The
success criteria *are* the eval set. [WB §10, §11.3]

## P17. Evals come before the agent and run on every change
Failure modes, golden dataset, graders and baseline exist before the first build (`EVALS.md` E1–E4).
After that, every change runs the suite, releases pass a stage gate, and production feeds new cases
back (E5–E7). Builds on P9/P10, book Part III and WB §11.

## P18. Scale the platform, not the agent count
Scale means more users, more volume, steady reliability and controlled cost. Grow it through a
registry, reusable components, typed contracts and clear owners (`PLATFORM.md`). Every new solution
should be cheaper than the last.

## P19. Every model and tool call passes through a hook and a gateway
Policy lives in shared chokepoints (standard hooks plus an AI gateway and a tool gateway), not
scattered through each agent's prompt. That's how guardrails, permissions, budgets and logging stay
consistent across many agents. Budgets are enforced there: a usage dashboard only observes. [Part IV; WB §7.7]

## P20. Right-size the process to the risk
Every solution picks a tier (Lite / Standard / Critical) at D1. A standard that's too heavy gets
skipped, and one that's too light lets risk through. When in doubt, go one tier up.

## P21. Prompts steer, code enforces
A prompt, system prompt or context file raises the odds of a behavior. It never guarantees it. Any
rule that must hold every time (never send, never delete, stay under budget, only read these tables)
lives in code, configuration the model can't rewrite, a permission check, a schema, or a human
approval. Never put secrets or compliance-critical rules *only* in a prompt. [WB §3.0, §4.3, §17.3, §25.2]

## P22. Choose the task before the tool
Most failed deployments chose the wrong task, not the wrong tool. Score each candidate task on how
much the people who do it **want** it automated (H1–H5) and how **capable** AI is at it today.
Build Green Light tasks (wanted + capable). Treat R&D tasks (wanted, not yet capable) as experiments.
Name Red Light tasks (capable, but people choose to keep them) so they're never automated by
accident. Record blockers (data, sign-off, another team's system) before building. [WB §1]

## P23. One agent first; split on evidence
Build a single agent with distinct tools, measure it, and split only at a **named failure boundary**:
routing errors, context overflow, conflicting roles, a tool it can't use, a latency ceiling, or an
organizational or trust boundary. Then re-run the same evals at the **same budget**. Multi-agent pays
when subtasks are independent and separately testable. It hurts on chains of dependent reasoning, and
it costs far more tokens. [WB §10, §12, §16.3–16.5]

## P24. Every agent is handoff-ready
An agent's spec (PRD / charter), state (STATE with a "Resume here" line) and reasons (DECISIONS) live in
files. Any model, vendor or person can then pick it up cold, with no memory of the original
conversation. [WB §10, §25.3]

## P25. Earn autonomy one permission at a time
Start with a **dry run** (the agent reports what it would do), then draft-only, then loosen one rule at
a time once it has proved itself on low-stakes cases (for example archive before send). Every write
keeps a way back: an undo action, or a human at the commit step. [WB §10, §25.6, §15.7]

---

### Gaps to fill
- *Principles of Building AI Agents* (book Vol. 1: foundations) is not in `reference/`.
- "Own Your Context Window" and "Accumulate Context Over Time" (12-Factor Agents) are cited by the book
  without chapters. WB §4's Offload move and §25 state files cover most of the second.

---

# FILE: REGISTRY-TEMPLATE.md

# Agent registry — template

Format of a **portfolio registry**: one row per agent, across all solutions (`PLATFORM.md` §1).
This file holds **no rows**: agent-standards is a read-only framework. Keep the real registry
outside it: a Unity Catalog table, a shared sheet, or an `agent-registry` repo owned by your platform
team. Each agent also records its own entry in `AGENT.md` §8.

| Agent | Solution | Mission (one line) | Tier | Stage | Business owner | Tech owner | Model | Tools / MCP | Gateway route | Eval plan | Last gate | Cost/task | Status |
|-------|----------|--------------------|------|-------|----------------|------------|-------|-------------|---------------|-----------|-----------|-----------|--------|
