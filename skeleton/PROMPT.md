# Prompt — the instructions the model gets

*Part of block 2 Steps: the job, the steps and how the model does them.* The prompt **steers**; anything that
must always hold is enforced in code (`AGENT.md` §6, `io/OUTPUT.md` DQ checks). Every change here is a
new version in `CHANGELOG.md` and re-runs the evals. No secrets, credentials or personal data in this
file.

**Prompt version:** 0.1.0

- [L] **Role: the agent's job** (one sentence, no "and"; the only place the job is written): TODO (<verb> <object> for <whom>, so that <outcome>)
- [L] **Context it receives** each run: facts, knowledge and prior state as defined in `io/INPUT.md`, reference files from `knowledge/` (keep as is)
- [L] **Output format:** the result fields in `io/OUTPUT.md` (keep as is)
- [L] **When unsure or stuck:** say so and escalate instead of guessing, within the limits in `AGENT.md` §2 (keep as is)
- [L] **Handing work to a human:** how a draft or preview is presented for the checkpoints in `AGENT.md` §6: TODO
- [S] **Must-never rules as instructions** (the same list as `AGENT.md` §6, where each one is enforced in code): TODO
- [if: user-facing] **AI disclosure wording** shown to users: TODO

## System prompt
Write the full instructions in the block below. The audit flags it while it still says TODO.

```text
TODO
```

## Steps
The procedure, in order: the only place the steps are written. Start each step with its level:
`C` code, `L` one LLM call, `W` workflow, `A` agent, `H` human. Use the simplest level that works; an
`A` step says why nothing simpler can do it. `C` steps are run by code, not the model; they're listed
so the model knows they happen. The audit flags this section while it still says TODO.

1. `L` TODO (e.g. Profile every column: type, null rate, distinct count, min/max, length, format patterns)

## Examples (few-shot)
Short, real, PII-scrubbed examples (from `io/examples/` or the golden set). Not the same cases the evals
score, or the evals stop measuring anything.

| ID | Input (short) | Expected output (short) | Tier |
|----|---------------|-------------------------|------|
| P1 | TODO | TODO | [S] |
