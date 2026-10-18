# Agent: TODO-name

> Skeleton from the Agent Standard (`STANDARD.md`). Replace every `TODO`. A field that doesn't apply
> gets `N/A (reason)`. Fill only the tags your tier needs: **[L]** Lite and up · **[S]** Standard and
> up · **[C]** Critical · **[if: …]** only when the condition holds. Check it with
> `deploy/audit-agent.ps1 <this folder>`.

**Tier:** TODO (Lite / Standard / Critical)
**Stage:** Design (Design / MVP / Pilot / Scale)
**Version:** 0.1.0 (see `CHANGELOG.md`)
**Business owner:** TODO · **Tech owner:** TODO

---

## 1. Purpose
*Is this the right task, and what does success look like?* How-to: FRAMEWORK D0–D1.

- [L] **Job (one sentence, no "and"):** TODO (<verb> <object> for <whom>, so that <outcome>)
- [L] **Task selection:** zone TODO (Green / R&D) · desired H-level TODO (H1–H5) · AI capability TODO /5, because TODO
- [L] **Blockers** (data, sign-off, another team's system): TODO
- [L] **North-star metric:** TODO · **Baseline today:** TODO · **Target:** TODO
- [L] **Problem it solves:** TODO
- [if: user-facing] **AI disclosure:** how users are told they're dealing with an AI agent: TODO
- [if: personal data] **Data protection (LGPD/GDPR):** lawful basis, minimization, retention: TODO
- [C] **Regulatory / record-keeping needs:** TODO

## 2. Steps
*What happens, in what order, and when does it stop?* How-to: FRAMEWORK D2–D5, patterns O1, O11.

- [L] **Trigger:** TODO (user message / schedule / webhook / event / hand-off from agent X)

| # | Step (verb + object) | Level (C/L/W/A/H) | H-level | Why this level | Tier |
|---|----------------------|-------------------|---------|----------------|------|
| 1 | TODO | TODO | TODO | TODO | [L] |

- [L] **Done when (stop condition):** TODO
- [L] **Caps:** max iterations TODO · timeout TODO s · max cost TODO
- [L] **Escalate to a human after:** TODO failed attempts, or on: TODO
- [L] **Exit reasons logged:** done / cap / timeout / budget / error / human_gate (keep as is)
- [L] **Instructions to the model** (role, system prompt, examples) are in `PROMPT.md` (keep as is)
- [S] **Plan-change limit** (how far it may change its own plan before a checkpoint): TODO
- [S] **One agent or several?** TODO (one agent, or the D4 reason 1–4 plus the X5 evidence for each extra agent)
- [if: more than one agent] **Topology:** TODO (hierarchical / pipeline / peer-to-peer + validator / swarm; A2A only across trust boundaries)

## 5. Tools & Access
*What can it touch, and with whose permission?* How-to: patterns 3, 18–20, O8; PLATFORM §4b.

| Tool (namespaced, e.g. `crm.get_contact`) | Purpose (precise description) | Read / Write | Permission scope | Requires approval? | Tier |
|-------------------------------------------|-------------------------------|--------------|------------------|--------------------|------|
| TODO | TODO | TODO | TODO | TODO | [L] |

- [L] **Tools are distinct** (no overlapping names, descriptions or parameters); tool responses are short and errors say what to do next: TODO (yes / fix needed)
- [L] **Agent identity:** its own non-human identity TODO · credentials short-lived, task-scoped, from the vault TODO · no shared service accounts TODO
- [L] **Trifecta:** private data TODO · untrusted content TODO · outbound channel TODO → **leg removed in code:** TODO
- [if: writes] **Safe writes per write tool:** preview → commit TODO · service-side ceiling TODO · idempotency key TODO · compensating action TODO · audit record TODO
- [if: writes] **Unattended-failure test:** if it misfired with nobody watching, what's the damage, who notices, what fixes it: TODO
- [if: runs code] **Sandbox** (rootless, capabilities dropped, read-only FS, deny-by-default network): TODO
- [S] **Third-party tools / MCP servers / skills vetted** (source, permissions, version pinned): TODO

**Skills** (own skills live in `skills/<name>/SKILL.md`; see `skills/README.md`). No skills? Replace the row's TODOs with `N/A (none)`.

| Skill (`name`) | Own / third-party | What it does | Source + pinned version | Tools / data it can reach | Needs approval? | Tier |
|----------------|-------------------|--------------|-------------------------|---------------------------|-----------------|------|
| TODO | TODO | TODO | TODO | TODO | TODO | [if: skills] |

## 6. Controls
*What must never happen, and who stays in control?* How-to: patterns 4, 21, O5, O10; P21, P25.

| Action | H-level (H1–H5) | Checkpoint (in-loop / draft review / deferred) | Reviewer | Max wait | Tier |
|--------|-----------------|------------------------------------------------|----------|----------|------|
| TODO | TODO | TODO | TODO | TODO | [L] |

- [L] **Must never do** (each enforced in code / config / approval, not only in the prompt): TODO
- [L] **Autonomy plan:** dry run on real data TODO → draft-only TODO → execute TODO (each step logged in `DECISIONS.md`)
- [S] **Guardrails:** input (injection, PII, off-topic) TODO · output (leakage, hallucination, toxicity) TODO · tool allow-list + argument schemas TODO
- [S] **Kill switch:** pause / resume TODO · revoke credentials TODO · stop TODO · who can pull it TODO
- [C] **Kill switch tested** (date, result): TODO
- [S] **OWASP Agentic Top 10 check** (goal hijack, tool misuse, privilege abuse, supply chain, code execution, memory poisoning, inter-agent comms, cascading failures, human-trust exploitation, rogue agent): TODO (rows reviewed + gaps)

## 8. Operations
*How it runs, changes, and is held accountable.* How-to: PLATFORM; pattern O6; P24.

- [L] **Model** (pinned version) + reasoning effort: TODO · **why this tier** (cheapest that passed the eval): TODO
- [L] **Budget enforced at:** TODO (gateway / provider) · per run TODO · per month TODO
- [L] **Logging:** what is logged TODO · secrets and personal data redacted TODO · who can read logs TODO
- [L] **Registry entry:** agent TODO · solution TODO · mission TODO · tier/stage TODO · owners TODO · model TODO · status TODO · **portfolio registry kept at:** TODO (outside agent-standards)
- [L] **Version history** kept in `CHANGELOG.md`: release unit = prompt (`PROMPT.md`) + model + tools + memory config + I/O contract + reference files (`knowledge/`) + skills (`skills/`) (keep as is)
- [L] **Human-decision log** (runtime approvals, rejections, edits, overrides): stored in TODO · fields: request_id, agent version, action, preview shown, decision, decided_by, time, reason, final value (keep as is) · retention TODO · access TODO
- [S] **Edits and overrides feed evals** (`evals/GOLDEN-SET.md`): TODO (how, how often)
- [S] **Rollout:** shadow TODO → canary TODO % → full · **rollback trigger:** TODO · **rollback method:** repoint to the last good `CHANGELOG.md` version, clear caches TODO
- [S] **Tracing format:** TODO (OpenTelemetry GenAI conventions, or the tool's own)
- [S] **Where it runs:** TODO (harness for prototype; hosted runtime for anything unattended)
- [if: memory] **Memory rules:** what it may remember TODO · retention TODO · who can see or delete it TODO
- [L] **Handoff files** present: `STATE.md` (Resume here), `DECISIONS.md`, `CHANGELOG.md`, `reviews/` (keep as is)
