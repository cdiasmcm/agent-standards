# Deploy — use the advisor in any LLM tool

**Master copy:** https://github.com/cdiasmcm/agent-standards (public). Edit → run `deploy/build-bundle.ps1`
→ commit → push. Every tool below reads the repo or the bundle built from it.

**Launch line (any tool):** *"Read START-HERE.md and create a new agent for &lt;problem&gt;."*

| Tool | One-time setup | Launch | Update after changes |
|------|----------------|--------|----------------------|
| **Databricks Genie Code** | See below | `@START-HERE.md create a new agent for <problem>` | Git folder → **Pull** |
| **Claude Code** | Paste the one-line prompt from `README.md`, or install a local skill that points at a clone | "Create a new agent for <problem>" | `git pull` in the clone |
| **Codex / Cursor / Copilot / Gemini CLI** | Clone the repo, open it | Launch line | `git pull` |
| **ChatGPT / Claude (web or desktop)** | Connect GitHub and pick this repo, or upload `dist/AGENT-STANDARDS-BUNDLE.md` | Launch line ("…or the bundle") | Connector: automatic. Upload: re-upload |
| **Gemini Gem / any other chat** | Upload `dist/AGENT-STANDARDS-BUNDLE.md` and paste `START-HERE.md` as instructions | Launch line | Re-upload |

## Databricks Genie Code: setup
Requirements: partner-powered AI features enabled for the account and workspace (admin setting), and
a GitHub credential linked in Databricks (*User settings → Linked accounts → Git integration*).

1. **Workspace → your home folder → Create → Git folder.** Paste the repo URL: `https://github.com/cdiasmcm/agent-standards.git`.
2. **Preferred location:** create the Git folder at `/Users/<you>/.assistant/skills/` with the name
   `agent-standards`. Genie Code then loads it as a **skill** (`SKILL.md` at the repo root).
   *Untested:* if Databricks won't create a Git folder there, put it anywhere in your home folder. The
   `@START-HERE.md` launch still works, and `AGENTS.md` is picked up when you work inside that folder.
3. Open Genie Code (Agent mode), type `@START-HERE.md create a new agent for <problem>`, and check it
   asks for the tier and starts block 1 (Purpose). The `deploy/*.ps1` scripts are PowerShell and won't run
   in Databricks: there, the advisor applies the audit checks by reading the files (AGENT-PROMPT, Audit).
4. **To update:** open the Git folder → **Pull**.

Outputs Genie Code creates (agent skeletons, audit reports) live in your Databricks workspace. Commit
them from the Git folder, or save them in the solution's own folder.

Docs: [Genie Code skills](https://docs.databricks.com/aws/en/genie-code/skills) ·
[Genie Code instructions / AGENTS.md](https://docs.databricks.com/aws/en/genie-code/instructions) ·
[Agent mode](https://docs.databricks.com/gcp/en/genie-code/agent-mode)

## What stays out of the repo
The source PDFs (`reference/*.pdf`, copyrighted) are never committed. The owner keeps them privately.
The standards cite them briefly and work without them. Only sessions that check a claim against the
original need the PDF.
