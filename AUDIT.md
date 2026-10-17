# Audit an agent with agent-standards

**To the AI reading this:** the user wants you to audit the agent in their current folder against the
Agent Standard (8 blocks every agent must have) and show them the results. Follow these steps in order.
Ask the user only when a step says so.

Prompt that brought you here:
`Read https://raw.githubusercontent.com/cdiasmcm/agent-standards/main/AUDIT.md and audit this agent for me.`

## Rules (apply to every step)
- **agent-standards is a read-only framework.** Never modify, commit to, or write files inside it.
- Write outputs **only** in the agent's folder (`<agent>/reviews/`). Don't change any of the agent's
  other files without asking the user first.
- Never mark a block complete without evidence from the agent's own files.

## Step 1. Get the framework (read-only)
- If a local clone already exists (the user tells you, or `~/.agent-standards` exists), run `git pull`
  there and use it.
- Otherwise clone it: `git clone https://github.com/cdiasmcm/agent-standards ~/.agent-standards`.
- If you can't run git, read the files from `https://raw.githubusercontent.com/cdiasmcm/agent-standards/main/<file>`.
- Read `STANDARD.md` (the 8 blocks), then the **Audit** workflow in `AGENT-PROMPT.md`.

## Step 2. Identify the agent
The agent folder is the current working directory, unless the user named another one. If the folder
holds several agents, list them and ask which one to audit (or audit each).

## Step 3. Completeness check
- **Skeleton layout** (the folder has `AGENT.md`): run
  `powershell -ExecutionPolicy Bypass -File ~/.agent-standards/deploy/audit-agent.ps1 -Path <agent folder> -Save`
  (on macOS/Linux: `pwsh -File ...`). It prints a block table and saves the report in `<agent>/reviews/`.
  If PowerShell isn't available, apply the same checks by reading the files: for each block, are the
  fields required by the agent's tier filled (no `TODO`)?
- **Any other layout** (no `AGENT.md`; the script exits with code 2): map the folder's existing files
  onto the 8 blocks (Purpose, Steps, Input, Output, Tools & Access, Controls, Evals & DQ, Operations).
  Note which file gives the evidence for each block.

## Step 4. Judgment review
For each block, check quality, not only presence (AGENT-PROMPT, Audit step 2). Is it a Green Light
task? Is every extra agent justified by evidence? Are success criteria testable yes/no statements? Is
every "must never" enforced in code? Is the trifecta broken in code? Do the data-quality checks fit this
data? Propose the risk tier if none is stated.

## Step 5. Save and show the results
1. Save `<agent folder>/reviews/standards-audit-YYYY-MM-DD.md` with:
   - a block table: `# | Block | Status (PASS / GAPS / NOT STARTED / MISSING / BLOCKED) | One line`
   - per block: the evidence found and the gaps
   - **blocking gaps** (what must be fixed before the next stage)
   - **next three actions**
   - (optional) feedback on the standard itself, written to `<agent folder>/reviews/standards-feedback-YYYY-MM-DD.md`
2. **Show the user** the block table, the blocking gaps and the next three actions in your reply, plus
   the path of the saved report.
3. Ask whether they want help fixing the gaps. Don't start changing their files on your own.
