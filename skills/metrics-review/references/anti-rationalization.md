# Anti-rationalization table

For every common excuse that gets given when one of the five review axes fails, the standard counter-response. Use it in adversarial review (incoming claims) and in self-review (anticipating what skeptics will ask).

The pattern — name the excuse, name the response — borrows from the **trustworthiness** framework in [Kohavi, Tang, Xu — *Trustworthy Online Controlled Experiments* (2020), Ch. 3](https://experimentguide.com/) and from epidemiology's tradition of named biases ([Sackett — *Bias in Analytic Research*, J Chron Dis 1979](https://www.sciencedirect.com/science/article/abs/pii/0021968179900128)).

---

## Excuses defending Definition (Axis 1)

| Excuse | Counter |
|---|---|
| "It's just conversion." | Which conversion? The funnel has 5 steps; "conversion" can name any of them. Show the event chain. |
| "Engagement is up." | Engagement is a category, not a metric. Which engagement metric — sessions, time, depth, frequency? Per-user or aggregate? |
| "It's industry-standard." | Which industry, which study, which year? Cite the source. Most "industry-standard" numbers trace to vendor marketing copy. |
| "NPS." | NPS without sample size, response rate, and segment is uninterpretable ([MeasuringU — NPS reporting basics](https://measuringu.com/nps/)). |
| "Users love it." | Love is not a metric. What behavior would users do if they loved it that they would not otherwise? |
| "It's the standard metric." | Standard at what company, when, defined how? "Standard" is shorthand for "I have not looked up the definition." |
| "We measure outcomes, not outputs." | What outcome, defined as what observable user behavior? Per [Cagan — *Inspired*](https://svpg.com/inspired-how-to-create-products-customers-love/), outcomes must translate to user behavior. |

---

## Excuses defending Sample & power (Axis 2)

| Excuse | Counter |
|---|---|
| "Statistically significant." | At what threshold, with what test, on what sample? Significance on large samples catches effects too small to act on ([Cohen, 1988](https://doi.org/10.4324/9780203771587)). |
| "p<0.05." | Effect size? Confidence interval? With n=10M, p<0.05 is the floor — practical significance is the real question ([Wasserstein & Lazar — ASA Statement, 2016](https://amstat.tandfonline.com/doi/full/10.1080/00031305.2016.1154108)). |
| "The data shows..." | The data has a confidence interval. Without it, the point estimate is one of many plausible values. |
| "60% of users." | 60% of how many? "3 of 5 = 60%" and "3,000 of 5,000 = 60%" have wildly different reliability. |
| "The trend is positive." | One direction over one window is not a trend. Show the same metric over 3 consecutive comparable windows. |
| "We have lots of data." | "Lots" is not a sample size. What is the n per cell? |
| "Big effect — must be real." | At n=20 with a 30% baseline, the 95% CI is roughly ±20 pp ([NN/g — small-sample stats](https://www.nngroup.com/articles/confidence-interval/)). |
| "It's directional." | "Directional" is what people say when the result is not significant but they want to act anyway. Commit to running until significance, or accept the result as inconclusive. |
| "We saw the lift in the pilot." | Pilots self-select for engaged users and ship-eager teams. Show the lift in a stratified rollout, not the pilot cohort. |

---

## Excuses defending Comparison (Axis 3)

| Excuse | Counter |
|---|---|
| "We shipped it and the metric went up." | What else changed in the same window? Marketing, pricing, traffic source, seasonality? Without isolation, this is correlation ([Athey & Imbens, 2017](https://arxiv.org/abs/1607.00698)). |
| "The redesign caused the lift." | Cause requires a control. Was there an A/B test, or pre/post? |
| "Last year vs this year." | What is different about the underlying conditions year over year? |
| "Compared to industry average." | Which industry, sampled how, defining the metric how? |
| "We compared to the control population." | Is the control structurally comparable — same segment, window length, exposure conditions? |
| "Pre/post is enough." | For a small, isolated change in a stable environment, sometimes. Name what else changed; if nothing was ruled out, the claim is conditional. |
| "We adjusted for seasonality." | How? Multiplicative adjustment, year-over-year, control group, regression? "Adjusted" without method is hand-waving. |
| "The treatment effect was..." | Treatment effects assume randomization. Was assignment random? At what level? |

---

## Excuses defending Window selection (Axis 4)

| Excuse | Counter |
|---|---|
| "The lift was clearest in this window." | Was the window picked before or after seeing the data? "Clearest" suggests after, which selects for what looks best ([Kerr — HARKing, 1998](https://journals.sagepub.com/doi/10.1207/s15327957pspr0203_4)). |
| "We compared month over month." | Pre-month and post-month? Same length, same seasonality? |
| "It was 4 weeks of data." | When did the 4 weeks start and end? Day-of-week matched? Skip-week-1 applied? |
| "We've been watching it for a while." | "A while" is unspecific. Show the metric for the 4 weeks before and after. Does the trend continue? |
| "The first week was high but we kept tracking." | The first week of a visible change is novelty-contaminated. Was week 1 included or excluded ([Kohavi et al., 2020](https://experimentguide.com/), Ch. 23)? |
| "We tested for 2 days and saw signal." | Two days is below the day-of-week cycle for almost any product metric. Run at least a full week. |
| "Test ended when we hit significance." | Peeking inflates the false-positive rate ([Evan Miller — How Not To Run an A/B Test](https://www.evanmiller.org/how-not-to-run-an-ab-test.html)). Was a sequential method used? |
| "The team needed to ship." | Time pressure is not methodology. State that the test was time-limited and the conclusion is conditional. |

---

## Excuses defending Counter-metric (Axis 5)

| Excuse | Counter |
|---|---|
| "Engagement is up too." | Engagement is not a counter to conversion. The counter is the thing you would be embarrassed to show if it moved wrong — the OEC framework formalises this ([Kohavi et al. — *Online Controlled Experiments at Large Scale*, KDD 2013](https://exp-platform.com/large-scale/)). |
| "Nothing else moved." | Did you check? Which guardrails were monitored? |
| "We didn't need a counter." | If the primary cannot be gamed, name how. Most metrics can be — that is why counters exist ([Strathern, 1997 — Goodhart](https://academic.oup.com/erev/article-abstract/5/3/305/6776275)). |
| "The counter was within normal range." | Show the range. "Within normal" is loose; the counter has a CI like everything else. |
| "Counter-metrics are overkill for small changes." | Even small changes can produce regressions on metrics nobody was watching. |
| "Support tickets held." | Was support volume the right counter for this change? What about user-behavior counters — task success on the affected flow, Day-7 retention, completion on the next step? |
| "It's a UX change, not a business change." | UX changes propagate to business metrics through behavior. A counter on user behavior is still relevant. |

---

## Generic excuses

| Excuse | Counter | Axis defended |
|---|---|---|
| "It's obvious from the data." | Nothing is obvious from data alone. What is the specific number, with definition, sample, comparison, window, and counter? | All five |
| "Trust me, I've been looking at this for months." | Walk me through the parse. | Often Definition or Comparison |
| "We're moving fast." | Speed does not change the standard for evidence. State limits so action is calibrated. | Sample & power |
| "It feels right." | Intuition is valuable for hypothesis generation; it does not replace evidence for conclusions. | All five |
| "The CEO wants the answer." | Authority does not move the noise band. State what the data can and cannot say. | All five |
| "The data speaks for itself." | Per [Hall](https://dscout.com/people-nerds/erika-hall-better-research-and-design), data does not speak. Someone chose what to count, when, for whom, how. | All five |

---

## Honest framings

When an axis fails legitimately (small sample, no control available, exploratory analysis), the right response is to **name it and bound the conclusion**:

- "Underpowered: n=80 per cell, MDE at 80% power is ~16 pp. Result is directional only."
- "Pre/post comparison, no control. Other changes in the window: [list]. Treating the result as suggestive, not causal."
- "Pilot cohort, self-selected. We do not extrapolate this lift to general rollout."
- "Sample of 5 enterprise customers. Qualitative themes follow; percentages would mislead at this n."
- "Counter-metric not monitored; risk of Goodhart trap noted, recommend monitoring in next iteration."

A claim that names its own limitations is more defensible than one that hides them. The reviewer's role is to ensure the limitations are stated, not removed.

---

## See also

- [review-checklist.md](review-checklist.md) — the five axes this table defends against.
- [claim-archetypes.md](claim-archetypes.md) — how the excuses cluster across claim types.
- [`../../metrics-basics/references/measurement-philosophy.md`](../../metrics-basics/references/measurement-philosophy.md) — Misconceptions 1–3 behind most of these excuses.
- [Sackett — *Bias in Analytic Research*, J Chron Dis 1979](https://www.sciencedirect.com/science/article/abs/pii/0021968179900128) — canonical bias taxonomy.
