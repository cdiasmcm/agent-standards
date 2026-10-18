# Agent Standards — Agent Guide

This repo is the **Agent Standards Advisor**: the standard every agent must meet (8 blocks,
`STANDARD.md`), the skeleton new agents start from, and the instructions for the advisor that applies
them. Any tool that reads `AGENTS.md` should start here.

## Golden rule for this repo: it is read-only when called
agent-standards is a **reusable framework**. Other agents call it to review their patterns and adjust
**their own** folder structure. **It must not change because of any audit, review, creation or gate of
another agent.** Never write, edit or commit anything here during those workflows: no reports, registry
rows, logs, skeleton copies or notes about other agents. Every output goes into the **agent's own
folder** (see `AGENT-PROMPT.md`, "Where outputs go").

## If you are asked to create, audit or gate an agent
Follow **`AGENT-PROMPT.md`** (entry point: `START-HERE.md`). It holds the role, the file map and the
five workflows: Create, Adopt, Audit, Gate, Improve. Work only in the agent's folder, and create there
only the folders that are in `skeleton/`. Merge existing files, never overwrite; ask about any file you
can't place.

## Maintaining the framework (only when the task is to change the standard itself)
This section applies only when the maintainer explicitly asks to change the framework, never during
Create, Audit or Gate. Feedback from those workflows arrives as a proposal file in the agent's folder
(`reviews/standards-feedback-*.md`); the maintainer decides whether to apply it here.
- Read `STATE.md` first (log and decisions about the framework only).
- Keep files plain, tool-neutral Markdown. No tool-specific syntax, because the standard is shared with
  several LLM tools (`DEPLOY.md`).
- Keep sources apart from our rules: ours are marked **Our rule**; book [ch.], workbook [WB §x] and
  external [EXT] content is paraphrased.
- A change to a block must stay consistent across `STANDARD.md`, `skeleton/`, `deploy/audit-agent.ps1`
  (headings, tier tags, `TODO` markers) and the library file for that block. Test with
  `deploy/audit-agent.ps1 -Path skeleton`, which should report every block as not started.
- `deploy/audit-agent.ps1` and `deploy/audit_agent.py` are the same audit in two languages. Change both
  together, and check they print the same report on the same folders.
- Log every framework change in `STATE.md`, and record lasting choices under Decisions with the reason.
  Never edit old entries. Never log work on other agents here.
- After changing the standard: run `deploy/build-bundle.ps1`, then commit and push. The repo is the
  master copy; every tool pulls from it.

## Folder rules
- Dates in `YYYY-MM-DD`. Never delete originals; superseded files go to `_archive/`.
- No agent-specific content in this repo: no reviews, registry rows or examples taken from real agents.
