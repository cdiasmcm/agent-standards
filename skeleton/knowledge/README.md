# Knowledge — reference files the agent uses

*Part of block 3 Input.* Small, reviewed reference tables and documents the agent needs to do its job:
naming conventions, code lists, mapping tables, glossaries, business rules. Put each file in this folder
and list it below.

- **Format:** CSV or Markdown, not `.xlsx` or `.docx`, so git shows every change and both the model and
  code can read it. The master can stay where its owner keeps it; this folder holds the exported copy.
- **Not here:** personal data, credentials, secrets, or large / fast-changing data. Those stay in their
  own system and are referenced from `io/INPUT.md` (`context.knowledge_refs`).
- **A change to a file here is a new agent version** (`CHANGELOG.md`) and re-runs the evals.
- **A rule that must always hold** (e.g. a naming convention) is also checked in code: the output DQ
  check in `io/OUTPUT.md` validates against the same file.

| File | What it holds | Owner | Source of truth | Refreshed | Used as (fact / knowledge_ref / DQ check) | Tier |
|------|---------------|-------|-----------------|-----------|-------------------------------------------|------|
| TODO | TODO | TODO | TODO | TODO | TODO | [if: reference files] |

No reference files? Replace the row's TODOs with `N/A (none)`.
