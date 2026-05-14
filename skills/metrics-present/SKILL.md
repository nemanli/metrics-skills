---
name: metrics-present
description: Turns metric results into stakeholder-ready output — board slide, exec email, retro deck, design impact story, stakeholder defence, "how do I explain this to the CPO/board?". Translates design findings into business language, frames counter-metrics. Skip for picking metrics (use metrics-ux), for diagnosing a movement (use metrics-diagnose), for HEART definitions (use metrics-basics).
allowed-tools: Read
---

## Overview

Turns metric results into stakeholder-ready output. Three jobs: (1) **pick the format** for the audience and channel (email, board slide, retro deck), (2) **translate** design vocabulary into business language, (3) **frame** the result honestly — primary metric paired with a counter-metric, sample size and time window stated, failures and limits surfaced rather than buried.

This skill is editorial, not analytical. It assumes the numbers are already validated. If the user is still asking "is this real?" or "why did it move?", redirect to `metrics-diagnose` first. If the user has no numbers yet, redirect to `metrics-ux`.

The reference materials carry the detail: [`templates.md`](references/templates.md) for the three output formats, [`business-language.md`](references/business-language.md) for design-to-business translation pairs, counter-metric pairings, and the Spool / Weinschenk framing patterns.

## When to Use

Use this skill when a designer or PM has results and needs to communicate them — phrased differently by seniority but matching the same job-to-be-done:

| Designer level | Typical phrasing that should trigger this skill |
|---|---|
| **Junior** | "PM asked for a writeup of the redesign results, where do I start?" / "How do I share these numbers with the team?" |
| **Middle** | "I have the numbers, how do I write the email to the stakeholders?" / "What goes on the board slide for this feature?" |
| **Senior** | "I need to defend this design to the CPO with data" / "How do I translate UX findings into business language for finance?" |
| **Lead** | "We're presenting the quarterly design impact story — what's the structure?" / "How do I frame a mixed result (one metric up, one flat) honestly?" |

Cross-cutting triggers (any seniority):

- Has results and asks for the **format** (email, slide, deck, retro).
- Asks how to **translate** UX or design language into business / executive vocabulary.
- Asks how to **frame** a counter-metric, a missed target, or a partial win.
- Mentions a specific audience: PM, eng lead, CPO, CFO, board, retro, quarterly review.
- Is preparing a **design impact story** for portfolio, performance review, or promotion.

Skip this skill when:

- The user is picking which metrics to track → use `metrics-ux`.
- The user is writing a pre-launch measurement plan or decision rule → use `metrics-spec`.
- The user is designing the events/tracking plan that captures the metric → use `metrics-instrumentation`.
- The user is figuring out why a number moved → use `metrics-diagnose`.
- The user is stress-testing an incoming claim or self-reviewing the draft before publishing → use `metrics-review`.
- The question is about a HEART definition or measurement philosophy → use `metrics-basics`.
- The metric is monetization-driven (revenue, MRR, LTV) → out of scope for v1.

## Process

### Step 1 — Detect mode

Read the user's prompt and pick one mode:

| Mode | Signal | Action |
|---|---|---|
| **Direct** | Asks for a specific format ("write the board slide", "draft the email", "what's the retro structure?") | Skip questionnaire. Open [`templates.md`](references/templates.md) and apply the matching format. |
| **Specific** | Has results AND a clear audience ("results for the CPO defence", "quarterly review for the board") | Skip questionnaire. Pick format from audience, translate, draft. |
| **Vague** | Has results but no clear audience or channel ("I have the numbers, how do I share them?") | Run hybrid questionnaire (Step 2). |

### Step 2 — Hybrid questionnaire (vague mode only)

Four context anchors, full version in [`../metrics-basics/references/context-questions.md`](../metrics-basics/references/context-questions.md). For this skill, the anchors map slightly differently:

1. **SCOPE** — what was measured, what numbers are in hand
2. **STAGE** — partial result (still rolling out) or full result (complete)
3. **AUDIENCE** — who will read it (single PM / leadership / board / cross-functional team / portfolio)
4. **DATA** — what supporting data is available (counter-metric ready? sample size known? time window stated?)

For each anchor, mark **present** (clear in prompt) or **missing**. Ask only for missing anchors:

- 0–1 missing → ask in one sentence
- 2–3 missing → ask in one numbered list
- 4 missing → use the full questionnaire

Never re-ask what the user already provided. Maximum 4 questions per session.

When asking, follow the "How to ask" section in [context-questions.md](../metrics-basics/references/context-questions.md) — inline numbered list for closed-choice questions (audience, format, stage).

The most common gap in this skill is **AUDIENCE**. The same numbers go into very different formats for a PM Slack thread vs. a board slide. Always confirm the audience before drafting.

### Step 3 — Pick the format

Match audience and channel to the output format. Full structures and filled examples in [`templates.md`](references/templates.md).

| Audience / channel | Format | Why |
|---|---|---|
| Single decision-maker (PM, eng lead, CFO) over inline message | **Stakeholder email** | One paragraph + numbers + ask. Optimised for mobile and quick decisions. |
| Exec, board, quarterly review | **Board slide** | Headline + 3 supporting + 1 counter-metric. The headline must work alone. |
| Cross-functional team retro | **Retro deck** | Before/after + what worked + what didn't + what we'd do differently. "What didn't" is non-negotiable. |
| Slack DM, mobile-first exec, tight context | **Compressed email** (1–2 sentences) | Same headline + numbers + ask, shorter form. See [`templates.md`](references/templates.md), Cross-cutting rules. |

When two formats fit, pick the shorter one. Adding length is easy; cutting it on demand is what burns time.

**Performance review / portfolio / promotion case** uses the retro structure with a different lens: design-decision attribution rather than team learning. Same shape, different emphasis — keep "what didn't" but frame it as "what I learned" rather than "what we'd do differently".

### Step 4 — Translate to business language (when needed)

Email and board slide → translate. Retro deck → keep design vocabulary; the team needs traceability to the craft.

Use [`business-language.md`](references/business-language.md) for the translation table (18 design → business pairs) and the three phrasing patterns:

- **Pattern 1 — Problem → cost → fix → recovered value** (Spool framing). Best when there is a clear user frustration and a measurable cost.
- **Pattern 2 — Investment → recoup window** (Weinschenk framing). Best when justifying a design investment to finance or leadership.
- **Pattern 3 — Primary + counter** (Mixpanel / Amplitude). Best for any honest result; mandatory for board slides.

Two anchors from [`business-language.md`](references/business-language.md):

- **Outcome over output** ([Cagan, *Inspired*](https://www.svpg.com/books/inspired-how-to-create-tech-products-customers-love-2nd-edition/)) — translate "we shipped X" into "X changed for users / the business by Y".
- **Inverted pyramid** ([NN/g](https://www.nngroup.com/articles/inverted-pyramid/)) — lead with the outcome; supporting detail comes after.

### Step 5 — Frame counter-metric

Every output that goes to leadership includes at least one counter-metric. Pairings are in [`business-language.md`](references/business-language.md). The counter-metric is the one you would be embarrassed to show if it had moved the wrong way; if you can't think of one, the framing is incomplete.

If the counter-metric did move the wrong way, surface it. Hiding it costs more credibility than the bad number itself.

### Step 6 — Draft and verify

Draft the output using the format structure. Before sending, check:

- **Headline carries the load.** If the slide were photographed without context, the headline still tells the story.
- **Sample size and time window stated.** No primary metric without n and the period it covers.
- **Counter-metric included.** Even if it held flat, name it.
- **Failures surfaced.** What didn't work is in the draft, not omitted.
- **Length matches context.** Mobile reader → compress. Quarterly review → expand.

End every draft with: **"Does this fit your audience, or should we adjust the framing?"**

## Example

**User prompt (specific mode):** *"I redesigned the configuration tool for our internal authoring app. NN/g-style task-time study, 4 tasks: original design 236s, new design 69s — a ~70% reduction. Subjective satisfaction scores also improved. Quarterly review slide for the CPO tomorrow. How do I frame this?"*

This example uses the published Macromedia Flash redesign case ([Nielsen / NN/g, 2001 — Usability Metrics](https://www.nngroup.com/articles/usability-metrics/)) as the underlying data.

**Mode detection:** Specific — has numbers, has audience (CPO, quarterly review).

**Anchor parse:**
- SCOPE: present (configuration tool redesign, 4-task study)
- STAGE: present (study complete)
- AUDIENCE: present (CPO, quarterly review = board slide format)
- DATA: present (before/after task time, satisfaction scores), but **sample size missing** — flag this back to the user before the slide ships.

**Format pick:** Board slide ([`templates.md`](references/templates.md), Format 2). Headline-first, primary + supporting + counter-metric, business-language translation.

**Translation:**
- "Task time 236s → 69s" → keep the time figure but lead with the productivity outcome (B2B tool → labour cost saved per session, see [`business-language.md`](references/business-language.md)).
- "Satisfaction scores improved" → supporting Happiness metric, paired but not headline.
- **No counter-metric reported in the source.** Flag this honestly on the slide rather than inventing one.

**Draft:**

```
Configuration-tool redesign cut task time by ~70% across four core tasks

Primary:      Time on task (4-task set): 236s → 69s   (≈70% reduction)
Supporting:   Subjective satisfaction:   improved post-redesign
              [Source: NN/g published usability-metrics study]
Counter:      Error rate / completion rate not reported in source —
              before broader rollout, recommend tracking these to confirm
              speed gain didn't come at the cost of accuracy

Implication: at this team's session volume, ~70% time saving translates
to ~N hours/month of recovered productivity, assuming the four tasks
are representative of daily use. (Assumption to confirm with usage logs.)
```

**Verify question:** "Does this fit a CPO audience, or should we tighten the language for board-level brevity?"

**Notes the agent should add for the user:**

- **Sample size is missing from the source data.** Before the slide goes to the CPO, ask: how many participants? An n=5 result lands very differently than n=50. The slide should state the sample size; if unknown, replace with "small-sample usability study, before broader validation."
- **No counter-metric in the original case.** Don't invent one — flag the gap on the slide. A real-world version would add error-rate or completion-rate tracking to confirm that faster ≠ sloppier (see [`business-language.md`](references/business-language.md), Counter-metric framing).
- **Productivity translation is an estimate.** "~N hours/month recovered" needs a stated assumption (sessions per day × people × task share). Show the math inline if asked; don't bury it.
- The retro version of this same data would expand the supporting and counter sections into separate slides, including "what didn't work" (which tasks, if any, didn't improve).
- For an email version, compress to: "Configuration tool redesign: task time 236s → 69s across 4 tasks (NN/g-style usability study). Asking for sign-off to roll out broader; we'll track error rate during rollout to confirm the gain holds." (See [`templates.md`](references/templates.md), Cross-cutting rules.)

## Common Pitfalls

These apply across all three formats. Each is also covered in the references for specific cases.

- **Burying the lead.** Background, methodology, or caveats before the headline. The first sentence (or slide headline) must carry the story alone — inverted-pyramid structure ([NN/g](https://www.nngroup.com/articles/inverted-pyramid/)). Detailed in [`templates.md`](references/templates.md).
- **Missing counter-metric.** Reporting only the win. Stakeholders read single-metric wins as advocacy, not analysis. Pair every primary with a counter — see [`business-language.md`](references/business-language.md), Counter-metric framing.
- **Design jargon for an exec audience.** "Improved usability", "user friction", "cleaner UI" don't map to a budget line. Translate to support cost, drop-off, error rate. Translation table in [`business-language.md`](references/business-language.md).
- **Numbers without sample size or time window.** "Completion is up 15%" with no n and no period is a guess. Always state both.
- **Estimates without assumptions.** A revenue figure with no stated assumption invites the wrong question ("how did you get that?") instead of the right one ("what should we do next?"). Show the assumption inline.
- **Vanity counter-metric.** "Engagement up too" is not a guardrail. The counter-metric is the one you would be embarrassed to show if it had moved the wrong way ([`business-language.md`](references/business-language.md)).
- **Retro that reads like a launch announcement.** Retros are for learning, not selling. If every slide says "we won," the team learns nothing — see [`templates.md`](references/templates.md), Format 3.
- **Naming analytics tools unprompted.** Do not name specific tools (Mixpanel, Amplitude, PostHog, Heap, GA4, etc.) unless the user has already named one. Ask first: "What tool is the data coming from?"

## Red Flags

When the user's situation triggers any of these, do not draft the output. Refuse or redirect.

- **Dishonest framing requested.** "Make it look like a clear win" / "downplay the retention drop" / "leave out the counter-metric so it lands cleaner". Refuse. Hiding bad numbers costs more credibility than the numbers themselves, and the bad news will surface from someone else (Sharon, [*It's Our Research*](https://shop.elsevier.com/books/its-our-research/sharon/978-0-12-385130-7), Ch. 5). Offer to frame the mixed result honestly instead.
- **Single-metric victory claim.** User wants a slide that reports only the win, no counter. Refuse the framing — every primary metric needs a guardrail. If there genuinely is no relevant counter-metric, say so explicitly on the slide rather than implying one exists.
- **Numbers not yet validated.** User has not yet confirmed whether the change is signal or noise. Redirect to `metrics-diagnose` before drafting any output. Drafting first and validating later wastes a draft and risks shipping the wrong story.
- **No data, planning the measurement.** User is at the design phase, asking how they will *eventually* present results. Redirect to `metrics-ux` to plan the measurement; come back here once results exist.
- **Out-of-scope (revenue, MRR, monetization).** Conversion (free → paid), revenue churn, LTV are deferred to `metrics-product` v2. Tell the user explicitly.
- **Audience mismatch unresolved.** User insists on one format ("just give me the slide") when the audience genuinely needs a different one (a CFO over Slack ≠ a board deck). Surface the mismatch; let the user choose, but flag the cost of the wrong format.
- **Wrong skill.** If the user is picking metrics → `metrics-ux`. If writing the pre-launch plan / decision rule → `metrics-spec`. If designing the tracking plan → `metrics-instrumentation`. If diagnosing a movement → `metrics-diagnose`. If stress-testing the claim before publishing → `metrics-review`. If asking for HEART definitions → `metrics-basics`.
