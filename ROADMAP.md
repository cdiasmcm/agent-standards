# Roadmap — the standards themselves

Status: ⬜ not started · 🟡 in progress · ✅ done

## ✅ Step 1 — Standards v1–v2 (2026-10-16)
Book-based standards plus our framework, evals, platform (hooks, gateways, registry), risk tiers, and a portable advisor (Claude Code skill, Genie Code, AGENTS.md, chat tools).

## ✅ Step 2 — First real audit (2026-10-16)
Audit run on a live agent; its report lives in that agent's folder (never here). Feedback on the standard arrives as
proposal files in agents' `reviews/` folders; the maintainer decides what to apply.

## ⬜ Step 3 — Set our defaults
Decisions the book leaves open, to settle once and reuse:
- Default stack / framework (Databricks Agent Bricks, Mastra, Claude Agent SDK, LangGraph, …)
- Default AI gateway and tool/MCP gateway (`PLATFORM.md` §5)
- Default eval tooling and observability / tracing tool
- Default sandbox (E2B, Daytona, …) and guardrail library
- Minimum golden-dataset size per stage

## ⬜ Step 4 — Add Vol. 1 foundations
Add *Principles of Building AI Agents* to the Drive `reference/` folder. Extend PRINCIPLES.md with foundations
(prompts, tools, memory, workflows, RAG, MCP).

## ⬜ Step 5 — Fill the book's gaps
Patterns the book cites without a chapter: *Own Your Context Window*, *Accumulate Context Over Time*
(from 12-Factor Agents). Decide whether to adopt them.

## ⬜ Step 6 — Refresh cadence
Re-check the standards against new sources every 6 months (the book calls itself a living document). Done once: AISA Workbook v8 merged 2026-10-16.

## ⬜ Step 7 — Prove portability
Load the advisor in a second tool (Genie Code first) and run a short Design session. Fix anything
that only worked because of Claude Code.
