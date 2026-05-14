# Claim archetypes

Four common shapes of incoming metric claims. Each has a typical pathology — the load-bearing axes that most often fail for that archetype, and the counter-questions that probe most efficiently.

Use this to decide where to focus the review when time is short. A full five-axis review is always valid; this reference helps allocate effort.

---

## Archetype 1 — Vendor case study

**Shape:** "CompanyX implemented our solution and saw +N% on [metric]."

**Typical form:** marketing landing page, conference talk, slide deck, sales pitch.

**Load-bearing failure axes (in order of frequency):**

1. **Sample & power.** n almost never stated. "+40% conversion" with no n is a slogan.
2. **Comparison.** Almost always pre/post, never controlled. "After implementing" = pre/post.
3. **Window selection.** Window chosen to maximize the lift. Pre-window often picked from a bad month.
4. **Counter-metric.** Counter rarely mentioned. If it did move wrong, definitely not reported.
5. **Definition.** Metric defined loosely so the vendor can pick the largest-moving funnel step.

**Selection bias to flag:** Vendors choose **which customer** to highlight. For every CompanyX case study, there are CompanyY and CompanyZ where the change did nothing — a textbook case of [survivorship bias](https://www.britannica.com/topic/survivorship-bias). The base rate is hidden.

**Counter-questions (prioritized):**

1. "Which specific metric, defined how? Walk me through the event chain."
2. "Was this an A/B test with a held-back control, or a pre/post comparison?"
3. "What was the n, what was the window, and was the window pre-registered?"
4. "What counter-metrics did you monitor — task success on the changed flow, support-ticket volume, or downstream user-behavior metrics?"
5. "What share of your customer base sees comparable lifts? Show me a stratified rollout, not a flagship case."
6. "Is the case study from a customer using your product in isolation, or was it part of a larger redesign that also shipped other changes?"

**Common verdict pattern:** "Don't trust" or "Need more info" — vendor case studies almost never have the parts needed for a serious review.

---

## Archetype 2 — Dashboard screenshot / PM update

**Shape:** "Our [metric] is up [N%] week-over-week" or "Conversion hit [X%]" — screenshot or chart sent in a Slack thread, a stand-up, a weekly review.

**Typical form:** Mixpanel/Amplitude/Looker screenshot, Slack message, weekly review email, exec dashboard.

**Load-bearing failure axes:**

1. **Window selection.** Weekly comparisons against an unstable baseline; one-off "this week was great" claims without trend context.
2. **Comparison.** Often calendar comparison on a cohort metric (e.g. "this month's retention vs last month's"), which mixes cohorts.
3. **Definition.** Dashboards have implicit definitions that everyone assumes are the same — and they often aren't.
4. **Counter-metric.** Dashboard shows one chart; counter lives on a different dashboard nobody opened.
5. **Sample & power.** Dashboards rarely show CIs; movements within noise look real.

**Selection bias to flag:** PMs often share the dashboards where things look good; the ones where the metric is flat or down don't get screenshot.

**Counter-questions (prioritized):**

1. "What's the underlying metric definition — event chain, segment, dedup?"
2. "Show me the prior 4 weeks. Is this week's movement outside the typical variation?"
3. "If this is a cohort metric (retention, activation), is it computed cohort-by-cohort or calendar-month?"
4. "What's the n for this week vs prior weeks? Is the volume comparable?"
5. "What counter-metric do you watch for this? Did it move?"
6. "Are you cherry-picking this dashboard from many, or is this the one we're committed to?"

**Common verdict pattern:** "Trust with caveats" or "Need more info" — internal dashboards are usually honest, but loose. The fix is asking for the missing context, not rejecting the claim.

---

## Archetype 3 — "Industry benchmark"

**Shape:** "Industry-standard NPS is 32" / "Industry conversion is 2.3%" / "Average X is Y."

**Typical form:** cited in slide decks, blog posts, PM talking points, vendor sales material.

**Load-bearing failure axes:**

1. **Definition.** "Industry NPS" assumes a single definition; in reality NPS measurement varies wildly by survey design, sampling, recipient pool, and scale interpretation ([MeasuringU — NPS reporting cautions](https://measuringu.com/nps/); the original Reichheld formulation in [*The One Number You Need to Grow*, HBR 2003](https://hbr.org/2003/12/the-one-number-you-need-to-grow) has been widely critiqued for measurement reliability since).
2. **Comparison.** Industry benchmarks usually mix B2C and B2B, mature and early-stage, free and paid. Comparing your product to "industry" can be apples-to-oranges.
3. **Sample & power.** Benchmark studies often have small samples per vertical; the "industry average" can be 12 companies.
4. **Window selection.** Year-old benchmarks are often cited as current. Industry moves; the number doesn't.

**Selection bias to flag:** "Industry benchmark" is often a single blog post citing another blog post citing a single study from 2015 with an unrepresentative sample. The lineage is opaque.

**Counter-questions (prioritized):**

1. "Where does this number come from — which specific study, which year?"
2. "How is the metric defined in that study? Does it match how we define it?"
3. "What's the sample of companies in the study? B2C/B2B mix? Product maturity?"
4. "Is the number reproduced in any other independent source?"
5. "How old is the data underlying it? Is the comparison still relevant?"

**Common verdict pattern:** "Don't trust without source" — "industry benchmarks" cited without a primary source are not evidence. Sometimes the underlying source, once found, is solid; usually it is one weak link in a citation chain.

**Trustworthy primary sources** (these can be cited; the issue is when *secondary* citations distort or stale them):

- NN/g (Nielsen Norman Group) — usability benchmarks ([nngroup.com](https://www.nngroup.com/articles/product-ux-benchmarks/)).
- Baymard Institute — e-commerce UX benchmarks ([baymard.com/research](https://baymard.com/research)).
- MeasuringU (Sauro) — usability stats ([measuringu.com](https://measuringu.com)).
- ACSI — customer satisfaction index, US ([theacsi.org](https://www.theacsi.org)).
- Published academic studies in CHI, CSCW, UIST.

---

## Archetype 4 — Leadership quote / executive claim

**Shape:** "The CEO said X" / "Per the CPO, retention is at all-time highs" / "Per leadership, the redesign succeeded."

**Typical form:** Slack threads, all-hands recap, performance review framing, decision rationale.

**Load-bearing failure axes:**

1. **Comparison.** Executive claims often skip the comparison ("all-time high" — vs what, when, segment?).
2. **Definition.** Executive shorthand drops the operational definition.
3. **Counter-metric.** Single-metric victory claims, almost always.
4. **Sample & power.** Rarely stated.
5. **Definition (sliding).** The metric the executive refers to may have a definition that has drifted from when the claim was first made.

**Selection bias to flag:** Executives are presenting; they choose which numbers support the narrative. The omitted numbers are not in the room. Also: Goodhart's Law under organisational authority ([Strathern, 1997](https://academic.oup.com/erev/article-abstract/5/3/305/6776275); see [measurement-philosophy.md Misconception 3](../../metrics-basics/references/measurement-philosophy.md)) — executive metrics tend to be the most aggressively gamed.

**Counter-questions (prioritized):**

1. "Which specific metric, defined how? Walk me through the formula."
2. "What's it being compared to? Same metric, prior period, comparable conditions?"
3. "What's the counter-metric, and did it move?"
4. "Is there a dashboard or doc with the underlying numbers and sample sizes?"
5. "Was this metric reviewed by anyone else, or is this leadership's read of leadership's numbers?"

**Special handling:** disagreeing with an executive claim in front of the executive is a political question, not a metrics question. The review here is to *understand* the claim well enough to decide what to do — whether to engage privately, request more data, or accept it as one input among many.

**Common verdict pattern:** "Need more info" — executive claims are compressed; the review's first job is to expand them back to a reviewable form.

---

## Cross-archetype patterns

### "It's only directional."

Phrase that appears across all four archetypes. Means: the data isn't significant, but we want to act on it anyway. The skeptical response is the same:

> "Directional" without significance means the result is consistent with the null hypothesis. If we act on directional results, our false-positive rate over many decisions will be high. Either commit to running until significance, or accept that this is a hypothesis-generating signal, not a decision-grade one.

### "It's hard to measure."

Common defense when one of the axes fails. Means: I'm aware of the issue but want to move on. Counter:

> "Hard to measure" can be true. But "hard to measure" doesn't change the noise. If the metric is genuinely hard, the claim has to be bounded — "the data is consistent with a lift between X and Y" — not asserted as a point. Or pair the quantitative with qualitative evidence to bridge the gap.

### "We don't have the data."

Counter:

> Then we don't have the conclusion either. The honest move is to state that the claim is currently unverifiable and identify what would make it verifiable. Acting on an unverifiable claim is taking the action and accepting the risk; that's a separate choice.

### "Trust me, I know this product."

Counter:

> Domain knowledge is valuable for hypothesis generation. For decisions, it pairs with evidence; it doesn't substitute for it. What's the specific evidence behind this claim?

---

## When the claim isn't from anyone — competitor or market claims

Variant of Archetype 3, but worth calling out separately. "Competitor X is at Y conversion" or "The market is moving toward Z."

These often:

- Come from a competitor's marketing material (subject to same selection bias as Archetype 1).
- Come from analyst reports with paywalled methodology.
- Come from "everybody knows" in the industry — which often means one blog post repeated.

Counter-questions same as Archetype 3: cite the primary source, check the methodology, evaluate whether it applies to your context.

---

## See also

- [review-checklist.md](review-checklist.md) — the five axes the archetypes are organized against.
- [anti-rationalization.md](anti-rationalization.md) — the excuses that appear when each archetype's pathology is named.
- [`../../metrics-basics/references/measurement-philosophy.md`](../../metrics-basics/references/measurement-philosophy.md) — Misconceptions 1–3 explain why these archetypes fail.
