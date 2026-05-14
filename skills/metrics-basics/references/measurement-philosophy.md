# Measurement philosophy — agent rule book

For the agent, not the designer. Three modes — **recommend**, **refuse/redirect**, **don't measure** — each rule with **Trigger** (what you see in the prompt) / **Action** (what to do) / **Why** (short justification with source).

---

## When to recommend metrics — 3 pillars

The agent's default arguments when the user asks why measurement is worth it. Use one or more depending on the situation.

### Pillar 1 — Close the feedback loop on your own work

**Trigger.** Designer asks how to know if their work succeeded:
- Explicit: "what should I measure?", "how do I know if it worked?", "how do I learn from this project?"
- Implicit (JTBD signal): user describes shipping without follow-up ("we launched X, then moved on")

**Action.** Recommend lightweight measurement tied to the designer's own learning — not performance review, not stakeholder reporting. Pair every quantitative signal with 1–2 user interviews.

**Why.** Without measurement, every project is an isolated event — the "this turned out well" intuition stays untested. [Cagan (Inspired)](https://svpg.com/inspired-how-to-create-products-customers-love/): even on strong teams, at least three quarters of ideas won't perform as the team hoped. Without measurement the designer never learns which of theirs landed.

**Risk and guard.**
- Risk: feedback loop crossing into performance review territory. Once the metric becomes a performance target, the designer games it (Goodhart) instead of using it to learn.
- Guard: keep the loop low-stakes — the designer chooses what to track, not the manager. Every quantitative signal must be paired with qualitative input. Feedback loop = number + interview, never number alone.

### Pillar 2 — Shared language with PM, engineering, and leadership

**Trigger.** Designer needs to defend or communicate design work to non-designers:
- Explicit: "I need to defend this to the CPO", "how do I show impact?", "PM has metrics, I only have screenshots"
- Implicit (JTBD signal): user frames design as undervalued ("design is treated as a cost center", "'the design looked better' is not a board-level argument")

**Action.** Recommend metrics that translate design work into the language other functions already speak. Use HEART categories or Spool's problem-value framing (frustration → dollar cost). Never recommend a single metric in isolation — pair the headline with input metrics and a guardrail (counter-metric). See Risk and guard below for the structure.

**Why.** Design is often the only function defending its work without a dashboard — others arrive with numbers, design with screenshots. Measurement moves design from "my taste" into "shared evidence," turning the function from cost center into impact center.

Sources: [NN/g — UX Metrics & ROI](https://www.nngroup.com/reports/ux-metrics-roi/); [Spool — Outcome-Driven UX Metrics](https://articles.centercentre.com/what-are-outcome-driven-ux-metrics/).

**Risk and guard.**
- Risk: a single metric shown to leadership becomes a target (Goodhart, see Misconception 3) or, when leadership has already decided, "shared language" collapses into measurement theater (see Situation 3).
- Guard: never recommend a single metric to leadership in isolation. The standard formulation — one headline metric paired with input metrics and guardrails — comes from the Overall Evaluation Criterion (OEC) framework ([Kohavi et al. — *Online Controlled Experiments at Large Scale*, KDD 2013](https://exp-platform.com/large-scale/); [Kohavi, Tang, Xu — *Trustworthy Online Controlled Experiments*, 2020, Ch. 7](https://experimentguide.com/)). Honest framing example: "sign-ups went up, **but** activation stayed flat."

### Pillar 3 — Honesty instead of storytelling

**Trigger.** Designer claims success without falsifiable evidence:
- Explicit: "the launch went well", "users seem to like it", "I think it worked"
- Implicit (vanity signal): user cites unfalsifiable numbers (page views, total sign-ups, total DAU) as proof of success

**Action.** Distinguish vanity metrics from actionable metrics. Vanity = makes you feel good but does not point to any next decision. Actionable = clear cause and effect; you know what moves it and what to do next. Recommend the actionable version.

**Why.** Without measurement, every project can look successful — especially to the designer who made it. Lean Analytics calls this "protection from lying to yourself." Numbers that feel good (page views, sign-ups) are not the same as numbers that show real change (activation, retention).

Sources: [Eric Ries — Beware of Vanity Metrics, HBR](https://hbr.org/2010/02/entrepreneurs-beware-of-vanity-metrics); [Lean Analytics — OMTM](https://leananalyticsbook.com/one-metric-that-matters/).

**Risk and guard.**
- Risk: presenting a number as a fact, hiding the underlying judgment behind "the data says…" (Hall — "numbers aren't facts").
- Guard: never say "data says." Use the formula **number + qualitative + judgment**: "data shows X, interviews show Y, my judgment is Z, so the decision is W."

---

## When to refuse or redirect — 4 misconceptions

When the user's prompt assumes one of these, the agent names it and redirects.

### Misconception 1 — "Numbers are objective; metrics are facts."

**Trigger.** User cites a number as if it settles the argument:
- Explicit: "the data says X", "the funnel proves it", "users obviously prefer Y"
- Implicit: any phrasing that treats a number as the end of a discussion ("just look at the metric")

**Action.** Numbers are not facts — every metric is a chain of choices (what to count, how to define an event, who counts as "active"). Reframe with the formula **number + qualitative + judgment**. Push back when the user treats a number as the end of a discussion.

**Why.** Hall: *"people see something expressed as a number, they think 'That's a fact,' but numbers aren't facts."* Sharper: when you start counting, you count what is **easiest to measure** — and that is often the **wrong thing**. Numbers carry interpretation, not fact.

Source: [Erika Hall — dscout interview](https://dscout.com/people-nerds/erika-hall-better-research-and-design).

### Misconception 2 — "The metric improved, so the change worked."

**Trigger.** User assumes cause from correlation alone:
- Explicit: "we shipped the redesign and sign-ups went up", "the new flow improved retention"
- Implicit: any post-release "X went up because we did Y" framing without a control group

**Action.** Without a control group, "it improved" is a story, not evidence. Ask what else changed in the same window: seasonality, marketing, audience mix, self-selection. Recommend an A/B test if reversible, baseline-and-segment comparison if not.

**Why.** Classic example: ice cream sales and sunburns rise together in summer — the sun causes both, ice cream causes neither. Designers fall for this most often after a release, when the team wants the redesign to be the cause.

Sources: [Statsig — Correlation Not Causation in A/B Tests](https://www.statsig.com/perspectives/correlation-not-causation-ab-tests), [Amplitude — Causation vs Correlation](https://amplitude.com/blog/causation-correlation).

### Misconception 3 — "If the metric hits the target, the system is healthy" (Goodhart's Law).

**Trigger.** User celebrates a single metric moving up without checking for trade-offs:
- Explicit: "sign-ups doubled", "engagement is at an all-time high", "this metric is up and to the right"
- Implicit: success claim with no mention of counter-metrics or unintended consequences

**Action.** *"When a measure becomes a target, it ceases to be a good measure"* — [Strathern (1997)](https://academic.oup.com/erev/article-abstract/5/3/305/6776275)'s formulation of Goodhart, in *European Review* 5(3): 305–321. Ask what could be gamed to produce this number. Recommend at least one counter-metric: "sign-ups doubled — what happened to activation? to 30-day retention?"

**Why.** Documented gaming: Wells Fargo employees opened ~3.5 million unauthorized accounts (2011–2016) under cross-sell quota pressure; call centers cut hold-time metrics by hanging up on customers; Soviet sheet steel and glass plans by weight produced unusably heavy products (Alec Nove). The Soviet nail and Delhi cobra anecdotes are popular but historically unverified — use them to illustrate the mechanism, not as evidence. When gaming is amplified by authority (HiPPO ordering the metric to confirm a decision), it becomes measurement theater — see Situation 3.

Sources: [Goodhart's Law — Wikipedia](https://en.wikipedia.org/wiki/Goodhart%27s_law), [Wells Fargo cross-selling scandal — Wikipedia](https://en.wikipedia.org/wiki/Wells_Fargo_cross-selling_scandal).

### Misconception 4 — "If we can't measure it, it doesn't count" (McNamara fallacy).

**Trigger.** User dismisses a concern because there is no metric for it:
- Explicit: "we can't measure trust, so let's focus on conversion", "intent is too soft to track", "if it's not in the dashboard it's not a priority"
- Implicit: any reasoning that drops a concern (accessibility, ethics, brand) because it isn't quantified

**Action.** McNamara fallacy ([Yankelovich, "Interpreting the New Life Styles," *Sales Management*, 1971](https://en.wikipedia.org/wiki/McNamara_fallacy)): (1) measure what is easy, (2) ignore or assign arbitrary numbers to what is hard, (3) decide the unmeasurable is unimportant, (4) declare it does not exist. Recommend qualitative methods (interviews, observation, diary studies) for the part the metric cannot reach.

**Why.** The most important things in a product (user intent, trust, brand integrity, long-term loyalty) are often the hardest to count. Yankelovich named this after Robert McNamara's reliance on enemy body count in Vietnam — the numbers said the U.S. was winning a war it ultimately lost.

Source: [McNamara fallacy — Wikipedia](https://en.wikipedia.org/wiki/McNamara_fallacy).

### Nuance — when these are not misconceptions

The 4 misconceptions above are wrong when used to make **design decisions**. Each has a legitimate purpose elsewhere — the misconception is not the metric, it is **using the metric for the wrong purpose**.

- **"Numbers as facts"** — acceptable for **operational monitoring** (uptime, error rate, latency). When the question is "is the system running?", the number is close to a fact.
- **"Metric improved → change worked"** — acceptable for **directional reporting** when the change is cheap, reversible, and low-risk. Full causal proof is overkill for a button-text tweak.
- **"Hit target = healthy"** — acceptable on **observation dashboards** that watch the system, not on **decision dashboards** that drive choices. Same chart, different role.
- **"Can't measure = doesn't count"** — defensible in **regulated or audited domains** (compliance, safety) where only verified metrics carry weight.

When the user's context fits one of these, the agent does not flag the misconception — it confirms the fit and recommends the metric.

---

## When not to measure — 4 situations

Situations where the agent recommends qualitative methods or no measurement. The rule is not "don't measure" — it is **don't claim the numbers will decide for you when they can't**.

### Situation 1 — Pre-launch (no users yet)

**Trigger.** User asks for metrics before there are users:
- Explicit: "we're launching next month, what should we track?", "no users yet, but I want to set up metrics"
- Implicit: behavioral metrics framed for a product with no traffic ("what's our retention curve target?")

**Action.** Recommend qualitative-first: 5–10 user interviews per week (Concierge MVP), prototype testing, Sean Ellis's 40% PMF test ("how would you feel if you could no longer use this product?"). Set up event instrumentation now, but do not analyze yet — there is no signal to find.

**Why.** No traffic = no behavioral signal. Watching sign-up curves before users arrive produces "PMF hallucination." At this stage qualitative beats quantitative on speed *and* fidelity.

Sources: [Sean Ellis — 40% PMF test](https://www.startup-marketing.com/the-startup-pyramid/), [GoPractice — Metrics Before/After PMF](https://gopractice.io/product/metrics-to-focus-on-before-and-after-product-market-fit/).

### Situation 2 — Sample too small for stable measurement

**Trigger.** User asks for percentages or rates from a small population:
- Explicit: "we have 12 enterprise customers, what's our task success rate?", "small B2B audience, can we still A/B test?"
- Implicit: any quantitative claim built on fewer than ~20 users

**Action.** Refuse the percentage. NN/g: stable quantitative usability needs **40 participants** (95% confidence, 15% margin of error, binary metric, population >500). Below ~20, percentages mislead more than they inform. Recommend 5–8 qualitative interviews instead — these are designed for this scale.

**Why.** Small samples produce noise that looks like signal. "3 of 5 users completed the task = 60%" sounds precise but the confidence interval is roughly ±43 percentage points — meaningless for decisions.

Source: [NN/g — Why 40 Participants for Quantitative UX Research](https://www.nngroup.com/videos/why-40-participants-quantitative-research/).

### Situation 3 — Decision already made (measurement theater)

**Trigger.** User commissions measurement to confirm a decision, not to inform it:
- Explicit: "the CPO has decided X, I need data to support it", "we already chose direction Y, can you find metrics that show it works?"
- Implicit: the analysis brief specifies the conclusion ("show that the redesign improved engagement")

**Action.** This is **measurement theater** — post-hoc rationalization wearing dashboard clothes. Refuse, or be explicit: "this is reporting, not research." Offer to measure for the *next* decision, with the metric chosen before the decision.

**Why.** When leadership has already decided, measurement loses its function (informing) and gains a harmful one (laundering authority). This is Misconception 3 with HiPPO power — same Goodhart mechanism, organizational form. At its sharpest it becomes gaming — see Wells Fargo's authority-driven mass falsification of accounts.

Sources: [UserVoice — HiPPOs](https://uservoice.com/blog/highest-paid-persons-opinion), [Goodhart's Law and the Death of Honest Metrics](https://medium.com/@claus.nisslmueller/goodharts-law-and-the-death-of-honest-metrics-e08cc756f93a).

### Situation 4 — Strategic / value-based decisions

**Trigger.** User frames a value question as a metric question:
- Explicit: "should we add this dark pattern to lift conversion?", "is accessibility worth the engineering cost?"
- Implicit: ethics, brand integrity, or accessibility framed as optimization candidates

**Action.** Refuse the framing. These decisions are not optimization questions — they are values. Concrete example: "should we trick users with dark patterns to lift conversion?" is **not an A/B test question**. The A/B test will say yes (conversion lifts); the question itself is wrong.

**Why.** Optimize a single metric (conversion) without value constraints and manipulative UI patterns win — hidden unsubscribes, guilt-tripping copy. The metric succeeds while the product gets worse. Numbers cannot answer "should we?" — only people can.

Sources: [Goodhart's Law and Dark Patterns in A/B Testing](https://blog.growthbook.io/goodharts-law-and-the-dangers-of-metric-selection-with-a-b-testing/).

### Nuance — when measurement still has value

The rule above is not "don't measure in these situations" — it is "don't claim the numbers will decide for you when they can't." Each situation has a legitimate measurement role:

- **Pre-launch instrumentation** — setting up events before traffic arrives is **preparation**, not premature analysis. Cheap, returns value the moment users arrive.
- **Small samples + qual** — wide confidence intervals + qualitative pairing can give meaningful **directional** signal, even when percentages cannot.
- **Theater context** — the current decision is locked, but measurement can inform the **next** decision (set the metric *before* that one is made).
- **Value-based decisions** — numbers can support or describe the trade-off (accessibility cost in engineer-hours, dark-pattern revenue lift), but the decision stays a values decision.

The agent recommends measurement in these adjusted forms — it does not refuse outright.

---

## Default rules — always apply (unless nuance applies)

When the agent recommends, refuses, or redirects on metrics, these rules cut across all three sections. They define the agent's voice, not its decision tree. The Nuance blocks above name the exceptions: when the user's context is operational, directional, regulated, or fits one of the 4 situations, the matching rule loosens.

1. **Never present a number as a fact.** Use "data shows" or "the metric indicates," never "data says" or "the data tells us."
2. **Never recommend a single metric as a target to leadership.** Pair the headline with input metrics (commonly 3–5) and at least one guardrail / counter-metric — see Pillar 2 Guard.
3. **Always pair quantitative with qualitative.** A number without an interview is a question, not an answer.
4. **Never skip the *why*.** When a metric moves, the next sentence must be "we don't yet know why" or "interviews suggest…", never "this proves…"

