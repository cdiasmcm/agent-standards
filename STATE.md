# STATE

Resume here → Test the one-line AUDIT prompt from a real agent folder; set up the Genie Code Git folder (DEPLOY.md).

## Log

<!-- Append-only. Newest at the bottom. Format: - YYYY-MM-DD — who — what was done / what is pending -->

- 2026-10-16 — Claude — Created folder structure (README, ROADMAP, PRINCIPLES, PATTERNS, decisions log).
- 2026-10-16 — Claude — Read the whole book (`reference/`, 22 chapters, 21 patterns). Rewrote PRINCIPLES.md (12 principles) and PATTERNS.md (21 cards with stage gates). Added NEW-SOLUTION-CHECKLIST.md, AGENTS.md/CLAUDE.md (Agent Standards Advisor role), `reviews/`. Replaced DECISIONS.md with this STATE.md (folder convention).
- 2026-10-16 — Claude — Added the owner's standards: FRAMEWORK.md (Decomposition Framework D1–D7), AGENT-CHARTER.md (per-agent template with 5-layer success contract), principles P13–P16, patterns O1–O3, and matching checklist and advisor-workflow items. More points from the owner may follow.

- 2026-10-16 — Claude — Added EVALS.md (Eval Lifecycle E1–E7), EVAL-PLAN.md template, P17, pattern O4; linked from FRAMEWORK, charter, checklist, AGENTS, README.

- 2026-10-16 — Claude — Standards v2: risk tiers + sprawl check (FRAMEWORK), PLATFORM.md (registry, reuse, contracts, hooks O5, gateways O6, operating model, Databricks mapping checked against docs), REGISTRY.md, P18–P20, platform gate. Made the advisor portable: AGENT-PROMPT.md (single source), tool-neutral AGENTS.md, GEMINI.md, skill/agent-standards (open Agent Skills format), PORTABILITY.md, and a local Claude Code skill.

- 2026-10-16 — Claude — Moved master copy from Google Drive to this Git repo (agent-standards, private GitHub). Repo is the skill: SKILL.md at root. Added START-HERE.md (one-line launch), DEPLOY.md (per tool, Genie Code first), deploy/build-bundle.ps1 + dist bundle, reference/README.md, .gitignore (book PDF excluded). PORTABILITY.md merged into DEPLOY.md.

- 2026-10-16 — Claude — Merged AISA Bootcamp Workbook v8 (Oct 2026): P21–P25, patterns O7–O13, FRAMEWORK D0 + one-agent-first + X5, distinct tools instead of ≤7, evals (20 real cases, cross-family judge, critical cases individually), PLATFORM (safe writes, logging, secrets, durable queues, A2A vs MCP), charter PRD fields; patterns 5+6 merged.

- 2026-10-16 — Claude — Simplified to the Agent Standard: STANDARD.md (8 blocks + 3 golden rules), skeleton/ (all Markdown, one place per block, tier tags [L]/[S]/[C]), AGENT-IO.md (standard envelope), deploy/audit-agent.ps1 (block-by-block completeness, BLOCKED on non-Green tasks), deploy/export-agent.ps1 (md → JSON Schema + JSONL at build). Added web best practices (OWASP Agentic Top 10, kill switch, agent identity, release/rollback, OTel GenAI, EU AI Act disclosure, data contracts, memory rules) and versioning/human-decision tracking (CHANGELOG + decision log). Old charter/eval-plan/checklist templates archived; library files mapped to blocks. Tested: skeleton audits as not started; a filled Lite sample passes all 8 blocks; export JSON parses.

- 2026-10-16 — Claude — Framework made read-only when called: outputs (audit reports, registry entries, logs, feedback) go to the agent's own folder; REGISTRY.md → REGISTRY-TEMPLATE.md; repo reviews/ removed, skeleton/reviews/ added; audit-agent.ps1 -Save writes to <agent>/reviews/ and refuses any write inside the framework; AGENT-PROMPT, START-HERE, SKILL, AGENTS, README, STANDARD and the local Claude Code skill updated.

- 2026-10-16 — Claude — Published to GitHub: https://github.com/cdiasmcm/agent-standards (private), main pushed; DEPLOY.md updated with the URL.

- 2026-10-16 — Claude — Public release prep: one-prompt runbooks AUDIT.md and CREATE.md ("Read <raw URL> and …"), README "give it to your AI" section, audit script exits 2 with guidance on non-skeleton folders, book/workbook content trimmed to short citations, personal names and local paths generalized, history squashed to one commit with the GitHub no-reply email.

- 2026-10-16 — Claude — Published publicly at https://github.com/cdiasmcm/agent-standards (clean single-commit history); raw AUDIT.md / CREATE.md URLs verified.

- 2026-10-17 — Claude — Skeleton gained `PROMPT.md` (block 2: role, system prompt, examples) and `knowledge/README.md` (block 3: reference files such as naming conventions, as CSV/Markdown, with owner and refresh; must-hold rules also checked in output DQ). Release unit now includes both. audit-agent.ps1 checks both files, flags an unwritten system prompt and listed reference files that don't exist. STANDARD, CREATE, AGENT-PROMPT, README and the bundle updated.

- 2026-10-17 — Claude — New **Adopt** workflow (AGENT-PROMPT workflow 2) for existing agents: inventory, merge map, ask about every file that can't be placed, merge block by block (never overwrite), no folders outside the skeleton, originals copied to `_archive/YYYY-MM-DD-pre-standard/` and removed only after approval. Skeleton gained `_archive/README.md` (merge log; disregarded by the agent). AUDIT, CREATE, START-HERE, SKILL, AGENTS, README, STANDARD updated; audit-agent.ps1 lists top-level entries not in the skeleton (info only) and its exit-2 message points to Adopt.

- 2026-10-17 — Claude — Databricks Genie Code support for the one-line audit: `deploy/audit_agent.py` (stdlib Python port of audit-agent.ps1, CLI + `run_audit()` for notebooks, same read-only guard). Verified identical reports and exit codes against the PowerShell script on 5 cases (plain skeleton, filled sample with extras and `_archive/`, Red-zone Standard/MVP, non-skeleton folder, write refusal). AUDIT.md gained a "no shell, only Python" route (Git folder → Python download to a temp folder → GitHub connector); CREATE, DEPLOY, AGENT-PROMPT, README and AGENTS updated. The real Genie Code run (egress, approvals) is still untested.

- 2026-10-18 — Claude — Skills added to block 5: `skeleton/skills/README.md` (one folder per skill, `skills/<name>/SKILL.md`, Agent Skills format; folder name = frontmatter `name`), a skills table in `AGENT.md` §5 (own / third-party, source + pinned version, reach, approval), skills in the release unit. Both audit scripts check listed own skills exist, every skills/ folder has a SKILL.md, and its name matches the folder; parity verified on 5 cases. STANDARD, CREATE, AGENT-PROMPT (incl. Adopt hint), README and the bundle updated.

- 2026-10-18 — Claude — Per-request data kept out of git: `skeleton/runs/README.md` (local/dev runs, one folder per request) and `skeleton/.gitignore` (runs/* except README, .env, tooling). `AGENT.md` §8 states where run data lands (production → trace store; dev → runs/) and asks for the trace store. Both audits flag a missing `.gitignore` or one that doesn't ignore `runs/`; parity verified; `git check-ignore` confirmed runs data and .env ignored, README and io/examples kept. CREATE/AGENT-PROMPT copy dot-files; Adopt merges an existing .gitignore. AGENT-IO, STANDARD, README, bundle updated.

- 2026-10-18 — Claude — Simplified `skeleton/AGENT.md` (77 → 59 lines; fields to fill Lite 37 → 19, Standard 48 → 21, Critical 50 → 22; still 4 tables). Each fact now lives in one file: job → `PROMPT.md` Role; north star → `evals/EVAL-PLAN.md`; model choice, agent splits and autonomy history → `DECISIONS.md`; version → `CHANGELOG.md`; "tools are distinct" and the OWASP check → audit judgment review; fixed rules → an untagged footer. Tools and skills merged into one table; one Human checkpoints table replaces three H-level/approval columns; one Data table for trace store, decision log and logs. User input only where marked _(you)_ (owners, §1 Purpose, §6 reviewers and must-never); the tier is derived from §1 risk facts. Both audits read the merged table; parity verified on 4 cases. CREATE, AGENT-PROMPT, AUDIT, STANDARD, FRAMEWORK, PATTERNS, skills/README updated.

- 2026-10-18 — Claude — "Ask only critical questions" rule (AGENT-PROMPT Rules): questions only for what the user alone knows, what decides go/no-go or the tier, or what could lose data; asked together in one list; everything else decided by the AI, guesses marked `(assumed)`, one summary at the end. Create and Adopt no longer confirm block by block. CREATE, START-HERE, SKILL, STANDARD and the local Claude skill updated.

## Decisions

<!-- Append-only. Format: - YYYY-MM-DD — decision — why -->

- 2026-10-16 — This folder acts as a reusable "Agent Standards Advisor" for every new agentic solution — the owner wants consistent standards and scale-readiness on each build.
- 2026-10-16 — Stage gates (MVP / Pilot / Scale / If) added to each pattern — the book gives patterns but not when each is mandatory; gates make "ready to scale" checkable.
- 2026-10-16 — Book text is paraphrased, with our own adjustments marked "Our rule" — keeps the book's view and ours apart, and respects copyright.
- 2026-10-16 — Context-rot threshold (~100K in the book) is treated as model-specific and measured with evals — the book is dated Oct 2025 and models have changed since.
- 2026-10-16 — Every solution is decomposed with FRAMEWORK D1–D7 before any build; steps are tagged C/L/W/A/H and only A steps become agents — the owner wants each agent to solve one problem at a time; the simplest-level rule follows Anthropic's *Building Effective Agents* (the book's source for pattern 2).
- 2026-10-18 — No block-by-block questioning when creating, adopting or evaluating agents: critical questions only, in one list — the owner finds per-block questions slow.
- 2026-10-18 — The user only fills what nobody else knows (owners, Purpose, reviewers and must-never); the AI derives the tier and drafts every other block for later adjustment — the owner wants AGENT.md easy to use with few blocks to update. Each fact lives in exactly one file.
- 2026-10-18 — Local run data lives in a git-ignored `runs/` inside the agent folder (owner's choice over keeping it outside the folder); production never writes back to the repo — changes flow dev → git → gate → deploy only.
- 2026-10-17 — Existing agents are merged into the skeleton (Adopt), never overwritten; no folders outside the skeleton; unplaceable files are asked about; originals go to `_archive/`, which the agent disregards — the owner's rules for applying the framework to agents that already have files.
- 2026-10-16 — Single-responsibility test S1–S7 with a ≤ 7 tools starting heuristic — makes "one problem per agent" checkable instead of a matter of taste.
- 2026-10-16 — Every agent needs a charter with a 5-layer success contract (output, quality, business, operations, safety), written as yes/no criteria with per-stage thresholds — the owner asked for clear success criteria for each agent.
- 2026-10-16 — Evals follow a fixed lifecycle E1–E7 with an eval plan per agent, written before the build — book Part III gives the patterns but no order; the owner wants evals as a built-in step of the process.
- 2026-10-16 — Starting minimums: dataset 30/100/300 cases per stage, ≥ 5 per failure mode, judge ≥ 90% agreement with SMEs, k = 3 runs per case — our defaults, to be tuned after the first real review.
- 2026-10-16 — The Drive folder is the agent; AGENT-PROMPT.md is the single source of the advisor logic and every tool gets a thin adapter — the owner will use Claude Code, Databricks and other LLM tools, and copies would drift.
- 2026-10-16 — On Databricks the advisor runs in Genie Code (it reads AGENTS.md and Agent Skills), not in Genie spaces — Genie spaces are for natural-language questions over UC data; they are a building block inside solutions instead.
- 2026-10-16 — Added risk tiers, sprawl check, platform standards, hooks and gateways — evaluation found scaling was framed as agent count; scale needs reuse, ownership and shared policy chokepoints.
- 2026-10-16 — GitHub repo is the master copy, local clone outside Google Drive — Databricks Git folders pull from GitHub (Drive isn't reachable), every change is versioned, and Drive sync can corrupt .git.
- 2026-10-16 — The repo root is an Agent Skill (SKILL.md at root) — cloned as a Git folder under Genie Code's skills path, it is discovered with every standard beside it and updates with one Pull.
- 2026-10-16 — Book PDF excluded from the repo — copyrighted; the standards paraphrase it and work without it.
- 2026-10-16 — Added the AISA Workbook v8 as a second source, cited as [WB §x] — it is a year newer than the book and adds measured multi-agent evidence, write-safety engineering and task selection.
- 2026-10-16 — "One agent first; split on evidence" (P23, FRAMEWORK X5) replaces splitting at design time — measured multi-agent costs (~15× tokens, 39–70% worse on sequential tasks) make early splits a cost, not a default.
- 2026-10-16 — Tool rule is "distinct tools" instead of "≤ 7 tools" — overlap, not count, predicts tool-selection errors.
- 2026-10-16 — MVP golden set is ≥ 20 real cases (was ≥ 30 incl. synthetic) — real cases beat invented ones; dry-run deltas count as real.
- 2026-10-16 — The standard is 8 must-have blocks per agent (Purpose, Steps, Input, Output, Tools & Access, Controls, Evals & DQ, Operations) plus 3 golden rules; principles/patterns become the how-to library — 25 principles and 34 patterns were too many to explain or apply.
- 2026-10-16 — The skeleton is Markdown only; JSON Schema / JSONL are generated at build time from the Markdown tables — readable by people and every LLM tool, while runtime validation still happens in code.
- 2026-10-16 — Completeness is checked by a deterministic script (audit-agent.ps1) and quality by the advisor's judgment review — prompts steer, code enforces, applied to the standard itself.
- 2026-10-16 — Every agent keeps CHANGELOG.md (versions = release unit) and a runtime human-decision log linked by request_id; overrides feed evals and approval rates gate autonomy — versioning and human decisions were previously scattered or undefined.
- 2026-10-16 — agent-standards is a reusable, read-only framework: it must not change because of any audit, review, creation or gate of another agent; all results live in that agent's own folder, and Improve only writes proposals there — stated by the owner after an audit report was committed into the framework by mistake (dropped from history before any push).
- 2026-10-16 — The repo is public so any AI can read AUDIT.md / CREATE.md by URL (LifeOS-style one-prompt use) — the owner wants audit and create with a single pasted sentence; private repos can't be read by URL.
- 2026-10-16 — Sources are cited briefly (name, one-line idea, chapter/section) rather than paraphrased in full — the repo is public and the sources are copyrighted (book) or course material (workbook).
- 2026-10-16 — Licensed CC BY 4.0 (documents) + MIT (deploy scripts); workbook-informed patterns reduced to our own rule + citation; task selection credited to the Stanford WORKBank study; GitHub repo recreated so no earlier commits survive publicly — prepare a clean public release.
