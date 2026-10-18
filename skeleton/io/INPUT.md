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
