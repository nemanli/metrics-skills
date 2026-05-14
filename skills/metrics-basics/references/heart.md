# Google HEART

A UX measurement framework developed at Google by Kerry Rodden, Hilary Hutchinson, and Xin Fu (CHI 2010). Five user-centered categories — Happiness, Engagement, Adoption, Retention, Task Success — paired with a Goals–Signals–Metrics process to turn each category into concrete metrics.

Google had large-scale behavioral data but no shared structure for tying it to user experience quality. HEART was built to close that gap.

## The five categories

[Rodden's guidance](https://kerryrodden.com/heart/): skip categories that don't apply to the product or feature. Tracking all five at once dilutes focus. In practice, most teams settle on 1–2 categories per feature.

- **Happiness:** Subjective user attitude — satisfaction, perceived ease of use, likelihood to recommend.
  - *Example indicators:* user feels the product is fast, trusts the results, would use it again.
  - *How to measure:* surveys (CSAT, NPS, SUS), in-product micro-surveys triggered after key actions, App Store ratings. Timing matters — ask right after the task, not days later.
  - *Do not confuse with Task Success:* Happiness captures perceived ease ("felt easy"); Task Success captures actual completion. Users often rate a flow positively even when they failed — measure both.

- **Engagement:** Depth and frequency of active use per user.
  - *Example indicators:* user returns often, uses core features per visit, spends meaningful time.
  - *How to measure:* sessions per user per week, actions per session, time spent on key tasks. Use per-user averages, not raw totals — raw DAU can grow from marketing while per-user engagement stays flat or drops.
  - *Per-user vs per-session:* per-user shows how engaged your base is overall; per-session shows intensity of a single visit. Power users can inflate per-user averages — report medians or segment by usage tier.

- **Adoption:** New users starting to use the product or feature in a given period.
  - *Example indicators:* first-time sign-ups, first use of a new feature.
  - *How to measure:* new accounts per week, new feature activations, upgrade rate from free to paid.
  - *Watch for vanity metrics:* sign-up counts can rise while activation (meaningful first use) drops. Always pair adoption with a "first value" metric — did the new user actually do the thing the feature is for?

- **Retention:** Rate at which existing users return over time.
  - *Example indicators:* users active last week return this week; users still active 30/60/90 days after sign-up.
  - *How to measure:* N-day retention curves, cohort retention, churn rate. Pair with adoption — high adoption + low retention signals a leaky funnel.

- **Task Success:** How well users complete their intended tasks.
  - *Example indicators:* search returns what the user wanted; checkout completes without errors.
  - *How to measure:* task completion rate, time-to-complete, error rate. Behavioral metrics, not survey-based.

## Choosing categories

The original HEART paper does not prescribe fixed pairings — it tells teams to pick categories that match product goals and skip the rest. The mapping below is a common practitioner shortcut, not Google guidance:

| Situation | Pick these |
|---|---|
| New feature launch | Adoption + Task Success |
| Mature feature | Retention + Happiness |
| Core workflow | Task Success + Engagement |
| Growth/monetization push | Adoption + Retention |
| Redesign of existing flow | Task Success + Happiness |

Use as a starting point, not as a rule. When in doubt, run the Goals–Signals–Metrics process (next section) and let the goal pick the category.

## Goals–Signals–Metrics process

HEART is a set of categories, not metrics. Turn each category into metrics using this three-step process:

1. **Goals:** State what success looks like for the product or feature, in plain language. One goal per HEART category you choose to track. Skip categories that don't apply.
2. **Signals:** Identify user behavior or attitudes that show the goal is (or is not) being met. A goal can have several signals.
3. **Metrics:** Choose the specific, trackable numbers for each signal. Prefer ratios and per-user averages over raw counts — they stay meaningful as the user base grows.

Do this top-down. Starting from metrics you already have and working backward produces a dashboard that looks busy but doesn't answer product questions.

## Setting baselines and targets

A metric without a reference point is noise. Three ways to set one:

- **Historical baseline:** measure the current state before making changes. Simplest and most reliable for iterative improvement.
- **Cohort comparison:** A/B test or compare segments (new vs returning users, platform, persona). Best for isolating the effect of a specific change.
- **Industry benchmark:** use published benchmarks (SUS average ~68, above 68 = above average usability; NPS varies widely by industry) for directional context only — your users, product category, and measurement method rarely match the benchmark exactly.

Set targets as ranges, not single numbers. "Task success rate: 75–85%" acknowledges natural variance; "exactly 80%" invites gaming.

## Common pitfalls in signal selection

- **Too broad:** "clicks" or "page views" alone say nothing about the goal. Tie each signal to a specific user intent.
- **Disconnected from the goal:** a signal that moves without the goal moving (or vice versa) is the wrong signal. Pressure-test by asking: if this signal goes up, does the goal clearly improve?
- **Too many signals per goal:** more signals dilute focus. Start with 1–2 strong signals, add more only if they reveal something new.

## Worked example — Gmail search

- **Goal (Task Success):** users find the email they are looking for.
- **Signals:** user clicks a result; user does not reformulate the query.
- **Metrics:** click-through rate on the first three results; query reformulation rate per search session.

## Worked example — file upload (Adoption + Task Success)

- **Goal (Adoption):** new users try the upload feature in their first week.
- **Signals:** user opens the upload dialog; user selects a file.
- **Metrics:** share of new users who open upload within 7 days; share who complete at least one upload.
- **Goal (Task Success):** uploads finish without errors.
- **Signals:** upload completes; user does not retry the same file.
- **Metrics:** upload success rate; retry rate per file.

## Best for

- Measuring user experience of a web or mobile product at scale.
- Teams that already have analytics in place but lack a shared structure for what to track.
- Feature-level measurement when you need to separate adoption from retention from task success.

## Limitations

- Not all five categories apply to every product. Pick the ones that fit; forcing all five creates noise.
- Weak for B2B, enterprise, or low-frequency products — retention and engagement indicators take months to stabilize.
- Scope is UX only. Does not cover business metrics (revenue, cost, margin) or root cause — HEART tells you *what* moved, not *why*. Combine with business metrics and qualitative research as needed.
- Happiness relies on surveys, which have sampling bias and low response rates. Treat as directional, not absolute.

## Sources

- [Kerry Rodden — The HEART framework for UX metrics](https://kerryrodden.com/heart/) (author's own reference page, links to all primary sources)
- [Measuring the User Experience on a Large Scale: User-Centered Metrics for Web Applications](https://research.google/pubs/measuring-the-user-experience-on-a-large-scale-user-centered-metrics-for-web-applications/) (original CHI 2010 paper — Rodden, Hutchinson, Fu)
