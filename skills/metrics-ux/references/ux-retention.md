# UX Retention — metrics

HEART Retention category — the rate at which existing users return over time. All three metrics here are behavioral, derived from product analytics. Retention answers "do users keep coming back?" — not "did they start using it?" (see [ux-adoption.md](ux-adoption.md)) or "are they engaged when they're here?" (see [ux-engagement.md](ux-engagement.md)). HEART pairs Adoption and Retention as distinct categories — high adoption with low retention signals a leaky funnel ([Rodden](https://kerryrodden.com/heart/)). For category context, see [heart.md](../../metrics-basics/references/heart.md#the-five-categories).

**Scope note.** Revenue churn (MRR/ARR churn), customer lifetime value (LTV), and other monetization-side retention metrics are owned primarily by PM and business, not design — they are deferred to a future `metrics-product` skill. This file covers customer-side (logo) retention and behavioral return rate, which designers directly drive through UX work.

**Cohort logic.** Retention is always measured by **signup cohort**, never by calendar period. A "this month's retention" number that mixes new and old users is meaningless — newer cohorts haven't had time to churn, so they inflate the average. Group users by the week or month they signed up, then track each cohort separately over time.

---

## N-day Cohort Retention

**Definition.** Share of a signup cohort still active on Day N after signup. Reported as a curve across multiple checkpoints (Day 1, 7, 30, 60, 90).

**When to use.** The single most important retention metric. Tracks whether new users actually keep using the product, separated from churn of older users. Best for products with daily, weekly, or monthly use cycles.

**How to measure.**
- Formula: for each signup cohort, `(cohort users active on day N / total cohort size) × 100`.
- Define "active" before measuring — meaningful action (see [ux-engagement.md](ux-engagement.md) for the trap of "app open = active"). Same definition must apply across cohorts and across days.
- Report as a curve, not a single number. Day 1 retention alone says little; the *shape* of the curve across days reveals product-market fit.
- Cohort window: weekly cohorts for products with daily/weekly use; monthly cohorts for B2B or weekly-use products.
- Sample size: cohorts must be large enough that a few churned users don't swing the curve; very small cohorts (under ~100) are too noisy to read week-over-week.

**Example (real data — Quettra / Andrew Chen, 2015 Android install cohort).** Across ~125M Android devices over 5 months ([Andrew Chen — losing 80% of mobile users is normal](https://andrewchen.com/new-data-shows-why-losing-80-of-your-mobile-users-is-normal-and-that-the-best-apps-do-much-better/)):

| Cohort | Day 1 | Day 7 | Day 30 | Day 90 |
|---|---|---|---|---|
| Average Android app | 29% | 17% | 10% | 4% |
| Top 10 apps | 75% | 67% | 60% | 51% |

The average app's curve trends toward zero (no plateau) — classic leaky bucket. The top-10 cohort flattens between Day 30 and Day 90 (60% → 51%), the canonical PMF shape: users who survive the first month mostly stay. The gap between the two curves is what separates products with PMF from products without.

**Interpreting the curve shape ([Amplitude — Interpret retention](https://amplitude.com/docs/analytics/charts/retention-analysis/retention-analysis-interpret)).**
- **Flattening curve** → product-market fit. The cohort plateaus and stays. Goal: raise the plateau.
- **Curve trending to zero** → no PMF. Every cohort eventually churns out completely. Acquisition becomes a leaky bucket.

**Related — power-user curve.** A separate diagnostic, distinct from cohort retention: plot the distribution of users by how many days they were active in a window (e.g. last 28 days). A "smile" shape — large peaks at both 1 day and 28+ days — indicates a healthy power-user segment alongside casual users ([Andrew Chen — Power-user curve](https://andrewchen.com/power-user-curve/)). Use the cohort retention curve to diagnose PMF; use the power-user curve to diagnose engagement distribution. Don't confuse them.

**Pitfalls.**
- Calendar-period retention ("this month's retention rate") mixes cohorts at different ages. Always cohort first.
- A single Day 1 number is meaningless without the rest of the curve — Day 1 is dominated by onboarding friction, not product value.
- Comparing incomplete cohorts to mature ones inflates retention. A cohort that signed up last week has had 7 days to churn; a cohort from 6 months ago has had 180 days. Compare cohorts only at the same age.

---

## Customer Churn Rate

**Definition.** Share of customers who stop using the product in a given period. Logo churn (count of customers), not revenue churn (deferred — see scope note).

**When to use.** Tracking the leaky-bucket question: how fast does the product lose existing users? Most useful for subscription, account-based, or login-required products where "churned" has a clear meaning. For consumer apps without accounts, return frequency (below) is closer to churn.

**How to measure.**
- Formula: `(customers who churned in period / customers at start of period) × 100` ([ChartMogul methodology](https://chartmogul.com/saas-metrics/customer-churn/)). New customers acquired during the period are excluded from the denominator — measure churn of the *existing* base.
- Define "churned" before measuring. Subscription products: cancelled or downgraded to free. Login products: no meaningful action in the last N days (e.g. 30 or 60). The N depends on your product cycle.
- Pick the period to match your usage cycle: monthly for daily/weekly products, quarterly or annual for low-frequency B2B.
- Sample size: at population level (whole customer base); segment cuts need each segment to be large enough that one or two churns don't move the rate by several percentage points.

**Example (illustrative).** A B2B SaaS product starts the month with 800 paying customers. During the month, 32 cancel (hypothetical figures). Churn rate = (32 / 800) × 100 = **4%** monthly — within the typical SMB SaaS range. Over a year, this compounds to ~39% annual churn if the rate holds.

**Benchmark.** Industry guides commonly cite ~3–7% monthly logo churn for SMB SaaS and ~5–10% annual for mature/enterprise SaaS; benchmarks vary by segment, contract length, and price point ([ChartMogul churn benchmarks](https://chartmogul.com/blog/churn-basics-and-benchmarks/), [Paddle SaaS churn rate](https://www.paddle.com/blog/saas-churn-rate)). Compare to your own trend, not industry averages — the segment mix and contract terms of cited benchmarks rarely match your product.

**Pitfalls.**
- Mixing voluntary churn (user cancels) with involuntary churn (payment fails) hides separate problems. Track both, but report separately — voluntary churn is a UX/product signal, involuntary is a billing/ops signal.
- Short-window churn rates (weekly) are noisy and overreact to one-off events. Monthly is the standard rolling window for most products.
- Churn rate without retention curve hides cohort effects. A "stable 5% monthly churn" can mask the fact that newer cohorts churn at 12% while older cohorts churn at 2%.

---

## Return Frequency (Weekly Active Return Rate)

**Definition.** Share of last week's active users who are also active this week. Operationalizes the HEART Retention signal: "users active last week return this week" ([Rodden](https://kerryrodden.com/heart/)).

**When to use.** Daily- or weekly-use products without explicit account churn (consumer apps, content platforms, productivity tools). Captures behavioral return without requiring a "cancelled" event. Pairs with cohort retention — cohort retention shows new-user stickiness; return frequency shows the *current* base's habit strength.

**How to measure.**
- Formula: `(users active in week N AND week N-1 / users active in week N-1) × 100`.
- More structured version: Amplitude's Lifecycle chart classifies users into New / Current / Resurrected / Dormant cohorts on a rolling basis ([Amplitude — Lifecycle chart](https://help.amplitude.com/hc/en-us/articles/228838627-The-Lifecycle-chart-track-the-growth-of-your-product-s-user-base), [Amplitude — Retention Lifecycle Framework](https://amplitude.com/blog/retention-lifecycle-framework)). "Current" = active both periods; "Dormant" = active last period only. Return rate = Current / (Current + Dormant).
- Period: weekly is standard; daily for very high-frequency products (messaging, social); monthly for low-frequency (banking, tax tools).
- Sample size: population-level metric; segment cuts need a large enough segment to keep the ratio stable across periods.

**Example (illustrative).** A productivity app had 4,200 weekly active users last week. This week, 2,900 of them are also active (hypothetical figures). Return rate = (2,900 / 4,200) × 100 = **69%**. A new feature ships; the next week's return rate among that cohort is 74% — the feature improved the habit, not just the one-time use.

**Pitfalls.**
- Return rate mixes new and old users into one number. If acquisition is rising fast, the return rate can drop simply because the denominator grew with users who haven't had time to form a habit. Pair with cohort retention to separate effects.
- Period definition matters. A "weekly return rate" of 80% on a daily-use product is healthy; on a monthly-use product, it's an artifact (almost all monthly users are weekly users). Match the period to the product's natural use cycle.
- A high return rate with falling cohort retention is a warning: existing power users are sticky, but new users aren't sticking. The product looks healthy in the short window and rotting in the long one.

---

## Retention vs vanity

| Vanity version | Retention version | Why the retention version is honest |
|---|---|---|
| Total active users this month | N-day cohort retention curve | Total users hide cohort age; cohort retention separates new from mature |
| Calendar-period "retention rate" (no cohort) | Cohort retention by signup week/month | Mixing cohorts inflates retention with newcomers |
| "Average user lifetime" without curve shape | Plateau % at Day 30 / 60 / 90 | A stable plateau is PMF; a falling curve is leakage masked by averaging |
| Total churn count this month | Customer churn rate (% of starting base) | Count grows with the user base; rate normalizes |
| MAU / DAU growth (raw) | Return rate or N-day retention | MAU rises with acquisition even when retention falls |

Default rule: retention is *always* a cohort question. If a number doesn't say which cohort and which age, it's not a retention metric — it's a snapshot.

---

## Choosing between them

| Situation | Use this | Why |
|---|---|---|
| Default — checking product health and PMF | N-day Cohort Retention (curve) | The single most diagnostic retention metric; reveals PMF or leakage |
| Subscription / account-based product, tracking leak rate | Customer Churn Rate | Direct measure of base shrinkage when "churned" has a clear meaning |
| Consumer or freemium app without explicit cancellation | Return Frequency | Behavioral return without needing a "cancelled" event |
| Daily-use product, checking habit strength | Return Frequency (week-over-week) | Captures whether the current base keeps coming back |
| Pre-launch (no signups yet) | None — use qualitative methods (see [measurement-philosophy.md](../../metrics-basics/references/measurement-philosophy.md)) | Retention metrics need cohorts to mature |
| Tracking new-user habit formation | Cohort Retention + Activation Rate ([ux-adoption.md](ux-adoption.md)) | Activation captures early habit; retention shows whether it stuck |
