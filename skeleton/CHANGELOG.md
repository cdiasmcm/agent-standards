# Changelog — agent versions

One version = the **release unit**: prompt + model + tools + memory config + I/O contract. Every
trace and output carries this version (`versions.agent`). Rollback = repoint to the last version
marked **good**. Newest at the top. Never edit an old row.

| Version | Date | What changed | Why (→ DECISIONS) | Eval before → after | Gate (stage, decision, approver) | Status |
|---------|------|--------------|-------------------|---------------------|-----------------------------------|--------|
| 0.1.0 | TODO | Skeleton created | First design | n/a | Design, n/a | draft |
