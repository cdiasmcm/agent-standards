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
