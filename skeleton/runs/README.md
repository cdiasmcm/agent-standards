# runs — local and dev run data (never committed)

*Part of block 8 Operations.* When the agent runs during development or testing (in Claude Code, a
Genie Code notebook, a local script), each request writes its data here, one folder per request:

```
runs/
  YYYY-MM-DD/
    <request_id>/
      input.json     the input envelope (AGENT-IO.md)
      output.json    the output envelope
      trace.json     steps, tool calls, cost, exit_reason
```

- **Never committed.** `.gitignore` ignores everything here except this README, because run data holds
  real inputs and can hold personal data.
- **Never used in production.** A production run writes to the stores named in `AGENT.md` §8 (trace
  store, human-decision log). Production runs a version deployed from git and never writes back into
  the agent's folder.
- **To keep a case** (a good example or a failure worth testing): remove names, emails, account numbers
  and other personal data, then copy it to `io/examples/` or add it to `evals/GOLDEN-SET.md`.
- Clean this folder whenever you like; nothing depends on it.
