# Five-axis review checklist

Detailed reference for SKILL.md Step 3. For each axis: the questions, the failure modes, the green-flag and red-flag signals, the counter-questions. The five axes are deliberately non-overlapping; a claim that passes all five is reviewable, a claim that fails two or more should not drive decisions.

The structure parallels established critical-appraisal traditions: CONSORT for trial reporting ([CONSORT 2010 statement](http://www.consort-statement.org/)), the EQUATOR Network's reporting guidelines, and the experimentation-trust framework in [Kohavi, Tang, Xu — *Trustworthy Online Controlled Experiments* (2020)](https://experimentguide.com/).

---

## Axis 1 — Definition

> **The question:** how is the metric computed?

### What to look for

| Sub-question | Why it matters |
|---|---|
| **What event chain defines it?** | "Conversion" can name any step in any funnel. Same word, different things. |
| **What segment does it cover?** | All users? Logged-in only? Mobile only? Excluded internal traffic? |
| **What is the dedup rule?** | Per-user, per-session, per-day? |
| **Is it a composite metric?** | NPS = promoters − detractors. CSAT = top-2 box / total. Composites hide trade-offs — NPS rising by 5 points can mean more promoters *or* fewer detractors, two very different signals ([MeasuringU — NPS](https://measuringu.com/nps/)). |
| **Is it a surrogate?** | "Engagement" used as a stand-in for "satisfaction". The surrogate may not predict what the headline implies. |
| **What is the unit?** | Percentage points vs relative percent — "+5%" of 60% = 63% (relative) or 65% (absolute). |

### Failure modes

- Same word, different definitions (e.g. "conversion" used three ways in the same deck).
- Composite metric that hides direction (NPS up 5 — more promoters or fewer detractors?).
- Surrogate substitution ("email opened = engagement").
- Unit confusion (pp vs relative %).
- Sliding definitions (metric changed during the measurement window). Erika Hall's framing applies: *"people see something expressed as a number and think 'that's a fact', but numbers aren't facts"* ([Hall — dscout interview](https://dscout.com/people-nerds/erika-hall-better-research-and-design)).

### Counter-questions

- "What is the event chain or formula behind this metric?"
- "What segment does this cover, and what share of users does that segment represent?"
- "Is this per-user or per-session? Per-day or cumulative?"
- "Is the change reported in percentage points or relative percent?"
- "Did the definition change at any point during the measurement window?"

---

## Axis 2 — Sample & power

> **The question:** is the sample big enough to make this number trustworthy?

### What to look for

| Sub-question | Why it matters |
|---|---|
| **What is the n?** | Without n, every percentage is a guess ([NN/g — sample sizes for quantitative](https://www.nngroup.com/articles/summary-quant-sample-sizes/)). |
| **What is the CI?** | A point estimate without a CI hides uncertainty. |
| **Was the test powered for the threshold?** | A non-significant result on small n means "test couldn't tell", not "no effect" ([Cohen, 1988](https://doi.org/10.4324/9780203771587)). |
| **What is the effect size?** | Statistical significance with tiny effect is operationally meaningless. |
| **Was multiple testing corrected?** | Reporting "the one metric of 20 that hit p<0.05" without correction inflates the false-positive rate ([Wasserstein & Lazar — ASA Statement on p-values, 2016](https://amstat.tandfonline.com/doi/full/10.1080/00031305.2016.1154108)). |

### Failure modes

- n omitted. Most common single failure across self-reported metrics.
- Underpowered "no effect" claim — small n, test fails to reach significance, reported as if the change had no effect.
- Statistically significant but tiny — p<0.001 on n=10M, effect size 0.2 pp.
- CI omitted — point estimate of "+15%" without bounds hides that the band may cross zero.
- Multiple testing without correction — "we looked at 20 metrics; 3 moved; here is one".
- Survivor bias — "of users who reached checkout" inflates relative to full population.

### Counter-questions

- "What is the n on each side of the comparison?"
- "What is the 95% CI on the difference?"
- "What is the effect size — Cohen's h/d or absolute pp?"
- "At this n, what is the MDE? Could the test have detected the effect you are claiming?"
- "How many metrics did you look at total? Was multiple-testing correction applied?"

See [`../../metrics-diagnose/references/stat-snippets.md`](../../metrics-diagnose/references/stat-snippets.md) §4 for the MDE check.

---

## Axis 3 — Comparison

> **The question:** versus what? What else changed in the same window?

### What to look for

| Sub-question | Why it matters |
|---|---|
| **Is there a control group?** | A control isolates the change from everything else happening ([Athey & Imbens, 2017](https://arxiv.org/abs/1607.00698)). |
| **If no control: what else changed?** | Pre/post catches every concurrent change. |
| **Is the comparison population comparable?** | Comparing new-user cohort A to old-user cohort B mixes mix shifts with the change. |
| **Cohort or calendar comparison?** | "This month's retention" mixes new and old users; retention is always a cohort question ([Andrew Chen — retention curves](https://andrewchen.com/new-data-shows-why-losing-80-of-your-mobile-users-is-normal-and-that-the-best-apps-do-much-better/)). |
| **Was the baseline stable?** | A 5 pp lift over a baseline that varies ±10 pp week-to-week is noise. |

### Failure modes

- Pre/post with no control. The most common failure mode in industry case studies.
- Comparison to a non-comparable benchmark.
- Calendar comparison on cohort metrics.
- Baseline cherry-pick (compare to the worst week of baseline; everything looks like a lift).
- Survivor bias — the change applies to everyone; the comparison is only to users who completed something.

### Counter-questions

- "Was this an A/B test, or a pre/post comparison?"
- "If pre/post: what else shipped or changed in the same window?"
- "Is the comparison population the same as the treatment population?"
- "For retention: was this cohort-vs-cohort, or calendar?"
- "How stable was the baseline before the change? Show me the prior 4 weeks."

---

## Axis 4 — Window selection

> **The question:** why this time window?

### What to look for

| Sub-question | Why it matters |
|---|---|
| **Was the window pre-registered?** | If chosen after seeing the data, the window itself is selected for what looks best ([Kerr — HARKing, 1998](https://journals.sagepub.com/doi/10.1207/s15327957pspr0203_4)). |
| **How long?** | Too short = noise. Too long = mixing in later-period changes. |
| **Same length pre and post?** | Asymmetric windows mix window-length effects with the change. |
| **Day-of-week / seasonality matched?** | Peak/off-peak comparisons inflate or hide effects. |
| **Skip-week-1 applied?** | First week post-launch is novelty-contaminated for visible changes ([Kohavi et al., 2020](https://experimentguide.com/), Ch. 23). |
| **Recent end?** | Window ending in a dip can hide softness; ending at a peak can inflate. |

### Failure modes

- Cherry-picked window — start and end chosen to maximise the lift.
- Asymmetric window lengths (1 week pre vs 4 weeks post).
- Novelty-contaminated post-window (includes week 1 of a visible UI change).
- Seasonality mismatch (Q4 vs Q1).
- Truncation at convenient point.

### Counter-questions

- "When was the window decided — before or after the data started coming in?"
- "Pre and post are the same length?"
- "Was week 1 included or excluded? If included, how is novelty handled?"
- "Show me the metric for the 2 weeks before and 2 weeks after the window. Does the trend continue?"

---

## Axis 5 — Counter-metric

> **The question:** what was the guardrail, and did it move?

### What to look for

| Sub-question | Why it matters |
|---|---|
| **What counter-metric was watched?** | Without a counter, you do not know if the primary moved by gaming — Goodhart's Law ([Strathern, 1997](https://academic.oup.com/erev/article-abstract/5/3/305/6776275)). |
| **Did the counter move?** | If against the primary, the lift is hollow. |
| **Was the counter actually a counter?** | "Engagement up too" is sympathy, not a guardrail. The OEC framework distinguishes the two ([Kohavi et al. — *Online Controlled Experiments at Large Scale*, KDD 2013](https://exp-platform.com/large-scale/)). |
| **Were operational guardrails monitored?** | Latency, error rate, support tickets catch implementation failure modes user metrics do not. |
| **Were guardrails reported?** | Or only the ones that held? |

### Failure modes

- No counter-metric. Single-metric victory claim — almost certainly hiding something.
- Vanity counter — sympathy metric, not a guardrail.
- Counter moved wrong, omitted.
- Counter pre-selected to hold (chosen because it could not reasonably move).
- Guardrails not watched — latency tripled, but only the conversion lift is reported.

### Counter-questions

- "What counter-metric was monitored?"
- "If you had to name the metric you would have been most embarrassed to show if it moved wrong — what is it?"
- "Did latency, error rate, or crash rate change?"
- "Did downstream user-behavior metrics change — retention, task success on the next step, support ticket volume?"
- "Show me the counter movement alongside the primary."

---

## Putting it together — verdict logic

| Failures | Acknowledged? | Verdict |
|---|---|---|
| 0 axes fail | — | **Trust.** Note remaining smallest gap. |
| 1–2 axes fail | Yes | **Trust with caveats.** Name the gap. |
| 1 axis fails | No | **Don't trust until acknowledged.** Ask counter-questions; re-review when answered. |
| 2+ axes fail | No | **Don't trust.** Multiple unaddressed load-bearing gaps; claim needs rework, not clarification. |
| Severe single-axis failure (e.g. definition shifted mid-window, no control with heavy confounds) | Either | **Don't trust.** One axis breaks the causal claim badly enough that further dialogue does not recover it. |
| Underspecified | — | **Need more info.** List missing parts. |

A failure on Axis 5 (counter-metric) is especially load-bearing. A claim that is otherwise pristine but has no counter-metric is almost always hiding a Goodhart trap. Treat single-metric claims as **Don't trust until acknowledged** unless the team has a structural reason a counter would not apply.

**Most vendor case studies and "industry benchmarks" fail 3–4 axes but the right move is one round of counter-questions, not rejection.** Outright **Don't trust** is reserved for cases where the rework needed is so large that further dialogue is wasted effort.

---

## See also

- [anti-rationalization.md](anti-rationalization.md) — excuses for failures on each axis and the counter-responses.
- [claim-archetypes.md](claim-archetypes.md) — how the parse differs across vendor case / dashboard / "industry benchmark" / leadership quote.
- [`../../metrics-basics/references/measurement-philosophy.md`](../../metrics-basics/references/measurement-philosophy.md), Misconceptions 1–3 — why these axes exist.
- [`../../metrics-diagnose/references/stat-snippets.md`](../../metrics-diagnose/references/stat-snippets.md) §4 — MDE / power check for Axis 2.
