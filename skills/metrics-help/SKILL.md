---
name: metrics-help
description: Use ONLY when the user explicitly asks which metrics skill to use, runs `/metrics-help`, or sends an ambiguous one-line prompt like "metrics", "help with metrics", "where do I start". Skip when the user's intent fits another skill — `metrics-ux` (measurement planning), `metrics-diagnose` (data interpretation), `metrics-present` (stakeholder communication), or `metrics-basics` (framework/term definitions). Those auto-trigger themselves; this skill is the fallback when none of them does.
allowed-tools:
---

## Overview

Routes ambiguous metrics prompts to the right skill. Does not answer metrics questions itself. Asks one short scoping question, maps the answer to a target skill, and tells the user which skill to invoke next.

The four content/foundation skills auto-trigger from their own `description` fields. This router exists for the residual cases — one-word prompts, mixed intent, or users who explicitly ask "which skill?".

## When to Use

Trigger this skill when:

- User runs `/metrics-help`.
- User asks directly: "which metrics skill should I use?", "where do I start?", "hansı skill?".
- Prompt is too short or vague for the other four to match — e.g. "metrics", "help me with metrics", "I need to measure something".
- Prompt mixes two jobs and it is unclear which comes first — e.g. "I need to measure onboarding and present results to the CPO".

Do not trigger when the prompt clearly matches one of the four skills. Their descriptions handle their own selection.

## Routing

### Step 1 — Scoping question

Ask only when the prompt is genuinely ambiguous. Skip the question when **any** of these signals is already present:

- A design situation is named (redesign, launch, onboarding, feature) → go to `metrics-ux`.
- A number, percentage, before/after, or "dropped/spiked" is mentioned → go to `metrics-diagnose`.
- An audience or format is named (CPO, board, slide, review, report) → go to `metrics-present`.
- A framework or term is named with no task ("what is X?", "define X") → go to `metrics-basics`.

Otherwise, ask:

> What do you need help with?
> 1. Picking which metrics to measure (a redesign, a launch, a feature)
> 2. Understanding what a metric movement means (you have data, a number changed)
> 3. Communicating results to stakeholders (review, slide, report)
> 4. Learning a framework or term (HEART, cohort, vanity metric)

Follow the "How to ask" section in [context-questions.md](../metrics-basics/references/context-questions.md) — closed 4-way choice, inline numbered list.

### Step 2 — Map answer to skill

| Answer | Target skill |
|---|---|
| 1 — picking metrics | `metrics-ux` |
| 2 — interpreting data | `metrics-diagnose` |
| 3 — communicating results | `metrics-present` |
| 4 — learning a term | `metrics-basics` |

Out-of-scope cases:

- Revenue, MRR, churn, LTV, conversion → say: "Business/product metrics are deferred to a future `metrics-product` skill (v2). For UX-side equivalents (adoption, retention, task success) use `metrics-ux`."
- Stakeholder conflict ("CPO disagrees with my metric") → say: "This is a communication and framing question. Use `metrics-present` for the framing; the disagreement itself is outside the metrics skill set."
- Tooling setup (GA4, Mixpanel, Amplitude config) → say: "This skill set covers method, not tool configuration. Use the tool's own documentation."
- Data exists but no baseline / sample too small → still route to `metrics-diagnose`. That skill's Red Flags handle the "stop and ask" path; the router does not pre-filter on data quality.

### Step 3 — Multi-skill sequences

If the user's job needs more than one skill, recommend the order. User confirms before proceeding (cross-skill rule #4).

| Situation | Sequence |
|---|---|
| New design + want to present impact later | `metrics-ux` → (collect data) → `metrics-present` |
| Metric dropped + need to brief stakeholders | `metrics-diagnose` → `metrics-present` |
| Defining a metric + then planning measurement | `metrics-basics` → `metrics-ux` |

State it as: "Start with `metrics-ux` to pick the metrics. Once you have data, come back and use `metrics-present` for the impact story. Sound right?"

### Step 4 — Hand off

Tell the user which skill to invoke and stop. Do not answer the underlying metrics question — that is the target skill's job. Example:

> Sounds like a measurement planning question. Use `metrics-ux` next. It will ask about scope, stage, audience, and data, then recommend metrics grounded in HEART.

## Limits

- Never recommend a metric, never interpret data, never write a stakeholder message. Routing only.
- Maximum one scoping question per session. If the answer is still unclear, pick the closest skill and let the user redirect.
- If the prompt clearly matches one of the four skills, do not route — let that skill auto-trigger. Routing a clear prompt adds friction.
