---
name: metrics-spec
description: Writes a measurement plan **before** the work ships — hypothesis, primary metric, counter-metric, guardrails, decision rule, sample size — so the team agrees on what "success" means before any number exists. Triggers on "measurement plan", "what counts as success?", "how will we know if this worked?", "PRD for metrics", "pre-register the analysis". Skip after data exists (use metrics-diagnose), for picking which metric to track without committing to a decision (use metrics-ux), for tracking-plan design (use metrics-instrumentation), for stakeholder communication (use metrics-present).
allowed-tools: Read
---

## Overview

Turns a planned design change into a written measurement plan that names — in advance — what would count as success, failure, or "keep iterating". Five jobs: (1) state a falsifiable **hypothesis**, (2) name the **primary metric** and at least one **counter-metric** + guardrails, (3) commit to a **decision rule** (ship / kill / iterate thresholds), (4) compute **sample size and duration** so the rule is detectable, (5) emit a one-page **spec artefact** the team can sign off.

The output is a pre-registered plan, not a recommendation. It is what `metrics-ux` produces *after* the team has decided to commit to a decision rule. `metrics-ux` answers "what should I measure?"; `metrics-spec` answers "what would change my mind?".

This skill never writes a spec for a decision the team has already made. If the user wants a plan that confirms a foregone conclusion, the skill refuses — see Red Flags.

## When to Use

Use this skill when a designer, PM, or design lead asks any of the following — phrased differently by seniority but matching the same job-to-be-done:

| Designer level | Typical phrasing that should trigger this skill |
|---|---|
| **Junior** | "How do I know in advance if my redesign worked?" / "PM wants me to write down what success looks like before we ship" |
| **Middle** | "I need a measurement plan for the onboarding rebuild" / "Can you help me write a PRD for metrics?" / "What's the decision rule — when do we ship vs revert?" |
| **Senior** | "Leadership keeps moving the goalposts after release. I want the metric locked before we ship" / "Need to pre-register the analysis so it can't be re-scoped later" |
| **Lead** | "Set a measurement plan template for the design team" / "Want every project to commit to a decision rule before launch — what should that look like?" |

Cross-cutting triggers (any seniority):

- A change is **planned but not yet shipped** and the team wants to agree on what "success" means.
- The user says "measurement plan", "PRD for metrics", "pre-register", "decision rule", "success criteria", "ship/kill threshold".
- The user wants the metric committed *before* the data exists, specifically to prevent post-hoc rationalization.
- The user describes a recurring problem with goalpost-shifting ("PM always changes the target after the result is in").

Skip this skill when:

- The change has already shipped and a number has already moved → use `metrics-diagnose`.
- The user is still browsing metric options without committing to a decision → use `metrics-ux`.
- The user wants A/B test mechanics in depth (randomization unit, sequential method, SRM tests) → that is PM/eng work, not designer scope. The decision-rule and detectability pieces relevant to designers are in this skill; for deeper experiment design, the team's experimentation platform docs are the right reference.
- The user has the spec and now wants stakeholder framing → use `metrics-present`.
- The user is asking what HEART or "hypothesis" means as a term → use `metrics-basics`.

## Process

### Step 1 — Detect mode

Read the user's prompt and pick one mode:

| Mode | Signal | Action |
|---|---|---|
| **Direct** | Asks for the spec template directly ("give me the measurement plan template", "what's the structure of a measurement spec?") | Skip questionnaire. Open [spec-template.md](references/spec-template.md). |
| **Specific** | Has the change, the hypothesis, and basic context ("we're rebuilding onboarding next sprint, hypothesis is X, audience Y, we have Amplitude") | Skip questionnaire. Walk through Steps 3–7 inline. |
| **Vague** | Has a change in mind but no hypothesis or decision rule ("I'm rebuilding onboarding, want a plan") | Run hybrid questionnaire (Step 2). |

### Step 2 — Hybrid questionnaire (vague mode only)

Four context anchors, full version in [`metrics-basics/references/context-questions.md`](../metrics-basics/references/context-questions.md). For this skill, the anchors interpret slightly differently:

1. **SCOPE** — the change being planned (feature, flow, redesign)
2. **STAGE** — must be **pre-launch** for this skill. If "just launched" or "mature", the spec is being written too late; flag the gap (see Red Flags) and ask whether the user wants `metrics-ux` (post-hoc measurement) or `metrics-diagnose` (data already exists) instead.
3. **AUDIENCE** — who signs off on the spec (self, PM, eng lead, design lead, leadership)
4. **DATA** — what analytics is in place to detect the decision rule when data arrives

For each anchor, mark **present** (clear in prompt) or **missing**. Ask only for missing anchors:

- 0–1 missing → ask in one sentence
- 2–3 missing → ask in one numbered list
- 4 missing → use the full questionnaire

Never re-ask what the user already provided. Maximum 4 questions per session.

When asking, follow the "How to ask" section in [`context-questions.md`](../metrics-basics/references/context-questions.md) — inline numbered list for closed-choice questions.

The most common gap in this skill is **STAGE confusion** (user thinks they're writing a measurement plan but the change has already shipped) and **AUDIENCE = self alone**. A spec only locks the team if at least one other person signs off — flag that gently.

### Step 3 — Write the hypothesis

A spec without a falsifiable hypothesis is a wish list. Use the canonical shape:

> **"If we [change], then [user behavior] will [direction] by [magnitude], because [mechanism]. We will know within [window]."**

Five required parts:

| Part | Example | Common failure |
|---|---|---|
| **Change** | "remove the address auto-validation step" | "redesign onboarding" — too vague to falsify |
| **User behavior** | "checkout completion rate" | "engagement" — not a behavior, a category |
| **Direction + magnitude** | "rise by at least 5 percentage points" | "improve" — undefined |
| **Mechanism** | "because the validation interrupts flow on mobile" | omitted — without a mechanism you can't tell signal from coincidence |
| **Window** | "within 4 weeks of full rollout" | omitted — the team can argue forever about "more data" |

Open [hypothesis-patterns.md](references/hypothesis-patterns.md) for strong vs weak hypothesis examples by HEART category, and the rewrite patterns for vague hypotheses ("improve onboarding" → "lift step-3 completion by ≥5 pp within 4 weeks of rollout").

A hypothesis is falsifiable when the user can name a specific outcome that would prove it wrong. If the answer to "what would change your mind?" is "I'm not sure", the hypothesis isn't ready — push back before continuing.

### Step 4 — Pick primary metric, counter-metric, guardrails

Cross-reference with `metrics-ux`. The spec adds commitment on top of selection:

| Metric role | Definition | Source |
|---|---|---|
| **Primary** | The single metric the decision will be made on. Must match the hypothesis. | [`metrics-ux`](../metrics-ux/SKILL.md) Step 4 |
| **Counter-metric** | The metric that would catch gaming or unintended harm — the one you'd be embarrassed to show if it moved wrong. Mandatory. | [`metrics-present/references/business-language.md`](../metrics-present/references/business-language.md), Counter-metric framing |
| **Guardrails** | Operational or business metrics that must not regress (latency, error rate, support tickets). Optional but recommended for any production change. | OEC framework: [Kohavi et al. — *Online Controlled Experiments at Large Scale*, KDD 2013](https://exp-platform.com/large-scale/); [Dmitriev et al. — *Pitfalls of Long-Term Online Controlled Experiments*, IEEE Big Data 2016](https://exp-platform.com/pitfalls-of-long-term/) |
| **Input metrics** | 3–5 supporting metrics that feed into the primary. Diagnostic, not deciding. | Optional |

Constraint: the primary metric must be **directly measurable** with the user's current DATA setup. If it requires instrumentation that doesn't exist, surface the gap — point to `metrics-instrumentation` — and either (a) pick a measurable proxy and name it as such, or (b) make instrumentation a precondition of the spec.

Goodhart guard: a primary metric with no counter is incomplete. Refuse to finalize until at least one counter is named.

### Step 5 — Decision rule

This is the part most teams skip and the part the spec exists for. Three branches, written before the data:

| Outcome | Threshold | Action |
|---|---|---|
| **Ship** | Primary metric meets or exceeds the hypothesis magnitude (e.g. ≥+5 pp), counter-metric not significantly worse (e.g. did not drop by more than X pp). | Roll out to 100% |
| **Kill** | Primary metric meaningfully worse than baseline (e.g. ≤−2 pp), OR counter-metric breached its threshold. | Revert |
| **Iterate** | Primary moved in the right direction but did not clear the bar, OR result is underpowered. | Refine and re-test |

Open [decision-rules.md](references/decision-rules.md) for how to pick thresholds — practical-significance vs statistical-significance, asymmetric thresholds when revert is costly, and how to write the "underpowered" branch so the team doesn't read it as "kill".

The rule must be written in the spec, signed off by the audience named in Step 2, and **dated**. After the data arrives, the rule applies as written — moving thresholds post-hoc invalidates the spec.

### Step 6 — Sample size and duration

A decision rule is only enforceable if the experiment has enough data to detect the threshold. Compute the minimum sample size at 80% power for the chosen threshold using the snippet in [`metrics-diagnose/references/stat-snippets.md`](../metrics-diagnose/references/stat-snippets.md) §4 (MDE / power check), inverted to solve for n instead of effect size:

```
# requirements: pip install statsmodels
from statsmodels.stats.power import NormalIndPower
from statsmodels.stats.proportion import proportion_effectsize

# --- inputs ---
p1 = 0.58        # baseline rate (current primary metric value)
p2 = 0.63        # target rate from the hypothesis (baseline + threshold)
alpha = 0.05
power = 0.80

effect_size = proportion_effectsize(p2, p1)
analysis = NormalIndPower()
n = analysis.solve_power(effect_size=effect_size, alpha=alpha, power=power,
                         alternative="two-sided")
print(f"Effect size (Cohen's h) = {effect_size:.3f}")
print(f"n required per group ≈ {n:.0f}")
```

Then translate to **calendar duration**:

> `duration_weeks = n_required ÷ (weekly_eligible_users × allocation_share)`

For continuous metrics (time on task, NPS) use Welch's t-test power instead — same `NormalIndPower` shape but `effect_size = (m2 − m1) / pooled_sd`; ask the user for the baseline mean and SD.

If the required duration exceeds the time the team has, name the trade-off explicitly:

- **Lower the threshold** — accept a smaller MDE the test can actually detect. State the new threshold in the spec.
- **Extend the duration** — push the decision out and tell stakeholders why.
- **Lower the power** — possible (down to ~70%) but reduces the chance of catching real effects. Document the reduced power, do not hide it.
- **Drop to qualitative** — if n is unreachable, the quantitative decision rule is infeasible. Switch to qualitative success criteria (5–8 interview themes), see [`metrics-basics/references/measurement-philosophy.md`](../metrics-basics/references/measurement-philosophy.md), Situation 2.

### Step 7 — Emit the spec artefact

Use [spec-template.md](references/spec-template.md). The filled template is the deliverable; everything above is the work to produce it. The artefact has eight blocks:

1. **Title and date** — what is being measured, when the spec was written.
2. **Owner and sign-off** — who wrote it, who approves it.
3. **Hypothesis** — the full sentence from Step 3.
4. **Primary metric** — definition, current baseline, target threshold.
5. **Counter-metric and guardrails** — names and "must not regress" thresholds.
6. **Decision rule** — three rows (Ship / Kill / Iterate).
7. **Sample size and duration** — required n per group, calendar window, allocation.
8. **Instrumentation status** — what is already tracked, what needs to be added before launch.

End with the verify question.

### Step 8 — Verify

End every spec with: **"Does this fit your situation, or should we adjust before sign-off?"**

If the user changes the hypothesis or threshold after this point, the spec restarts from Step 3 — moving thresholds is the failure mode this skill exists to prevent.

## Example

**User prompt (specific mode):** *"We're rebuilding the onboarding flow next sprint. Current step-3 (profile setup) completion rate is 58% (n ≈ 30k new signups/week). Hypothesis is that removing the optional-fields block will lift it. PM and design lead need to sign off before we touch the code. We have Amplitude with full event tracking. How do I write the measurement plan?"*

**Mode detection:** Specific — has the change, baseline, hypothesis direction, audience, and DATA.

**Anchor parse:**
- SCOPE: present (onboarding step-3, profile setup)
- STAGE: present (pre-launch — "next sprint")
- AUDIENCE: present (PM, design lead)
- DATA: present (Amplitude, full events)

All 4 present. Proceed to Step 3.

**Step 3 — Hypothesis (rewritten with the user):**

> If we **remove the optional-fields block from onboarding step-3**, then **task success on step-3 (completion rate)** will **rise by at least 5 percentage points (58% → ≥63%)** because **the optional fields create the impression that all fields are required, and new users abandon rather than skip them**. We will know **within 6 weeks of full rollout** (4 weeks for cohorts to accumulate, plus 7 days of post-signup observation for the Day-7 retention counter).

Mechanism is present, magnitude is named, window is named — falsifiable.

**Step 4 — Metrics:**

- **Primary:** Step-3 completion rate (Task Success category — see [`metrics-ux/references/ux-task-success.md`](../metrics-ux/references/ux-task-success.md)), new signups only, 7-day rolling. Baseline 58%, target ≥63%.
- **Counter-metric:** Day-7 retention for the new-signup cohort. Threshold: must not regress by more than 2 pp ([`business-language.md`](../metrics-present/references/business-language.md), counter-metric framing — a fast completion that does not retain is not improvement, see [`metrics-ux/references/ux-retention.md`](../metrics-ux/references/ux-retention.md)).
- **Guardrails:** Step-3 average task time (must not increase by >10 s), profile-edit support tickets (must not rise by >25% rel — users hitting friction after onboarding).
- **Input metrics:** Field-level abandonment per step-3 field, time-to-step-3, CSAT on the post-onboarding micro-survey.

**Step 5 — Decision rule:**

| Outcome | Threshold | Action |
|---|---|---|
| **Ship** | Step-3 completion ≥63% AND Day-7 retention not down >2 pp AND guardrails held | Roll to 100% of new signups |
| **Kill** | Step-3 completion ≤56% OR Day-7 retention down >4 pp OR any guardrail breached | Revert |
| **Iterate** | Completion between 58–63% OR underpowered at the 6-week mark | Run for 2 more weeks at 50%, then re-evaluate |

**Step 6 — Sample size and duration:**

```
p1 = 0.58, p2 = 0.63, alpha = 0.05, power = 0.80
→ Cohen's h ≈ 0.101, n per group ≈ 1,540
```

At ~30,000 new signups/week with 50/50 allocation, each arm sees ~15,000/week — well above the 1,540 threshold. The 6-week window is set by cohort-formation needs (4 weeks of cohorts + 7-day retention observation for the last cohort), not by power. Sample is not the constraint.

**Step 7 — Spec artefact:** rendered via [spec-template.md](references/spec-template.md), filled with the values above. Owner: [designer name]. Sign-off: PM + design lead. Date: [today].

**Step 8 — Verify:** "Does this fit your situation, or should we adjust before sign-off?"

### Example 2 — pre-launch with no baseline

**User prompt (vague mode):** *"We're launching a brand-new AI assistant feature in two months. I want a measurement plan ready before we ship. There are no users yet."*

**Mode detection:** Vague — change named, but no baseline, no hypothesis, no audience.

**Anchor parse:**
- SCOPE: present (AI assistant, new feature)
- STAGE: present (pre-launch)
- AUDIENCE: missing
- DATA: missing

**Questionnaire (2 missing → numbered list):**

> Two quick questions before drafting the plan:
> 1. **AUDIENCE** — who needs to sign off on the plan (self, PM, eng lead, leadership)?
> 2. **DATA** — what analytics will be in place at launch (Amplitude/Mixpanel/PostHog with full events, GA-only, or instrumenting from scratch)?

**User reply:** *"PM signs off. We're instrumenting from scratch, eng has a 2-week window for events before launch."*

**Step 3 — Hypothesis.** Pre-launch with no baseline forces a different shape — there is no "current rate" to lift. Two options:

- **Adoption-first hypothesis** (when the question is "will users use this?"): *"At least 30% of weekly active users will invoke the AI assistant at least once within 14 days of launch, because [the entry point is surfaced in the main nav]. We will know within 6 weeks of launch."*
- **Activation hypothesis** (when the question is "will users find value?"): *"Of users who invoke the assistant once, at least 40% will return to use it in their next session within 7 days, because [the first-use experience surfaces an immediately useful answer]. We will know within 6 weeks of launch."*

Pick one as primary based on which question matters more to the team. Both can live in the spec; only one decides.

**Step 4 — Metrics:**

- **Primary:** Activation Rate (assistant invoked + returned-to-assistant within 7 days). Baseline: none (pre-launch); target ≥30% within 6 weeks ([`metrics-ux/references/ux-adoption.md`](../metrics-ux/references/ux-adoption.md) — activation definition).
- **Counter-metric:** Core-flow task success rate (the non-assistant path). Threshold: must not regress by more than 2 pp. Catches the failure mode where the assistant cannibalizes a working flow.
- **Guardrails:** p95 response latency <2.5 s; cost-per-invocation tracked but not gated.

**Step 5 — Decision rule:** same three-row pattern, written before launch. Ship if Activation ≥30% AND core-flow task success held. Kill if Activation <10% OR core-flow regressed. Iterate otherwise (most likely outcome for a v1).

**Step 6 — Sample size and duration.** Without a baseline, the test isn't pre-vs-post — it's "did Activation clear 30%?". Sample is set by the precision needed on the rate, not by a comparison. For a target of 30% ±5 pp at 95% confidence, n ≈ 320 activated users. If the feature gets 1,000 weekly invocations, the spec is detectable from week 2 onward.

**Step 7 — Spec artefact:** rendered via [spec-template.md](references/spec-template.md). Owner: [designer]. Sign-off: PM. **Instrumentation status section flagged** — events not yet built; spec is conditional on the eng 2-week window being met. Add a line: *"Spec is invalid if instrumentation is incomplete at launch; default to qualitative success criteria (8 interview themes across the first 50 users) until events ship."*

**Step 8 — Verify:** "Does this fit your situation, or should we adjust before sign-off?"

## Common Pitfalls

These apply across every measurement plan. Each is also covered in the references for specific cases.

- **Vague hypothesis.** "Improve onboarding" is not falsifiable — the team will declare victory regardless of what happens. Rewrite to name change, behavior, magnitude, mechanism, and window (Step 3). [hypothesis-patterns.md](references/hypothesis-patterns.md) has the rewrite table.
- **Primary metric without a counter.** Single-metric specs become Goodhart traps the moment they ship. Always pair the primary with a counter the team would be embarrassed to ship if it moved wrong. See [`metrics-basics/references/measurement-philosophy.md`](../metrics-basics/references/measurement-philosophy.md), Misconception 3.
- **Decision rule with no "iterate" branch.** Ship-or-kill specs force binary outcomes on data that is usually inconclusive. The most common real outcome is "underpowered, direction right" — name the iterate branch explicitly. [decision-rules.md](references/decision-rules.md).
- **Threshold pulled from the air.** "10% lift" sounds reasonable but means nothing without a baseline and a sample-size check. Compute the MDE detectable at the available n; if the chosen threshold is below it, the spec is undetectable. Step 6.
- **Self sign-off only.** A spec one person signs is a private note, not a commitment. Require at least one other named signer — usually the person who controls the ship decision (PM, eng lead, design lead).
- **Spec written after the data is in.** Pre-registration only works if the threshold was named before the result. Writing the spec post-hoc is reporting, not planning — refuse, redirect to `metrics-diagnose` for honest interpretation of what already happened.
- **Naming analytics tools unprompted.** Do not name specific tools (Mixpanel, Amplitude, PostHog, Heap, GA4, etc.) unless the user has already named one. Ask first.

## Red Flags

When the user's situation triggers any of these, do not write the spec. Refuse or redirect.

- **Decision already made (measurement theater).** The team has already chosen to ship/kill; they want a spec that retro-justifies it. Refuse — same mechanism as [`measurement-philosophy.md`](../metrics-basics/references/measurement-philosophy.md) Situation 3. Offer to write a spec for the *next* decision, not this one.
- **No falsifiable hypothesis.** After two rewrites, the user cannot name what outcome would change their mind. The work isn't ready for a spec — recommend a kickoff session to pin down the hypothesis, then come back.
- **Post-launch.** The change has already shipped, the metric has already moved. A spec written now is rationalization. Redirect to `metrics-diagnose`.
- **Threshold incompatible with sample size.** The required n is unreachable in any realistic window AND the user refuses to lower the threshold or extend duration. Switch to qualitative success criteria or stop — quantitative pre-registration on an undetectable threshold is theater. See [`measurement-philosophy.md`](../metrics-basics/references/measurement-philosophy.md), Situation 2.
- **Out-of-scope (revenue, MRR, monetization).** Conversion (free → paid), revenue churn, LTV are deferred to `metrics-product` v2. Same boundary as the other skills — name it, offer the UX-side equivalent if one exists, stop.
- **Wrong skill.** If diagnosing a movement → `metrics-diagnose`. If still browsing metric options → `metrics-ux`. If designing the tracking plan → `metrics-instrumentation`. If reviewing a claim → `metrics-review`. If communicating the result → `metrics-present`.
