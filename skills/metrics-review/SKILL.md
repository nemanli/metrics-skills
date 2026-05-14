---
name: metrics-review
description: Stress-tests a metric claim against five common failure modes — definition, sample & power, comparison, window, counter-metric — so the user can trust, distrust, or follow up on the number. Works on incoming claims (vendor case studies, PM dashboards, "industry benchmarks", leadership quotes) AND on the user's own draft before they publish. Triggers on "is this claim true?", "review this metric", "vet this benchmark", "is +15% real?", "check this case study". Skip for diagnosing a metric movement on data you own (use metrics-diagnose) or for picking metrics (use metrics-ux).
allowed-tools: Read
---

## Overview

Stress-tests a metric claim. Two modes — incoming (someone gave you a number) and self-review (you're about to publish a number) — driven by the same five-axis checklist. Three jobs: (1) **parse** the claim into its load-bearing parts (number, metric, comparison, window, sample), (2) **review** along five axes — definition, sample & power, comparison, window selection, counter-metric — using a published anti-rationalization table, (3) deliver a **verdict** (Trust / Trust with caveats / Don't trust / Need more info) plus the counter-questions the user can take back to the claim's author.

This skill is adversarial by design. It assumes claims are wrong by default — not because most people are dishonest, but because the failure modes are common, ubiquitous, and hard to spot in your own work. Doubt-first review is cheap; eating a bad number is expensive.

This skill is not `metrics-diagnose`. `metrics-diagnose` operates on **your own raw data** to interpret a movement. `metrics-review` operates on **someone's claim about a number** to decide whether to believe it. The two skills share statistical intuition but answer different questions.

## When to Use

Use this skill when a designer, PM, or design lead asks any of the following — phrased differently by seniority but matching the same job-to-be-done:

| Designer level | Typical phrasing that should trigger this skill |
|---|---|
| **Junior** | "PM says conversion is up 15%, is that real?" / "This vendor case study claims +40% conversion, can I trust it?" |
| **Middle** | "We're citing 'industry NPS = 32' in the deck — where does that number come from?" / "Our analyst showed me this dashboard, I want a second opinion before I forward it" |
| **Senior** | "I'm about to publish a +20 pp lift to the board. What's wrong with my claim?" / "CPO is pushing a number from a vendor — what should I ask them?" |
| **Lead** | "Set the team's review checklist for metric claims" / "Every PR with a metric claim should go through a stress-test — what's the template?" |

Cross-cutting triggers (any seniority):

- The user is shown a number by someone else and wants to vet it (incoming).
- The user has results and wants a hostile review before publishing (self-review).
- The user is asked to defend a number and wants to know the failure modes in advance.
- The user is reviewing a vendor case study, "industry benchmark", or competitor claim.
- The user mentions phrases like "this seems too good", "is this cherry-picked?", "what would skeptics ask?".

Skip this skill when:

- The user owns the raw data and wants to interpret a movement → use `metrics-diagnose` (signal vs noise, hypothesis generation).
- The user is choosing what to measure → use `metrics-ux`.
- The user is writing a measurement plan before the data exists → use `metrics-spec`.
- The user is communicating an already-validated result → use `metrics-present`.
- The user is asking what a term like "MDE" or "Goodhart" means → use `metrics-basics`.

## Process

### Step 1 — Detect mode

| Mode | Signal | Action |
|---|---|---|
| **Incoming** | User is reviewing someone else's claim (vendor case, dashboard, exec quote, benchmark, competitor metric, internal cross-team report) | Run Steps 2–5 with the "challenge" lens. Output the verdict + counter-questions. |
| **Self-review** | User has their own draft and wants a hostile second pass before publishing | Run Steps 2–5 with the "what would skeptics ask?" lens. Output the failure points + fixes before the draft ships. |
| **Direct** | Asks the review checklist directly ("give me the 5-axis checklist", "what's the anti-rationalization table?") | Skip parsing. Open [review-checklist.md](references/review-checklist.md) or [anti-rationalization.md](references/anti-rationalization.md). |

Both modes use the same five axes. The difference is who the counter-questions go to:

- **Incoming:** counter-questions go back to the claim's author.
- **Self-review:** counter-questions are what the user must answer in their own draft before publishing.

### Step 2 — Parse the claim

Identify the load-bearing parts. Open [claim-archetypes.md](references/claim-archetypes.md) to see how the parse differs across archetypes (vendor case, dashboard screenshot, "industry benchmark", leadership quote).

Six required parts:

1. **Number** — the headline figure ("+15%", "62%", "$300M", "3.8/5").
2. **Metric** — what is being measured (conversion, NPS, task time, revenue, retention).
3. **Comparison** — vs what? (before/after, treatment vs control, vs benchmark, vs goal).
4. **Window** — over what time period.
5. **Sample** — n, segment, exclusions.
6. **Counter-metric** — what guardrail was watched (if any).

If any part is missing, that **is** part of the review — flag it explicitly. A claim missing a sample size is not a partial claim; it's an incomplete claim.

### Step 3 — Run the five-axis review

Open [review-checklist.md](references/review-checklist.md) for the full checklist. Summary table:

| Axis | Question | Common failure |
|---|---|---|
| **Definition** | How is the metric computed? What event chain, what segment, what dedup rule? | "Conversion" used to mean three different things in the same deck. Composite metrics that hide trade-offs. Surrogate metrics that aren't what the headline implies. |
| **Sample & power** | What's the n? What's the confidence interval? Was the test powered? | "3 of 5 = 60%" with no CI. Statistically significant on huge n but practically tiny effect. Underpowered test reported as "no effect". |
| **Comparison** | What's the control? Cohort vs calendar? Baseline established before the change? | Pre/post snapshot with no control. Comparing to a non-comparable population. Comparison to a benchmark that doesn't apply. |
| **Window selection** | Why this time window? Pre-registered or chosen after seeing data? Seasonality? | Cherry-picked window where the metric looked best. Comparing peak-season post to off-season pre. Window ending exactly when the metric dipped. |
| **Counter-metric** | What was the guardrail? Did it move? Was it watched? | No counter mentioned (Goodhart risk). Counter moved wrong way but was omitted. Counter was vanity (engagement up too — not a real guardrail). |

For each axis: name what you can see, what's missing, and what's a red flag.

### Step 4 — Apply the anti-rationalization table

Open [anti-rationalization.md](references/anti-rationalization.md). This is the load-bearing reference — it lists the common excuses that get given when one of the five axes fails, and the counter-response for each.

Examples (excerpted):

| Excuse | Counter |
|---|---|
| "But the trend is up." | One direction over one period isn't a trend. Show me the same metric over 3 consecutive comparable windows. |
| "Users love it — look at NPS." | NPS without sample size, response rate, and segment is not interpretable. What's n? Who responded? Were detractors silent? |
| "The data speaks for itself." | Data doesn't speak. Someone chose what to count, when to count it, who to count, and how to define "it". Walk me through those choices. |
| "It's industry-standard." | Which industry, which study, which year, which methodology? Cite the source. |
| "We saw the lift in the pilot." | Pilots self-select for engaged users and ship-eager teams. Show me the lift in a stratified rollout, not the pilot cohort. |
| "Statistically significant." | At what threshold, with what test, on what sample? p<0.05 on n=10,000 catches effect sizes too small to act on. |

[anti-rationalization.md](references/anti-rationalization.md) has the full table organized by axis.

### Step 5 — Deliver the verdict

Five verdict categories. **Distinguish acknowledged from hidden failures** — a claim that names its own limits is far more trustworthy than one that hides them, even when both technically fail the same axes.

| Verdict | When | What to say |
|---|---|---|
| **Trust** | All five axes pass. Definition crisp, sample adequate, comparison clean, window pre-registered or principled, counter-metric watched and held. | "Looks solid. The only follow-up I'd ask is [smallest remaining gap]." |
| **Trust with caveats** | 1–2 axes have known limitations that are **acknowledged in the claim** (e.g. "underpowered, directional only", "pre/post, no control"). | "Believable, with these caveats: [list]. Before acting on it, confirm: [counter-question]." |
| **Don't trust until acknowledged** | 1 axis fails and the claim **hides or asserts past the failure** (no caveats). The fix is one round of counter-questions, not rejection. | "I would not act on this yet. The load-bearing issue is [axis]: [specific failure]. Ask the author: [counter-questions]. Re-review when answered." |
| **Don't trust** | 2+ axes fail and **none are acknowledged**, OR a single axis fails badly enough to invalidate the claim (e.g. no control + heavy confounds, or definition that has shifted mid-window). | "I wouldn't act on this in its current form. Multiple load-bearing issues: [list]. The claim needs rework, not clarification." |
| **Need more info** | The claim is too underspecified to review. Sample missing, definition unstated, window unclear. | "Can't tell from what I have. To make this reviewable, I need: [list of missing parts from Step 2]." |

Most vendor case studies and "industry benchmarks" land in **Don't trust until acknowledged** — they typically fail 3–4 axes, but the right move is to ask the source to address the gaps, not reject outright. Outright **Don't trust** is reserved for cases where the rework needed is so large that further dialogue is wasted effort.

Always end with **counter-questions** — the things the user takes back to the claim's author (incoming) or addresses in their own draft (self-review).

### Step 6 — Verify

End every review with: **"Does this fit the situation, or should we narrow down?"**

If self-review reveals that the draft has a load-bearing flaw, do not soften the verdict to spare the user. The whole point is to catch the failure before publication, when it's cheap to fix.

## Example

### Example 1 — incoming vendor case study

**User prompt (incoming mode):** *"A vendor pitched us their checkout product. They cite a case study: 'CompanyX saw +40% conversion after implementing our solution.' CFO is interested. Should we trust it?"*

**Mode detection:** Incoming — vendor case study, third-party claim.

**Step 2 — Parse:**

| Part | Present? |
|---|---|
| Number | +40% (vague — relative? absolute?) |
| Metric | "Conversion" (which conversion? add-to-cart → purchase? landing → signup?) |
| Comparison | After "implementing", implies pre/post — no mention of control |
| Window | Missing |
| Sample | Missing |
| Counter-metric | Missing |

5 of 6 parts missing or ambiguous. This is barely a claim — it's a marketing slogan.

**Step 3 — Five-axis review:**

| Axis | Finding |
|---|---|
| **Definition** | "Conversion" undefined. Could be any step in any funnel. Vendor's incentive is to pick the largest-moving metric. |
| **Sample & power** | n unknown, CI unknown, significance unknown. |
| **Comparison** | Pre/post implied; no control group named. Other changes in the window (seasonality, marketing, traffic mix) are not isolated. |
| **Window selection** | Window unknown. Vendor likely picked a window that maximizes the lift. |
| **Counter-metric** | Refunds, customer-acquisition cost, payment-failure rate, time-to-purchase — none mentioned. |

**Step 4 — Anti-rationalization:**

The case study deploys at least three common patterns: vague metric ("conversion"), no control (pre/post implied), no counter. Each maps to a counter-question in [anti-rationalization.md](references/anti-rationalization.md).

**Step 5 — Verdict: Don't trust until acknowledged.**

> The claim has 5 of 6 load-bearing parts missing or ambiguous. The +40% number is unreviewable as stated. This is the typical shape of a vendor case study — the fix is one round of counter-questions, not outright rejection. Do not treat as a benchmark yet.
>
> **Before re-engaging with the vendor, ask:**
> 1. **Definition.** Which specific conversion (e.g. "checkout-start → order-completed")? What was the event chain?
> 2. **Comparison.** Was this a controlled A/B test or a pre/post snapshot? If pre/post, what else changed in that window?
> 3. **Sample and window.** What's the n, what's the time window, and was the window pre-registered or chosen after seeing the data?
> 4. **Counter-metrics.** Did any guardrail change — task success on the affected flow, support-ticket volume, or downstream user-behavior metrics?
> 5. **Reproducibility.** Has this lift held in any other customer's deployment, or is CompanyX the only data point?
>
> If the vendor answers 1–3 with concrete numbers, re-review. If they cannot or will not, the case study is marketing copy, not evidence — escalate to outright **Don't trust**.

**Step 6 — Verify:** "Does this fit the situation, or should we narrow down?"

### Example 2 — self-review before publishing

**User prompt (self-review mode):** *"I'm presenting tomorrow to the design leadership team. Headline: 'New onboarding redesigned cut time-to-first-action by 47% and lifted Day 7 retention by 8 pp.' I want a hostile review before I publish."*

**Mode detection:** Self-review.

**Step 2 — Parse:**

| Part | Present? |
|---|---|
| Number | 47% (time-to-first-action) and +8 pp (Day 7 retention) — two headlines |
| Metric | Time-to-first-action and Day 7 retention — both specific |
| Comparison | Implied pre/post (old onboarding vs new) — not stated |
| Window | Missing — when did the new onboarding ship? when did the measurement window run? |
| Sample | Missing — how many users in each cohort? |
| Counter-metric | None named |

Two metrics in headline, both with crisp definitions but unstated sample, window, and counter.

**Step 3 — Five-axis review:**

| Axis | Finding |
|---|---|
| **Definition** | Both metrics defined ✓. But: time-to-first-action could be per-user mean or median (means are sensitive to long-tail outliers — a redesign that helps median users can be misrepresented as helping everyone). Define which. |
| **Sample & power** | Unstated. If both cohorts are >1,000, a 47% time reduction is detectable at p<0.01 even with high variance. If cohorts are <100, the 8 pp retention lift has CI ≈ ±10 pp — meaningless. **Risk axis.** |
| **Comparison** | Pre/post cohort comparison. Three contamination risks: (1) seasonality (new vs old run in different months); (2) traffic mix shift (marketing changed in the window); (3) novelty effect on the new flow. None acknowledged. **Risk axis.** |
| **Window selection** | Unstated. If the new-onboarding measurement window starts at launch, novelty inflates the early metrics. Best practice: skip week 1 from the analysis. Was this done? |
| **Counter-metric** | None. Time-to-first-action and retention both went up — what about: (a) task quality (faster users may have skipped steps); (b) Day 30 retention (Day 7 lift can fade); (c) support tickets (faster onboarding can produce more confused users later); (d) ratio of "started but didn't complete onboarding" (faster completion can hide higher initial bounce). **Critical gap.** |

**Step 4 — Anti-rationalization (anticipated):**

| Anticipated pushback | The skeptic the user will face |
|---|---|
| "Time-to-first-action is down — that's great." | "Down for the users who got to first action. What share of users got there at all? Did first-action rate change?" |
| "Day 7 retention is up 8 pp." | "Day 7 of which cohort vs which? With what sample size? What's the CI?" |
| "We saw lift in the rollout." | "Was this a controlled test or a sequential pre/post? If pre/post, what else changed in those windows?" |

**Step 5 — Verdict: Trust with major caveats — do not publish as-drafted.**

> Both metrics have clean definitions but the draft is missing three load-bearing pieces: sample size, time window, and counter-metric. Publishing as-is invites the questions you cannot answer.
>
> **Before publishing, add:**
>
> 1. **Sample size and time window** for each cohort. "Old onboarding cohort (n=X, weeks W1–W4) vs new onboarding cohort (n=Y, weeks W5–W8)."
> 2. **At least one counter-metric.** Pick one that catches the most plausible failure mode here: **first-action rate** (the share of users reaching first action at all). A 47% time-to-first-action reduction means little if first-action *rate* fell — speedier-for-fewer is not improvement.
> 3. **Day 30 retention if available.** Day 7 lift can be novelty; Day 30 confirms persistence.
> 4. **Caveats on pre/post comparison.** Acknowledge that this is pre/post, not a controlled test, and name the other changes in the window (marketing, seasonality, etc.) that you've ruled out or accept as confounds.
> 5. **Skip-week-1 analysis,** if applicable. State whether the new-onboarding window excludes the first week to remove novelty.
>
> Without these, the headline is defensible but the questions in the room will be unflattering. With them, the claim is publishable.
>
> **Anticipated counter-questions** (script your answers):
> - "What's the sample size?"
> - "How do we know it's the onboarding and not [other change shipped in the same window]?"
> - "Did first-action *rate* change, or only the time among those who reached first action?"
> - "Does Day 30 retention hold the lift?"

**Step 6 — Verify:** "Does this fit, or should we narrow down on any axis?"

## Common Pitfalls

These apply across every review. Each is also covered in the references.

- **Accepting "the trend is up" as evidence.** One direction over one window isn't a trend. Trends require multiple consecutive comparable windows. See [anti-rationalization.md](references/anti-rationalization.md).
- **Trusting "industry-standard" without a source.** Most "industry-standard" benchmarks come from blog posts citing other blog posts. Demand a primary source (vendor study, academic paper, published benchmark report).
- **Conflating statistical and practical significance.** "p<0.05" on a 10M-user test catches effect sizes too small to act on. Always ask for the effect size and its CI alongside the p-value.
- **Pre/post comparison treated as causal.** Without a control, pre/post catches everything that changed in the window: seasonality, marketing, mix, the change you care about. Name what else changed; if nothing was isolated, the claim is correlational, not causal.
- **Missing counter-metric treated as benign.** "No counter mentioned" doesn't mean "counter held". It means we don't know. Goodhart's Law: any single metric becomes a target. Always ask for the counter.
- **Pilot results extrapolated to general rollout.** Pilots self-select for engaged users and ship-eager teams. Lifts in pilots routinely don't replicate in general rollouts. Demand stratified-rollout data before extrapolating.
- **Citing a vendor case study as evidence for our decision.** Vendors choose which customer to highlight (the one that succeeded). The base rate is hidden — for every CompanyX case study, there's a CompanyY where the change did nothing. Ask the vendor what share of customers see comparable lifts.
- **Softening self-review to spare the user.** The skill exists to catch failures before publication. A polite verdict that lets a flawed draft ship has done damage, not service.
- **Naming analytics tools or vendor products unprompted.** Do not name specific tools or vendors unless the user has already named one. Ask first.

## Red Flags

When the user's situation triggers any of these, name the issue explicitly and stop.

- **No source for the claim.** Cannot identify who said it, when, on what data. Refuse to review — there's nothing to vet. Tell the user: "Find the source; I can review when there's something concrete."
- **Decision already locked.** User is reviewing for cover ("I just need you to sign off so I can publish"). Refuse: review is for catching problems before publication, not for legitimizing decisions. Same mechanism as [`metrics-basics/references/measurement-philosophy.md`](../metrics-basics/references/measurement-philosophy.md), Situation 3.
- **Asked to find flaws in someone for political reasons.** Adversarial review is a tool for testing claims, not for attacking authors. If the framing is "find a way to discredit X", refuse — the skill is for honest stress-testing, not advocacy. Offer instead to review the claim on its merits.
- **Asked to confirm a number is right.** "Help me prove this is true" is the wrong stance for review. Review is doubt-first; the user can decide to trust after the doubt is satisfied. Reframe: "I'll stress-test it; if it holds, you'll know it's defensible."
- **Out-of-scope (revenue, MRR, monetization claims).** Revenue and monetization claims are owned by `metrics-product` v2. Same boundary as other skills. For UX-side claims about revenue (e.g. "the redesign produced $X" with $X derived from a behavioral metric), review the behavioral metric here, but flag that the revenue translation is out of scope.
- **Wrong skill.** If diagnosing a movement on owned data → `metrics-diagnose`. If picking metrics → `metrics-ux`. If writing a spec → `metrics-spec`. If communicating a validated result → `metrics-present`. If asking what a term means → `metrics-basics`.
