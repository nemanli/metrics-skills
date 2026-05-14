# Context questions — 4 anchors

The agent uses these to decide what is missing before recommending metrics. Four anchors: **SCOPE**, **STAGE**, **AUDIENCE**, **DATA**. For each anchor, mark **present** or **missing**. Order matters — each answer narrows the space for the next.

**Explicit vs inferred present.** Some anchors are spelled out in the prompt ("we use Amplitude" → DATA explicit). Others are inferred from intent or framing ("I want to learn what worked" → AUDIENCE inferred as self). Treat both as present — but when inferred, briefly state the inference back to the user ("assuming this is for your own learning, …") so they can correct it. Never silently extend an inferred value into recommendations the user did not ask for.

---

## SCOPE — what is being measured

**Question.** Which product or feature do you want to set metrics for, and what specifically?

**Options.** SCOPE is usually free-text (named feature, flow, screen). Ask inline as a short sentence — no numbered options. Only offer numbered options if you can draw 2–3 concrete choices from the user's own prompt (e.g. they mentioned "onboarding and checkout" — Onboarding / Checkout / Both).

**Why we ask.** Without a clear scope, every metric recommendation is noise. SCOPE anchors the conversation to something concrete — a flow, screen, or feature — and prevents the designer from measuring "everything" or nothing at all.

| Prompt fragment | SCOPE | Reason |
|---|---|---|
| "I redesigned onboarding" | present | named feature: onboarding |
| "the new pricing page is live" | present | named feature: pricing page |
| "task success on checkout step 3" | present | scoped to a specific step |
| "we shipped a dashboard for power users" | present | named feature + audience |
| "How do we improve retention?" | missing | "retention" is a metric, not a scope |
| "metrics for our product" | missing | "product" too generic |
| "engagement is dropping" | missing | metric mentioned, no scope |
| "what should we track this quarter?" | missing | timeframe only, no feature |

---

## STAGE — pre-launch / just launched / mature

**Question.** What stage is this work at — pre-launch, just launched, or mature?

**Options.** Three standard choices, reorder so the most likely one (given the prompt) appears first:
- **Pre-launch** — not shipped yet, no real users.
- **Just launched** — shipped within the last 4–5 weeks, baseline still forming.
- **Mature** — live for months or longer, stable baseline.

**Why we ask.** Stage determines the entire measurement approach. Pre-launch means no behavioral data — we plan, not analyze. Just launched means we're establishing a baseline. Mature means we're looking for trends, regressions, or optimization. Recommending a retention curve to a pre-launch product is wasted advice.

| Prompt fragment | STAGE | Reason |
|---|---|---|
| "we're launching next month" | present | pre-launch |
| "in beta, opening to general users next week" | present | pre-launch (closed beta = no broad signal yet) |
| "shipped last week, want to set up tracking" | present | just launched (baseline not yet stable) |
| "shipped 3 weeks ago" | present | just launched (still inside baseline window) |
| "shipped 5 weeks ago" | present | just launched (end of baseline window — borderline) |
| "live for 6 months" | present | mature (baseline stable, trend signal possible) |
| "this feature has been live for 2 years" | present | mature |
| "users have been complaining since the redesign" | present | mature (post-release) |
| "I'm working on a redesign" | missing | unclear if shipping soon or mature feature being changed |
| "metrics for the new feature" | missing | "new" is ambiguous (pre-launch? just launched?) |
| "we want to measure adoption" | missing | metric named, stage unclear |

Boundary heuristic: pre-launch = no real users yet; just launched = baseline still forming (typically 2–3 weeks for daily-use products, 4–5 weeks for weekly-use products — [NN/g benchmarking guidance](https://www.nngroup.com/articles/product-ux-benchmarks/)); mature = stable baseline available.

---

## AUDIENCE — what the data is for and who sees it

**Question.** What will you do with the data, and who will you present results to?

**Options.** Four standard choices, reorder by prompt fit:
- **Self / own learning** — diagnostic depth, design vocabulary OK.
- **Team retro** — process improvement, "what didn't work" included.
- **PM / eng lead** — single decision-maker, short email-style.
- **Leadership / board** — business language, headline + counter-metric mandatory.

**Why we ask.** The same metric serves different purposes depending on the audience. A designer proving impact to themselves needs a diagnostic. A designer presenting to a CPO needs a business story. AUDIENCE drives output format, depth, and language.

| Prompt fragment | AUDIENCE | Reason |
|---|---|---|
| "I want to learn what worked" | present (inferred) | "learn" → self-directed; user did not state audience explicitly |
| "for the quarterly review with leadership" | present | leadership (business story) |
| "I need to defend this to the CPO" | present | leadership (defence) |
| "the team will use this in retros" | present | team (process improvement) |
| "for the design impact report" | present (inferred) | report context → leadership/stakeholders, not stated explicitly |
| "what should we measure?" | missing | no use case stated |
| "I want to measure our redesign" | missing | purpose unclear |
| "track engagement properly" | missing | "properly" doesn't reveal audience |

---

## DATA — what analytics and tools are in place

**Question.** What data and analytics tools do you already have set up?

**Options.** Four standard choices:
- **Full event tracking** — Amplitude / Mixpanel / PostHog / Heap with events instrumented. All metrics in scope.
- **Funnels only** — basic funnel reporting, limited event coverage. Multi-step diagnostics OK; per-user medians limited.
- **GA / page-level only** — page views and traffic, no product events. Most behavioral metrics out of reach.
- **None / starting from scratch** — recommend qualitative methods + plan to instrument.

Do not name a specific tool inside an option label unless the user has already named one in the prompt — keep the labels generic.

**Why we ask.** Feasibility is non-negotiable. Recommending cohort retention analysis to a team with no analytics setup sets them up to fail. DATA filters the recommendation to what can actually be measured today — and flags what needs to be set up first.

| Prompt fragment | DATA | Reason |
|---|---|---|
| "we have Amplitude set up" | present | tool named |
| "no analytics yet, just Google Analytics on the marketing site" | present | DATA known absent — recommend qualitative methods + instrumentation setup, not behavioral metrics |
| "PostHog is in place, all events tracked" | present | tool + coverage |
| "we use Mixpanel but only for funnels" | present | tool + scope of coverage |
| "I'll need to instrument this from scratch" | present | DATA known absent — same action as above (qual + setup) |
| "what should I measure?" | missing | tooling not mentioned |
| "metrics for the new flow" | missing | feasibility unknown |
| "we want better data" | missing | "better" doesn't reveal current state |

---

## Examples — full prompt parsing

**Prompt 1:** "I redesigned onboarding, what should I measure?"
- SCOPE: present (onboarding)
- STAGE: missing (pre-launch? just shipped?)
- AUDIENCE: missing (self? leadership?)
- DATA: missing (no tooling mentioned)
- **Action:** 3 missing → ask numbered list (STAGE / AUDIENCE / DATA)

**Prompt 2:** "Task success on the new checkout dropped from 74% to 61% after last week's release. We use Amplitude. I need to figure out why before the team retro on Friday."
- SCOPE: present (checkout)
- STAGE: present (just launched, post-release)
- AUDIENCE: present (team retro)
- DATA: present (Amplitude)
- **Action:** 0 missing → recommend metrics directly (likely diagnose path)

**Prompt 3:** "I redesigned the settings page last month. Want to learn what to do better next time."
- SCOPE: present (settings page)
- STAGE: present (just launched — "last month" = ~4 weeks, end of baseline window)
- AUDIENCE: present (inferred) — "learn what to do better" → self-directed
- DATA: missing (no tooling mentioned)
- **Action:** 1 missing → ask focused DATA question. Confirm the inference: *"Assuming this is for your own learning rather than a stakeholder report — let me know what analytics you have set up."*

**Prompt 4:** "metrics"
- All 4 missing
- **Action:** full questionnaire, all 4 questions in order

---

## Decision logic

After parsing the prompt against all 4 anchors, the agent acts on the count of missing anchors:

| Missing count | Agent action |
|---|---|
| 0 | Recommend metrics directly. Cite the anchor values you inferred. |
| 1 | Ask one focused question. Single sentence. |
| 2–3 | Ask one numbered list (one question per missing anchor). |
| 4 | Use the full questionnaire (all 4 questions, in order). |

Rules:
- Never re-ask what the user already provided.
- Maximum 4 questions per session.
- If the user partially answers, mark the anchor present and move on.

---

## How to ask

Shared convention for every skill in this repo — not just the 4 anchors above. When a skill needs to ask the user something (context anchors, missing CSV fields, audience confirmation, mode disambiguation), keep it short and inline.

**Format.** Inline numbered list. 1–4 questions per turn. Each question gets 2–4 mutually exclusive options. Keep options to 1–5 words each, with a one-sentence description if the meaning is not obvious.

**When to ask:**
- Context anchors (SCOPE / STAGE / AUDIENCE / DATA) in vague mode.
- Mode disambiguation when the prompt could fit two skills or two paths.
- Missing CSV fields in `metrics-diagnose` Step 1 (which column is sample size, which value is before vs after).
- Audience confirmation in `metrics-present` (PM / leadership / board / retro).
- Verify question at the end of a recommendation — only when the user has a real choice between narrowing options. A simple "does this fit?" stays inline.

**When to skip:**
- One-sentence clarifications with no real options ("did you ship to all users or a subset?") — ask inline without numbered options.
- Free-text answers the user must write themselves (CSV column names, custom thresholds). Numbered options are for closed choices, not open input.
- Direct mode — no questions at all; answer the prompt.

**Where the options come from.** Do not invent options from scratch:

| Topic | Source of options |
|---|---|
| STAGE / AUDIENCE / DATA / SCOPE | the "Options" block under each anchor above |
| Format pick (email / slide / retro) | `metrics-present/references/templates.md` |
| Mode disambiguation | the skill's own "Mode detection" table |
| CSV column mapping (free text) | not a closed choice — ask inline |

**Adapt to the prompt:**
- **Reorder.** Put the option that fits the prompt's signals first. "I redesigned onboarding last sprint" → STAGE list leads with "Just launched", not "Pre-launch".
- **Drop irrelevant options.** If the user already said "shipped 2 weeks ago", do not show STAGE at all — it is present.
- **Tighten descriptions.** Replace generic copy with the user's own scope ("Just launched — onboarding shipped 2 weeks ago, baseline still forming") so the list reads as situated, not boilerplate.
