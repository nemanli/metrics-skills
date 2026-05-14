# Decision rules — how to pick thresholds

The decision rule is the part most teams skip and the part the spec exists for. Without it, every result is renegotiated after the fact — the same failure mode pre-registration was designed to prevent in medical research ([Goldacre et al., COMPare project, *Trials* 2019](https://trialsjournal.biomedcentral.com/articles/10.1186/s13063-019-3173-2)) and in online experimentation ([Kohavi, Tang, Xu — *Trustworthy Online Controlled Experiments*, Ch. 17, 2020](https://experimentguide.com/)).

## Why three rows, not two

Most teams default to Ship-or-Kill. That forces a binary decision on data that is rarely conclusive — the most common real outcome ("metric moved in the right direction but did not clear the bar, OR result was underpowered") gets shoehorned into one of the existing rows, and the team starts renegotiating thresholds.

The Iterate row catches the inconclusive case explicitly:

| Outcome | What it means |
|---|---|
| **Ship** | The change cleared a threshold high enough to justify permanent rollout. |
| **Kill** | The change moved the wrong way enough to justify reverting, OR a guardrail breached. |
| **Iterate** | The change moved in the right direction but did not clear the Ship bar, OR the test was underpowered. The hypothesis is neither confirmed nor refuted. |

Industry experience reports confirm the same pattern. Microsoft's experimentation team reports that only about a third of online experiments produce a clear positive outcome on the first run; the rest are flat, mixed, or negative ([Kohavi & Thomke — *The Surprising Power of Online Experiments*, HBR 2017](https://hbr.org/2017/09/the-surprising-power-of-online-experiments)). Spotify reports that its team treats "trustworthy learning" as the win condition, not "positive outcome" ([Spotify Engineering — *Beyond Winning*, 2025](https://engineering.atspotify.com/2025/9/spotifys-experiments-with-learning-framework)). Both findings argue for a structured Iterate row.

---

## How to pick the Ship threshold

The Ship threshold is the smallest lift that justifies **permanent rollout**, not the smallest lift you would be happy to see. Three inputs:

1. **Practical significance.** What is the smallest movement that matters in product terms? "1 pp on a 50% baseline at this volume = ~X more weekly successes" — does that justify the permanent code path? If not, raise the bar. The distinction between statistical and practical significance is canonical in clinical trials ([Cohen, 1988 — *Statistical Power Analysis for the Behavioral Sciences*](https://doi.org/10.4324/9780203771587)).
2. **Detectability.** What is the MDE at the available sample size? If practical significance is below MDE, the threshold is undetectable — trade off (lower threshold, extend window, lower power, or switch to qualitative). See [stat-snippets §4](../../metrics-diagnose/references/stat-snippets.md).
3. **Asymmetric cost.** When the cost of a wrong "ship" exceeds the cost of a wrong "kill" (payments, security, accessibility), bias the threshold up. The reverse case (small startups cannot afford to leave lift on the table) biases it down. Default is symmetric.

### Concrete patterns

| Situation | Ship threshold pattern |
|---|---|
| Replacing a working flow with a similar one | "≥ practical-significance lift AND counter not worse" — high bar |
| Adding an entirely new feature | "≥ adoption AND ≥ activation threshold" — two-stage; trial alone is not enough |
| Polish or copy change | "≥ MDE at current sample size AND counter held" — lower bar |
| Reversible feature (flag-controlled) | "≥ directional lift AND no guardrail breached" — bias low |
| Irreversible change (data migration, removed flow) | "≥ practical-significance lift × 2 AND multiple counters held" — bias high |

---

## How to pick the Kill threshold

The Kill threshold is **not** the mirror of Ship. It is the smallest regression the team would not tolerate, which is usually much smaller than the Ship lift — accepted regressions compound over time, while accepted lifts plateau.

| Type | Kill threshold |
|---|---|
| Primary regression | "Primary drops by more than [smallest unacceptable]" — usually less than Ship in absolute terms |
| Counter-metric breach | "Counter rises by more than [threshold]" — even if primary is up |
| Guardrail breach | "Any guardrail crosses its threshold" — automatic, regardless of primary |
| Compound | "(Primary regression by X) OR (Counter breach by Y) OR (any guardrail breach)" — typical real spec |

The compound form is the default. Single-condition Kill rules miss the most common failure mode: primary held flat or rose slightly, but a counter or guardrail moved badly. Microsoft documents this asymmetry in its guardrail-metric guidance ([Microsoft ExP — guardrail metrics](https://www.microsoft.com/en-us/research/group/experimentation-platform-exp/)).

---

## How to pick the Iterate band

The Iterate band is the gap between Ship and Kill — directional but inconclusive. Two sub-cases:

1. **Direction right, magnitude small.** Primary moved up but not enough to clear Ship. Action: run for another cycle (extend the window, recruit more users, or split into a sub-segment that might show stronger signal).
2. **Underpowered.** The window closed before enough data accrued to detect the threshold. Action: extend the window OR drop to a lower threshold the data *can* detect.

Iterate without an action is just deferral. Name the next step:

```
Iterate if:
  Primary moved 0 → +Ship_threshold (directional, did not clear)
    → run 2 more weeks at current allocation, then re-evaluate
  OR
  Result is underpowered at end of window (CI wider than threshold)
    → extend window by [duration] OR re-spec at lower threshold
```

---

## Asymmetric risk — when symmetric thresholds are wrong

Default is symmetric: Ship at +X, Kill at −X. Asymmetric thresholds apply when the cost of one error type dominates.

### Bias up (raise Ship, lower Kill) — when:

- The change touches payments, billing, account access, or anything where a regression hurts existing successful users.
- The change is irreversible (data migration, deprecated endpoint, removed flow).
- The user base is large and a small regression compounds (a 1 pp regression on 10M users = 100,000 users affected).
- Trust is the dominant risk — regressions on trust-laden flows (security, privacy, accessibility) erode credibility faster than they recover, a well-documented asymmetry in the trust literature ([Slovic — *Perceived Risk, Trust, and Democracy*, Risk Analysis 1993](https://onlinelibrary.wiley.com/doi/10.1111/j.1539-6924.1993.tb01329.x)).

### Bias down (lower Ship, raise Kill) — when:

- The change is in an early-stage product where leaving lift on the table outweighs the risk of shipping a flawed version.
- The change is flag-controlled and reversible at zero cost.
- The current baseline is so low that any positive movement is meaningful (e.g. activation at 8%).
- Maintenance cost of the new path is negligible.

### Document the asymmetry

When the spec uses asymmetric thresholds, state why in one sentence under the decision rule — otherwise the team reads the asymmetry as a typo:

> *"Kill threshold is intentionally tighter than Ship: this change touches account-creation, and a regression on existing-user account access compounds faster than the lift compounds value."*

---

## Statistical significance vs practical significance

Different concepts, often conflated. The spec must distinguish them ([Cohen, 1988](https://doi.org/10.4324/9780203771587); [Wasserstein & Lazar — ASA Statement on p-values, 2016](https://amstat.tandfonline.com/doi/full/10.1080/00031305.2016.1154108)).

| | Statistical significance | Practical significance |
|---|---|---|
| **Question** | Is this change unlikely to be noise? | Is this change large enough to matter? |
| **Source** | p-value, confidence interval | Domain judgment, cost-benefit |
| **Failure mode** | p < 0.05 but tiny effect — real, operationally meaningless | Large effect, p > 0.05 — meaningful but might be noise |

A complete spec requires **both**: the Ship threshold is the practical bar, and the test must be powered to detect that bar at p < 0.05. If statistical significance is met but practical is not, that is an Iterate. If practical is met but statistical is not, that is also an Iterate — extend the window.

---

## Pre-registration and the integrity rule

Once the spec is signed, the rule applies as written. Three integrity rules:

1. **No threshold changes after data arrives.** Any change becomes a new spec for the next decision, not a modification of this one.
2. **No new primary metrics added post-hoc.** "Primary did not move but look at this other metric" is moving the goalposts. The other metric is, at best, evidence for the next hypothesis.
3. **No conditional re-specs.** "Ship if primary OR (secondary AND tertiary)" with branches added after the data guarantees a Ship verdict. The rule must be single and fixed.

If the team wants to re-spec after an inconclusive result, that is fine — write a new spec for the v2 hypothesis. Do not edit the original. This rule is the operational form of HARKing avoidance ([Kerr — *HARKing: Hypothesizing After the Results are Known*, 1998](https://journals.sagepub.com/doi/10.1207/s15327957pspr0203_4)).

---

## Common failure modes

- **"Hit a clearly defined target."** The target is "any improvement". No rule.
- **No Kill row.** Spec is "ship if X; otherwise iterate". Kill becomes impossible by construction.
- **Symmetric Kill = mirror of Ship.** Default but usually wrong; regressions compound, lifts plateau.
- **No Iterate action.** "Iterate" without naming the next cycle is "decide later" — same problem as no rule.
- **Underpowered Ship threshold.** Threshold is below MDE at available n. Compute MDE first.
- **Counter-metric without threshold.** "Must not regress" — by how much? Without a threshold, the team argues about whether the observed move counts.

---

## If the spec is tested with an A/B experiment

Designers do not usually design experiments themselves — that is PM, growth, or engineering work — but when a spec is validated through an A/B test, three rules from the experimentation literature affect the decision rule:

- **No peeking.** Checking the dashboard daily and stopping at the first p<0.05 inflates the false-positive rate to roughly 3–4× nominal ([Johari et al. — *Peeking at A/B Tests*, KDD 2017](https://dl.acm.org/doi/10.1145/3097983.3097992); [Evan Miller — How Not To Run an A/B Test](https://www.evanmiller.org/how-not-to-run-an-ab-test.html)). Pre-commit a fixed-horizon end date and a locked dashboard until that date — or use a published sequential method.
- **Keep a holdback after rollout.** A long-term untouched control (5–10% of traffic, held back for 4–12 weeks after rollout to 100%) catches novelty fade and confirms the lift compounds rather than decays ([Kohavi, Tang, Xu — *Trustworthy Online Controlled Experiments*, 2020, Ch. 23](https://experimentguide.com/)).
- **Detectable threshold.** The Ship threshold in block 6 must be detectable at the planned sample size — see [stat-snippets §4](../../metrics-diagnose/references/stat-snippets.md). If practical significance < MDE, the spec is undetectable as written.

The deeper experiment-design questions (randomization unit, allocation, exposure rule, novelty/network bias) belong to the team running the test. As a designer, ask: was a control held? Was the window pre-registered? Has a counter-metric been monitored? — same questions `metrics-review` asks for any incoming claim.

---

## See also

- [hypothesis-patterns.md](hypothesis-patterns.md) — the load-bearing sentence the decision rule depends on.
- [`../../metrics-diagnose/references/stat-snippets.md`](../../metrics-diagnose/references/stat-snippets.md) §4 — MDE / power check.
- [`../../metrics-basics/references/measurement-philosophy.md`](../../metrics-basics/references/measurement-philosophy.md), Misconception 3 — why counter and guardrails exist.
- [Kohavi, Tang, Xu — *Trustworthy Online Controlled Experiments* (2020)](https://experimentguide.com/), Ch. 17 — launching decisions.
