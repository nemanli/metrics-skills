# Business Language

Translate design vocabulary into the language stakeholders use. Designers describe **what changed in the product**; executives ask **what changed in the business**. The mapping below converts the first into the second.

## Why translation matters

Stakeholders allocate budget against revenue, cost, risk, and growth. A finding phrased in design terms ("we improved the flow") competes with findings phrased in business terms ("we recovered 12% of abandoned carts"). The second wins funding.

This reflects the broader **outcome over output** principle: empowered teams are measured by what changes for users and the business, not by what they ship ([Marty Cagan, *Inspired*](https://www.svpg.com/books/inspired-how-to-create-tech-products-customers-love-2nd-edition/)). Translation converts output language ("we redesigned the form") into outcome language ("we recovered $X in abandoned revenue").

Two anchors from established practice:

- **Spool's problem-value framing** — describe the user's frustration, then attach the dollar amount the frustration costs. Spool's canonical case: a mandatory registration form blocked checkout. After replacing "Register" with "Continue," purchases rose 45% — $15M in the first month, $300M in the first year ([Center Centre](https://articles.centercentre.com/three_hund_million_button/)).
- **Weinschenk's cost-of-delay framing** — fixing a usability problem after development costs roughly 100× more than fixing it in design. A $100K UX investment for a micro-lending site recouped in ~40 days by recovering abandoned donations ([HFI / Susan Weinschenk](https://www.humanfactors.com/about_us/animated-video-explains-how-UX-design-delivers-ROI.asp)).

## Translation table

Each row: design phrase → business phrase → why this version lands. Use the right column when writing for executives, finance, or cross-functional leadership.

| Design phrase | Business phrase | Why it lands |
|---|---|---|
| Improved usability | Reduced support ticket volume | Maps to a line item in the support budget |
| User friction | Drop-off / cart abandonment | Names the revenue leak directly |
| Better onboarding | Faster time-to-first-value, higher activation | Activation is a tracked funnel metric |
| Cleaner UI | Lower cognitive load → fewer errors → fewer reworks | Connects design to error cost |
| Increased engagement | Higher retention → higher LTV | Engagement alone is vanity; LTV is finance |
| User satisfaction (CSAT/NPS) | Customer retention risk indicator | Reframes a soft metric as a leading signal |
| Reduced clicks / steps | Shorter task time → labor cost saved (B2B) or conversion lift (B2C) | Two distinct dollar paths depending on product |
| Accessibility improvements | Expanded addressable market + compliance risk reduction | Revenue + legal framing |
| Design system adoption | Engineering velocity, reduced rework cost | Speaks to eng leadership budget |
| Usability test findings | De-risked development spend before code is written | Frames research as risk reduction |
| Wireframe / prototype | Testable model for validating assumptions cheaply | Same idea, finance vocabulary |
| User research insight | Customer evidence supporting (or refuting) a planned investment | Connects to investment decisions |
| Improved task success rate | Higher conversion / completion → revenue impact | Direct funnel translation |
| Lower error rate | Reduced rework, reduced support contacts | Two cost lines |
| Faster task completion | Productivity gain (B2B) or session-to-conversion lift (B2C) | Nielsen's intranet ROI calc applies here ([NN/g](https://www.nngroup.com/articles/return-on-investment-for-usability/)) |
| Improved learnability | Lower training cost, faster onboarding for new users | Especially strong for B2B |
| Reduced churn risk | Protected recurring revenue | Direct CFO language |
| New feature adoption | Validated product-market fit signal for the feature | Frames adoption as evidence, not vanity |

### Source anchors for the table

The mapping pattern follows the outcome-over-output principle ([Cagan](https://www.svpg.com/books/inspired-how-to-create-tech-products-customers-love-2nd-edition/)): each design phrase on the left names an output; each business phrase on the right names the outcome that output produces.

Specific rows are anchored in published work:

- *Improved usability → support cost*, *Faster task completion → productivity gain*: [NN/g — ROI for Usability](https://www.nngroup.com/articles/return-on-investment-for-usability/) (intranet productivity calc; 100K-employee company sees 50× returns).
- *User friction → drop-off / cart abandonment*, *Lower error rate → reduced rework*: [Spool — $300M Button](https://articles.centercentre.com/three_hund_million_button/) (forced registration cost $300M/year; removing it recovered the same).
- *Cleaner UI → lower cognitive load → fewer errors*: anchored in [Sweller (1988) — Cognitive Load During Problem Solving, *Cognitive Science* 12:257–285](https://onlinelibrary.wiley.com/doi/10.1207/s15516709cog1202_4); reducing extraneous load lowers error rate and reaction time ([Hick-Hyman, 1952](https://en.wikipedia.org/wiki/Hick%27s_law)).
- *Accessibility improvements → addressable market + compliance risk*: [W3C WAI — Business Case for Digital Accessibility](https://www.w3.org/WAI/business-case/) (covers market reach, brand, innovation, and legal exposure; W3C estimates a global disability market of ~$7T).
- *Design system adoption → engineering velocity*: [Forrester Total Economic Impact study, cited via Figma](https://www.figma.com/blog/forrester-analyzes-the-roi-of-dev-mode/) reports 20–30% developer output gains, ~90 min/week saved per developer, and $10M efficiency savings over 3 years for a composite organisation of 100–1,000 designers and developers.
- *Cost-of-delay framing across the table* (errors caught in design vs. post-development): [HFI / Weinschenk — ROI of UX](https://www.humanfactors.com/about_us/animated-video-explains-how-UX-design-delivers-ROI.asp).

Rows about retention, LTV, churn, and activation use standard funnel-economics vocabulary; specific formulas are out of scope here and live in [`../../metrics-ux/references/ux-retention.md`](../../metrics-ux/references/ux-retention.md) and [`../../metrics-ux/references/ux-adoption.md`](../../metrics-ux/references/ux-adoption.md).

## Counter-metric framing

A single-metric win is rarely a real win. Pair every primary metric with a counter-metric (also called guardrail) that catches the trade-off — the practice is formalised as the Overall Evaluation Criterion (OEC) in [Kohavi et al. — *Online Controlled Experiments at Large Scale*, KDD 2013](https://exp-platform.com/large-scale/) and codified in [Kohavi, Tang, Xu — *Trustworthy Online Controlled Experiments* (2020), Ch. 7](https://experimentguide.com/).

Why this matters in presentations: stakeholders trust findings more when the presenter shows what could have gone wrong but didn't. Omitting the counter-metric reads as advocacy; including it reads as analysis.

Common pairings (industry practice):

| Primary metric | Counter-metric to report alongside | Trade-off it catches |
|---|---|---|
| Conversion rate ↑ | Customer satisfaction / refund rate | Pushed users into a purchase they regret |
| Stories engagement ↑ | Main feed engagement | Cannibalisation across surfaces (Instagram case via Mixpanel) |
| Booking rate ↑ | Post-booking rating / complaint rate | Hidden friction surfacing later (Airbnb case via Mixpanel) |
| Session duration ↑ | Task success rate, time-to-key-action | Engagement that comes from confusion, not value |
| Activation rate ↑ | Day-30 retention | Users activated but didn't stick |
| Adoption rate ↑ | Support ticket volume on the new feature | Adoption driven by confusion, not delight |

Rule of thumb from industry experimentation practice: 2–3 counter-metrics per experiment. More than that produces noise and false positives ([Dmitriev et al. — *Pitfalls of Long-Term Online Controlled Experiments*, IEEE Big Data 2016](https://exp-platform.com/pitfalls-of-long-term/)).

## Phrasing patterns

Three patterns that translate any finding into business framing.

**Pattern 1 — Problem → cost → fix → recovered value (Spool).**
> Real case: "Mandatory registration blocked first-time buyers at checkout. The form was costing the site $300M/year in lost sales. Replacing 'Register' with 'Continue' lifted purchases by 45% — $15M in the first month, $300M in the first year." ([Spool / Center Centre](https://articles.centercentre.com/three_hund_million_button/))

**Pattern 2 — Investment → recoup window (Weinschenk).**
> Real case: "A $100K UX investment for a micro-lending site recouped in ~40 days by recovering donation sessions abandoned at the navigation step." ([HFI / Weinschenk](https://www.humanfactors.com/about_us/animated-video-explains-how-UX-design-delivers-ROI.asp))

**Pattern 3 — Primary + counter (OEC framework).**
> Illustrative pairing: "Conversion rose from 58% to 65% (+7 pp, n = 142,000). Refund rate held flat at 2.1%, confirming the lift is durable rather than driven by impulse." The pattern formalises as the Overall Evaluation Criterion in [Kohavi et al., KDD 2013](https://exp-platform.com/large-scale/) — a single weighted combination of primary outcome and guardrails that prevents single-metric victory claims.

> Note on baselines vs. lifts: GOV.UK reported its LPA completion rate moving from 28.7% to ~70% — but this was a **funnel-definition correction**, not a service change ([GOV.UK Data Blog](https://dataingovernment.blog.gov.uk/2015/02/25/updating-the-lasting-power-of-attorney-completion-rate/)). When you present a number jump, separate "we changed the product" from "we changed the measurement"; conflating the two destroys credibility.

## Pitfalls

- **Over-claiming dollar values.** If the conversion model is rough, say "estimated" and show the assumption. A specific-but-wrong number destroys credibility faster than a wide range.
- **Translating only the win.** Translating the negative findings into business language is equally important — it builds trust and prevents stakeholders from learning the bad news from someone else.
- **Dropping the design vocabulary entirely.** Keep one clear design term per finding so the work stays traceable to the craft. Translation is for executives, not for the design team's own record.

## When to leave terms untranslated

Some design terms have no clean business equivalent and shouldn't be forced. Examples: heuristic evaluation, tree testing, card sort, affinity diagram. For these, name the method briefly and lead with the outcome ("a card sort with 18 users showed the current navigation hides the top 3 tasks; we restructured around them, and task success rose from 61% to 82%").

## See also

- [`templates.md`](templates.md) — output formats that use this vocabulary (stakeholder email, board slide, retro deck)
- [`../../metrics-basics/references/measurement-philosophy.md`](../../metrics-basics/references/measurement-philosophy.md) — when measurement adds value vs theatre
- [`../../metrics-basics/references/heart.md`](../../metrics-basics/references/heart.md) — HEART Goals-Signals-Metrics, useful for matching design metrics to business goals ([Kerry Rodden / Google](https://kerryrodden.com/heart/))
