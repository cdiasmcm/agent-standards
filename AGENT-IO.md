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
- **Where envelopes persist:** in production, in the trace store named in `AGENT.md` §8. In local and
  dev runs, in `runs/YYYY-MM-DD/<request_id>/` inside the agent's folder, which `.gitignore` keeps out
  of every commit. Only PII-scrubbed samples are committed (`io/examples/`, `evals/GOLDEN-SET.md`).
