---
name: metrics-help
description: Router for ambiguous metrics prompts — "metrics", "help with metrics", "where do I start?", `/metrics-help`. Asks one scoping question and points to the right skill. Fallback only — the seven content/foundation skills auto-trigger themselves; skip this one when intent fits metrics-ux, metrics-spec, metrics-instrumentation, metrics-diagnose, metrics-review, metrics-present, or metrics-basics.
allowed-tools: Read
---

## Overview

Routes ambiguous metrics prompts to the right skill. Does not answer metrics questions itself. Asks one short scoping question, maps the answer to a target skill, and tells the user which skill to invoke next.

The seven content/foundation skills auto-trigger from their own `description` fields. This router exists for the residual cases — one-word prompts, mixed intent, or users who explicitly ask "which skill?".

## When to Use

Trigger this skill when:

- User runs `/metrics-help`.
- User asks directly: "which metrics skill should I use?", "where do I start?", "hansı skill?".
- Prompt is too short or vague for the seven to match — e.g. "metrics", "help me with metrics", "I need to measure something".
- Prompt mixes two or more jobs and it is unclear which comes first — e.g. "I need to write a measurement plan and instrument the events".

Do not trigger when the prompt clearly matches one of the seven skills. Their descriptions handle their own selection.

## Routing

### Step 1 — Scoping question

Ask only when the prompt is genuinely ambiguous. Skip the question when **any** of these signals is already present:

- A design situation is named with no commitment to a decision rule (redesign, launch, onboarding, feature) → go to `metrics-ux`.
- The user wants a written measurement plan **before** shipping ("measurement plan", "PRD for metrics", "pre-register", "success criteria", "decision rule") → go to `metrics-spec`.
- The user mentions tracking plan, event taxonomy, naming convention, event spec, "what to log", PII → go to `metrics-instrumentation`.
- A number, percentage, before/after, or "dropped/spiked" is mentioned with data the user owns → go to `metrics-diagnose`.
- The user wants to stress-test a claim ("is this real?", "vet this case study", "review my draft before publish") → go to `metrics-review`.
- An audience or format is named (CPO, board, slide, review, report) → go to `metrics-present`.
- A framework or term is named with no task ("what is X?", "define X") → go to `metrics-basics`.

Otherwise, ask:

> What do you need help with?
> 1. Picking which metrics to measure (a redesign, a launch, a feature)
> 2. Writing a measurement plan before the change ships (hypothesis, decision rule)
> 3. Designing the events / tracking plan that captures a metric
> 4. Understanding what a metric movement means (you have data, a number changed)
> 5. Stress-testing a metric claim (incoming claim or self-review before publishing)
> 6. Communicating results to stakeholders (review, slide, report)
> 7. Learning a framework or term (HEART, decision rule, tracking plan, PII)

Follow the "How to ask" section in [context-questions.md](../metrics-basics/references/context-questions.md) — closed 7-way choice, inline numbered list.

If 7 options is too many for the prompt, collapse to the lifecycle phase first:

> Where are you in the project?
> 1. **Before launch** — picking metrics, writing the plan, designing instrumentation
> 2. **After data exists** — diagnosing a movement or reviewing a claim
> 3. **Communicating** — building the stakeholder story
> 4. **Learning** — defining a term

Then drill into the specific skill within that phase.

### Step 2 — Map answer to skill

| Answer (full 7-way) | Target skill |
|---|---|
| 1 — picking metrics | `metrics-ux` |
| 2 — writing a measurement plan | `metrics-spec` |
| 3 — designing the tracking plan | `metrics-instrumentation` |
| 4 — interpreting data you own | `metrics-diagnose` |
| 5 — stress-testing a claim | `metrics-review` |
| 6 — communicating results | `metrics-present` |
| 7 — learning a term | `metrics-basics` |

Out-of-scope cases:

- Revenue, MRR, churn, LTV, conversion (free→paid) → say: "Business/product metrics are out of scope. For UX-side equivalents (adoption, retention, task success) use `metrics-ux`."
- A/B test design (variant split, randomization unit, stopping rule, sequential testing) → say: "Designing experiments is PM / growth / eng work, not in this skill set. For the designer-facing pieces of an A/B test — the decision rule before the test, the analysis after, the stakeholder story — use `metrics-spec`, `metrics-diagnose`, `metrics-review`, `metrics-present` respectively."
- Stakeholder conflict ("CPO disagrees with my metric") → say: "This is a communication and framing question. Use `metrics-present` for the framing; for vetting the stakeholder's counter-claim use `metrics-review`."
- Tool-specific configuration (GA4, Mixpanel, Amplitude, PostHog setup) → say: "This skill set covers method, not tool configuration. Use `metrics-instrumentation` for the tool-agnostic plan; the tool's own docs handle config."
- Statistical method tutorials ("teach me hypothesis testing") → say: "This skill set applies statistics to UX measurement, not statistical theory. Use `metrics-basics` for terms and `metrics-diagnose`/`metrics-spec` for application."
- Data exists but no baseline / sample too small → still route to `metrics-diagnose`. That skill's Red Flags handle the "stop and ask" path; the router does not pre-filter on data quality.

### Step 3 — Multi-skill sequences

If the user's job needs more than one skill, recommend the order. User confirms before proceeding.

| Situation | Sequence |
|---|---|
| New design + want to present impact later | `metrics-ux` → (collect data) → `metrics-present` |
| New design + want decision rule before shipping | `metrics-ux` → `metrics-spec` → (collect data) → `metrics-diagnose` → `metrics-present` |
| Plan + instrument (full pre-launch) | `metrics-spec` → `metrics-instrumentation` → (collect data) → `metrics-diagnose` |
| Metric dropped + need to brief stakeholders | `metrics-diagnose` → `metrics-present` |
| Stress-test the result before publishing | `metrics-diagnose` → `metrics-review` (self-review mode) → `metrics-present` |
| Incoming vendor / "industry benchmark" claim | `metrics-review` only |
| Defining a metric + then planning measurement | `metrics-basics` → `metrics-ux` |
| Plan + measure + diagnose (full lifecycle) | `metrics-spec` → `metrics-instrumentation` → (collect data) → `metrics-diagnose` → `metrics-review` → `metrics-present` |
| Stakeholder pushback on metric choice | `metrics-basics` (frame the term) → `metrics-review` (vet their alternative) → `metrics-present` (defend) |
| Messy live taxonomy needs cleanup | `metrics-instrumentation` (audit mode) |

State it as: "Start with `metrics-spec` to write the plan. Once the change is shipped and data accrues, use `metrics-diagnose` to interpret. Sound right?"

**General rule for prompts not in the table.** When the user names ≥2 jobs in one prompt, list the sequence as numbered steps, name the bridge artifact between each step (signed spec, tracking plan version, validated numbers, draft slide), and stop. Do not chain-trigger — skills cannot invoke each other, so the user has to re-enter the next prompt when they have the bridge artifact in hand.

### Step 4 — Hand off

Tell the user which skill to invoke and stop. Do not answer the underlying metrics question — that is the target skill's job. Example:

> Sounds like a pre-launch measurement plan. Use `metrics-spec` next. It will ask about scope, stage, audience, and data, then walk you through hypothesis, primary metric, counter-metric, decision rule, and sample size.

## Limits

- Never recommend a metric, never interpret data, never draft a tracking plan, never review a claim, never write a stakeholder message. Routing only.
- Maximum one scoping question per session. If the answer is still unclear, pick the closest skill and let the user redirect.
- If the prompt clearly matches one of the seven skills, do not route — let that skill auto-trigger. Routing a clear prompt adds friction.
