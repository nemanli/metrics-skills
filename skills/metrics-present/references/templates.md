# Templates

Three output formats for presenting design metrics. Pick by audience and channel:

| Format | Audience | Channel | Length |
|---|---|---|---|
| Stakeholder email | PM, eng lead, single decision-maker | Inline message | 1 paragraph + numbers + ask |
| Board slide | Exec, board, quarterly review | One slide | Headline + 3 supporting + 1 counter-metric |
| Retro deck | Cross-functional team | 3–5 slides | Before/after + what worked + what didn't |

Why three: stakeholders need different information at different times, communicated in different ways. Contributors need frequent, specific updates; executives need short, decision-ready summaries ([Atlassian Team Playbook — Stakeholder Communications Plan](https://www.atlassian.com/team-playbook/plays/stakeholder-communications-plan)).

A guiding principle from two writing cultures: **clear writing requires clear thinking** ([Slab — How Stripe Built a Writing Culture](https://slab.com/blog/stripe-writing-culture/)). Amazon enforces the same idea by banning slide decks in favour of six-page narrative memos — Bezos's argument is that "PowerPoint-style presentations somehow give permission to gloss over ideas, flatten out any sense of relative importance, and ignore the interconnectedness of ideas" ([CNBC — Bezos on the six-page memo](https://www.cnbc.com/2018/04/23/what-jeff-bezos-learned-from-requiring-6-page-memos-at-amazon.html)). Draft narrative first; convert to slides only when the audience demands it.

## Format 1 — Stakeholder email

### Structure

1. **Headline** — one sentence stating the outcome and the change. No preamble.
2. **Numbers** — primary metric (before → after, sample size, time window). One counter-metric.
3. **Why it changed** — one sentence linking the design change to the metric movement.
4. **Ask** — what you want from the recipient: a decision, a sign-off, a meeting, or "just visibility, no action."

### Why this order

The first sentence carries the load. Recipients on mobile, in a hurry, or in deep focus often read only that. This is the **inverted pyramid** structure from journalism: most important information first, supporting detail after, so the reader can stop at any point and still have the story ([NN/g — Inverted Pyramid: Writing for Comprehension](https://www.nngroup.com/articles/inverted-pyramid/)). If you bury the lead, the message fails.

### Filled example (illustrative numbers)

> **Subject:** Onboarding completion up 15 pp after step 2 redesign — sign-off needed
>
> We shipped the redesigned step 2 of onboarding two weeks ago. Completion rose from 47% to 62% (n = 4,820, 14 days post-launch). Day-7 retention held flat at 38% — the lift didn't come at the cost of stickiness.
>
> The change reduced required fields from 7 to 3 and moved phone verification to a later step. Drop-off at step 2 fell from 31% to 14%.
>
> **Ask:** sign-off to roll out to the remaining 50% of traffic this Friday. If you have concerns, reply by Thursday EOD.

### Pitfalls

- **Subject lines that hide the news.** "Onboarding update" is invisible. "Onboarding completion +15 pp — sign-off needed" gets opened.
- **Numbers without sample size.** A 15 pp lift with n = 40 is noise; with n = 4,820 it's signal. Always state n.
- **Asking for "thoughts."** Recipients read "thoughts" as "no action needed" and don't reply. Ask for a specific decision with a deadline.

## Format 2 — Board slide

### Structure

```
[ Headline: outcome in business terms, one line ]

Primary metric: [ before ] → [ after ]   ([ Δ ], n = [ N ])
Supporting:    [ metric 2 ]: [ value ]
               [ metric 3 ]: [ value ]
Counter:       [ guardrail metric ]: [ value, "held flat" or "moved by X" ]

[ One-line interpretation: what this means for the business ]
```

### Why this shape

Executives scan, they don't read. The headline must work alone — if the slide were photographed and shared without context, the headline still tells the story. This is the same inverted-pyramid logic as the email format ([NN/g](https://www.nngroup.com/articles/inverted-pyramid/)). Three supporting metrics show breadth; one counter-metric shows honesty (see [`business-language.md`](business-language.md) for counter-metric pairing rules).

### Filled example (real case)

Adapted from the canonical Spool $300M Button case ([Center Centre](https://articles.centercentre.com/three_hund_million_button/)) — a published, verifiable outcome. Verified figures appear without brackets; metrics that *would* be reported in a real version of this slide but were not published in the case appear in [brackets].

```
Removing forced registration at checkout recovered $300M in annual sales

Primary:      Number of customers purchasing: +45%
Supporting:   First-month incremental revenue: $15M
              First-year incremental revenue: $300M
              [Counter: chargeback / refund rate — not reported in source;
               you would track this in a real rollout to confirm guest
               checkout doesn't raise abuse risk]

Annualised revenue recovery: $300M (verified, first 12 months post-launch)
```

The bracketed counter-metric line is the shape of what you would add in a real-world version of this slide — Spool's original case did not report it. The same template works for smaller cases. Replace the headline, primary metric, supporting metrics, and counter-metric with your own — keep the structure.

### Pitfalls

- **Three metrics that all measure the same thing.** Conversion, completion, and success rate are often the same metric in three names. Pick distinct angles: outcome, efficiency, satisfaction.
- **Counter-metric that's actually a vanity metric.** "Engagement up too" is not a guardrail. A real counter-metric is the one you'd be embarrassed to show if it moved the wrong way.
- **Estimates without assumptions.** A revenue figure with no stated assumption invites the wrong question ("how did you get that number?") instead of the right one ("what should we do next?").

## Format 3 — Retro deck

### Structure

3–5 slides. Mandatory sections:

1. **Goal & hypothesis** — what we set out to change and why we thought the design would change it.
2. **Before / after** — primary metric, supporting metrics, counter-metric. Same numbers as the board slide, more context.
3. **What worked** — design decisions that moved the metric. Be specific about the cause.
4. **What didn't** — failed hypotheses, unexpected drops, tests that showed nothing. **This section is non-negotiable.**
5. **What we'd do differently** — one or two concrete changes to the next iteration.

### Why "what didn't" is mandatory

Most experiments don't ship as wins. Spotify's experimentation team reports a learning rate (~64%) that far exceeds the win rate, and treats "successful experiment" as one that delivers trustworthy insight, not necessarily a positive outcome ([Spotify Engineering — Beyond Winning](https://engineering.atspotify.com/2025/9/spotifys-experiments-with-learning-framework)). Hiding failures destroys this. Reporting them builds the team's collective memory and prevents repeated mistakes.

Sharon's research storytelling principle applies: research presentations that omit contradicting evidence lose stakeholder trust over time ([Sharon — It's Our Research, Ch. 5](https://shop.elsevier.com/books/its-our-research/sharon/978-0-12-385130-7)).

### Filled example (skeleton — illustrative numbers, not a real case)

The numbers below show the *shape* of a complete retro, not a published outcome. Use the structure; substitute your own measured values.

```
Slide 1 — Goal
We set out to reduce cart abandonment in mobile checkout (62% in Q1).
Hypothesis: removing the address auto-validation step would reduce
friction without increasing post-purchase address-correction tickets.

Slide 2 — Before / After
Cart-to-purchase rate:  58% → 65%   (+7 pp, n = 142,000)
Avg. checkout time:     3:14 → 1:48
Address-correction tickets:  +6% (small, expected)

Slide 3 — What worked
- Removing inline validation cut typing time by ~40%.
- Fallback validation at order confirmation caught 94% of typos.

Slide 4 — What didn't
- A/B variant with auto-fill from past orders showed no lift (n = 31,000).
- Hypothesised return-user signal didn't predict checkout speed.

Slide 5 — Next
- Ship the validated change to 100%.
- Drop the auto-fill experiment.
- Investigate the +6% support tickets — is it acceptable cost or worth fixing?
```

### Pitfalls

- **Retro that reads like a launch announcement.** Retros are for learning, not selling. If every slide says "we won," the team learns nothing.
- **Vague "what didn't."** "We could have moved faster" is not a learning. "Variant B showed no lift at n = 31,000 — auto-fill hypothesis was wrong" is.
- **No "what we'd do differently."** Without it, the retro produces no future change.

## Cross-cutting rules

- **Lead with the headline.** All three formats put the outcome first; background, methodology, and caveats come later (inverted-pyramid structure, [NN/g](https://www.nngroup.com/articles/inverted-pyramid/)).
- **State sample size and time window.** Every primary metric needs both. A number without n is a guess.
- **Pair primary with counter.** Every format includes at least one counter-metric. See [`business-language.md`](business-language.md) for pairing examples.
- **Translate to business terms when the audience needs it.** Email and board slide → translate. Retro deck → keep design vocabulary; the team needs traceability to the craft.
- **Match length to context.** The stakeholder email above is the long form. For tight contexts (Slack DM, exec on mobile, chat with a CFO who already knows the project), compress to 1–2 sentences: "Onboarding completion 47% → 62% (n=4,820, 14d). Day-7 retention flat. Asking for sign-off to roll to 100% by Friday." Same structure (headline + numbers + ask), shorter form.

## See also

- [`business-language.md`](business-language.md) — design-to-business translation pairs and counter-metric framing
- [`../../metrics-basics/references/measurement-philosophy.md`](../../metrics-basics/references/measurement-philosophy.md) — when measurement adds value vs theatre
- [`../../metrics-diagnose/references/hypothesis-tests.md`](../../metrics-diagnose/references/hypothesis-tests.md) — statistical tests behind the numbers cited in templates
