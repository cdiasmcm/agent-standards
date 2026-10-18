# Prompt — the instructions the model gets

*Part of block 2 Steps: how the model is told to do its steps.* The prompt **steers**; anything that
must always hold is enforced in code (`AGENT.md` §6, `io/OUTPUT.md` DQ checks). Every change here is a
new version in `CHANGELOG.md` and re-runs the evals. No secrets, credentials or personal data in this
file.

**Prompt version:** 0.1.0

- [L] **Role** (one sentence, same job as `AGENT.md` §1): TODO
- [L] **Context it receives** each run: facts, knowledge and prior state as defined in `io/INPUT.md`, reference files from `knowledge/` (keep as is)
- [L] **Output format:** the result fields in `io/OUTPUT.md` (keep as is)
- [S] **Must-never rules, repeated as guidance** (each one is enforced in code per `AGENT.md` §6): TODO
- [S] **When unsure:** what to do instead of guessing (ask, flag, escalate): TODO

## System prompt
Write the full instructions in the block below. The audit flags it while it still says TODO.

```text
TODO
```

## Examples (few-shot)
Short, real, PII-scrubbed examples (from `io/examples/` or the golden set). Not the same cases the evals
score, or the evals stop measuring anything.

| ID | Input (short) | Expected output (short) | Tier |
|----|---------------|-------------------------|------|
| P1 | TODO | TODO | [S] |
