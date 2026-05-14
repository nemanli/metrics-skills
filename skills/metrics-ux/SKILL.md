---
name: metrics-ux
description: Use when the user asks how to measure UX outcomes — usability, satisfaction, completion, drop-off, adoption, retention, or task success applied to a real design situation. Use when the user describes a redesign, onboarding flow, or feature launch and wants metrics. Use when the user asks "what should I measure" after a design change. Skip for revenue, MRR, business growth (deferred to metrics-product v2). Skip for diagnosing a metric drop (use metrics-diagnose). Skip for building a stakeholder report (use metrics-present). Skip for pure framework definitions with no measurement task (use metrics-basics).
allowed-tools:
---

## Overview

Recommends UX metrics grounded in Google's HEART framework (Rodden, CHI 2010). Five categories — Happiness, Engagement, Adoption, Retention, Task Success — each backed by a reference file with sourced metrics, formulas, examples, and pitfalls. Picks the right metric for the user's situation; refuses or redirects when measurement isn't the right answer.

This skill is for designer-driven measurement. Conversion rate (free → paid), revenue churn, MRR, LTV, and other monetization-side metrics are deferred to a future `metrics-product` skill.

## When to Use

Use this skill when a designer asks any of the following — phrased differently by seniority but matching the same job-to-be-done:

| Designer level | Typical phrasing that should trigger this skill |
|---|---|
| **Junior** | "I shipped a screen, did it work?" / "How do I know if my design worked?" / "PM asked how the release went and I have nothing concrete to say" / "What should I measure for this onboarding redesign?" |
| **Middle** | "I'm starting a new project, what should I track from day one?" / "What metrics should I set up before the redesign so I can show before/after?" / "How do I measure a feature like this?" |
| **Senior** | "I need to defend this design to leadership / the CPO" / "How do I speak the language of business and data?" / "Which metrics confirm the value of this AI feature?" |
| **Lead** | "What metrics should the team standardize on?" / "We need a consistent measurement approach across designers" / "What's the maturity baseline for our team's metric practice?" |

Cross-cutting triggers (any seniority):

- Asks how to measure a specific UX outcome (satisfaction, completion, retention, adoption, engagement, task success).
- Asks for the definition or formula of a HEART-category metric (CSAT, NPS, SUS, CES, DAU/MAU, feature adoption, activation, cohort retention, churn, task success, error rate, drop-off, learnability).
- Needs to set baselines or success thresholds for a UX metric.

Skip this skill when:

- A metric has dropped and the user wants to find out why → use `metrics-diagnose`
- The user has results and needs to present them to leadership → use `metrics-present`
- The question is about HEART theory, framework definitions, or measurement philosophy → use `metrics-basics`
- The metric is monetization-driven (revenue, MRR, LTV, free→paid conversion) → out of scope for v1

## Process

### Step 1 — Detect mode

Read the user's prompt and pick one mode:

| Mode | Signal | Action |
|---|---|---|
| **Direct** | Asks about a named metric or definition ("What is Task Success Rate?", "How is HEART Adoption measured?") | Skip questionnaire. Open the matching reference file directly. |
| **Specific** | Gives both a clear situation AND a goal/constraint ("Onboarding completion dropped from 60% to 45%, recover in 30 days") | Skip questionnaire. Recommend metrics directly. |
| **Vague** | Describes a situation but no clear goal/data ("I redesigned onboarding, what should I measure?") | Run hybrid questionnaire (Step 2). |

### Step 2 — Hybrid questionnaire (vague mode only)

Four context anchors, full version in [metrics-basics/references/context-questions.md](../metrics-basics/references/context-questions.md):

1. **SCOPE** — which product or feature, what specifically being measured
2. **STAGE** — pre-launch / just launched / mature
3. **AUDIENCE** — what the data is for, who will see it
4. **DATA** — what analytics and tools are in place

For each anchor, mark **present** (clear in prompt) or **missing**. Ask only for missing anchors:

- 0–1 missing → ask in one sentence
- 2–3 missing → ask in one numbered list
- 4 missing → use the full questionnaire

Never re-ask what the user already provided. Maximum 4 questions per session.

When asking, follow the "How to ask" section in [context-questions.md](../metrics-basics/references/context-questions.md) — inline numbered list for closed-choice questions.

### Step 3 — Pick HEART category

Match the user's situation to the HEART category. When in doubt, run the Goals–Signals–Metrics process from [heart.md](../metrics-basics/references/heart.md).

| User situation | Primary category | Reference |
|---|---|---|
| Subjective satisfaction, perceived ease, NPS, SUS, CSAT, CES | Happiness | [ux-happiness.md](references/ux-happiness.md) |
| Habit, depth, frequency, DAU/MAU, time spent | Engagement | [ux-engagement.md](references/ux-engagement.md) |
| New users, feature uptake, activation, time-to-first-value | Adoption | [ux-adoption.md](references/ux-adoption.md) |
| Return rate, churn, cohort curves, PMF check | Retention | [ux-retention.md](references/ux-retention.md) |
| Task completion, errors, time on task, drop-off, learnability | Task Success | [ux-task-success.md](references/ux-task-success.md) |

Multi-category situations are common. Onboarding redesign typically spans Adoption + Task Success + Happiness. Recommend 2–3 categories paired, not one in isolation (HEART pairing is structural — see [measurement-philosophy.md](../metrics-basics/references/measurement-philosophy.md), Pillar 2).

### Step 4 — Recommend metrics from the reference

Open the matching reference file(s) and use its **"Choosing between them"** table at the bottom — every reference has one. Filter the candidates against the anchors from Step 2:

| Anchor | What it filters out |
|---|---|
| **STAGE = pre-launch** | All behavioral metrics (no traffic = no signal). Redirect to qualitative methods (Red Flags, below). |
| **STAGE = just launched** | Cohort retention beyond Day 30, mature-baseline comparisons (cohorts haven't had time). Recommend baseline-setting metrics. |
| **STAGE = mature** | All metrics in scope. Pick by goal, not stage. |
| **DATA = no analytics** | Behavioral metrics that need event tracking (Stickiness, Activation, Cohort Retention, Drop-off). Recommend survey-based (CSAT, NPS, SUS) + qualitative + plan to instrument. |
| **DATA = funnels only** | Multi-step diagnostics OK; per-user medians and cohort curves may be unavailable. |
| **DATA = full event tracking (Amplitude, Mixpanel, PostHog, etc.)** | All metrics in scope. |
| **AUDIENCE = self / team retro** | Diagnostic-style: per-step drop-off, per-segment breakdown, qualitative heavy. |
| **AUDIENCE = leadership / board** | Headline + 2–3 supporting + counter-metric, business-language framing (defer to `metrics-present` for the final output). |

After filtering, every recommendation must include:

- A **headline metric** for the primary HEART category — chosen from the reference's "Choosing between them" table.
- A **counter-metric** to prevent gaming (Goodhart guard, see [measurement-philosophy.md](../metrics-basics/references/measurement-philosophy.md), Misconception 3). Often comes from a different HEART category — e.g. headline = Activation Rate, counter = Day 7 Retention.
- A **qualitative pair** — at least one qualitative method (interview, session recording, open-text micro-survey) for the recommendation overall, not per metric ([measurement-philosophy.md](../metrics-basics/references/measurement-philosophy.md), Default Rule 3). One interview round can ground multiple quantitative metrics.

When the reference's "Choosing between them" table has multiple matches for the user's situation, prefer the one explicitly tied to their STAGE or product type (daily-use vs weekly-use, subscription vs freemium, B2B vs B2C). Never recommend a metric the user can't measure with their current DATA — flag the gap and propose what to instrument.

### Step 5 — Verify

End every recommendation with: **"Does this fit your situation, or should we narrow down?"**

## Example

**User prompt (vague mode):** *"I redesigned the onboarding flow for our mobile app last sprint. What should I measure?"*

**Mode detection:** Vague — situation present, no goal or data mentioned.

**Anchor parse:**
- SCOPE: present (onboarding flow, mobile app)
- STAGE: missing (just shipped? still in beta?)
- AUDIENCE: missing (self? PM? CPO?)
- DATA: missing (what analytics is set up?)

**Questionnaire (3 missing → numbered list):**

> Three quick questions before I recommend metrics:
> 1. **STAGE** — has it shipped to all users yet, or still in a phased rollout?
> 2. **AUDIENCE** — is this for your own learning, a team retro, or to defend the redesign to leadership?
> 3. **DATA** — what analytics do you already have set up (Amplitude, Mixpanel, GA, in-house, none)?

**User reply:** *"Shipped 2 weeks ago to all new signups. For my own learning + a team retro in 2 weeks. We have Amplitude with all events tracked."*

**Anchor refresh:** all 4 present. STAGE = just launched (baseline still forming); AUDIENCE = self + team (diagnostic, not stakeholder); DATA = Amplitude full.

**HEART pick:** Onboarding redesign primarily affects **Adoption** + **Task Success** + **Happiness** (perceived ease).

**Recommendation:**

> For an onboarding flow shipped 2 weeks ago, with Amplitude in place, focus on three metrics:
>
> 1. **Activation Rate** ([ux-adoption.md](references/ux-adoption.md)) — define your "habit moment" (e.g. "completed 3 core actions within 7 days") by comparing retainers vs churners in your data. This is the honest answer to "did they actually adopt?"
> 2. **Drop-off Rate per step** ([ux-task-success.md](references/ux-task-success.md)) — Amplitude funnel chart by step. Diagnoses *where* users abandon, not just how many.
> 3. **CSAT** ([ux-happiness.md](references/ux-happiness.md)) — one-question post-onboarding micro-survey. Captures perceived ease that behavioral metrics miss.
>
> **Counter-metric:** pair Activation with Day 7 retention ([ux-retention.md](references/ux-retention.md)) — high activation with low retention means users hit your threshold but didn't form a habit.
>
> **Qualitative pair:** 3–5 user interviews from new signups, focused on the moments where the funnel shows drop-off.
>
> **Note on STAGE:** baseline is still forming at 2 weeks. Wait at least 2–4 weeks more before reading the trend (see [measurement-philosophy.md](../metrics-basics/references/measurement-philosophy.md), Situation 1).
>
> Does this fit your situation, or should we narrow down?

## Common Pitfalls

These apply across all UX metric work. Each one is also covered in the reference files for specific cases.

- **Vanity metric trap.** Recommending raw totals (sign-ups, DAU, sessions, page views, CTR) when per-user or cohort versions exist. Convert to a ratio or median before recommending. Per-category vanity-vs-honest tables live in [ux-engagement.md](references/ux-engagement.md), [ux-adoption.md](references/ux-adoption.md), [ux-retention.md](references/ux-retention.md).
- **Single-metric trap.** Recommending one metric in isolation without a counter-metric. Goodhart's Law: any single metric becomes a gaming target. Always pair the headline with input metrics and at least one guardrail (see [measurement-philosophy.md](../metrics-basics/references/measurement-philosophy.md), Pillar 2 Guard).
- **Quant without qual.** Recommending a number without a qualitative pair (interview, session recording, open-text question). A number alone is a question, not an answer ([measurement-philosophy.md](../metrics-basics/references/measurement-philosophy.md), Default Rule 3).
- **Wrong category.** Picking Happiness (subjective) when the question is Task Success (behavioral), or Engagement when the question is Adoption. Use the Goals–Signals–Metrics process in [heart.md](../metrics-basics/references/heart.md) to derive the category from the goal.
- **Cohort confusion.** Calendar-period numbers ("this month's retention rate") that mix new and old users. Retention and adoption are *always* cohort questions (see [ux-retention.md](references/ux-retention.md), Cohort logic).
- **Comparing across products or industries.** Cross-product benchmarks (NPS by industry, stickiness by app type) are directional only — survey design, "active" definition, and segment mix shift the number. Compare to the user's own trend.
- **Naming analytics tools unprompted.** Do not name specific tools (Mixpanel, Amplitude, PostHog, Heap, GA4, etc.) unless the user has already named one or the DATA anchor has been probed and the user has no tool in place. Ask first: "What analytics tool are you currently using?"

## Red Flags

When the user's situation triggers any of these, do not recommend a metric. Refuse or redirect.

- **Pre-launch with no users.** Behavioral metrics produce no signal without traffic. Recommend qualitative methods (interviews, prototype testing, Sean Ellis 40% PMF test) — see [measurement-philosophy.md](../metrics-basics/references/measurement-philosophy.md), Situation 1.
- **Sample too small.** Below ~20 users, percentages produce noise that looks like signal. Recommend 5–8 qualitative interviews instead — see [measurement-philosophy.md](../metrics-basics/references/measurement-philosophy.md), Situation 2.
- **Decision already made (measurement theater).** User asks for metrics to confirm a decision the leadership has already locked. Refuse or be explicit: "this is reporting, not research." Offer to measure the *next* decision — see [measurement-philosophy.md](../metrics-basics/references/measurement-philosophy.md), Situation 3.
- **Value-based / strategic question framed as metrics.** "Should we add this dark pattern to lift conversion?" is not an A/B test question. Refuse the framing — see [measurement-philosophy.md](../metrics-basics/references/measurement-philosophy.md), Situation 4.
- **Out-of-scope (revenue, MRR, monetization).** Conversion rate (free → paid), revenue churn, LTV are deferred to `metrics-product` v2. Tell the user explicitly: "this is owned by PM/business; v1 covers designer-driven UX metrics only."
- **Wrong skill.** If the user is diagnosing a metric drop ("retention dropped, why?") → redirect to `metrics-diagnose`. If presenting results to stakeholders → redirect to `metrics-present`.
