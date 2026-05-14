# UX Happiness — metrics

HEART Happiness category — the user's subjective attitude toward the product. All four metrics here are survey-based: the user reports how they feel, not what they did. SUS and CES carry "usability" and "effort" in their names, but both are surveys — standard HEART (Rodden, CHI 2010) places survey-based perception in Happiness. For behavioral measures (completion rate, error rate, time on task), see [ux-task-success.md](ux-task-success.md). For category context, see [heart.md](../../metrics-basics/references/heart.md#the-five-categories).

---

## CSAT — Customer Satisfaction Score

**Definition.** Self-reported satisfaction with a specific interaction.

**When to use.** Right after key moments — purchase, support contact, onboarding completion, feature use. Captures short-term, contextual satisfaction. Use alongside NPS (which captures long-term loyalty).

**How to measure.**
- Formula: `CSAT = (top-two-box responses / total responses) × 100`. Standard scales: 1–5 or 1–7. Top-two = 4–5 on a 5-point scale, or 6–7 on a 7-point scale.
- Sample size: ~40 responses for ±15% margin at 95% confidence ([NN/g guidance for quantitative UX studies](https://www.nngroup.com/articles/summary-quant-sample-sizes/)); ~100+ for confident comparison across segments.
- Timing: ask immediately after the interaction. Delay reduces accuracy — recall quality deteriorates within hours of an experience ([survey methodology research, Sage Journals 2023](https://journals.sagepub.com/doi/10.1177/00811750221126499)).

**Example (illustrative).** 100 users complete checkout and answer the post-purchase survey on a 5-point scale. 78 rate it 4 or 5. CSAT = (78 / 100) × 100 = **78%** (hypothetical figures).

**Benchmark.** Industry guides commonly cite 75–85% top-two-box for digital products; ≥85% is considered excellent, <70% needs improvement. ACSI 2024 software/SaaS sector data shows ~78% as the average. For sector-level reference, the [American Customer Satisfaction Index (ACSI)](https://theacsi.org/our-industries/) publishes annual scores on a 0–100 scale (different metric — see note below). Compare to your own trend, not industry averages — survey design and segment mix change the number.

**Note — CSAT vs CSI/ACSI.** CSAT is a single-question measure of one interaction. CSI (Customer Satisfaction Index), of which ACSI is the standard, is a composite index built from multiple weighted questions across the whole relationship. Related but not interchangeable — use CSAT for moments, ACSI/CSI-style indexes for overall product or brand health.

**Pitfalls.**
- One-question surveys produce extreme answers — happy or angry users respond more than neutral ones. Always read CSAT alongside response rate.
- CSAT is interaction-specific. A high CSAT on checkout does not mean overall product satisfaction is high.
- Asking too often causes survey fatigue. Industry practice: space surveys at least 2 weeks apart, with a typical cap of 1–2 per user per month ([ACSI on survey fatigue](https://theacsi.org/news-and-resources/blog/2026/04/08/can-fewer-surveys-provide-better-customer-insights/)).

---

## NPS — Net Promoter Score

**Definition.** Likelihood a user would recommend the product to others.

**When to use.** Quarterly or post-milestone pulse on overall loyalty. Best for mature products with enough users to get stable samples. Not for after-task feedback (use CSAT instead).

**How to measure.**
- Formula: ask "How likely are you to recommend [product] to a friend or colleague?" on a 0–10 scale. `NPS = % promoters (9–10) − % detractors (0–6)`. Range: −100 to +100. Passives (7–8) are excluded from the score but tracked separately.
- Sample size:
  - General survey rule (±5% margin, 95% confidence): ~384 responses (Cochran's formula).
  - NPS-specific (±10-point margin on the NPS scale): ~250 responses ([MeasuringU](https://measuringu.com/nps-benchmark-test-sample-size/)).
  - Practical minimum: 100+ responses per segment per quarter is the industry floor for meaningful NPS analysis ([CustomerGauge](https://customergauge.com/blog/nps-survey-best-practices)); below this, margin of error becomes too wide.
  - B2B with small user bases may settle for less; B2C with segment cuts (region, plan, cohort) often needs 1,000+.
- Timing: relational NPS is typically quarterly or annual ([Bain Net Promoter System](https://www.netpromotersystem.com/about/)); monthly relationship surveys cause fatigue and lower response rates. For fast-moving products with frequent interactions, monthly is acceptable.

**Example (illustrative).** 500 users respond. 200 are promoters (40%), 100 are passives (20%), 200 are detractors (40%). NPS = 40 − 40 = **0** (hypothetical figures).

**Benchmark.** Varies widely by industry, segment, and year. Recent industry data (2024): B2B SaaS ~36 (229-company benchmark), B2C SaaS 47–54, ecommerce ~50, telecom 25–35 (world-class 50+). A score of +40 is excellent in telecom, healthy in financial services, and merely average in SaaS or ecommerce. Reference: [Bain NPS Prism](https://www.bain.com/consulting-services/customer-strategy-and-marketing/nps-prism/) and aggregated 2024–2025 data from Bain, Qualtrics, CustomerGauge. Compare to your own trend, not to other industries.

**Pitfalls.**
- Cultural bias: research suggests U.S. respondents are about twice as likely as Japanese respondents to pick top-box scores on identical scales, while Japanese respondents lean ~2.4× more on the midpoint ([MeasuringU — cultural effects on rating scales](https://measuringu.com/scales-cultural-effects/)). Compare NPS / CSAT within-region only; cross-region deltas mostly reflect response style, not experience quality.
- Single-number trap: NPS condenses three groups into one number. Always report promoter/passive/detractor breakdown alongside the score.
- Response bias is the bigger risk than response rate. [Bain](https://www.bain.com/insights/creating-a-reliable-metric-loyalty-insights/) shows promoters respond far more often than detractors — a 20% response rate with NPS +50 can mask a true NPS of −22 once non-responders are studied. Channel response rates: email 15–25%, SMS 40–50%, in-app 20–35%, website 8–15%. Focus on representativeness (segment coverage, response bias checks) rather than chasing a higher rate.

---

## SUS — System Usability Scale

**Definition.** A 10-question standardized survey producing a single 0–100 score for perceived usability.

**When to use.** Benchmarking usability over releases, comparing design alternatives, post-launch health checks. Not for quick in-product feedback — SUS requires a full session before answering.

**How to measure.**
- Formula: 10 standardized items alternating positive/negative phrasing, each on a 1–5 agreement scale. Scoring: for odd-numbered items, score = response − 1; for even-numbered items, score = 5 − response. Sum the 10 adjusted item scores, multiply by 2.5 → final score on a 0–100 scale.
- Sample size: SUS works on very small samples ([Sauro/MeasuringU](https://measuringu.com/sus/) — usable from as few as 2 users with wide confidence intervals); for design comparisons, [NN/g recommends 40 participants](https://www.nngroup.com/articles/summary-quant-sample-sizes/) (±15% margin, 95% confidence). 30 is workable if you accept 90% confidence instead.
- Timing: administer right after a task session, while the experience is fresh.

**Example (illustrative — scoring mechanics).** A user answers item 1 (positive: "I would use this often") with **5** → adjusted score 5 − 1 = **4**. Item 2 (negative: "I found this unnecessarily complex") with **2** → adjusted score 5 − 2 = **3**. Continuing across all 10 items, the adjusted scores sum to **32**. Final SUS = 32 × 2.5 = **80** ("excellent" range).

**Benchmark.** 68 = average across products. Above 68 = above average. Above 80 = excellent ([Sauro, MeasuringU](https://measuringu.com/sus/)).

**Pitfalls.**
- Do not modify the 10 items. Changing wording breaks the benchmark — the score becomes incomparable to published norms.
- SUS measures the whole product, not a specific feature. For feature-level usability perception, build a custom 1–3 item scale instead.
- A single SUS score is hard to act on alone. [NN/g notes SUS is not diagnostic](https://www.nngroup.com/articles/measuring-perceived-usability/) — pair with open-ended follow-up ("what made it hard?") or session recordings to get diagnostic signal.

---

## CES — Customer Effort Score

**Definition.** Perceived effort the user spent to complete a task or resolve an issue.

**When to use.** Any interaction where the user is trying to *get something done* — support, self-service, account recovery, checkout, sign-up, onboarding completion, post-purchase. Less useful for discovery or browsing flows where the goal is exploration, not resolution.

**How to measure.**
- Formula: ask "[Company] made it easy for me to handle my issue" on a 1–7 agreement scale ("strongly disagree" → "strongly agree"). Report `% top-two-box` (responses at 6–7) or mean score.
- Sample size: Gartner does not publish a specific minimum for CES. General survey rules apply — ~384 for ±5% margin at 95% confidence (Cochran's formula); smaller samples produce direction, not precision. Match sample size to flow volume and the comparison you need to make.
- Timing: immediately after task completion or abandonment. Asking later loses the effort memory.

**Example (illustrative).** 100 users complete the password recovery flow. 65 respond at 6 or 7 on the agreement scale. CES = (65 / 100) × 100 = **65%** top-two-box (hypothetical figures) — below the Gartner 70% threshold (see Benchmark), so the flow would be an improvement candidate.

**Benchmark.** Industry-cited Gartner CEB benchmarks: below 70% top-two-box = improvement area; above 90% = strong. The CES 2.0 (1–7 scale) currently used was introduced in [Dixon, Toman & DeLisi, *The Effortless Experience* (2013)](https://www.penguinrandomhouse.com/books/312730/the-effortless-experience-by-matthew-dixon/), based on CEB's research with 97,000+ customers across 100+ companies. The original CES concept and finding that 96% of high-effort customers become disloyal vs. 9% of low-effort came from [Dixon et al., HBR 2010 — "Stop Trying to Delight Your Customers"](https://hbr.org/2010/07/stop-trying-to-delight-your-customers). CES predicts churn more reliably than CSAT for service interactions.

**Pitfalls.**
- Use the standard wording. Variants like "how much effort did this take?" produce noisier results and break comparison to the Gartner CEB benchmarks. Stick to the agreement-scale phrasing in the formula above.
- CES is service-context-specific. Applying it to discovery or browsing flows produces meaningless data — those flows are *meant* to take effort.
- High effort is sometimes correct. Tax filing, medical forms, legal documents — users expect work. CES penalizes inherent task complexity, not just bad design.

---

## Choosing between them

| Situation | Use this | Why |
|---|---|---|
| After a single interaction (purchase, support ticket) | CSAT | Captures contextual satisfaction in the moment |
| Quarterly loyalty pulse for the whole product | NPS | Designed for long-term, cross-period comparison |
| Benchmarking overall product usability — across releases or between design alternatives | SUS | Standardized, comparable to published norms |
| Service or self-service flows where effort drives churn | CES | Predicts churn better than satisfaction in service contexts |
| New feature, no baseline yet | CSAT or custom 1–3 item survey | NPS and SUS need a larger user base to be stable |
