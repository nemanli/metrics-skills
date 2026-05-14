# Hypothesis patterns — strong vs weak

A hypothesis is the load-bearing sentence of the spec. If it is not falsifiable, every later block is decoration. A falsifiable hypothesis names an outcome the author would accept as proof they were wrong — the criterion comes from [Popper's philosophy of science](https://plato.stanford.edu/entries/popper/) and is the same standard used in clinical pre-registration ([Goldacre et al., *Trials* 2019](https://trialsjournal.biomedcentral.com/articles/10.1186/s13063-019-3173-2)).

## Canonical shape

> **"If we [change], then [user behavior] will [direction] by [magnitude], because [mechanism]. We will know within [window]."**

This shape mirrors the **If-Then-Because** template recommended for hypothesis-driven experimentation ([Kohavi, Tang, Xu — *Trustworthy Online Controlled Experiments* (2020), Ch. 5](https://experimentguide.com/); practitioner version in [GoodUI — hypothesis kit](https://goodui.org/leaks/)). Five required parts:

| Part | Role | Failure mode |
|---|---|---|
| **Change** | The specific design or product alteration | Vague ("redesign onboarding") — cause is not isolated |
| **User behavior** | Observable, measurable action | Abstract ("engagement") — not a behavior, a category |
| **Direction + magnitude** | Up/down and by how much | "Improve" — no falsifiable threshold |
| **Mechanism** | Why the change should produce the behavior | Omitted — signal cannot be told from coincidence |
| **Window** | When the measurement will be declared complete | Open-ended — team argues forever about "more data" |

A hypothesis is ready when the user can answer **"what specific outcome would prove this wrong?"** in one sentence. If the answer is "I am not sure", the hypothesis is not ready.

---

## Strong vs weak — by HEART category

For each [HEART category (Rodden, Hutchinson, Fu — CHI 2010)](https://kerryrodden.com/heart/): a weak version (what designers usually write first), why it fails, and a strong rewrite.

### Happiness

| | Hypothesis |
|---|---|
| **Weak** | "The redesign will make users happier with checkout." |
| **Failure** | "Happier" is not measurable. No behavior, no magnitude, no mechanism. |
| **Strong** | "If we replace the 4-field shipping form with a 1-field auto-detect, then post-checkout CSAT will rise from 3.8 to ≥4.1 on the 5-point scale, because the form is the most-cited friction point in 60 days of open-text feedback. We will know within 3 weeks of full rollout (≥600 responses)." |

CSAT scale guidance: [MeasuringU — CSAT and top-2-box](https://measuringu.com/csat/). Category context: [ux-happiness.md](../../metrics-ux/references/ux-happiness.md).

### Engagement

| | Hypothesis |
|---|---|
| **Weak** | "The new feed will improve engagement." |
| **Failure** | "Engagement" is a category, not a metric. Any movement gets retroactively claimed as success. |
| **Strong** | "If we replace the chronological feed with a recency-weighted ranked feed, then weekly sessions per active user will rise from 4.2 to ≥4.8 among 30-day-active users, because users currently miss high-relevance posts published outside their session windows. We will know within 6 weeks." |

The strong version commits to a *segment* (30-day-active). Without that, the metric is sensitive to mix shifts — a known pitfall illustrated in [Andrew Chen — *New data shows why losing 80% of your mobile users is normal*](https://andrewchen.com/new-data-shows-why-losing-80-of-your-mobile-users-is-normal-and-that-the-best-apps-do-much-better/), drawing on Quettra's industry retention dataset. Category context: [ux-engagement.md](../../metrics-ux/references/ux-engagement.md).

### Adoption

| | Hypothesis |
|---|---|
| **Weak** | "Users will adopt the new AI assistant." |
| **Failure** | "Adopt" is undefined (first try? repeat use? habit?). No threshold for success. |
| **Strong** | "If we surface the AI assistant in the primary nav with a labelled affordance, then ≥30% of weekly active users will invoke the assistant at least once within 14 days of launch, AND of those, ≥40% will return to it in their next session within 7 days, because the labelled affordance removes the discovery problem prior in-context entry points hit. We will know within 6 weeks." |

Adoption hypotheses often need **two thresholds** — trial and repeat — because trial without return is a vanity metric ([Ries — *Beware of Vanity Metrics*, HBR 2010](https://hbr.org/2010/02/entrepreneurs-beware-of-vanity-metrics)). Category context: [ux-adoption.md](../../metrics-ux/references/ux-adoption.md).

### Retention

| | Hypothesis |
|---|---|
| **Weak** | "Onboarding changes will improve retention." |
| **Failure** | Which retention — Day 1, Day 7, Day 30? Cohort or rolling? No mechanism. Window unbounded. |
| **Strong** | "If we add a contextual 'first task' prompt at the end of onboarding, then Day-7 retention for the new-signup cohort will rise from 38% to ≥44%, because users who complete one core action in week 1 retain at roughly twice the rate of those who do not (observed in current cohort data). We will know after 4 weekly cohorts post-change accumulate (~5 weeks total)." |

Retention hypotheses must name the *cohort definition* and the *day mark* — Day-1, Day-7, and Day-30 retention move for different reasons ([Andrew Chen — mobile retention benchmarks](https://andrewchen.com/new-data-shows-why-losing-80-of-your-mobile-users-is-normal-and-that-the-best-apps-do-much-better/)). Category context: [ux-retention.md](../../metrics-ux/references/ux-retention.md).

### Task Success

| | Hypothesis |
|---|---|
| **Weak** | "The new checkout will reduce errors." |
| **Failure** | No baseline error rate, no specific error type, no magnitude. |
| **Strong** | "If we remove inline address validation and replace it with post-submit validation, then the address-input error rate on mobile will drop from 14% to ≤8% AND task time on the address step will drop from 27s to ≤18s, because inline validation interrupts thumb-typing and triggers errors before the user has finished. We will know within 3 weeks." |

Task-success hypotheses often pair an **error metric** with a **time metric** — error reductions that come at the cost of speed are a known trade-off in usability ([ISO 9241-11 — effectiveness vs efficiency](https://www.iso.org/standard/63500.html)). Category context: [ux-task-success.md](../../metrics-ux/references/ux-task-success.md).

---

## Rewrite patterns

When the user gives a vague hypothesis, walk through these rewrites instead of accepting the vague version.

| Vague input | Final rewrite |
|---|---|
| "Improve onboarding" | "Lift step-3 completion from 47% to ≥55% within 4 weeks of rollout, because the new copy clarifies the next required action." |
| "Reduce friction" | "Cut median checkout time from 3:14 to ≤2:00 on mobile, because the new flow removes 2 of 4 required fields." |
| "Make users more engaged" | "Lift sessions/user/week from 4.2 to ≥4.8 among 30-day-actives within 6 weeks, because the new feed surfaces relevance users currently miss." |
| "Better UX" | Refuse — not a hypothesis. Ask: "What specific user behavior do you expect to change, and by how much?" |
| "Boost completion" | "Lift onboarding step-3 completion from 58% to ≥63% within 4 weeks, because removing the optional-fields block stops new users from abandoning at the perceived-required gate." |

The pattern: name the **specific metric**, then **baseline → target**, then **mechanism**, then **window**. If the user cannot answer one step, that is where the work stops — pin down the missing piece before continuing.

---

## Anti-patterns to refuse

These signal a hypothesis that is not ready. Push back rather than write a spec around them.

- **"It will improve."** No direction, no magnitude. → Ask: "Up by how much?"
- **"Users will love it."** Not measurable; love is not a behavior. → Ask: "What specifically will they do that they do not do now?"
- **"We expect to see lift."** No baseline. → Ask: "What is the current value? What would count as lift?"
- **"It should be obvious from the data."** Hindsight excuse for not committing. → Ask: "Before the data arrives, what specific number would make you ship?"
- **"It will help the business."** Wrong layer; need the user behavior that translates to business outcome.
- **"It might also lift X, Y, Z."** Three primary metrics is no primary metric. → Pick one. Others become input or counter-metrics.
- **"At least X%."** When pressed, the user names a threshold below the noise band at the available sample size. → Show the MDE check; raise the threshold or accept the spec is undetectable.

---

## When the hypothesis is exploratory

Some work is genuinely exploratory — "we do not know what users will do; we want to ship and learn." That is a valid stance, but it is not what `metrics-spec` is built for. Pre-registration assumes a decision; learning agendas do not need one ([Kohavi et al., 2020 — Ch. 17 distinguishes "learn" from "ship" decisions](https://experimentguide.com/)).

Two options:

- **Switch to learning goals.** Replace the hypothesis with named **learning questions** the team commits to answering (e.g. "What share of users discover the new entry point?", "What is the dominant first action after invoking the assistant?"). The spec becomes a learning agenda, not a decision rule.
- **Use `metrics-ux` instead.** That skill recommends what to measure for learning; it does not require a decision rule. Come back to `metrics-spec` after one cycle of learning, when a decision-grade hypothesis exists.

Either way, do not write a pseudo-spec with a made-up threshold. The whole point of pre-registration is to bind the team to a rule they wrote before the data; a made-up threshold makes the rule meaningless.
