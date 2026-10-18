# Skills — packaged capabilities the agent loads when a task needs them

*Part of block 5 Tools & Access.* A skill is a folder of instructions (and optionally scripts or
reference files) that the model loads only when it's relevant. It follows the open Agent Skills format
(agentskills.io), which Claude Code, Databricks Genie Code and other tools read.

## Layout: one folder per skill
```
skills/
  data-engineer/
    SKILL.md          required, exactly this name
    scripts/          optional: code the skill runs
    references/       optional: docs the skill reads on demand
```
- **Why a folder, not `data_engineer_skill.md`:** tools discover a skill only as a folder holding a file
  named exactly `SKILL.md`. A renamed file is never loaded, and the folder keeps the skill's scripts and
  references together with it.
- **Name:** the folder name equals the `name` in the frontmatter: lowercase letters, digits and hyphens
  (`data-engineer`).
- **Frontmatter:** `name` and `description` (what it does and when to use it; the model reads this to
  decide whether to load the skill).
- **No secrets, credentials or personal data** in a skill.

## Rules
- Every skill, own or third-party, is listed in the tools & skills table in `AGENT.md` §5 (Type `skill`), with what it can
  reach and whether it needs approval.
- Only the agent's **own** skills live here. Third-party skills are installed from their source at a
  pinned version and listed in §5, not copied into this folder.
- A skill change is a new agent version (`CHANGELOG.md`) and re-runs the evals.
- What a skill does is still bound by `AGENT.md` §6: a skill can't grant permissions the agent doesn't have.
