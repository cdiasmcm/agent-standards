# Create a new agent with agent-standards

**To the AI reading this:** the user wants a new agent built to the Agent Standard (8 blocks every
agent must have). You'll set up its folder from the skeleton and fill the blocks **with the user, one
at a time**. Follow these steps in order.

Prompt that brought you here:
`Read https://raw.githubusercontent.com/cdiasmcm/agent-standards/main/CREATE.md and create a new agent for <problem>.`

## Rules (apply to every step)
- **agent-standards is a read-only framework.** Never modify, commit to, or write files inside it.
- Everything you create goes into the **new agent's folder**.
- Go one block at a time and wait for the user at the end of each. Don't jump ahead to architecture.

## Step 1. Get the framework (read-only)
Same as `AUDIT.md` step 1: use an existing clone (`git pull`), or
`git clone https://github.com/cdiasmcm/agent-standards ~/.agent-standards`, or read the raw files. In a
tool with no shell (e.g. Databricks Genie Code), use the "No shell, only Python" route in `AUDIT.md`
step 1, and also download the `skeleton/` files you need.
Read `STANDARD.md`, then the **Create** workflow in `AGENT-PROMPT.md`.

## Step 2. Set up the folder
1. Restate the problem in one sentence and ask for: the agent's name, where its folder should go
   (default: a new folder in the current directory), and the **risk tier** (Lite / Standard / Critical).
   When in doubt, choose the higher tier.
2. If `<agent folder>` already has files, **stop**: this is an existing agent. Switch to the **Adopt**
   workflow in `AGENT-PROMPT.md` (merge, never overwrite) and tell the user.
   Otherwise copy the framework's `skeleton/` folder to `<agent folder>/`. If you can't write files, output each
   skeleton file as a Markdown block with its path.
3. Set `Tier`, `Stage: Design` and the owners in `AGENT.md`.

## Step 3. Fill the 8 blocks, in order
For each block, ask only the questions its fields need for the tier. Fields above the tier get
`N/A (tier)`. Fill the files, then confirm with the user before moving on.
1. **Purpose** (`AGENT.md` §1): start with task selection (FRAMEWORK D0). If the task isn't Green
   Light, stop and say so.
2. **Steps** (`AGENT.md` §2): one agent first; challenge every step tagged "agent". Then write the
   instructions to the model in `PROMPT.md` (role, system prompt, examples).
3. **Input** (`io/INPUT.md`): ask for any reference files the agent must follow (naming conventions,
   code lists, mappings). Save each as CSV or Markdown in `knowledge/` and list it in
   `knowledge/README.md`. → 4. **Output** (`io/OUTPUT.md`): a rule from a reference file that must
   always hold gets a DQ check against that file.
5. **Tools & Access** (`AGENT.md` §5) → 6. **Controls** (`AGENT.md` §6)
7. **Evals & DQ** (`evals/`): add a first golden-set row from the dry-run plan.
8. **Operations** (`AGENT.md` §8), plus the first `CHANGELOG.md` entry and a `STATE.md` "Resume here".

## Step 4. Check and show
Run the audit on the new folder (`AUDIT.md` steps 3–5). Show the user the block table and what's still
open, and save the report in `<agent folder>/reviews/`.
