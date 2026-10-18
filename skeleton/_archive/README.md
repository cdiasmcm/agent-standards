# _archive — originals kept for history (disregarded by the agent)

When an existing agent is brought onto the skeleton (the **Adopt** workflow), its original files are
merged into the skeleton files and then copied here, one dated subfolder per merge
(`_archive/YYYY-MM-DD-pre-standard/`, same relative paths as before). They are removed from their old
place only after the owner approves the list.

**This folder is disregarded by the agent.** Nothing in it is ever loaded as prompt, context, knowledge
or eval data, and the audit skips it. It's read only by people who want the history. If something here
is still needed, merge it into the right skeleton file instead of pointing the agent at it.

## Merge log
| Date | Original path | Content merged into (file, section) | Archived as | Approved by |
|------|---------------|--------------------------------------|-------------|-------------|
