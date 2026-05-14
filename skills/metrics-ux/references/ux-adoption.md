# UX Adoption — metrics

HEART Adoption category — new users starting to use the product or feature in a given period. All three metrics here are behavioral. Adoption answers "did people start using it?" — not "did they keep using it?" (see [ux-retention.md](ux-retention.md)) or "did they do it well?" (see [ux-task-success.md](ux-task-success.md)). HEART treats Adoption and Retention as distinct categories ([Rodden](https://kerryrodden.com/heart/)), so adoption alone doesn't show whether new users stick — always pair with a retention or activation metric. For category context, see [heart.md](../../metrics-basics/references/heart.md#the-five-categories).

**Scope note.** HEART Adoption also lists "upgrade rate from free to paid" as an indicator. Conversion / monetization metrics are owned primarily by PM and business, not design — they are deferred to a future `metrics-product` skill. This file covers only the adoption metrics that designers directly drive through UX work.

**Vanity warning.** Sign-up counts and "users who clicked the feature once" are the most common vanity metrics in adoption. They rise with marketing pushes and curiosity clicks even when nobody actually adopts the product. Pair every adoption number with an activation or first-value metric (below).

---

## Feature Adoption Rate

**Definition.** Share of active users who use a specific feature within a given period.

**When to use.** Tracking uptake of a new or existing feature among the people who actually use the product. Best for feature-level questions ("did our new dashboard land?"); not a substitute for product-wide growth metrics.

**How to measure.**
- Formula: `(users who used the feature in period / total active users in period) × 100` ([Pendo](https://www.pendo.io/glossary/feature-adoption/)). Define "active user" before measuring — typically MAU or WAU, depending on your product cycle.
- Define "used the feature" as a meaningful action, not a page view. Opening the feature page is curiosity; completing the feature's core action is adoption.
- Sample size: feature-level adoption is a population ratio. Segment cuts (region, plan, cohort) need a large enough segment to keep the ratio stable; small segments produce week-to-week noise that can be mistaken for real shifts.
- Timing: 30-day rolling window for monthly products; 7-day for daily-use products ([Amplitude — KPI tracking with rolling windows](https://amplitude.com/docs/analytics/insights)). Single-day adoption is too noisy.

**Example (illustrative).** A SaaS app has 10,000 monthly active users. In month 3 after launching a new export feature, 1,200 of them export at least once. Feature adoption = (1,200 / 10,000) × 100 = **12%** (hypothetical figures). The previous month it was 8% — adoption is climbing, but well below the product's most-used feature (~40%).

**Benchmark.** Pendo's cross-product benchmark puts median feature adoption at ~6.4% and top-decile at ~15.6% ([Pendo, 2024](https://www.pendo.io/pendo-blog/feature-adoption-benchmarking/)). Compare to your own product trend; cross-product benchmarks are directional, not targets.

**Pitfalls.**
- Counting "feature opened" as adoption inflates the number. Curiosity clicks are not adoption — only completed core actions count.
- Total feature users (without dividing by active users) is vanity. As MAU grows, total users go up even if the feature is losing traction.
- Adoption alone says nothing about sustained use. A 12% adoption with 90% one-time-use is worse than a 6% adoption with 80% repeat-use. Always pair with activation rate (below).

---

## Time-to-First-Value (TTFV)

**Definition.** Median time from signup (or first product entry) to the user's first "aha moment" — the first time they get the core value the product promises.

**Relationship to Activation Rate.** TTFV is the *time component* of activation, not a fully independent metric. Activation Rate (below) already answers "did they reach value within window W?" TTFV answers "how fast did they get there?" Use TTFV when the question is specifically about onboarding speed; use Activation Rate when the question is whether users adopt at all.

**When to use.** Onboarding redesigns where the goal is to reduce friction in the new-user path. Most useful for products with a clear value moment (first message sent, first track played, first invoice created). Less useful for exploratory or research products where value is diffuse, and redundant when Activation Rate already captures both threshold and window.

**How to measure.**
- Concept: Sean Ellis's "aha moment" is when the utility of the product clicks for the user ([Amplitude — aha moment](https://amplitude.com/blog/aha-moment), citing *Hacking Growth*). TTFV measures how long it takes them to get there.
- Formula: industry practice (no single canonical formula) is `median(time from signup → first occurrence of the defined value event)`. Define the value event before measuring (e.g. "first document shared", "first 4 photos uploaded").
- Sample size: depends on baseline activation rate and the lift you want to detect. Use a power calculator (e.g. [Amplitude — sample size for experiments](https://amplitude.com/calculate/sample-size)) — hundreds of signups per cohort is the floor for noticing large effects; thousands per arm for typical lifts.
- Timing: report by signup cohort (week or month), not by calendar week. Calendar-week TTFV mixes new and returning users.

**Example (illustrative).** A team-collaboration app defines "first value" as "user invited at least one teammate AND posted at least one message." Across a month of new signups, the median user reaches first value in **~17 minutes** (hypothetical figure). After streamlining the invite flow, the next cohort's median drops to ~9 minutes. Mean would be misleading — a long tail of users who take days drags the average up; the median tells the story for typical users.

**Pitfalls.**
- Defining "first value" as the easiest action (e.g. "user clicked the Save button") makes TTFV trivially low and meaningless. The value event should be the smallest action that proves the product worked for them.
- TTFV without an activation rate is incomplete. A fast TTFV for the 20% who reach it tells you nothing about the 80% who never do — pair with the activation rate below.
- Single TTFV number hides distribution. Report median + the share who never reach the value event within 7 (or 14) days.

---

## Activation Rate

**Definition.** Share of new users who reach the product's "habit moment" — completing the core action **multiple times within an initial window** — distinguishing curiosity clicks from real adoption.

**When to use.** Distinguishing one-time use from real adoption, especially for new features and onboarding flows. The most honest answer to "did they actually adopt it?"

**How to measure.**
- Formula: `(new users who completed N+ uses within W days / new users in cohort) × 100`. The N and W are product-specific.
- Reforge calls this the "habit moment" — activation requires repeated use within a window, not just first use ([Reforge — Activation Flow](https://www.reforge.com/c/retention-series-eg/activation/activation-flow)). Well-known historical examples often cited in PLG literature: Pinterest "pinned on 4 days of the first 28"; Facebook "added 7 friends in 10 days"; Slack "around 2,000 messages sent by a team." Use these as patterns for how to *shape* a definition, not as targets to copy — every product's activation pattern comes from its own retention data.
- Picking N and W: derive from your data, don't guess. The standard PLG procedure ([aakashg's activation guide](https://www.news.aakashg.com/p/ultimate-guide-activation)):
  1. Pick a retention checkpoint that defines "real adoption" for your product (commonly 30 / 60 / 90 days post-signup).
  2. Split signups into two groups: users still active at the checkpoint (retainers) vs users who churned.
  3. For each candidate behaviour (notes created, invites sent, files uploaded, etc.) and each candidate window (first 7 / 14 / 21 days), measure how often retainers vs churners cross the threshold.
  4. The (behaviour, threshold N, window W) combination with the largest gap between retainers and churners — and that retainers cross most consistently — becomes your activation definition.
  5. Validate by checking the lift: users who hit the threshold should retain meaningfully better than users who don't.
- Sample size: cohort-based. Industry practice uses several hundred new users per cohort for stable comparison; smaller cohorts give direction but wide confidence intervals.
- Timing: report per signup cohort, not per calendar period. Activation is a property of a cohort, not a moving average.

**Example (illustrative).** A note-taking app defines activation as "created at least 3 notes within the first 7 days after signup." Of 1,000 signups in week 12, 380 hit that threshold (hypothetical figures). Activation rate = **38%**. Plain feature adoption (any note created) is 72% — but most of those are one-time triers. The 38% activation number is the honest measure of who actually adopted.

**Pitfalls.**
- Picking N and W arbitrarily (e.g. "3 uses in 14 days because it sounds right") produces a number with no predictive value. Tie the threshold to retention data — the threshold should separate retainers from churners.
- Activation is feature-or-product-specific. A single "activation rate" for the whole product papers over different value moments for different user segments. Often better to define activation per persona or per use case.
- Activation lags signup by W days. A "this week's activation rate" needs W days of waiting per cohort — never compare incomplete cohorts to mature ones.

---

## Adoption vs vanity

| Vanity version | Adoption version | Why the adoption version is honest |
|---|---|---|
| Total sign-ups this month | Activation rate | Sign-ups can come from marketing; activation requires the user to actually use the product |
| Total feature users (any time) | Feature adoption rate (% of active users) | Normalizes by user base; rises only if real share grows |
| Feature page views, CTR on a feature CTA | Feature adoption rate (completed core action) | Curiosity ≠ adoption; clicks measure intent, not uptake |
| Page views per session on the new feature | Activation rate or feature adoption rate | Page-view counts rise with traffic; adoption metrics rise only with real use |
| Time from launch to "1,000 users" | TTFV (median per cohort) | Per-user measurement; immune to marketing-driven spikes |
| "Users who tried it" | Activation rate (N+ uses in W days) | One-time trial is not adoption — repeat use is |

Default rule: when reporting adoption, ask "could this number rise from a marketing push without anyone genuinely adopting the product?" If yes, it is a vanity version — pair with activation or TTFV.

---

## Choosing between them

| Situation | Use this | Why |
|---|---|---|
| Tracking uptake of a launched feature | Feature Adoption Rate | Standard HEART Adoption metric, comparable across releases |
| Onboarding redesign — specifically measuring speed-to-value | Time-to-First-Value | The *time component* of activation; use only when speed is the core design question |
| Distinguishing real adoption from one-time trials (default) | Activation Rate | The honest "did they actually adopt it?" answer; already includes a time window |
| Freemium / trial conversion (free → paid) | *Out of scope — deferred to `metrics-product` v2 (decision 12)* | Conversion is owned primarily by PM/business, not design |
| Pre-launch (no users yet) | None — use qualitative methods (see [measurement-philosophy.md](../../metrics-basics/references/measurement-philosophy.md)) | Adoption metrics need real signups to be meaningful |
| Mature feature, looking for stagnation | Feature Adoption Rate (trend) + Activation Rate | Adoption rate alone may stay flat while real engagement falls |
| Daily-use product, checking if new users form a habit | Activation Rate + Stickiness ([ux-engagement.md](ux-engagement.md)) | Activation captures early habit formation; stickiness shows whether the habit stuck |
