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
**Agent Card (Our rule):** every agent's card (A2A v1.0) is generated, never hand-written, by the export
(`deploy/export-agent.ps1` / `export_agent.py`) into `build/agent-card.json` from `AGENT.md`, `PROMPT.md`
and `CHANGELOG.md`. It describes the agent's job only, never its internal tools or skills. It's published
at `https://{domain}/.well-known/agent-card.json` only when `AGENT.md` §5 fills the A2A line, with the
security scheme added for the chosen auth.
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
