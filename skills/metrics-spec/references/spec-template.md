# Measurement spec — template

A one-page plan the team signs off **before** the change ships. The shape borrows from clinical-trial pre-registration ([COMPare project — Goldacre et al., *Trials* 2019](https://trialsjournal.biomedcentral.com/articles/10.1186/s13063-019-3173-2)) and from industry experimentation handbooks ([Kohavi, Tang, Xu — *Trustworthy Online Controlled Experiments*, 2020](https://experimentguide.com/)). After sign-off, the rule applies as written — moving thresholds post-hoc invalidates the spec, the same failure mode pre-registration is designed to prevent.

Copy the block below into the project doc and fill it in. Eight blocks, in order. Keep the whole thing under one page; if you cannot, the hypothesis is not sharp enough yet.

---

## Template

```
Measurement spec — [feature or change name]

Date signed:     [YYYY-MM-DD]
Owner:           [name, role]
Sign-off:        [name(s), role(s)]    — at least one other than the owner

────────────────────────────────────────────────────────────────────────

1) Hypothesis
   If we [change], then [user behavior] will [direction] by [magnitude],
   because [mechanism]. We will know within [window].

2) Primary metric
   Name:        [metric name]
   Definition:  [exact formula / event chain]
   Baseline:    [current value, sample size, time window]
   Target:      [threshold derived from hypothesis magnitude]
   Segment:     [scope — all users, mobile only, new users, etc.]

3) Counter-metric
   Name:        [metric the team would be embarrassed to ship if it moved wrong]
   Definition:  [exact formula]
   Threshold:   [must not regress beyond X]

4) Guardrails (operational / business)
   - [latency / error rate / support tickets / cost — name and threshold]

5) Input metrics (diagnostic, not deciding)
   - [supporting metric 1, 2, 3]

6) Decision rule
   Ship if:     Primary ≥ [target] AND counter ≤ [threshold] AND guardrails held
   Kill if:     Primary ≤ [revert threshold] OR counter > [breach threshold] OR
                any guardrail breached
   Iterate if:  Primary moved in the right direction but did not clear the bar,
                OR result is underpowered at the end of the window.

7) Sample size and duration
   Required n per group:  [from MDE / power check]
   Allocation:            [50/50, 90/10, staged]
   Calendar window:       [start → end]
   Power assumption:      [80% at alpha 0.05]
   Detectability check:   [weekly_eligible × allocation × duration ≥ required n?]

8) Instrumentation status
   Already tracked:       [events / properties currently in the analytics tool]
   To be added:           [events that must ship before launch]
   Owner of instrumentation: [eng name]
   Spec invalid if instrumentation is incomplete at launch.

────────────────────────────────────────────────────────────────────────

Notes
- The decision rule applies as written. Changing the threshold after the
  data arrives invalidates the spec.
- Qualitative pair: [planned interviews / session recordings tied to this
  measurement].
- Next-decision metric: [if Iterate fires, what is the v2 hypothesis?]
```

---

## How to fill each block

### 1. Hypothesis

Use the canonical shape. Five required parts — if any is missing, the spec is not falsifiable in [Popper's sense](https://plato.stanford.edu/entries/popper/) (a hypothesis is scientific only when it forbids some outcome).

> If we **[change]**, then **[user behavior]** will **[direction]** by **[magnitude]**, because **[mechanism]**. We will know within **[window]**.

See [hypothesis-patterns.md](hypothesis-patterns.md) for strong-vs-weak examples by HEART category.

### 2. Primary metric

Must match the user behavior named in the hypothesis. The formula must be exact: "onboarding completion rate" is ambiguous; "share of new signups who reached `onboarding_completed` within 24 hours of `signup_started`" is not. Definition drift between teams is a documented source of failed experiments ([Kohavi et al., 2020 — Ch. 3 on metric design](https://experimentguide.com/)).

### 3. Counter-metric

The hardest block. The counter is the metric you would be embarrassed to show if it moved the wrong way. Without it, the primary becomes a Goodhart target ([Strathern, 1997 — *European Review*](https://academic.oup.com/erev/article-abstract/5/3/305/6776275)). Pairings:

| Primary (UX-side) | Plausible counter |
|---|---|
| Activation rate | Day 7 retention (cheap activation that does not stick) |
| Task success rate on a redesigned flow | Average task time, or per-step error rate (faster success that hides regression on quality) |
| Engagement (sessions/user) | Task success rate (engagement-without-progress = users stuck) |
| Sign-up completion rate | 14-day retention (vanity sign-ups never return) |
| Time-on-site | Drop-off at goal step (longer time can mean confusion) |
| AI feature adoption | Core-flow task success (cannibalising a working path) |

The counter does not have to be UX-side. Designers commonly pair a UX primary with a business or operational counter that monitors downstream harm — for example, task success on checkout paired with support-ticket volume or refund rate, both of which are owned by other teams but visible to the designer. The rule is about the **primary**: designer-led specs commit to a UX-side primary; business counters are watched, not owned.

The guardrail / OEC framework comes from [Kohavi et al. — *Online Controlled Experiments at Large Scale*, KDD 2013](https://exp-platform.com/large-scale/) and [Dmitriev et al. — *Pitfalls of Long-Term Online Controlled Experiments*, IEEE Big Data 2016](https://exp-platform.com/pitfalls-of-long-term/).

### 4. Guardrails

Production-side metrics that must not regress. Distinct from the counter-metric (a user-behavior trade-off), guardrails are operational: p95/p99 latency, error rate, support-ticket volume, cost-per-invocation, accessibility regressions. Industry experimentation platforms enforce guardrail breaches as automatic kills ([Microsoft ExP — guardrail metrics](https://www.microsoft.com/en-us/research/group/experimentation-platform-exp/)).

### 5. Input metrics

3–5 diagnostic metrics that feed the primary. Not deciding — they exist so that, when the primary moves, the team can localise cause. If the primary moves but no input metric does, that is itself a signal: usually the primary moved for a reason outside the hypothesis.

### 6. Decision rule

Three rows: Ship, Kill, Iterate. Iterate is mandatory — most real outcomes are inconclusive at first, and ship-or-kill specs force premature decisions on noisy data ([Kohavi et al., 2020 — Ch. 17 on launching decisions](https://experimentguide.com/)). Threshold-setting detail in [decision-rules.md](decision-rules.md).

### 7. Sample size and duration

Computed from the threshold in block 2 and the baseline. Use [stat-snippets §4](../../metrics-diagnose/references/stat-snippets.md) (MDE / power check) — the underlying method is standard two-proportion power analysis ([Chow, Shao, Wang — *Sample Size Calculations*, 3rd ed.](https://www.routledge.com/Sample-Size-Calculations-in-Clinical-Research/Chow-Shao-Wang-Lokhnygina/p/book/9781138740983)).

Detectability check is a single yes/no: does available traffic in the window meet the required n per group? If not, the spec is undetectable as written.

### 8. Instrumentation status

Two columns: events already captured, and events that must ship before launch. Name the instrumentation owner. If events are not in place at launch, fall back to qualitative success criteria (Sean Ellis's 40% PMF survey is one option for early-stage signals — [startup-marketing.com](https://www.startup-marketing.com/the-startup-pyramid/)).

For tracking-plan format, see [`metrics-instrumentation`](../../metrics-instrumentation/SKILL.md).

---

## Filled example

Onboarding step-3 case from the SKILL Step 6 example:

```
Measurement spec — Onboarding step-3: remove optional-fields block

Date signed:     2026-05-15
Owner:           Azar (design lead)
Sign-off:        Pat (PM), Sam (design lead)

1) Hypothesis
   If we remove the optional-fields block from onboarding step-3,
   then task success on step-3 (completion rate) for new signups will
   rise by at least 5 percentage points (58% → ≥63%), because the
   optional fields create the impression that all fields are required,
   and new users abandon rather than skip them.
   We will know within 6 weeks of full rollout (4 weeks of cohorts
   + 7-day retention observation for the last cohort).

2) Primary metric
   Step-3 completion rate (Task Success), new signups, 7-day rolling.
   Baseline 58.0% (n ≈ 30,000 signups/week). Target ≥63.0%.

3) Counter-metric
   Day-7 retention for the new-signup cohort.
   Must not regress by more than 2 pp absolute.

4) Guardrails
   - Step-3 average task time: must not increase by >10 s
   - Profile-edit support tickets / 1,000 signups: must not rise by >25% rel
   - Post-onboarding crash rate: must not rise by >0.5 pp

5) Input metrics
   Per-field abandonment in step-3; time-to-step-3; post-onboarding CSAT.

6) Decision rule
   Ship if:     Step-3 completion ≥63% AND Day-7 retention not down >2 pp
                AND guardrails held
   Kill if:     Step-3 completion ≤56% OR Day-7 retention down >4 pp
                OR any guardrail breached
   Iterate if:  Completion between 58–63% OR underpowered at week 6

7) Sample size and duration
   Required n ≈ 1,540 per arm (Cohen's h ≈ 0.10, alpha 0.05, power 0.80).
   50/50 new signups, 6-week window. ~15,000/arm/week ≫ 1,540 —
   sample not the constraint; window is set by cohort accumulation
   (4 weeks of cohorts + 7-day retention observation for the last cohort).

8) Instrumentation status
   Already tracked: signup_started, step_*_viewed, step_*_completed,
                    onboarding_completed, support_ticket_tag.
   Owner: Sam (design lead, coordinating with eng).
```

---

## See also

- [hypothesis-patterns.md](hypothesis-patterns.md) — strong vs weak hypothesis examples.
- [decision-rules.md](decision-rules.md) — how to choose Ship/Kill/Iterate thresholds.
- [`../../metrics-diagnose/references/stat-snippets.md`](../../metrics-diagnose/references/stat-snippets.md) — power and MDE snippets.
- [Kohavi, Tang, Xu — *Trustworthy Online Controlled Experiments* (2020)](https://experimentguide.com/) — the canonical industry reference.
- [Goldacre et al. — COMPare project, *Trials* 2019](https://trialsjournal.biomedcentral.com/articles/10.1186/s13063-019-3173-2) — why pre-registration matters.
