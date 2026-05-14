---
name: metrics-diagnose
description: Diagnoses metric movements when the user has data — a number dropped/spiked/plateaued, before/after numbers, a funnel, a cohort table, or a CSV — and asks "is this real?", "why?", or "what to check next?". Skip if no data exists yet (use metrics-ux), for stakeholder communication (use metrics-present), or for pure metric definitions (use metrics-basics).
allowed-tools: Read
---

## Overview

Diagnoses metric movements from real data. Three jobs: (1) decide whether the change is **signal or noise** using a proper statistical test, (2) generate ranked **hypotheses** for the cause grounded in known root-cause patterns, (3) recommend a prioritized **action plan** — what to test next, in what order, with what method.

Statistics happen inside the skill. The user gets a clean answer ("13-point drop is signal, p<0.01, 95% CI: −16.2% to −9.8%, large effect") plus the hypothesis ranking and action plan — not formula derivations.

This skill never diagnoses without data. If the user has no baseline, no sample size, or no comparable segment, the skill stops and asks. Diagnosing on insufficient data produces confident-sounding nonsense.

## When to Use

Use this skill when a designer or PM brings real data and asks for interpretation — phrased differently by seniority but matching the same job-to-be-done:

| Designer level | Typical phrasing that should trigger this skill |
|---|---|
| **Junior** | "Task success dropped from 74% to 61% after the redesign — did I break it?" / "Conversion is down this week, is that bad?" |
| **Middle** | "Retention curve flattened earlier than the previous cohort, what's going on?" / "Funnel step 3 lost 8 points after release, where do I look first?" |
| **Senior** | "We shipped two changes in the same sprint, the metric moved — how do I separate the effects?" / "CSAT and Task Success disagree, which one is right?" |
| **Lead** | "Adoption looks fine on the headline number but a key segment dropped — is the segment shift the cause or a symptom?" / "Quarterly review tomorrow — what does this metric movement actually mean?" |

Cross-cutting triggers (any seniority):

- Has before/after numbers, a funnel snapshot, a cohort table, or a CSV/screenshot of metric data.
- Asks "is this real?", "is this significant?", "why did this change?", "what should I check next?".
- Reports an unexpected pattern: drop, spike, plateau, divergence between two related metrics.
- Asks how to test a hypothesis they already have ("I think it's X — how do I confirm?").

Skip this skill when:

- The user has no data and is planning what to measure → use `metrics-ux`.
- The user wants to write a measurement plan / decision rule **before** shipping → use `metrics-spec`.
- The user wants to design the events/tracking plan that captures the metric → use `metrics-instrumentation`.
- The user wants to stress-test someone else's claim or self-review before publishing → use `metrics-review`.
- The user has interpreted the data and now needs to communicate it → use `metrics-present`.
- The question is about the definition or formula of a metric → use `metrics-ux` or `metrics-basics`.
- The metric is monetization-driven (revenue, MRR, LTV) → out of scope for v1.

## Process

### Step 1 — Parse input

Identify what the user provided:

| Input type | Action |
|---|---|
| **Inline numbers** (e.g. "74% → 61%, n=1,200") | Extract: metric, before, after, sample size, time window. Note what is missing. |
| **CSV / file path** | Use `Read` to load. Read the first 5–10 rows to inspect structure. Make no assumption about column names, headers, or layout — see CSV parsing rules below. |
| **Description only** ("retention dropped a lot") | No numbers — go to Step 2 (DATA anchor will fail; ask for data). |
| **Funnel / cohort table** (pasted) | Parse step-by-step or cohort-by-cohort. Identify the suspect step or cohort. |

**CSV parsing rules.** Dashboard exports vary widely across teams — never assume a fixed schema.

- Read the file and inspect the first 5–10 rows before doing anything else. Identify whether headers exist (first row is text vs numbers), whether the layout is **wide** (each time period is a column: `Week 1, Week 2, Week 3`) or **long** (one row per period: `date, metric, value`), and what the sample-size carrier is (a column, a header annotation, or absent).
- Map what you see to the five required fields below — do not look for column names like "metric" or "segment". The user's columns may be `Conv %`, `Users`, `Cohort_Date`, `v1_test_users`, or anything else.
- **Never silently guess.** If a mapping is ambiguous (two plausible sample-size columns; unclear which value is before vs after; date format unknown), ask the user — quote the column names you see and ask which is which.

**Five required fields** (extract or confirm before Step 2):

1. **Metric** (what is being measured — proportion, continuous, count, rate)
2. **Before** value (with sample size)
3. **After** value (with sample size)
4. **Time window** (how long each measurement covers)
5. **Segment** (all users, or a subset)

**How many to ask at once** (mirrors the Phase 2 questionnaire pattern):

- 0–2 fields missing or ambiguous → ask in one short message
- 3+ missing or the column structure is unclear → ask the user to describe the export ("which column is the sample size? what's the date format? is each row a week or a user?")

When asking, follow the "How to ask" section in [context-questions.md](../metrics-basics/references/context-questions.md) — inline numbered list for closed-choice questions (metric type, before/after column pick). Free-text answers (column names the user must type) stay inline as a short sentence.

If the dashboard export contains only metric values with no context (no sample size, no segment, no time window definition), stop and ask. Do not invent missing fields.

### Step 2 — DATA anchor check

Diagnosis requires data. Before any further step, confirm:

| Check | Pass | Fail → Action |
|---|---|---|
| **Baseline exists** | Pre-change number with the same definition and segment | If no baseline, refuse to diagnose. Recommend setting one before drawing conclusions ([measurement-philosophy.md](../metrics-basics/references/measurement-philosophy.md), Situation 1). |
| **Sample size sufficient** | n ≥ ~100 per group for proportion metrics; n ≥ ~30 per group for continuous | If below threshold, statistical tests produce noise. Recommend qualitative methods (5–8 interviews) instead. |
| **Same definition before/after** | Metric formula, event, segment unchanged | If definition changed (new event, new segment, new tracking), the change may be measurement artifact. Stop and verify. |
| **Time window comparable** | Same length, same seasonality (e.g. both weekdays vs both weekends) | If windows differ, normalize first or pick comparable windows. |

If any check fails, name it explicitly and stop. Do not proceed to statistical testing on bad data.

### Step 3 — Mode detection

Pick one mode:

| Mode | Signal | Action |
|---|---|---|
| **Direct** | User asks how to test a specific hypothesis ("I think it's the new CTA — how do I confirm?") | Skip questionnaire. Go to [hypothesis-tests.md](references/hypothesis-tests.md), recommend the test method directly. |
| **Specific** | User has data + a clear suspect ("Drop happened the day we shipped X, was it X?") | Skip questionnaire. Run Step 4 (statistical test) + go directly to the matching pattern in [root-cause-patterns.md](references/root-cause-patterns.md). |
| **Vague** | User has data but no suspect ("Retention dropped, no idea why") | Run Step 4 (statistical test) first, then generate ranked hypotheses from [root-cause-patterns.md](references/root-cause-patterns.md). Ask SCOPE / STAGE anchors only if the metric type is unclear. |

### Step 4 — Signal vs noise (statistical test)

Pick the test by metric type. **Do not compute p-value, CI, effect size, or MDE from memory.** LLMs round off, miscompute CI bounds, and produce confident-sounding nonsense for any non-trivial input. Hand the user a copy-paste Python snippet from [stat-snippets.md](references/stat-snippets.md) and wait for the result before interpreting.

| Metric type | Test | Snippet |
|---|---|---|
| **Proportion** (success rate, retention rate, adoption rate, drop-off, conversion) | Two-proportion z-test | [stat-snippets.md](references/stat-snippets.md) §1 |
| **Continuous** (time on task, session duration, NPS score, SUS score) | Welch's t-test (unequal variances) | [stat-snippets.md](references/stat-snippets.md) §2 |
| **Count** (events per user, errors per session) | Chi-square test of independence (categorical) or Welch's t-test on per-user means (when distribution is reasonable) | [stat-snippets.md](references/stat-snippets.md) §3 or §2 |
| **Rate over time** (funnel step rate week over week) | Two-proportion z-test on the suspect window vs baseline window | [stat-snippets.md](references/stat-snippets.md) §1 |

Process:

1. Select the matching snippet from [stat-snippets.md](references/stat-snippets.md). Substitute the user's values into the `--- inputs ---` block.
2. Show the filled snippet to the user. Ask them to run it and paste the output back.
3. If the snippet result is non-significant (`p ≥ 0.05`), also send the **MDE / power check** snippet ([stat-snippets.md](references/stat-snippets.md) §4). A non-significant test on a small sample is underpowered, not negative — the user needs to know which.

What each output value means (use to translate the snippet output, never to invent one):

- **p-value** — probability the observed change happened by chance under the null hypothesis.
- **95% confidence interval** — Wilson for proportions (snippet §1); Welch t-based for means (snippet §2).
- **Effect size** — Cohen's h for proportions, Cohen's d for continuous. Thresholds: small ≈ 0.2, medium ≈ 0.5, large ≈ 0.8.
- **MDE** (snippet §4) — minimum detectable effect at 80% power for the current sample size.

Once the user pastes the snippet output, interpret in this format (one block, no formulas):

> **Signal vs noise:** [Statistically significant / Not significant / Underpowered]. [Two-proportion z-test / Welch's t-test], p=[value from snippet], 95% CI on the difference: [lower, upper from snippet], effect size [h/d]=[value from snippet] ([small/medium/large]). [One-sentence practical interpretation: "Drop is real and large enough to act on" / "Drop is within noise — wait for more data" / "Sample too small to detect a change of this size".]

Decision rule:

- **p < 0.05 AND effect size ≥ small** → real signal, proceed to Step 5.
- **p < 0.05 AND effect size below practical threshold** → statistically real but practically negligible. Name this explicitly; do not over-act.
- **p ≥ 0.05 AND power adequate** → not signal. Likely noise.
- **p ≥ 0.05 AND power inadequate** → underpowered. Recommend either more data or qualitative alternatives.

### Step 5 — Hypothesis generation and ranking

Open [root-cause-patterns.md](references/root-cause-patterns.md). Match the user's metric type (adoption / retention / task success / engagement) and pull the 3 patterns. For each pattern, evaluate fit:

| Pattern fit signal | Score |
|---|---|
| Telltale signs match the user's data exactly | High |
| Some telltale signs match, others don't | Medium |
| Telltale signs don't match, but the pattern is mechanically possible | Low |

Output 3–5 ranked hypotheses. Each hypothesis must include:

- **Hypothesis** (one sentence).
- **Why it ranks here** (which telltale signs match or don't).
- **How to confirm** (specific check — segment cut, funnel inspection, interview, A/B test — drawn from [hypothesis-tests.md](references/hypothesis-tests.md)).
- **Typical fix if confirmed** (link back to [root-cause-patterns.md](references/root-cause-patterns.md)).

### Step 6 — Prioritized action plan

Convert the ranked hypotheses into a sequenced plan:

1. **First check** — the cheapest, fastest test for the highest-ranked hypothesis (usually a segment cut or funnel inspection in existing analytics).
2. **If first check confirms** — the suggested fix or follow-up test.
3. **If first check disconfirms** — move to hypothesis #2.
4. **Stop condition** — when to declare the diagnosis done vs when to escalate to a controlled experiment.

End with the verify question.

### Step 7 — Verify

End every diagnosis with: **"Does this fit your situation, or should we narrow down?"**

## Example

**User prompt (specific mode):** *"Task Success Rate dropped from 74% to 61% after we shipped the redesign last week. n was 1,200 in the week before, 1,150 in the week after. Same flow, same definition. Why?"*

**Step 1 — Parse input:** Metric=Task Success Rate (proportion); Before=74% (n=1,200); After=61% (n=1,150); Window=1 week each, consecutive; Segment=all users; Suspect event=redesign shipped at the boundary.

**Step 2 — DATA anchor check:** Baseline ✓ (week before). Sample size ✓ (>>100). Same definition ✓ (user confirmed). Time window ✓ (both 1 week, consecutive). All pass.

**Step 3 — Mode:** Specific. User has data + clear suspect (redesign).

**Step 4 — Signal vs noise:**

Proportion metric → two-proportion z-test ([stat-snippets.md](references/stat-snippets.md) §1). Filled snippet:

```
from statsmodels.stats.proportion import proportions_ztest, confint_proportions_2indep
import math
x1, n1 = 888, 1200      # 74% before
x2, n2 = 702, 1150      # 61% after
p1, p2 = x1/n1, x2/n2
stat, pval = proportions_ztest([x1, x2], [n1, n2])
ci_low, ci_high = confint_proportions_2indep(x2, n2, x1, n1, method="wald")
h = 2 * (math.asin(math.sqrt(p2)) - math.asin(math.sqrt(p1)))
print(f"p1={p1:.4f}  p2={p2:.4f}  z={stat:.3f}  p-value={pval:.4g}")
print(f"95% CI on diff: [{ci_low:+.4f}, {ci_high:+.4f}]  Cohen's h = {h:.3f}")
```

> Run that locally and paste the output back; I'll interpret. Expected shape: highly significant, large CI bounded well below zero, h in the small-to-medium range.

(For the rest of this example, assume the user pasted back: `p1=0.7400 p2=0.6104 z=6.85 p-value=7.4e-12 95% CI on diff: [-0.1664, -0.0928] Cohen's h = -0.281`.)

> **Signal vs noise:** Statistically significant. Two-proportion z-test, p<0.001, 95% CI on the difference: −16.6% to −9.3%, Cohen's h=0.28 (small-to-medium). Drop is real and unlikely to be noise. Effect size is small in statistical terms but operationally meaningful at this scale (≈150 fewer successful users per week).

**Step 5 — Hypothesis generation** (from [root-cause-patterns.md](references/root-cause-patterns.md), Task Success patterns):

1. **UI change introduced friction at a specific step.** *Rank: High.* Telltale match: drop coincides exactly with redesign ship date. *How to confirm:* Funnel breakdown by step, week-over-week. Look for one step where drop concentrates (vs uniform drop across all steps). *Typical fix:* Iterate on the step with the largest delta.
2. **Instruction or label clarity regressed.** *Rank: Medium.* Telltale match: redesign often changes copy alongside layout. *How to confirm:* Open-text post-task survey on the failing step ("what were you trying to do?"). Or 5 quick usability tests on the new flow. *Typical fix:* Rewrite the affected copy; A/B test against the old.
3. **Edge case surfaced for a previously-protected segment.** *Rank: Medium-Low.* Telltale match: would show as drop concentrated in one segment (mobile, locale, account type). Need segment cut to confirm. *How to confirm:* Cut Task Success by device, locale, account age. Look for one segment with disproportionate drop. *Typical fix:* Address the segment-specific case; consider phased rollout for next release.

**Step 6 — Prioritized action plan:**

1. **First check (today):** Funnel breakdown by step, last 2 weeks, week-over-week. Goal: find whether the 13-point drop is concentrated in one step or spread evenly.
2. **If concentrated in one step → Hypothesis 1 confirmed.** Run 5 usability tests on that step within 3 days; ship a fix candidate; A/B test fix vs current.
3. **If spread evenly → Hypothesis 2 or 3.** Cut by device/locale/account age (Hypothesis 3). If a segment stands out, address that. If not, run the post-task open-text survey (Hypothesis 2).
4. **Stop condition:** Diagnosis is done when a single hypothesis explains ≥70% of the drop. If after both checks no single cause stands out, escalate to a controlled A/B test of redesign-on vs redesign-off.

> Does this fit your situation, or should we narrow down?

### Example 2 — underpowered, no real signal

**User prompt (specific mode):** *"Day 7 retention for our beta cohort dropped from 42% to 34% after we changed the welcome screen. n=80 in the old cohort, n=75 in the new one. Should we revert?"*

**Step 1 — Parse input:** Metric=Day 7 Retention (proportion); Before=42% (n=80); After=34% (n=75); Window=cohort-based (Day 7 measurement); Segment=beta users.

**Step 2 — DATA anchor check:** Baseline ✓. Same definition ✓. Time window ✓ (matched cohort age). **Sample size FAIL** — n=80 and n=75 are below the ~100 per group threshold for stable proportion testing. Flag explicitly but proceed to Step 4 to quantify what the data can and cannot say.

**Step 3 — Mode:** Specific. User has data + clear suspect (welcome screen change).

**Step 4 — Signal vs noise:**

Proportion metric, small n → run both the z-test ([stat-snippets.md](references/stat-snippets.md) §1) *and* the MDE check ([stat-snippets.md](references/stat-snippets.md) §4), since a non-significant result on n≈80 is almost certainly underpowered. Filled snippets:

```
# §1 — z-test
from statsmodels.stats.proportion import proportions_ztest, confint_proportions_2indep
import math
x1, n1 = 34, 80     # 42% before
x2, n2 = 26, 75     # 34% after
stat, pval = proportions_ztest([x1, x2], [n1, n2])
ci_low, ci_high = confint_proportions_2indep(x2, n2, x1, n1, method="wald")
h = 2 * (math.asin(math.sqrt(x2/n2)) - math.asin(math.sqrt(x1/n1)))
print(f"z={stat:.3f}  p={pval:.4g}  CI=[{ci_low:+.4f}, {ci_high:+.4f}]  h={h:.3f}")

# §4 — MDE at current n
from statsmodels.stats.power import NormalIndPower
analysis = NormalIndPower()
h_mde = analysis.solve_power(effect_size=None, nobs1=80, alpha=0.05, power=0.80,
                             alternative="two-sided")
phi1 = 2 * math.asin(math.sqrt(0.42)); phi2 = phi1 + h_mde
mde_pp = (math.sin(phi2/2)**2 - 0.42) * 100
print(f"MDE at n=80/group, p1=42%: ~{mde_pp:.1f} percentage points")
```

> Run both; paste output back. Expected: p≈0.3 (non-significant), wide CI, MDE ≈ 16pp — meaning n=80 can't detect drops smaller than that.

(For the rest of this example, assume the user pasted back: `z=-1.04 p=0.298 CI=[-0.2260, +0.0660] h=-0.165` and `MDE at n=80/group, p1=42%: ~15.7 percentage points`.)

> **Signal vs noise:** Not significant — and underpowered. Two-proportion z-test, p=0.30, 95% CI on the difference: −22.6% to +6.6%, Cohen's h=0.17 (small). At n≈80 per group, the minimum detectable effect at 80% power is ~16 percentage points; the observed 8-point drop is well below that threshold. Conclusion: the data **cannot tell** whether retention truly dropped, stayed flat, or improved slightly. The wide CI spans both meaningful drop and meaningful gain.

**Step 5 — Hypothesis generation:** Skipped. Generating ranked hypotheses on inconclusive data would invent a story. Name the gap instead.

**Step 6 — Prioritized action plan:**

1. **Do not revert based on this data.** The 8-point drop is within the noise band at this sample size — reverting would treat noise as signal.
2. **Collect more cohorts.** Continue running the new welcome screen for 2–3 more cohorts to reach ~250+ per group total. At that sample size, MDE drops to ~9 percentage points, which would let the test detect an effect of the size you're worried about.
3. **In parallel, run 5 qualitative sessions** on the new welcome screen with beta users. Five users will surface usability problems faster than the underpowered quantitative test will resolve ([hypothesis-tests.md](references/hypothesis-tests.md), Family 2).
4. **Stop condition:** Decide based on the larger sample (≥250 per group). If the drop persists at that scale and is statistically significant, then revert or iterate. If it disappears, the original 8-point gap was noise.

> Does this fit your situation, or should we narrow down?

## Common Pitfalls

These apply across all diagnostic work. Each is also covered in the reference files for specific cases.

- **Correlation as causation.** Two events happen near the same time (release + drop) → assume one caused the other. Always require a mechanism (specific change → specific user behavior → specific metric impact) before declaring cause. The redesign-shipped-then-metric-dropped pattern is the most common false positive in this skill.
- **Single-cause bias.** Assuming one explanation accounts for the entire change. Real metric movements are often multi-cause (e.g. seasonal + UI change + segment shift simultaneously). When the first hypothesis only explains part of the drop, keep looking.
- **Common-cause noise.** Treating normal variation as signal. Week-over-week metric movements within the confidence interval of the baseline are noise, not change — the size of that band depends on sample size and baseline rate. The Step 4 statistical test exists to filter this out; never skip it and never eyeball "looks like a drop" without running it.
- **Underpowered conclusions.** "p > 0.05" does not mean "no change". With small samples, real effects go undetected. Always check power; if inadequate, say so explicitly instead of claiming the change isn't real.
- **Definition drift.** A metric definition that changed silently (new event tracked, segment redefined, deduplication rule updated) creates fake drops or spikes. Always confirm same definition before/after — Step 2 exists for this.
- **Segment Simpson's paradox.** Headline metric moves one direction; every individual segment moves the opposite direction. Caused by segment mix shifting. If the headline disagrees with every segment cut, the cause is mix, not behavior.
- **Naming analytics tools unprompted.** Do not name specific tools (Mixpanel, Amplitude, PostHog, Heap, GA4, etc.) unless the user has already named one. Ask first: "What analytics tool are you pulling this data from?"

## Red Flags

When the user's situation triggers any of these, do not run a diagnosis. Refuse or redirect.

- **No baseline.** Diagnosing a "drop" without a comparable pre-period number is impossible. Ask for the baseline; if none exists, recommend setting one and waiting.
- **Sample too small.** Below ~100 users per group for proportions, or ~30 per group for continuous, statistical tests are noise generators. Recommend qualitative methods (5–8 interviews on the suspect flow) instead — see [measurement-philosophy.md](../metrics-basics/references/measurement-philosophy.md), Situation 2.
- **Definition changed.** Metric formula, tracked event, or segment definition changed between before and after. The "movement" is a measurement artifact, not user behavior. Stop; reconcile definitions first.
- **Decision already made.** User wants the diagnosis to support a conclusion already reached ("we know it's X, just confirm"). Refuse: this is reporting, not diagnosis. Offer to test the assumption honestly — see [measurement-philosophy.md](../metrics-basics/references/measurement-philosophy.md), Situation 3.
- **Multiple simultaneous changes with no isolation.** Two or more changes shipped in the same window, no segment was held out. Causal attribution is impossible without a control. Recommend a hold-back test or staged rollout for the next release.
- **Wrong skill.** If the user wants to plan what to measure → redirect to `metrics-ux`. If they want a pre-launch decision rule → `metrics-spec`. If designing the tracking plan → `metrics-instrumentation`. If stress-testing someone else's claim or self-reviewing a draft → `metrics-review`. If presenting the diagnosis to stakeholders → `metrics-present`.
- **Out-of-scope metric (revenue side).** MRR, LTV, ARR, free→paid conversion, and other monetization metrics are deferred to `metrics-product` (v2, not yet available). When the user asks about these: (1) state the boundary clearly, (2) offer the UX-side equivalent if one exists ("if churn is driving the drop, bring behavioral data for the churned segment and I can help diagnose the product experience"), (3) stop — do not provide diagnostic frameworks, decomposition buckets, or first-step instructions for the out-of-scope metric, even as orientation. Helpfulness does not override a hard scope boundary.
