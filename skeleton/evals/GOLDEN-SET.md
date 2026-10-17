# Golden set

Real cases first: production records, dry-run deltas, human overrides. SME-written next, synthetic
only to fill gaps. **Strip personal data** before a case goes in, and make sure you may reuse it.
Expected results are **criteria, not exact wording**. Cover the ugly: edge cases, out-of-scope
requests, "I don't know" cases, and injection attempts.

Minimum by stage (real cases): **MVP 20 · Pilot 100 · Scale 300**, with at least 5 per failure mode.
IDs: `G001`, `G002`, … The `EX` row shows the format. The audit doesn't count it, so delete it once
real cases exist. This table is exported to JSONL for eval tools (`deploy/export-agent.ps1`).

| ID | Input (summary or reference) | Expected (criteria) | Failure mode | Critical | Source |
|----|------------------------------|---------------------|--------------|----------|--------|
| EX | Invoice INV-123 with PO-9 attached, totals match | status completed; match = true; no flags | FM1 | no | example |
