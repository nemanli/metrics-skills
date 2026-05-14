# UX Engagement — metrics

HEART Engagement category — depth and frequency of active use, measured per user. All four metrics here are behavioral: derived from product analytics, not surveys. For perceived ease and satisfaction, see [ux-happiness.md](ux-happiness.md). For first-time activation (different from sustained engagement), see [ux-adoption.md](ux-adoption.md). For category context, see [heart.md](../../metrics-basics/references/heart.md#the-five-categories).

**Vanity warning.** Raw totals (total DAU, total page views, total session count) belong to traffic and growth dashboards, not engagement. They rise with marketing and acquisition even when per-user engagement falls. Every metric here is per-user or a ratio. See "Engagement vs vanity" at the bottom.

---

## Stickiness (DAU/MAU ratio)

**Definition.** Share of monthly active users who are also active on a given day. `DAU/MAU × 100`.

**When to use.** Daily-use products (messaging, social, productivity, dashboards). Best for tracking habit formation over time. Not meaningful for weekly or occasional-use products (banking, tax tools, real estate) — there a stickiness of 5% can be perfectly healthy.

**How to measure.**
- Formula: `(DAU averaged over 30 days / MAU) × 100`. Single-day DAU divided by MAU is noisy — use a rolling 30-day DAU average.
- Define "active" before measuring. A meaningful action (sent a message, opened a document, completed a task) — not just app open. App-open-as-active inflates the number and hides disengagement.
- Sample size: stickiness is a population-level ratio, no per-user sample minimum. Segment cuts need a large enough segment that small day-to-day swings don't move the ratio meaningfully — small cohorts are too volatile to read.
- Timing: stickiness needs at least one full retention cycle to interpret. Industry practice is to track on a rolling 30-day window and watch the monthly trend until cohort curves flatten ([Andrew Chen — cohorts and revisit rates](https://andrewchen.com/how-to-measure-if-users-love-your-product-using-cohorts-and-revisit-rates/)), rather than reacting to a single month's number. Single-week comparisons hide weekday/weekend cycles.

**Example (illustrative).** A messaging app has 30-day average DAU of 18,000 and MAU of 60,000. Stickiness = (18,000 / 60,000) × 100 = **30%** (hypothetical figures). If next quarter MAU rises to 90,000 (marketing push) but DAU stays at 18,000, stickiness drops to 20% — the user base grew, but engagement per user fell.

**Benchmark.** Industry-cited references: 20%+ commonly considered healthy for consumer apps; 50%+ is "world class" and historically achieved by top social/messaging apps like Facebook ([Andrew Chen](https://andrewchen.com/dau-mau-is-an-important-metric-but-heres-where-it-fails/)); B2B SaaS benchmarks commonly cited around 40% ([Mixpanel — citing Gainsight](https://mixpanel.com/blog/mau/)). Compare to your own trend; cross-product comparisons mislead because "active" is defined differently in each.

**Pitfalls.**
- DAU/MAU answers "how often" but not "what they did." A 40% stickiness with declining actions per session is degrading engagement disguised as healthy frequency.
- Inactive accounts inflate MAU until they fully churn. Pair with a 90-day inactive cleanup or report MAU using a stricter activity definition.
- Not applicable to all products. Calendly, TurboTax, and most B2B tools are weekly or seasonal — measure WAU/MAU or monthly cohort retention instead.

---

## Sessions per active user (per week)

**Definition.** Average number of distinct sessions a user starts per week, calculated only across users who were active that week.

**When to use.** Tracking engagement frequency for any product where return visits matter. Pairs with stickiness — stickiness shows what share of users return; sessions-per-user shows how often each returning user comes back.

**How to measure.**
- Formula: `total sessions in week N from active users / count of active users in week N`. Report median, not mean — power users skew the average upward.
- Define "session" before measuring. Industry standard: a session ends after 30 minutes of inactivity (GA4 default — see [Bounteous overview of GA4 sessions](https://www.bounteous.com/insights/2021/12/02/understanding-sessions-google-analytics-4/), Google Marketing Platform partner). Adjust for your product if usage patterns differ (e.g. video apps may use a longer threshold).
- Sample size: same as stickiness — population ratio, no per-user minimum. Behavioral metrics are heavy-tailed; only compare segments large enough that a handful of power users don't dominate the result.
- Timing: wait at least 2–4 full weeks before reading a trend (industry experimentation guidance — [Amplitude — power analysis](https://amplitude.com/explore/experiment/power-analysis)). Weekly variance is high; for engagement curves that flatten slowly, several weeks more is typical.

**Example (illustrative).** In week 12, an app has 5,000 weekly active users who started 22,000 sessions total. Mean sessions per user = 22,000 / 5,000 = **4.4** (hypothetical figures). The median, however, is **2** — half of active users return only twice a week, while a small power-user tail drives the mean up. Report both; the gap between mean and median tells the engagement-distribution story.

**Pitfalls.**
- Session count without per-user normalization is vanity. Total sessions can rise from new acquisition while engagement per user drops.
- Mean alone hides the distribution. Always report median + mean, or median + 90th percentile.
- Different platforms count sessions differently (web 30-min timeout, mobile app session-on-open). Do not compare across platforms without aligning the definition.

---

## Actions per session (per-user median)

**Definition.** Number of meaningful in-product actions a user takes within a single session, measured at the user level then aggregated.

**When to use.** Measuring engagement *depth* — whether users do more than open the product. Best when paired with sessions-per-user (frequency) for a full picture.

**How to measure.**
- Formula: for each user, compute median actions per session over the period; then report the population median across users.
- Define "meaningful action" before measuring. Examples: sent a message, completed a search with a click on a result, edited a document, played a track. Excludes passive events (page load, scroll, focus).
- Sample size: per-user median is robust to outliers, but heavy-tailed behavioural distributions still require segments large enough that one or two power users don't dominate the median.
- Timing: weekly cadence, with a multi-week trailing window to smooth daily noise.

**Example (illustrative).** In a music app, "meaningful action" = play, save, share, or add to playlist. The median user takes 3 such actions per session (hypothetical figure). After a redesign that surfaces playlists earlier, the median rises to 5 — engagement depth improved. Total actions could rise from acquisition alone, so the per-user median is the trustworthy signal.

**Pitfalls.**
- "Action" definition is the whole game. Counting every click, scroll, and hover produces noise; counting only the rare "ideal" action produces near-zero everywhere. Pick a small set of actions that represent product value — the Overall Evaluation Criterion framework ([Kohavi et al. — *Online Controlled Experiments at Large Scale*, KDD 2013](https://exp-platform.com/large-scale/)) recommends a single weighted headline plus three to five input metrics; Rodden's HEART guidance is "a handful, not everything."
- A rising actions-per-session can also mean users are confused and clicking around looking for something. Pair with task success and qualitative input before celebrating.
- Per-session is useless without per-user aggregation. A handful of long power-user sessions can move the per-session average without reflecting broad behavior change.

---

## Time spent on key tasks (per-user median)

**Definition.** Median minutes per user per week spent inside defined "value moments" of the product — not total time in app.

**When to use.** Products where the value is consumption or creation (video, music, writing tools, learning platforms). Less useful for transactional products (banking, ticketing) where shorter time is better.

**How to measure.**
- Formula: define "key task" time windows (video play, document edit, lesson in progress). Sum per-user time inside those windows per week, then report population median.
- Exclude background, idle, and minimized-app time. OS-level reports (iOS Screen Time, Android Digital Wellbeing) can overcount due to background activity, split-screen, or lock-screen states ([third-party analysis, Timing app](https://timingapp.com/help/screen-time)). Use product-instrumented timers when accuracy matters.
- Sample size: same caveat as actions per session — segments must be large enough that a few heavy users don't dominate the median.
- Timing: rolling 30-day window ([Amplitude — KPI tracking with rolling windows](https://amplitude.com/docs/analytics/insights)). Single-week values fluctuate with content drops, day of week, and marketing pushes.

**Example (illustrative).** A learning app defines key task time as "lesson in progress, screen visible, last interaction <2 minutes ago." The per-user median is 22 minutes per week (hypothetical figures). After moving lesson recommendations to the home screen, it rises to 31 minutes per week. Total app time could rise from added settings menus or onboarding screens — measuring only key-task time keeps the metric honest.

**Pitfalls.**
- Total time in app is vanity for almost every product. Time spent in settings, error states, or accidental opens does not equal engagement.
- For transactional products, longer time means *worse* experience (longer checkout, harder navigation). Use task success and time-on-task from [ux-task-success.md](ux-task-success.md) instead.
- Time-based metrics are easy to game with auto-play, auto-scroll, or modal popups that delay closing. Pair with retention (do users come back?) and satisfaction to catch dark-pattern engagement.

---

## Engagement vs vanity

The difference is not which metric you use — it is whether the metric reacts to **per-user behavior change** or to **acquisition and traffic**. Same number, different framing:

| Vanity version | Engagement version | Why the engagement version is honest |
|---|---|---|
| Total DAU | DAU/MAU stickiness | Removes growth from acquisition; shows habit |
| Total sessions this week | Median sessions per active user | Normalizes by population; shows frequency per person |
| Session duration (avg, all users) | Median time on key tasks per user | Excludes accidental opens; counts only value moments |
| Total actions / page views | Median actions per session per user | Two-level normalization; shows depth, not traffic |
| CTR, bounce rate, page views per session | % of MAU completing the click's intended outcome | Outcome > click; a click without follow-through is traffic noise |
| Total time in app | Median time on key tasks per user | Excludes idle, background, error-state time |
| Total engaged users (any definition) | % of MAU meeting engagement threshold | Ratio scales correctly as the user base grows |

Default rule: when reporting engagement, ask "would this number rise if we doubled marketing spend without any product change?" If yes, it is a vanity version — convert to a per-user ratio or median before recommending it.

---

## Choosing between them

| Situation | Use this | Why |
|---|---|---|
| Daily-use product, tracking habit formation | Stickiness (DAU/MAU) | Designed to capture daily-return rate |
| Weekly or occasional-use product | WAU/MAU or cohort retention ([ux-retention.md](ux-retention.md)) | Stickiness misleads outside daily use |
| Measuring frequency per returning user | Sessions per active user (median) | Per-user normalization, robust to acquisition |
| Measuring depth — what users do per visit | Actions per session (per-user median) | Captures behavior change inside a session |
| Consumption or creation product | Time on key tasks (per-user median) | Time = value when the goal is content engagement |
| Transactional product (checkout, banking) | Task success + time-on-task ([ux-task-success.md](ux-task-success.md)) | Engagement metrics misframe transactional efficiency |
