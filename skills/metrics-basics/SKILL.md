---
name: metrics-basics
description: Defines UX measurement frameworks, terms, and philosophy when the user is learning the foundation rather than applying it — "what is HEART?", "define cohort retention", "what is MDE?", "what's a decision rule?", "why do we measure things this way?". Skip when a real situation is in mind (redesign, metric drop, stakeholder report, pre-launch plan, A/B test, tracking plan, claim review) — those go to the content skills.
allowed-tools: Read
---

## Overview

Shared foundation for every metrics skill in this repo. Holds the HEART framework, measurement philosophy, the term glossary, and the 4 context anchors used by adaptive mode. Other skills (`metrics-ux`, `metrics-spec`, `metrics-instrumentation`, `metrics-diagnose`, `metrics-review`, `metrics-present`) read these references when they need shared context.

## When to Use

Use this skill when:

- The user asks directly about HEART (categories, Goals–Signals–Metrics, choosing categories).
- The user asks what a metric term means (e.g. "what's a baseline?", "what's a cohort?").
- The user asks a meta question about measurement ("why measure this?", "when should we not measure?").
- Another skill needs the 4 context anchors to run its adaptive questionnaire.

Do not use this skill when the user has a concrete task that fits a content skill (UX measurement, diagnosing a metric drop, presenting results). Those skills load this one's references as needed.

## References

Read only what the current task requires. Do not load all references by default.

- [heart.md](references/heart.md) — Google HEART framework: 5 categories, Goals–Signals–Metrics, choosing categories, baselines, common pitfalls. Read when the user mentions HEART, picks UX categories, or needs the Goals–Signals–Metrics process.
- [measurement-philosophy.md](references/measurement-philosophy.md) — why we measure, what measurement is not, when not to measure. Read when the user questions the value of measurement, proposes a vanity metric, or asks meta questions.
- [glossary.md](references/glossary.md) — definitions of recurring terms (baseline, cohort, vanity metric, Goodhart, counter-metric, HEART, NPS, MDE, decision rule, tracking plan, PII, SRM, etc.) grouped by category: frameworks, UX metrics, statistics, communication, and planning/experimentation/instrumentation/review. Read when the user asks what a term means or uses one ambiguously.
- [context-questions.md](references/context-questions.md) — full wording of the 4 anchors (SCOPE / STAGE / AUDIENCE / DATA), present-vs-missing prompt examples, decision logic, and the inline-list convention for asking the user. Read when running the adaptive questionnaire in vague mode or when any skill is about to ask the user something.
