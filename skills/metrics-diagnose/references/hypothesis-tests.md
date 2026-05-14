# Hypothesis Tests

How to test a hypothesis once root-cause patterns ([root-cause-patterns.md](root-cause-patterns.md)) have generated candidates. Three test families: **A/B test**, **user research**, **analytics dive**. Plus a statistical-test selection table for [SKILL.md](../SKILL.md) Step 4.

Pick the cheapest test that can confirm or rule out the hypothesis. Cost order (low to high): analytics dive → user research → A/B test. Never escalate to A/B when a segment cut would answer the question.

---

## Statistical test selection (Step 4 reference)

For [SKILL.md](../SKILL.md) Step 4 (signal vs noise). Pick the test by metric type, hand the user the matching snippet from [stat-snippets.md](stat-snippets.md), interpret what they paste back. Never compute p / CI / MDE from memory.

| Metric type | Test | When to use | Sample size minimum |
|---|---|---|---|
| **Proportion** (success rate, retention rate, adoption rate, drop-off, conversion) | Two-proportion z-test (Wilson CI) | Comparing two binomial rates with known n | ~100 per group for stable result |
| **Continuous** (time on task, session duration, NPS, SUS) | Welch's t-test | Comparing two means without assuming equal variance | ~30 per group for the central limit theorem to hold; more if distribution is skewed |
| **Count** (events per user, errors per session) | Chi-square test of independence (categorical buckets) OR Welch's t-test on per-user means | Chi-square for distribution of categories; t-test when per-user means are approximately normal | ~5 expected counts per cell for chi-square; ~30 per group for t-test |
| **Rate over time** (funnel rate week-over-week) | Two-proportion z-test on suspect window vs baseline window | Treat each window as an independent sample of the same underlying rate | ~100 per window |
| **Cohort retention curve** (Day N retention compared across cohorts) | Two-proportion z-test at each Day N point | Compare cohorts at matched cohort age, not at calendar date | ~100 per cohort at the Day N point being tested |

**Effect sizes.** Always report alongside p-value:

- **Cohen's h** (proportions): small ≈ 0.2, medium ≈ 0.5, large ≈ 0.8 ([Cohen, 1988 — *Statistical Power Analysis*](https://doi.org/10.4324/9780203771587)).
- **Cohen's d** (continuous): same thresholds. Industry-cited convention; treat as orientation, not absolute.

**Power check (when p ≥ 0.05).** Compute the minimum detectable effect (MDE) at 80% power for the current sample size. If the observed difference is below MDE, the test is **underpowered** — do not conclude "no effect", conclude "cannot detect an effect of this size".

**Multiple comparisons.** When checking many segments or many metrics in the same diagnosis, raw p-values overstate significance. With 20 independent comparisons at α=0.05, ~1 false positive is expected by chance. For exploratory segment cuts, treat p-values as directional, not confirmatory; only the headline test gets a strict α=0.05 threshold.

---

## Family 1 — Analytics dive

Cheapest test family. Use existing event data; no new instrumentation, no users contacted, no holdback. Always try this first.

### Funnel analysis

**When to use.** Hypothesis is "drop is concentrated at step X" (Task Success patterns T1, T3; Adoption pattern A2). Funnel data already exists in product analytics tools (Amplitude, Mixpanel, Heap, PostHog, GA4).

**How.** Plot conversion at each step, before vs after. Compute step-over-step conversion (conditional on reaching the previous step), not just absolute counts. Identify the step with the largest delta.

**Common mistakes.**
- Comparing absolute counts instead of step-over-step rates — total traffic shifts confound the comparison.
- Defining the funnel after seeing the data ("the drop is between step 2 and 3" → funnel built around that boundary). Define the funnel before, then look.
- Ignoring funnel ordering when users can complete steps out of order — Amplitude and Mixpanel default to ordered funnels; verify the metric matches the user flow.

### Segmentation cut

**When to use.** Hypothesis is "cause is segment-specific" (Task Success T3, Adoption A3, Retention R3, Engagement E2). Or to rule out segment mix as the explanation (Simpson's paradox).

**How.** Cut the suspect metric by candidate segments: device, locale, OS version, account age, acquisition channel, plan tier, persona. Compute per-segment before/after. If the headline movement disappears within every segment, the cause is mix, not behavior.

**Common mistakes.**
- Cutting by too many segments at once — multiple comparisons inflate false positives. Pick 2–4 segments hypothesis-driven, not all available.
- Comparing tiny segments (<100 users) — within-segment noise dominates.
- Stopping at the first segment that "looks different" — confirm with a statistical test on that segment, not eyeballing.

### Cohort comparison

**When to use.** Hypothesis is about retention shape, lifecycle, or onboarding leak (Retention R1, R3; Engagement E2). Calendar-date numbers can't answer cohort questions — see [ux-retention.md](../../metrics-ux/references/ux-retention.md) on cohort logic.

**How.** Group users by signup week (or first-action week). Plot retention curves cohort by cohort. Compare recent cohorts to older cohorts at matched cohort age (Day 7, Day 30). If recent cohorts diverge early but converge later, the issue is onboarding. If they're flat at all ages, the issue is structural (acquisition mix, value proposition).

**Common mistakes.**
- Mixing cohort retention with calendar retention. "March retention" is a calendar number; "Day 30 retention for the March cohort" is a cohort number. They answer different questions.
- Truncating cohorts at the data cutoff (a 2-week-old cohort can't have Day 30 retention yet). Always compare at matched cohort age.
- Using cohort sizes that are too small — cohort retention at low n is dominated by noise.

---

## Family 2 — User research

Use when analytics shows *what* changed but not *why*. Cheaper than A/B test; slower than analytics dive.

### Usability test (5 users, think-aloud)

**When to use.** Hypothesis is "users are confused at step X" (Task Success T1, T2; Adoption A2). Best for identifying *cause* of a known step-level drop, not for measuring magnitude.

**How.** Recruit 5 users matching the affected segment. Ask them to perform the failing task; observe with think-aloud protocol. Five users surface ~85% of usability issues in the affected flow ([NN/g — Why You Only Need to Test with 5 Users](https://www.nngroup.com/articles/why-you-only-need-to-test-with-5-users/)). For quantitative benchmarking (success rate confidence interval), see Sample Size in [ux-task-success.md](../../metrics-ux/references/ux-task-success.md).

**Common mistakes.**
- Using the lab to measure success rate (lab Hawthorne effect inflates it). Use the lab for *why*, use production for *how much* — see [ux-task-success.md](../../metrics-ux/references/ux-task-success.md), Pitfalls.
- Recruiting from the wrong segment — if the drop is on mobile, test on mobile, not desktop.
- Asking leading questions ("did you find this confusing?"). Use task-based prompts ("complete X"), then observe.

### Open-text micro-survey

**When to use.** Hypothesis is "users misunderstand the action" (Task Success T2; Engagement E3). When usability tests are too slow and existing analytics can't capture intent.

**How.** Add a one-question post-task survey on the failing step: "What were you trying to do here?" or "What didn't work as you expected?". Open-text only; multiple choice biases the response. Run for 1–2 weeks to collect 50–100 responses; categorize verbatims; report frequency per category.

**Common mistakes.**
- Surveying everyone instead of the affected segment — dilutes signal.
- Closed-ended questions ("Was this clear? Yes/No") — confirms what you expect, doesn't surface what you missed.
- Stopping after 10 responses — themes emerge after ~30–50 responses for typical UX issues.

### Stakeholder/support data review

**When to use.** Hypothesis suggests the issue is visible to support, sales, or community channels (Retention R2, Engagement E1, E3). Often the fastest qualitative signal — the data already exists.

**How.** Pull support tickets, NPS verbatims, in-app feedback, or community posts from the affected window. Categorize by theme. Compare volume and theme distribution to a pre-change window of the same length.

**Common mistakes.**
- Reading top tickets without normalizing by total volume — total ticket volume varies week to week.
- Trusting support sample as representative of all users — support contactors are skewed toward the most-affected and most-vocal.

---

## Family 3 — A/B test (controlled experiment)

Most expensive but most rigorous. Use only when analytics + research can't isolate cause, or when the fix needs measured proof before rollout.

### When to use

- Multiple hypotheses are plausible and a segment cut can't separate them.
- A fix is ready and needs measured impact before full rollout.
- The change being tested is reversible (you can ship version A or B without long-term lock-in).

### When NOT to use

- Sample is too small to detect the expected effect at 80% power. Compute MDE first; if MDE is larger than any plausible effect, the test will be inconclusive.
- The effect is small and not worth the test cost (engineering, traffic, time).
- The change is irreversible (pricing change, public launch, brand change).

### Sample size requirements

Minimum sample size depends on baseline rate, expected effect size, and target power. Industry-standard formula:

`n per group ≈ 16 × p(1-p) / (Δ)²`

Where p = baseline rate, Δ = minimum effect to detect. This gives ~80% power at α=0.05 ([Evan Miller — Sample Size Calculator](https://www.evanmiller.org/ab-testing/sample-size.html)). For rates near 50% with a 5-point effect (Δ=0.05), the formula gives ~1,600 per group; for a 10% baseline with a 1-point effect (Δ=0.01), it gives ~14,400 per group. Smaller expected effects need disproportionately more sample — halving Δ quadruples the required n.

**Run length.** A common rule is to run for at least 1 full business cycle (typically 1–2 weeks) to capture day-of-week effects, even if the sample size is reached earlier. Decide sample size and duration in advance; do not stop early when significance appears ([Evan Miller — How Not To Run an A/B Test](https://www.evanmiller.org/how-not-to-run-an-ab-test.html)).

### Common mistakes

- **Peeking.** Stopping the test as soon as p<0.05 is reached. With repeated peeks, false positive rate inflates well above 5%. Decide sample size and duration up front; check only at the planned endpoint.
- **HARKing** (Hypothesizing After Results are Known). Running multiple variants, finding one that beats control, declaring that variant the hypothesis. With enough variants, one will beat control by chance.
- **Underpowered tests interpreted as null.** A non-significant test with low power means "couldn't detect this effect", not "no effect exists". Always report MDE alongside p-value.
- **Novelty effect.** New treatments often outperform during the first 1–2 weeks because users notice the change. If long-term effect matters, run longer or pre-register a follow-up measurement window.

---

## Decision matrix — which test for which hypothesis

| Hypothesis type | First test | Second test (if first inconclusive) |
|---|---|---|
| "Drop is at step X" (T1) | Funnel analysis | Usability test on step X |
| "Copy is unclear" (T2) | Open-text micro-survey | Usability test with think-aloud |
| "Specific segment is affected" (T3, A3, R3, E2) | Segmentation cut | Usability test recruited from that segment |
| "Onboarding leak" (R1) | Cohort comparison + funnel | Open-text micro-survey on early-funnel dropoffs |
| "Feature deprecation hurt retention" (R2) | Segmentation cut by past feature usage | Stakeholder/support data review |
| "Awareness gap" (A1) | Segmentation cut by exposure source | A/B test of discovery surfaces |
| "Seasonal pattern" (E1) | Year-over-year comparison | (No second test needed if YoY confirms) |
| "Content/surface change reduced engagement" (E3) | Funnel by entry surface | Open-text micro-survey at the surface |
| "Multiple changes shipped, can't isolate" | A/B test (hold-back) | (Required — no analytics-only solution) |

When in doubt, default to **analytics dive first, A/B test last**. If a question can be answered by a segment cut on existing data, it should never escalate to a controlled experiment.
