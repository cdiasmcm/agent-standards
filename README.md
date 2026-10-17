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
| `skeleton/` | Template copied for every new agent (all Markdown; one place per block) |
| `AGENT-IO.md` | Standard input/output envelope (blocks 3–4) |
| `deploy/audit-agent.ps1` | Block-by-block completeness audit of an agent folder |
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
