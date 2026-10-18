# Agent: TODO-name

> From the Agent Standard (`STANDARD.md`). **You only fill what's marked _(you)_:** the owners, §1
> Purpose, and the reviewers and must-never list in §6. The AI drafts everything else for you to check
> now and adjust any time. `TODO` = still open; a field that doesn't apply gets `N/A (reason)`.
> Tags: **[L]** every tier · **[S]** Standard and Critical · **[C]** Critical only · **[if: …]** only
> when it holds. The agent's job and behaviour live in `PROMPT.md`. Check with `deploy/audit-agent.ps1 <this folder>`.

**Tier:** TODO (set from the risk facts in §1: Lite / Standard / Critical)
**Stage:** Design (Design / MVP / Pilot / Scale)
**Business owner:** TODO _(you)_ · **Tech owner:** TODO _(you)_

---

## 1. Purpose
*Should this be built, and is it allowed?* _(you)_ How-to: FRAMEWORK D0. The job itself is the Role in
`PROMPT.md`; the success numbers are in `evals/EVAL-PLAN.md`.

- [L] **Task selection:** zone TODO (Green / R&D) · people want it automated at H-level TODO (H1–H5) · AI capability TODO /5, because TODO · blockers: TODO
- [L] **Risk facts** (they set the tier): personal data TODO · irreversible or external actions TODO · money, health or legal TODO · changes anything or people rely on it TODO (each yes / no → any of the first three = Critical; else the fourth = Standard; else Lite)
- [if: user-facing, personal data or regulated] **Compliance:** AI disclosure TODO · data protection (lawful basis, minimization, retention) TODO · regulatory and record-keeping TODO

## 2. Steps
*What happens, and when does it stop?* Drafted by the AI from §1. How-to: FRAMEWORK D2–D5, patterns O1, O11.

| # | Step (verb + object) | Level (C code / L LLM call / W workflow / A agent / H human) | Why this level | Tier |
|---|----------------------|--------------------------------------------------------------|----------------|------|
| 1 | TODO | TODO | TODO | [L] |

- [L] **Limits** (enforced in code): done when TODO · max iterations TODO · timeout TODO s · max cost per run TODO · escalate to a human after TODO failed attempts, or on TODO
- [if: more than one agent] **Agents and topology:** TODO (hierarchical / pipeline / peer-to-peer + validator / swarm; the reason and evidence for each extra agent go in `DECISIONS.md`)

## 5. Tools & Access
*What can it touch, and with which identity?* Drafted by the AI from the steps. How-to: patterns 3, 18–20, O8; PLATFORM §4b.

| Name (e.g. `crm.get_contact`, `data-engineer`) | Type (tool / MCP / skill) | Own or third-party + pinned version | Purpose | Read / Write | Scope | Tier |
|------------------------------------------------|---------------------------|-------------------------------------|---------|--------------|-------|------|
| TODO | TODO | TODO | TODO | TODO | TODO | [L] |

Own skills live in `skills/<name>/SKILL.md` (see `skills/README.md`). Which actions need approval is set in §6.

- [L] **Identity & credentials:** its own non-human identity TODO · short-lived, task-scoped credentials from the vault, never in prompts TODO
- [L] **Trifecta:** private data TODO · untrusted content TODO · outbound channel TODO → leg removed in code: TODO
- [if: writes or runs code] **Safe changes:** preview → commit, service-side ceiling, idempotency key, compensating action, audit record TODO · if it misfires with nobody watching: damage, who notices, what fixes it TODO · sandbox for code TODO

## 6. Controls
*Who stays in control, and what can never happen?* The AI proposes; _(you)_ confirm the reviewers and the
must-never list. How the model is told about them goes in `PROMPT.md`. How-to: patterns 4, 21, O5, O10; P21, P25.

| Action that needs a human | Checkpoint (before acting / draft review / after the fact) | Reviewer _(you)_ | Max wait | Tier |
|---------------------------|------------------------------------------------------------|------------------|----------|------|
| TODO | TODO | TODO | TODO | [L] |

- [L] **Must never** _(you)_ (each with how it's enforced: code / config / approval, never the prompt alone): TODO
- [L] **Autonomy now:** TODO (dry run / draft-only / execute; every change of level is logged in `DECISIONS.md`)
- [S] **Safety:** guardrails (input, output, tool allow-list and argument checks) TODO · kill switch (pause, revoke credentials, stop; who can pull it) TODO
- [C] **Kill switch tested** (date, result): TODO

## 8. Operations
*How it runs, and stays affordable and recoverable.* The AI proposes defaults; adjust any time. How-to: PLATFORM; pattern O6; P24.

- [L] **Run:** model (pinned) and effort TODO · budget enforced at TODO (gateway / provider), per run TODO, per month TODO · runs on TODO (harness for prototypes, hosted runtime for anything unattended)

| Data | Stored in | Retention | Who can read | Tier |
|------|-----------|-----------|--------------|------|
| Trace store (input/output envelopes, traces) | TODO | TODO | TODO | [L] |
| Human-decision log (approvals, edits, overrides) | TODO | TODO | TODO | [L] |
| Logs (secrets and personal data redacted) | TODO | TODO | TODO | [L] |

- [S] **Rollout & rollback:** shadow → canary TODO % → full · rollback trigger TODO · rollback = repoint to the last `good` version in `CHANGELOG.md`
- [if: memory] **Memory:** what it may remember TODO · retention TODO · who can see or delete it TODO

---

**Fixed rules** (from the standard; nothing to fill)
- Every run is a new request: an input envelope with a `request_id` (`AGENT-IO.md`). It ends with an exit reason: done / cap / timeout / budget / error / human_gate.
- The model's instructions (job, how to do each step, how to behave) live in `PROMPT.md`.
- Run data: production → the stores above; local and dev runs → `runs/` (git-ignored). Nothing per request is committed; only PII-scrubbed cases go to `io/examples/` or the golden set.
- One release = prompt + model + tools + memory config + I/O contract + `knowledge/` + `skills/`, recorded in `CHANGELOG.md` (its top row is the current version). Handoff files: `STATE.md`, `DECISIONS.md`, `CHANGELOG.md`, `reviews/`. Each human-decision log entry records: request_id, agent version, action, preview shown, decision, decided_by, time, reason, final value.
- Tracing follows OpenTelemetry GenAI conventions unless the platform has its own. The registry entry is built from the header, the Role in `PROMPT.md` and §8.
