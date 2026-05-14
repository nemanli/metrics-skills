# Glossary

Definitions of non-obvious terms used across the metrics skills. One entry per term, alphabetical within category. Each definition is 1–2 sentences; for full treatment, follow the link.

---

## Frameworks and concepts

- **4 context anchors (SCOPE / STAGE / AUDIENCE / DATA).** Four questions the skill checks before recommending metrics — what is being measured, what life-cycle stage, who will read the result, what data is in place. See [`context-questions.md`](context-questions.md).
- **Actionable metric.** A metric tied to a specific user behavior the team can influence; the opposite of a vanity metric. Lean Analytics distinguishes them as the basis of [OMTM](https://leananalyticsbook.com/one-metric-that-matters/).
- **Adaptive mode (Direct / Specific / Vague).** Three modes the skill picks based on the prompt: a named metric question (Direct), a situation with a clear goal (Specific), or a situation with no clear goal (Vague — triggers the questionnaire).
- **Counter-metric (also: guardrail metric).** A secondary metric paired with a primary to catch trade-offs. Reporting a primary without a counter reads as advocacy rather than analysis ([Mixpanel](https://mixpanel.com/blog/guardrail-metrics/)).
- **Goals–Signals–Metrics.** The HEART top-down process: state goal, identify user signals, pick metrics — never start from metrics already on hand ([Rodden / Google](https://kerryrodden.com/heart/)).
- **Goodhart's Law.** *"When a measure becomes a target, it ceases to be a good measure"* — Strathern's formulation. Any single metric becomes a gaming target ([Wikipedia](https://en.wikipedia.org/wiki/Goodhart%27s_law)).
- **Guardrail metric.** See *Counter-metric*.
- **HEART.** Five UX measurement categories — Happiness, Engagement, Adoption, Retention, Task Success — developed at Google by Rodden, Hutchinson, Fu (CHI 2010). Skip categories that don't apply; pair 1–2 per feature. See [`heart.md`](heart.md).
- **HiPPO.** Highest-Paid Person's Opinion. Decisions driven by authority rather than evidence; combined with measurement, it produces *measurement theater*.
- **ISO 9241-11.** International usability standard defining usability as effectiveness (success, errors), efficiency (time, resources), and satisfaction. Anchor for [`ux-task-success.md`](../../metrics-ux/references/ux-task-success.md).
- **Jobs-to-be-Done (JTBD).** A framing of user goals as the "job" they hire a product to do, used in this repo to identify which skill matches a designer's request.
- **Leaky bucket.** Pattern where new users come in but existing users leave at a similar rate — high adoption with low retention. See [`ux-retention.md`](../../metrics-ux/references/ux-retention.md).
- **McNamara fallacy.** The reasoning chain "measure what's easy → ignore what's hard → declare it unimportant → declare it doesn't exist." Named by Yankelovich after McNamara's reliance on body counts in Vietnam ([Wikipedia](https://en.wikipedia.org/wiki/McNamara_fallacy)).
- **Measurement theater.** Commissioning measurement to confirm a decision already made. The metric loses its informational role and becomes a way to launder authority ([`measurement-philosophy.md`](measurement-philosophy.md), Situation 3).
- **North Star metric.** A single metric that captures core customer value, paired with input metrics and guardrails ([Amplitude](https://amplitude.com/books/north-star/about-north-star-framework)).
- **OMTM (One Metric That Matters).** Lean Analytics framing: at any given stage, focus on the single metric that most matters; everything else is supporting ([Lean Analytics](https://leananalyticsbook.com/one-metric-that-matters/)).
- **Outcome over output.** Measure what changes for users and the business, not what the team shipped ([Cagan, *Inspired*](https://www.svpg.com/books/inspired-how-to-create-tech-products-customers-love-2nd-edition/)).
- **PMF (Product-Market Fit).** A retention curve that flattens — users who survive the early window mostly stay. Diagnostic shape, not a single number ([Andrew Chen](https://andrewchen.com/new-data-shows-why-losing-80-of-your-mobile-users-is-normal-and-that-the-best-apps-do-much-better/)).
- **Sean Ellis 40% test.** Pre-launch PMF check: ask users "how would you feel if you could no longer use this product?" 40%+ "very disappointed" suggests fit ([Sean Ellis](https://www.startup-marketing.com/the-startup-pyramid/)).
- **Spool framing.** Problem → cost → fix → recovered value. Describe the user's frustration, attach the dollar amount it costs. Canonical case: $300M Button ([Center Centre](https://articles.centercentre.com/three_hund_million_button/)).
- **Vanity metric.** A number that rises with traffic or marketing without telling you what changed for users — total sign-ups, total DAU, page views. The opposite of an actionable metric ([Eric Ries, HBR](https://hbr.org/2010/02/entrepreneurs-beware-of-vanity-metrics)).
- **Weinschenk framing.** Investment → recoup window. State the design investment in dollars and the time it takes to recover through reduced support, recovered abandonment, etc. ([HFI](https://www.humanfactors.com/about_us/animated-video-explains-how-UX-design-delivers-ROI.asp)).

## UX metrics

- **Actions per session (per-user median).** Meaningful actions a user takes within one session, aggregated user-first. Engagement depth metric. See [`ux-engagement.md`](../../metrics-ux/references/ux-engagement.md).
- **Activation Rate.** Share of new users who hit the "habit moment" — completing a core action multiple times within an initial window. The honest answer to "did they actually adopt?" See [`ux-adoption.md`](../../metrics-ux/references/ux-adoption.md).
- **Aha moment.** First time the product's utility clicks for the user; the value event TTFV measures the time to ([Amplitude](https://amplitude.com/blog/aha-moment)).
- **CES (Customer Effort Score).** Self-reported effort to complete a task or resolve an issue. Predicts churn better than CSAT for service interactions ([Dixon et al., HBR 2010](https://hbr.org/2010/07/stop-trying-to-delight-your-customers)).
- **Cohort retention curve.** Plot of % of a signup cohort still active at Day 1 / 7 / 30 / 60 / 90. The shape (flattening = PMF; trending to zero = no PMF) is the diagnosis. See [`ux-retention.md`](../../metrics-ux/references/ux-retention.md).
- **CSAT (Customer Satisfaction Score).** Self-reported satisfaction with a specific interaction, top-two-box on a 1–5 or 1–7 scale. See [`ux-happiness.md`](../../metrics-ux/references/ux-happiness.md).
- **Customer Churn Rate.** Share of customers who stop using the product in a given period; logo churn, not revenue churn (deferred to v2). See [`ux-retention.md`](../../metrics-ux/references/ux-retention.md).
- **DAU / MAU.** Daily / Monthly Active Users — count of distinct users active in the period. Always normalize per-user before comparing across time.
- **Drop-off Rate (per step).** Share of users leaving a specific step in a multi-step flow. The per-step shape is the diagnostic value, not the flow-wide total. See [`ux-task-success.md`](../../metrics-ux/references/ux-task-success.md).
- **Error Rate.** Errors per task attempt. Distinguish slips (right intent, wrong action) from mistakes (wrong intent) — Norman's distinction matters for the fix ([Norman, *Design of Everyday Things*](https://www.basicbooks.com/titles/don-norman/the-design-of-everyday-things/9780465050659/)).
- **Feature Adoption Rate.** Share of active users who used a specific feature in a given period. Define "used" as a meaningful action, not a page view ([Pendo](https://www.pendo.io/glossary/feature-adoption/)).
- **Hawthorne effect / observer bias.** Lab participants are more patient, read more carefully, and try harder than real users — lab metrics are an upper bound on production behavior ([NN/g](https://www.nngroup.com/articles/hawthorne-effect-observer-bias-user-research/)).
- **Learnability.** How much users improve at a task with repetition. Nielsen's 5th usability component; needs spaced attempts across days ([NN/g](https://www.nngroup.com/articles/measure-learnability/)).
- **Mistake.** Wrong intent — user chose the wrong path. Usually a model or information-architecture problem. See *Slip*.
- **NPS (Net Promoter Score).** *% promoters (9–10) − % detractors (0–6)* on a 0–10 "would you recommend" scale. Cultural and response-bias caveats are large; compare within-region only ([Bain](https://www.netpromotersystem.com/about/)).
- **N-day Cohort Retention.** % of a signup cohort still active on Day N after signup, reported as a curve. The single most diagnostic retention metric.
- **Power-user curve.** A separate diagnostic from cohort retention: distribution of users by how many days they were active in a window. A "smile" shape (peaks at 1 day and 28+ days) marks healthy power-user mix ([Andrew Chen](https://andrewchen.com/power-user-curve/)).
- **Return Frequency.** Share of last week's actives who are also active this week. Behavioral return rate without needing a "cancelled" event.
- **Sessions per active user.** Median sessions a user starts per week, computed only on users active that week. Engagement frequency metric (paired with stickiness).
- **Slip.** Right intent, wrong action — a misclick or typo. Usually fixable with better affordances. See *Mistake*.
- **Stickiness.** *DAU / MAU × 100*. Daily-return rate among monthly users. Meaningful for daily-use products only; misleads for weekly or occasional-use products.
- **SUS (System Usability Scale).** A 10-question standardized survey producing a 0–100 score; benchmark average is 68 ([Sauro / MeasuringU](https://measuringu.com/sus/)).
- **Task Success Rate.** Share of users who complete a defined task correctly. First metric to check after a redesign ([NN/g](https://www.nngroup.com/articles/success-rate-the-simplest-usability-metric/)).
- **Time on Task.** Time from task start to task completion. For small samples (n<25) use geometric mean — median is biased upward in right-skewed distributions ([MeasuringU](https://measuringu.com/average-times/)).
- **Top-two-box.** % of survey responses in the top two scale points (e.g. 4–5 on a 1–5 scale). Standard CSAT and CES reporting format.
- **TTFV (Time-to-First-Value).** Median time from signup to the user's first "aha moment." The time component of activation, not a fully independent metric.

## Statistics and methodology

- **A/B test.** Controlled experiment comparing two variants on randomized traffic. Use only when analytics + research can't isolate cause; see [`hypothesis-tests.md`](../../metrics-diagnose/references/hypothesis-tests.md).
- **Baseline.** Reference point against which to compare a metric — historical, cohort, or industry. A metric without one is noise.
- **Chi-square test.** Statistical test for the distribution of categorical counts (e.g. error types across variants). Needs ~5 expected counts per cell.
- **Cohen's d / Cohen's h.** Effect-size measures for continuous (d) and proportional (h) differences. Thresholds: small ≈ 0.2, medium ≈ 0.5, large ≈ 0.8 ([Cohen, 1988](https://doi.org/10.4324/9780203771587)).
- **Cohort.** A group of users defined by a shared start event (signup week, first action, acquisition channel). Retention and adoption are *always* cohort questions.
- **Confidence interval.** Range around a sample estimate where the true population value is likely to fall, given a chosen confidence level (commonly 95%).
- **Definition drift.** Silent change in how a metric is computed (event renamed, filter changed) that makes before-and-after numbers incomparable. A common false-alarm cause for metric movements.
- **Geometric mean.** Central tendency for right-skewed distributions (e.g. task time, n<25). Less inflated by outliers than the arithmetic mean.
- **HARKing.** *Hypothesizing After Results are Known* — running multiple variants, finding one that beats control, then declaring it the hypothesis. Inflates false-positive rate.
- **MDE (Minimum Detectable Effect).** The smallest effect a test can detect at a given sample size and power. Report MDE alongside any non-significant result; without it, "no effect detected" is not the same as "no effect exists".
- **Multiple comparisons.** When checking many segments or metrics, raw p-values overstate significance. With 20 comparisons at α=0.05, ~1 false positive is expected by chance.
- **Novelty effect.** New treatments often outperform during the first 1–2 weeks because users notice the change. Run longer if long-term effect matters.
- **Peeking.** Stopping an A/B test as soon as p<0.05 appears. With repeated peeks, false-positive rate inflates well above 5% ([Evan Miller](https://www.evanmiller.org/how-not-to-run-an-ab-test.html)).
- **Power (statistical).** Probability that a test correctly detects an effect that genuinely exists. Industry default: 80%.
- **Sample size.** Number of observations needed for a stable estimate at a chosen confidence level. NN/g cites ~40 participants for quantitative usability ([NN/g](https://www.nngroup.com/articles/summary-quant-sample-sizes/)).
- **Signal vs noise.** Whether an observed change is a real shift in the underlying metric, or random variation. The first question after a metric movement.
- **Simpson's paradox.** A trend that appears in segments reverses (or disappears) when segments are combined. Common cause of false retention or adoption "drops" — segment mix shifts even when per-segment behavior is flat.
- **Two-proportion z-test.** Statistical test comparing two binomial rates (e.g. conversion before vs after). Default test for proportional metrics; ~100 per group is the floor.
- **Welch's t-test.** t-test that does not assume equal variance between groups. Default for continuous metrics (time on task, NPS, SUS).

## Communication and process

- **BLUF (Bottom-Line Up Front).** Communication style where the conclusion is the first sentence, supporting detail follows. Same logic as inverted pyramid.
- **Inverted pyramid.** Journalism structure: most important information first, supporting detail after, so the reader can stop at any point and still have the story ([NN/g](https://www.nngroup.com/articles/inverted-pyramid/)).
- **Retro / Retrospective.** Team meeting or document reviewing what worked, what didn't, and what to change next time. The "what didn't" section is non-negotiable. See [`../../metrics-present/references/templates.md`](../../metrics-present/references/templates.md).
- **Stakeholder.** Anyone who needs the result of the work — PM, eng lead, exec, customer-facing team. Different stakeholders need different formats; the same numbers don't fit every audience ([Atlassian](https://www.atlassian.com/team-playbook/plays/stakeholder-communications-plan)).
