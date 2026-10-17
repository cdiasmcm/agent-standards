# Decisions — design-time human decisions

Architecture choices, splits into more agents, permission changes (dry run → draft → execute),
accepted risks. Append-only: never edit an old entry; add a new one that supersedes it.
Runtime human decisions (approvals, rejections, edits) go to the human-decision log (`AGENT.md` §8),
not here.

Format: `- YYYY-MM-DD — decision — why — who`
