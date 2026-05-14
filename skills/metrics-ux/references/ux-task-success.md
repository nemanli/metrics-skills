# UX Task Success — metrics

HEART Task Success category — how well users complete their intended tasks. All five metrics here are behavioral, not survey-based ([Rodden](https://kerryrodden.com/heart/)). Task Success answers "did they succeed at what they came to do?" — not "how do they feel about it?" (see [ux-happiness.md](ux-happiness.md)) or "how often do they come back?" (see [ux-retention.md](ux-retention.md)). For category context, see [heart.md](../../metrics-basics/references/heart.md#the-five-categories).

**Standards anchor.** These metrics align with [ISO 9241-11:2018](https://www.iso.org/standard/63500.html), the international usability standard, which defines usability as effectiveness (success, errors), efficiency (time, resources), and satisfaction. Nielsen's 5 components add learnability and memorability ([NN/g — Usability 101](https://www.nngroup.com/articles/usability-101-introduction-to-usability/)).

**Define the task before measuring.** Every metric here depends on a clear task definition with a specific end state (order placed, file uploaded, message sent). Without that, "success" and "drop-off" are subjective. Exploratory tasks (browsing, research, learning) have no clear endpoint — these metrics will produce noise. Use qualitative methods for those.

---

## Task Success Rate

**Definition.** Share of users who complete a defined task correctly.

**When to use.** The single most diagnostic Task Success metric. First metric to check after a redesign. Best for tasks with a clear endpoint — checkout, onboarding, search, account recovery. Not for exploratory or open-ended flows.

**How to measure.**
- Formula: `(successful completions / total task attempts) × 100` ([NN/g — Success Rate](https://www.nngroup.com/articles/success-rate-the-simplest-usability-metric/)).
- Define "success" as a specific end state before measuring (order placed, file uploaded, message sent). Partial completions can be reported separately as "partial success" if useful.
- Sample size: ~40 participants for stable quantitative benchmarking at 95% confidence ([NN/g — Sample sizes for quantitative usability](https://www.nngroup.com/articles/summary-quant-sample-sizes/)). Smaller samples produce direction, not precision.
- Timing: measure consistently across releases — change one variable at a time (UI, copy, audience).

**Example (real aggregate).** Across **1,189 tasks in 115 usability tests with 3,472 users**, MeasuringU found the average task-completion rate is **78%**; top quartile exceeded **92%**, bottom quartile fell below **49%** ([MeasuringU — What is a good task-completion rate](https://measuringu.com/task-completion/)). Use these as orientation, not targets — your task definition and audience determine what "good" looks like for your product.

**Benchmark.** ~78% across typical digital tasks; >92% is top-quartile; <70% signals friction (Sauro / MeasuringU, 1,189-task dataset).

**Pitfalls.**
- Defining "success" too loosely (e.g. "user reached the confirmation page") inflates the number. The end state should be the actual user goal (order placed and confirmed), not a proxy.
- A high success rate with a high error rate (below) means users recovered, but the flow still wasted effort. Pair the two metrics.
- Lab-vs-production gap (Hawthorne effect / observer bias) — observed participants are more patient, read instructions more carefully, and try harder to complete tasks than real users will ([NN/g — Hawthorne effect and observer bias](https://www.nngroup.com/articles/hawthorne-effect-observer-bias-user-research/)). Treat lab success rates as an upper bound on production behavior.

---

## Error Rate

**Definition.** Frequency of user mistakes during a task.

**When to use.** Forms, data entry, multi-step flows, anything with validation. Pairs with Task Success Rate — a flow with high success and high errors means users recover, but the cost in time and effort is real.

**How to measure.**
- Formula: `total errors / total task attempts` ([MeasuringU — Measuring Errors in UX](https://measuringu.com/errors-ux/)). For per-opportunity rates, divide by total error opportunities, not just attempts.
- Distinguish slips from mistakes ([Don Norman, *The Design of Everyday Things*](https://www.basicbooks.com/titles/don-norman/the-design-of-everyday-things/9780465050659/)):
  - **Slip:** right intent, wrong action (clicked the wrong button, mistyped). Usually fixable with better affordances.
  - **Mistake:** wrong intent (chose the wrong path entirely). Usually a model/IA problem.
- Tag errors by type to find patterns. Falls under ISO 9241-11 "effectiveness" (accuracy and completeness).
- Sample size: same as success rate — ~40 participants for benchmarking; smaller for direction.

**Example (real aggregate).** Sauro's analysis of **719 tasks** across consumer and business software found an average of **0.7 errors per task**, with **two out of three users making at least one error** ([MeasuringU — Measuring Errors in UX](https://measuringu.com/errors-ux/)). Use this as a reference for what "common" looks like; your own per-attempt rate depends on task complexity and validation design.

**Pitfalls.**
- No universal benchmark — error rates depend on task complexity. Track trend over time; a rising error rate after a release is the signal.
- Counting non-errors as errors (back-button clicks, hesitation pauses) inflates the number. Define what counts as an error before measuring.
- Errors without slip/mistake tagging produce noise. The fix for slips (better affordances) is different from the fix for mistakes (better information architecture).

---

## Time on Task

**Definition.** Time from task start to task completion.

**When to use.** Frequent tasks where speed matters (search, checkout, repeat workflows). Less useful for exploratory or creative tasks where longer time is often better.

**How to measure.**
- Formula: per-task duration from start event to success event. **Use geometric mean for small samples (n<25)**; the median is biased upward by ~10% in right-skewed time distributions ([MeasuringU / Sauro & Lewis — Average Task Times](https://measuringu.com/average-times/)). For larger samples, median is acceptable.
- Falls under ISO 9241-11 "efficiency" (resources expended). Always report alongside success rate — a fast task that fails is not efficient.
- Exclude outliers caused by interruptions (long pauses, abandoned then resumed). Cap at a reasonable maximum or filter at task start.
- Timing window: measure consistently across cohorts and releases; never compare across different task definitions.

**Example (real case).** In a Macromedia Flash usability study reported by NN/g, redesign cut total task time from **236 seconds to 69 seconds** — a 70% reduction in time-to-complete ([NN/g — Usability Metrics](https://www.nngroup.com/articles/usability-metrics/); sample size not specified by NN/g). Reporting before/after on the same task definition is what makes the number actionable; the absolute time means little without the comparison.

**Pitfalls.**
- Mean over median (or worse, over geometric mean for small samples) overstates time because of long-tail outliers. Use the right central tendency for the sample size.
- Time on task without success rate misleads — a fast failed task is not a win. Pair always.
- Industry benchmarks for time on task are rarely comparable because task definitions differ between studies. Compare to your own baseline before/after changes.

---

## Drop-off Rate (per step)

**Definition.** Share of users leaving a specific step in a multi-step flow. Per-step, not flow-wide.

**When to use.** Onboarding, checkout, sign-up, wizards, any flow with two or more steps. Diagnoses *where* users abandon, not just how many. Pairs with overall completion rate (which is `1 - flow-wide drop-off`) for the full-funnel picture.

**How to measure.**
- Formula: `(users leaving step N / users entering step N) × 100`. Compute per step, not as a single flow-wide number — the per-step shape is the diagnostic value.
- Report alongside the funnel (entries and exits per step); a heatmap of drop-off rates highlights the weakest step.
- Segment by entry point, device, traffic source — checkout drop-off looks very different on mobile vs desktop, paid vs organic.
- Sample size: depends on the smallest step's traffic. A per-step rate is only stable when each step has enough entries that one or two abandonments don't shift the rate by several points; small steps need a wider observation window.

**Example (real case — GOV.UK Lasting Power of Attorney service).** GOV.UK's digital LPA service refined its funnel definition (excluding logged-in returners and back-navigators) and found completion rose from a misleading **28.7% to ~70%** across 35,000 tracked users ([GOV.UK Data Blog — Updating the LPA completion rate](https://dataingovernment.blog.gov.uk/2015/02/25/updating-the-lasting-power-of-attorney-completion-rate/)). The lesson is structural: the same flow can look like 28% or 70% depending on how you define "entered" and "completed." Always document the funnel definition before reporting the number.

**Aggregate benchmark.** Baymard's meta-analysis of 50 studies puts average online cart abandonment at **70.22%** (mobile 80.02%, desktop 66.41%) ([Baymard — Cart Abandonment Statistics](https://baymard.com/lists/cart-abandonment-rate)). The mobile-vs-desktop gap (~14 percentage points, calculated from Baymard's figures) is large enough that segmenting by device is mandatory before acting.

**Pitfalls.**
- A single flow-wide drop-off number hides the weak step. Always report per step.
- Mixing devices and segments hides the real story. The mobile-vs-desktop gap on checkout is large (see Baymard figures above) — segment first, then act.
- Drop-off is symptom, not cause. Pair with qualitative input (session recordings, user interviews) to understand *why* users leave a specific step.

---

## Learnability

**Definition.** How much users improve at a task with repetition. Nielsen's 5th usability component ([NN/g — Usability 101](https://www.nngroup.com/articles/usability-101-introduction-to-usability/)): "how easy is it for users to accomplish basic tasks the first time they encounter the design?"

**When to use.** Products used regularly (productivity tools, dashboards, editors, B2B apps). Irrelevant for one-off flows like password reset.

**How to measure.**
- Formula: compare Time on Task or Error Rate across multiple attempts by the same user. A clear downward curve = good learnability. NN/g recommends **30–40 participants and 5–10 trials**, noting that the learning curve is typically logarithmic, not linear ([NN/g — How to Measure Learnability](https://www.nngroup.com/articles/measure-learnability/)).
- Within-subjects design: same users, different attempts. Between-subjects (different users at different "skill levels") confounds learnability with self-selection.
- Timing: spread attempts over days, not minutes. Same-session repetition measures short-term memory, not learnability.

**Example (illustrative — public learnability case studies with named products are rare).** 20 users perform a data-export task on day 1, day 3, and day 5. Day 1 geometric mean time: 4m 30s; day 3: 2m 15s; day 5: 1m 40s. The flattening curve (close to expert time by day 5) shows the design is learnable. If day 5 still matched day 1, the product would be hostile to repeat use.

**Pitfalls.**
- Same-session repetition is short-term memory, not learnability. Space attempts across days.
- Single-attempt benchmarks miss learnability entirely. A product that's hard on day 1 but trivial on day 5 looks worse in a one-shot study than it deserves.
- Learnability hides the *floor* — a product can be highly learnable on day 5 and still have a difficult first session. Pair with Task Success Rate or activation metrics ([ux-adoption.md](ux-adoption.md)) to check whether new users stay long enough to reach the learnable plateau.

---

## Choosing between them

| Situation | Use this | Why |
|---|---|---|
| First check after a redesign | Task Success Rate | Most diagnostic single metric; reveals whether the flow works |
| Multi-step flow (checkout, onboarding) | Drop-off Rate (per step) + Task Success Rate | Per-step drop-off finds the weakest step; success rate gives flow health |
| Forms, data entry, validation-heavy flows | Error Rate (with slip/mistake tags) | Tells you *why* users fail, not just *if* they fail |
| Speed-critical task (search, repeat workflow) | Time on Task (geometric mean) + Success Rate | Speed only counts when the task succeeds |
| Repeat-use product (productivity, dashboards) | Learnability (curve across attempts) | Single-attempt metrics miss the day-5 reality |
| Exploratory or open-ended task (browsing, research) | None — use qualitative methods | These metrics need a clear task endpoint |
