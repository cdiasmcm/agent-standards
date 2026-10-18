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
- An audit never moves, renames, merges or creates files or folders (except the report). Bringing the
  agent onto the skeleton is the **Adopt** workflow in `AGENT-PROMPT.md`, run only if the user asks.

## Step 1. Get the framework (read-only)
- If a local clone already exists (the user tells you, or `~/.agent-standards` exists), run `git pull`
  there and use it.
- Otherwise clone it: `git clone https://github.com/cdiasmcm/agent-standards ~/.agent-standards`.
- If you can't run git, read the files from `https://raw.githubusercontent.com/cdiasmcm/agent-standards/main/<file>`.
- **No shell, only Python (e.g. Databricks Genie Code):**
  1. If the workspace has a Git folder of agent-standards (often `/Users/<you>/.assistant/skills/agent-standards`), use it.
  2. Otherwise run a Python cell that downloads the files you need into a **temporary folder** (never
     into the agent's folder), at least `STANDARD.md`, `AGENT-PROMPT.md` and `deploy/audit_agent.py`:
     ```python
     import os, tempfile, urllib.request
     base = "https://raw.githubusercontent.com/cdiasmcm/agent-standards/main/"
     std = os.path.join(tempfile.gettempdir(), "agent-standards")
     for f in ["STANDARD.md", "AGENT-PROMPT.md", "deploy/audit_agent.py"]:
         os.makedirs(os.path.dirname(os.path.join(std, f)), exist_ok=True)
         urllib.request.urlretrieve(base + f, os.path.join(std, f))
     ```
  3. If outbound HTTP is blocked, use the GitHub connector if it's enabled, or ask the user to create
     the Git folder (`DEPLOY.md`).
- Read `STANDARD.md` (the 8 blocks), then the **Audit** workflow in `AGENT-PROMPT.md`.

## Step 2. Identify the agent
The agent folder is the current working directory, unless the user named another one. In a notebook
tool (e.g. Genie Code), it's the folder of the open notebook or file; if that's unclear, ask for the
workspace path (e.g. `/Workspace/Users/<you>/my-agent`). If the folder
holds several agents, list them and ask which one to audit (or audit each).

## Step 3. Completeness check
- **Skeleton layout** (the folder has `AGENT.md`): run
  `powershell -ExecutionPolicy Bypass -File ~/.agent-standards/deploy/audit-agent.ps1 -Path <agent folder> -Save`
  (on macOS/Linux: `pwsh -File ...`). It prints a block table and saves the report in `<agent>/reviews/`.
  **No PowerShell** (e.g. Databricks): run the Python version, which gives the same result:
  `python deploy/audit_agent.py <agent folder> --save`, or in a notebook cell:
  ```python
  import sys; sys.path.insert(0, "<standards root>/deploy")
  from audit_agent import run_audit
  print(run_audit("<agent folder>", save=True))
  ```
  Only if neither can run, apply the same checks by reading the files: for each block, are the fields
  required by the agent's tier filled (no `TODO`)?
- **Any other layout** (no `AGENT.md`; the script exits with code 2): map the folder's existing files
  onto the 8 blocks (Purpose, Steps, Input, Output, Tools & Access, Controls, Evals & DQ, Operations).
  Note which file gives the evidence for each block, and list files you couldn't map to any block.

## Step 4. Judgment review
For each block, check quality, not only presence (AGENT-PROMPT, Audit step 2). Is it a Green Light
task? Is every extra agent justified by evidence? Are success criteria testable yes/no statements? Is
every "must never" enforced in code? Is the trifecta broken in code? Do the data-quality checks fit this
data? Are the tools distinct? Walk the OWASP Top 10 for Agentic Applications and note gaps. Derive the
risk tier from the risk facts in `AGENT.md` §1 if none is stated.

## Step 5. Save and show the results
1. Save `<agent folder>/reviews/standards-audit-YYYY-MM-DD.md` with:
   - a block table: `# | Block | Status (PASS / GAPS / NOT STARTED / MISSING / BLOCKED) | One line`
   - per block: the evidence found and the gaps
   - **blocking gaps** (what must be fixed before the next stage)
   - **next three actions**
   - (optional) feedback on the standard itself, written to `<agent folder>/reviews/standards-feedback-YYYY-MM-DD.md`
2. **Show the user** the block table, the blocking gaps and the next three actions in your reply, plus
   the path of the saved report.
3. Ask whether they want help fixing the gaps. Don't start changing their files on your own. If the
   agent isn't on the skeleton yet, offer **Adopt** (`AGENT-PROMPT.md` workflow 2): merge map first,
   questions about any file you can't place, no folders outside `skeleton/`, originals to `_archive/`.
