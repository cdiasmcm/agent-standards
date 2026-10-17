# Agent Charter — <Agent name>

One charter per agent (see `FRAMEWORK.md` step D6). Store it in the solution's own folder, next to
`STATE.md` (append-only log with a "Resume here" line) and `DECISIONS.md` (choices + why). No
charter, no build. The charter is the agent's PRD. It must let a worker with **no memory of the
original conversation** pick the work up cold: use exact paths, commands and versions, and no
references to chat history. [WB §10, §25.3]

**Lite tier core** (always fill in): §1 Identity & job · §3 Control flow + stop condition · §2 Outputs ·
§9 Guardrails · §7 Success criteria. The rest scales with the tier.

**Solution:**  **Version:**  **Owner (business):**  **Owner (tech):**  **Date:**  **Tier:** Lite / Standard / Critical

## 1. Identity & job (one job)
- **Mission:** <verb> <object> for <whom>, so that <outcome>. *(one sentence, no "and"; if it won't fit, the scope is wrong)*
- **Task selection (D0):** zone Green / R&D · desired H-level H_ · capability _/5 · blockers: none / …
- **Problem it solves:** what goes wrong or costs time today
- **Process steps covered** (from D2): #…
- **Level** (D3): A, with the reason C / L / W can't do it:
- **Why a separate agent?** (only if not agent #1, FRAMEWORK D4 reason 1–4 + X5 evidence):

## 2. Trigger, inputs & outputs
| | |
|---|---|
| **Trigger** (user message / schedule / webhook / event / hand-off from agent X) | |
| **Inputs at runtime** (from whom / what, format) | |
| **Background context to load** (files, docs, prior state) | |
| **Output** (exact shape / schema, and where it lands) | |
| **In scope** | |
| **Out of scope** (refuse or hand off) | |
| **Hand-offs** (next agent / human, brief fields per O12) | |

## 3. Control flow & stop conditions (O11)
- **Shape:** single-shot / loop / workflow with one agentic step
- **Done when…** (explicit stop condition):
- **Caps:** max iterations _ · timeout _ · token budget _ · spend ceiling _ (enforced at the gateway)
- **Exit reasons logged:** done / cap / timeout / budget / error / human gate
- **Plan-change limit** (how far it may change its own plan before a human checkpoint):

## 4. Model & configuration
- **Model** (pinned version) and **reasoning effort**:
- **Why this tier:** cheapest model that passed the eval (EVAL-PLAN E5):
- **Context budget per call:**

## 5. Tools & access (patterns 3, 20; O8)
| Tool | Purpose (precise description) | Read / Write / Requires approval | Permission scope | Safe-write controls (preview, ceiling, idempotency, compensating action) |
|------|-------------------------------|----------------------------------|------------------|-------------------------------------------------------------------------|

- Tools are **distinct** (no overlapping names, descriptions or parameters). Selection accuracy checked in evals ☐
- Credentials: issued by the vault at runtime, scoped to this agent ☐ · none in prompts, briefs or repo ☐

## 6. Context & memory (patterns 7, 8)
- Knowledge sources / retrieval (top-K):
- Offloaded to files (tool outputs, intermediate results):
- **State / memory kept between runs** (what, and where):
- Never-summarize items:
- Facts injected every run (date, timezone, business rules):

## 7. Success criteria contract
Every criterion is a testable yes/no statement. Thresholds only go up between stages. These criteria
**are** the eval set. Graders, datasets, baseline and gate results live in `EVAL-PLAN.md`.

| ID | Layer | Criterion (yes/no statement) | Metric | Method | Dataset | MVP | Pilot | Scale |
|----|-------|------------------------------|--------|--------|---------|-----|-------|-------|
| SC1 | L1 Output contract | Output matches schema with all required fields | % valid | Deterministic assert | Golden set | 100% | 100% | 100% |
| SC2 | L2 Task quality | | | Binary judge (other model family on high stakes) / SME | | | | |
| SC3 | L3 Business impact | | | | | | | |
| SC4 | L4 Operations | p95 latency ≤ _ s; cost per task ≤ _ | | Tracing | Prod sample | | | |
| SC5 | L4 Operations | Escalation-to-human rate ≤ _%; no run ends on an unexpected exit | | Tracing | Prod sample | | | |
| SC6 | L5 Safety | Zero critical violations; every safety-critical and injection case passes individually | count | Guardrail logs + red-team set | Prod + red-team set | 0 | 0 | 0 |

**Primary criterion (S5):** SC_. This is the one number that says whether the agent does its job.
**Baseline:** current process / human performance on the same dataset:

## 8. Failure behavior & failure modes
- **On tool error:** retry _ times → fallback _ → escalate to _
- **On uncertainty / low confidence:** ask / escalate / "I don't know" (never guess on _)
- **On hitting a cap:** stop, report the exit reason, hand to _
- **Failure modes** (pattern 10, `EVALS.md` E1; keep in sync with the eval plan):

| Failure mode | Definition | Example | Linked criterion |
|--------------|------------|---------|------------------|

## 9. Guardrails, HITL & security (patterns 4, 18–21; O8, O10)
- **H-level per action** and checkpoint type:

| Action | H-level (H1–H5) | Checkpoint (in-loop / draft review / deferred) | Reviewer | Max wait |
|--------|-----------------|------------------------------------------------|----------|----------|

- **Must never do** (enforced in code, not only in the prompt, P21):
- **Autonomy plan (P25):** dry run (O10) ☐ → draft-only ☐ → permissions loosened one at a time (log each in DECISIONS)
- **Trifecta:** private data ☐ · untrusted content ☐ · outbound channel ☐. **Leg removed in code:**
- Input guards: · Output guards: · Tool allow-list + argument schemas ☐
- Runs code? → sandbox meeting pattern 19's spec:
- **Unattended-failure test** for each write: damage / who notices / what puts it right:

## 10. Budget & observability
- Cost ceiling per run / per month (enforced where):
- What gets logged (redacted per PLATFORM §4) and where:
- Where it runs (harness for prototype; hosted runtime if unattended):

## 11. Single-responsibility & sprawl (FRAMEWORK D5)
☐ S1 one mission ☐ S2 one output ☐ S3 one owner ☐ S4 distinct tools ☐ S5 one judge ☐ S6 testable alone ☐ S7 clear boundary
Sprawl (if not the only agent): ☐ X1 ☐ X2 ☐ X3 ☐ X4 ☐ X5 equal-budget evidence

## 12. Change log
- YYYY-MM-DD — change — reason — eval result before → after
