# Block 4 — Output

The agent returns the **standard output envelope** (`AGENT-IO.md`): status, exit reason, preview,
flags, metrics, versions. This file defines only what is specific to this agent: the `result` fields,
where they land, and the data-quality checks run **before** the output is released.

Same types and columns as `INPUT.md`. This table is the source for the generated JSON Schema.

**Output contract name + version:** TODO (e.g. `invoice-match-result v1`)

## Result fields
| Field | Type | Required | Rule | DQ check | Tier |
|-------|------|----------|------|----------|------|
| TODO | TODO | TODO | TODO | TODO | [L] |

## Where it lands
- [L] **Delivered to:** TODO (user / system / next agent / human reviewer)
- [if: writes] **Preview shown before commit** (`preview` field): what it contains: TODO

## Data quality checks (before release)
- [L] **Schema-valid:** every required field present and typed: TODO
- [L] **Business rules:** TODO (e.g. amounts reconcile, dates in range)
- [S] **Grounded:** each claim or value traceable to a source in `provenance`: TODO
- [S] **No leakage:** no secrets or personal data beyond what the recipient may see: TODO
- [L] **On a failed check:** TODO (retry N times / return with a flag / escalate)
