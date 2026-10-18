# agent-standards

**The Agent Standard: 8 blocks every agent must have**, plus a portable advisor that creates new agents
from a skeleton and audits existing ones for what's missing. Works in Claude Code, Databricks Genie
Code and any LLM tool.

## Use it: give it to your AI
Nothing to install. Open your AI coding harness (Claude Code, Codex, Cursor, Gemini CLI or any capable
agent) **in your agent's folder** and paste one line.

**Audit an existing agent:**
```
Read https://raw.githubusercontent.com/cdiasmcm/agent-standards/main/AUDIT.md and audit this agent for me.
```

**Create a new agent:**
```
Read https://raw.githubusercontent.com/cdiasmcm/agent-standards/main/CREATE.md and create a new agent for <problem>.
```

The AI fetches this framework read-only, does the work, saves the results in **your agent's folder**
(`reviews/`), and shows you the block-by-block results.

**Already have an agent with its own files?** After the audit, ask the AI to bring it onto the skeleton
(the **Adopt** workflow). It shows a merge map first, asks about any file it can't place, merges your
content block by block, creates no folders outside the skeleton, and moves originals to `_archive/`
(ignored by the agent) only after you approve.

## What the audit gives you
One report, saved as `reviews/standards-audit-YYYY-MM-DD.md` in your agent's folder and summarized in
the chat. It contains:

1. **A verdict:** which stage the agent is ready for (Design, MVP, Pilot or Scale) and its proposed risk
   tier (Lite, Standard or Critical).
2. **A status for each of the 8 blocks:**

   | Status | Meaning |
   |--------|---------|
   | **PASS** | Everything this tier requires is there, with evidence |
   | **GAPS** | Partly there; the missing items are listed |
   | **NOT STARTED** | The block exists but nothing is filled in |
   | **MISSING** | No file or section for this block |
   | **BLOCKED** | The task shouldn't be automated as is (e.g. people want to keep it human, or AI can't do it reliably yet) |

3. **Evidence and gaps per block:** which of your files show it's covered, and what's missing or weak
   (e.g. "no stop condition", "success criteria aren't testable", "credentials passed in prompts").
4. **Blocking gaps:** what must be fixed before the next stage.
5. **Next three actions:** the most useful fixes, in order.
6. **Optional:** feedback on the standard itself (`reviews/standards-feedback-YYYY-MM-DD.md`).

The audit has two parts. A **completeness check** tests whether each block's required fields are
filled; `deploy/audit-agent.ps1` does it on agents built from the skeleton. A **judgment review** by
the AI tests whether what's there is good enough. Agents not built from the skeleton are mapped onto
the 8 blocks first. The audit never changes your agent's files, and it never writes to this framework.

**Example summary** (shown in the chat):

| # | Block | Status | One line |
|---|-------|--------|----------|
| 1 | Purpose | PASS | Clear job, north star and baseline; tier: Standard |
| 2 | Steps | GAPS | No iteration or time cap; no escalation rule |
| 3 | Input | GAPS | No freshness check on synced data |
| 4 | Output | PASS | Output schema and data-quality checks in place |
| 5 | Tools & Access | PASS | Write access only in dev; credentials from a vault |
| 6 | Controls | GAPS | Kill switch designed but not tested |
| 7 | Evals & DQ | MISSING | No golden set yet |
| 8 | Operations | GAPS | Plan approvals inside sessions aren't logged |

> **Verdict:** ready for MVP, not Pilot. **Blocking:** build the golden set (20 real cases), set
> per-agent thresholds, test the kill switch. **Next:** 1) golden set 2) caps and escalation rule
> 3) kill-switch test.

| # | Block | | # | Block |
|---|-------|---|---|-------|
| 1 | Purpose | | 5 | Tools & Access |
| 2 | Steps | | 6 | Controls |
| 3 | Input | | 7 | Evals & Data Quality |
| 4 | Output | | 8 | Operations |

**3 golden rules:** simplest first · prompts steer, code enforces · autonomy is earned.
The one-page explanation is [STANDARD.md](STANDARD.md).

With a local clone you can also say *"Read START-HERE.md and audit the agent in &lt;folder&gt;"*.
Setup per tool (Genie Code, chat tools): [DEPLOY.md](DEPLOY.md).

> **Read-only framework.** agent-standards is reusable. Agents call it to review their patterns and
> adjust **their own** folder structure. It **must not change** because of any audit, review, creation
> or gate of another agent. Reports, registry entries and logs always go into that agent's folder,
> never here.

## Structure
| Path | What it is |
|------|------------|
| `STANDARD.md` | **The standard**: 8 blocks, 3 golden rules, tiers, stages, sources |
| `skeleton/` | Template copied for every new agent (all Markdown; one place per block), including `PROMPT.md` for the instructions to the model `knowledge/` for reference files such as naming conventions, `skills/` for the agent's own skills (one folder per skill), and `_archive/` for originals after an Adopt (ignored by the agent) |
| `AGENT-IO.md` | Standard input/output envelope (blocks 3–4) |
| `deploy/audit-agent.ps1`, `deploy/audit_agent.py` | Block-by-block completeness audit of an agent folder (PowerShell, or Python for Databricks and other tools without PowerShell; same results) |
| `deploy/export-agent.ps1` | At build time: Markdown tables → JSON Schema + JSONL |
| `deploy/build-bundle.ps1` | Builds `dist/AGENT-STANDARDS-BUNDLE.md` (everything in one file) |
| `AUDIT.md`, `CREATE.md` | One-prompt runbooks for any AI ("Read <URL> and …") |
| `START-HERE.md`, `AGENT-PROMPT.md`, `SKILL.md`, `AGENTS.md`, `CLAUDE.md`, `GEMINI.md` | The advisor and its entry points |
| `REGISTRY-TEMPLATE.md` | Format of a portfolio registry (kept outside this repo) |
| `skeleton/reviews/` | Where each agent keeps its own audit reports (none are stored in this repo) |
| **Library** (how-to per block): `FRAMEWORK.md` (1–2), `EVALS.md` (7), `PLATFORM.md` (5, 6, 8), `PATTERNS.md`, `PRINCIPLES.md` | Detailed rules with source traceability |
| `ROADMAP.md`, `STATE.md` | What's next; log + decisions about the framework itself (never about other agents) |
| `_archive/` | Superseded templates |

**Sources:** *Patterns for Building AI Agents* (Bhagwat & Gienow, 2025), the *AISA Modern AI Bootcamp
Workbook* v8 (Oct 2026), and external best practice researched 2026-10-16, cited briefly, with our own
rules marked **Our rule**. PDFs are not in the repo (see `reference/`).

## Changing the standard
Edit → run `deploy/build-bundle.ps1` → commit → push. Then Pull in each tool (Genie Code Git folder,
local clones).

## License
Documents (Markdown, skeleton, bundle): **CC BY 4.0**. Scripts in `deploy/`: **MIT**. See [LICENSE.md](LICENSE.md).
Cited third-party sources remain their owners' property.
