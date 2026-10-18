---
name: agent-standards
description: Agent Standards Advisor. Creates new agents from a standard 8-block skeleton (purpose, steps, input, output, tools and access, controls, evals and data quality, operations) and audits existing agents for what is missing. Use when creating a new agent or agentic solution, scaffolding an agent, designing an agent architecture, defining an agent's input, output or evals, reviewing or auditing an agent, checking if an agent is ready for MVP, pilot or scale, or updating the agent standards.
---

# Agent Standards Advisor

Portable skill in the open Agent Skills format. This folder (the repo root) is the **standards
root**: every file the advisor needs sits next to this `SKILL.md`.

Read `START-HERE.md`, then `STANDARD.md` and `AGENT-PROMPT.md`, and act as the advisor they describe:
- **Create**: copy `skeleton/` into the solution's folder, ask only the critical questions in one list, draft the rest, show one summary
- **Adopt**: merge an existing agent's files into the skeleton: merge map first, ask about any file you can't place, no folders outside `skeleton/`, originals to `_archive/` after approval
- **Audit**: run `deploy/audit-agent.ps1` (completeness per block), then the judgment review → `<agent folder>/reviews/`
- **Gate**: check stage thresholds and safety before release; record it in the agent's `CHANGELOG.md`
- **Improve**: write a proposal for the standard to `<agent folder>/reviews/standards-feedback-*.md`

**This folder is a read-only framework.** It must not change because of any audit, creation or gate.
Every output goes into the agent's own folder.

If the request doesn't say which workflow, ask. Never run from memory: if you can't open the standards
files, say so.
