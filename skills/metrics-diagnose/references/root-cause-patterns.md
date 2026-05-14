# Root-Cause Patterns

Twelve patterns for diagnosing metric movements: 4 HEART metric families × 3 patterns each. Each pattern lists **telltale signs** (what the data looks like when this is the cause), **how to confirm** (specific check), and **typical fix** (what usually addresses it).

Use after [SKILL.md](../SKILL.md) Step 4 (signal vs noise) confirms the change is real. These patterns are diagnostic priors, not certainties — match telltale signs against the user's data, rank by fit, then confirm with the suggested check.

For test methods (A/B test, user research, analytics dive), see [hypothesis-tests.md](hypothesis-tests.md).

---

## Adoption drops

Adoption metrics: Feature Adoption Rate, Activation Rate, Time-to-First-Value ([ux-adoption.md](../../metrics-ux/references/ux-adoption.md)).

### A1. Awareness gap

**Telltale signs.**
- Existing users (active before launch) show no behavior change; new users show low adoption.
- Feature usage concentrates in users who saw a release announcement, in-app banner, or email.
- Drop appears uniform across segments, not concentrated.

**How to confirm.** Cut adoption by exposure source (saw banner / saw email / no exposure). If adoption is high among the exposed and near-zero among the unexposed, the gap is awareness, not the feature itself.

**Typical fix.** Increase discovery — in-product entry points, tooltips on related features, contextual prompts at the moment of need. Industry guides commonly cite first-week awareness as the dominant adoption blocker for B2B and prosumer tools ([Pendo — Feature Adoption](https://www.pendo.io/glossary/feature-adoption/)).

### A2. UX friction at the entry point

**Telltale signs.**
- Users reach the feature entry point but don't complete the first action (high entry, low first-use completion).
- Drop-off concentrates in the first 1–2 steps after entering the feature.
- Time-to-First-Value is well above the cohort median for users who do activate.

**How to confirm.** Funnel from feature-entry → first-meaningful-action. If the drop is at step 1 or 2, friction is the cause. Pair with 5 quick usability tests on the entry flow.

**Typical fix.** Reduce steps to first value, default the most common configuration, remove non-essential fields. The "activation moment" (Sean Ellis / Reforge) is a per-product threshold that should be reachable in under a few minutes for most consumer flows ([Reforge — Activation](https://www.reforge.com/blog/why-product-led-growth-needs-an-activation-metric)).

### A3. Wrong audience or segmentation shift

**Telltale signs.**
- Headline adoption looks low, but a specific target segment (power users, paying customers, a vertical) has high adoption.
- The mix of new signups changed around the same window (marketing campaign, partnership, pricing change).
- Adoption rate per segment is stable; only the segment mix shifted (Simpson's paradox).

**How to confirm.** Cut adoption by acquisition source, account type, persona. Compare per-segment adoption between before and after. If per-segment numbers are flat but the headline moved, the cause is mix, not behavior.

**Typical fix.** Two paths: (a) re-target acquisition to the segments where the feature lands, or (b) adapt the feature to the new dominant segment. Decision depends on whether the segment shift is intentional.

---

## Retention drops

Retention metrics: N-day Cohort Retention, Customer Churn Rate, Return Frequency ([ux-retention.md](../../metrics-ux/references/ux-retention.md)).

### R1. Early-stage churn (onboarding leak)

**Telltale signs.**
- Day 1 and Day 7 retention dropped; Day 30+ retention for older cohorts is unchanged.
- The drop appears in the most recent cohorts only, not in retained users from earlier cohorts.
- Activation Rate also moved in the same direction.

**How to confirm.** Plot retention curves cohort by cohort. If recent cohorts diverge from older cohorts in the first 7 days but converge later, the leak is in onboarding or first-use, not in long-term value.

**Typical fix.** Diagnose the onboarding funnel (this is now an Adoption problem — see pattern A2). Common causes: a new mandatory field, a permission prompt, a confusing first screen. Early-cohort retention has outsized leverage — the steepest part of the curve is Day 0–7, where most products lose the majority of users ([Andrew Chen — Losing 80% of mobile users is normal](https://andrewchen.com/new-data-shows-why-losing-80-of-your-mobile-users-is-normal-and-that-the-best-apps-do-much-better/)).

### R2. Feature deprecation or value regression

**Telltale signs.**
- Retention drop concentrates in users who relied on a specific feature, integration, or workflow.
- Drop is gradual, not sudden — users churn over weeks as they hit the missing functionality.
- Support tickets, NPS open-text, or community posts mention the removed/changed feature.

**How to confirm.** Cut retention by past usage of the suspect feature. If users who used Feature X retain at a lower rate post-change, but users who never used X are flat, the deprecation is the cause. Cross-check with qualitative signals (support, NPS verbatims).

**Typical fix.** Restore the feature, provide a migration path, or explicitly communicate the trade-off. For B2B, proactive outreach to high-value affected accounts often saves more than feature restoration.

### R3. Cohort composition change (acquisition mix)

**Telltale signs.**
- Per-cohort retention curves are flat or improving when viewed individually.
- Headline retention dropped because new cohorts have different demographics (geography, device, acquisition channel) with structurally lower retention.
- Often coincides with marketing spend increases, paid channel expansion, or referral program launches.

**How to confirm.** Cut retention by acquisition channel and cohort. If organic users retain at the same rate as before, and paid users retain at a structurally lower rate (and paid mix grew), the cause is mix.

**Typical fix.** Two paths: (a) tighten acquisition targeting toward higher-retention segments, or (b) accept the mix and lower the retention target for the new blended population. Industry guides note that mix shifts are a common false alarm in retention diagnostics — the headline moves before any user behavior changes ([ChartMogul — Customer churn methodology](https://chartmogul.com/saas-metrics/customer-churn/)).

---

## Task Success drops

Task Success metrics: Task Success Rate, Error Rate, Time on Task, Drop-off Rate per step, Learnability ([ux-task-success.md](../../metrics-ux/references/ux-task-success.md)).

### T1. UI change introduced friction at a specific step

**Telltale signs.**
- Drop coincides exactly with a release date.
- Funnel breakdown shows the drop concentrated in one step (not uniform across the flow).
- Error Rate or Time on Task at that step also increased.

**How to confirm.** Funnel breakdown by step, week-over-week around the release date. Identify the step with the largest delta. If one step accounts for ≥70% of the total drop, this pattern is the cause.

**Typical fix.** Iterate on the affected step — reduce required input, clarify the action, fix the regression. Run 5 usability tests on the new step before re-shipping. NN/g's Macromedia Flash case (236s → 69s after task-time-driven redesign) is a canonical example of single-step friction reduction ([NN/g — Usability Metrics](https://www.nngroup.com/articles/usability-metrics/)).

### T2. Instruction or label clarity regressed

**Telltale signs.**
- Drop is not concentrated at one step — spread across multiple steps in the flow.
- Time on Task increased even at steps where Success Rate is unchanged (users hesitate).
- Open-text feedback mentions confusion ("I didn't know what this meant", "what does X mean here?").
- Often happens when copy is rewritten alongside a visual redesign.

**How to confirm.** Add a one-question post-task open-text survey on the failing flow ("what were you trying to do at this step?"). Or run 5 usability tests with think-aloud protocol. If users describe wrong intent or misread labels, clarity is the cause.

**Typical fix.** Rewrite affected copy with task-oriented language (verb + object: "Send invoice", not "Submit"). A/B test the new copy against the current. GOV.UK's LPA service moved its reported completion rate from 28.7% to ~70% by tightening the funnel definition and refining the journey — a reminder that "fixing the metric" sometimes also means fixing how the metric is computed ([GOV.UK Data Blog — Updating the LPA completion rate](https://dataingovernment.blog.gov.uk/2015/02/25/updating-the-lasting-power-of-attorney-completion-rate/)).

### T3. Edge case surfaced for a previously-protected segment

**Telltale signs.**
- Headline drop is moderate, but one segment (mobile, locale, account age, device class) shows a much larger drop.
- The release changed something segment-specific (responsive layout, locale-specific copy, a permission prompt that fires on certain OS versions).
- Other segments are flat or near-flat.

**How to confirm.** Cut Task Success by device, locale, account age, and OS version. Look for one segment with disproportionate drop. If isolating that segment recovers the headline, the edge case is the cause.

**Typical fix.** Address the segment-specific case (fix the mobile breakpoint, restore the locale string, handle the OS version). For next release, consider phased rollout with a hold-back segment to catch this earlier.

---

## Engagement shifts

Engagement metrics: Stickiness (DAU/MAU), Sessions per active user, Actions per session, Time on key tasks ([ux-engagement.md](../../metrics-ux/references/ux-engagement.md)).

### E1. Seasonal or external pattern

**Telltale signs.**
- Same week-over-week drop appears in last year's data at the same calendar window.
- Drop coincides with holidays, summer slowdown, end-of-quarter rush, or a known industry event.
- Other engagement metrics (Sessions, Actions) drop in proportion — no specific feature deteriorated.

**How to confirm.** Plot the metric across multiple years (or quarters) at the same calendar window. If the same dip appears year-over-year, seasonality is the explanation. Cross-check against industry benchmarks for the same window if available.

**Typical fix.** None — adjust the comparison baseline. Use year-over-year (same calendar week) instead of week-over-week. For forecasting, build seasonal adjustment into the metric dashboard.

### E2. New user mix dilution

**Telltale signs.**
- Stickiness (DAU/MAU) dropped, but per-cohort stickiness for established users is flat.
- New signups grew faster than retained users (MAU denominator inflated by users who haven't formed a habit yet).
- Often coincides with marketing campaigns, referral pushes, or going viral.

**How to confirm.** Cut Stickiness by cohort age (Day 0–30 cohort vs Day 60+ cohort). If older cohorts are stable and only the blended number dropped, the dilution effect is the cause. Industry analyses commonly flag this as a top false alarm in DAU/MAU dashboards — the ratio moves because the denominator inflates, not because users disengaged ([Andrew Chen — DAU/MAU is an important metric, but here's where it fails](https://andrewchen.com/dau-mau-is-an-important-metric-but-heres-where-it-fails/)).

**Typical fix.** Report Stickiness per cohort, not blended. For the headline, segment by user lifecycle stage. The growth itself is healthy — the metric framing is misleading.

### E3. Content or surface change reduced reasons to return

**Telltale signs.**
- Sessions per active user dropped while DAU is flat (users come less often, but the same population).
- A specific surface (feed, notifications, recommendations, content cadence) changed in the same window.
- Actions per session at that surface also dropped.

**How to confirm.** Cut Sessions by entry surface (push notification, email digest, direct app open). If the drop concentrates in one entry path, that surface is the cause. For content-driven products, check whether content publishing rate, recommendation diversity, or notification frequency changed.

**Typical fix.** Restore the changed input (publishing cadence, notification logic, recommendation diversity) or test alternatives. For content products, the relationship between content supply and engagement is direct — Andrew Chen's "law of shitty clickthroughs" applies: same content, more often, loses effect ([Andrew Chen — The law of shitty clickthroughs](https://andrewchen.com/the-law-of-shitty-clickthroughs/)).

---

## Cross-pattern guidance

When multiple patterns show medium-fit signs, **rank by cost-to-test, not by likelihood**. The cheapest test (a segment cut in existing analytics) should run before any test that requires new instrumentation, user research, or an A/B test. Real diagnoses often confirm one pattern and rule out another in the same session.

When **no pattern fits** the telltale signs, do not force a match. Common causes outside this list: data pipeline bug (definition drift — see [SKILL.md](../SKILL.md) Step 2), competitor or market shift, and platform-level changes (iOS update, browser change). For these, the diagnosis path is investigative, not pattern-matched — start with the data team or instrumentation review, not user research.
