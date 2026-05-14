<div align="center">

<img src="docs/header.svg" alt="UX Metrics Skills" width="720">

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.1-blue.svg)](VERSION)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-nemanli-0A66C2?logo=linkedin&logoColor=white)](https://www.linkedin.com/in/nemanli/)
[![X](https://img.shields.io/badge/-@azarnemanli-000000?logo=x&logoColor=white)](https://x.com/azarnemanli)
[![Website](https://img.shields.io/badge/-nemanli.com-4B0082?logo=google-chrome&logoColor=white)](https://nemanli.com/)

Eight skills that mentor a designer through a full measurement cycle — picking the right metric for a feature, instrumenting it, committing to a decision rule before shipping, reading the data once it arrives, vetting other people's claims, and defending the result to stakeholders.

</div>

## Install

### Claude Code (recommended)

```
/plugin marketplace add https://github.com/nemanli/ux-metrics-skills.git
/plugin install ux-metrics-skills@ux-metrics-skills
```

The HTTPS URL works without any SSH key setup.

<details>
<summary>Short form (requires SSH keys configured on GitHub)</summary>

```
/plugin marketplace add nemanli/ux-metrics-skills
/plugin install ux-metrics-skills@ux-metrics-skills
```

If this errors, either [add an SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh) or use the full HTTPS URL above.

</details>

<details>
<summary>Clone locally (for development)</summary>

```bash
git clone https://github.com/nemanli/ux-metrics-skills.git
claude --plugin-dir /path/to/ux-metrics-skills
```

For symlink or copy install, see [docs/install-claude-code.md](docs/install-claude-code.md).

</details>

## Skills

| Skill | Role | Use when |
|---|---|---|
| `metrics-ux` | Pick metrics | Choosing what to measure for a feature, redesign, or launch |
| `metrics-spec` | Write the measurement plan | Committing to hypothesis, primary, counter, decision rule **before** shipping |
| `metrics-instrumentation` | Design the tracking plan | Designing events, properties, naming conventions, PII rules |
| `metrics-diagnose` | Explain why a number moved | A metric moved unexpectedly and you have data |
| `metrics-review` | Stress-test a claim | Vetting an incoming claim, or hostile self-review before publishing |
| `metrics-present` | Build the stakeholder story | Communicating results to stakeholders |
| `metrics-basics` | Shared foundation | Learning HEART, terms, decision rules, tracking plans, PII |
| `metrics-help` | Fallback router | The prompt is ambiguous |

## The problem

UX and product designers are asked to defend their work with numbers. Most don't have a data analyst on call. The common failure modes:

- **Vanity metrics** — page views and session counts that say nothing about the design change.
- **Single-number victory claims** — "+15% conversion" without a counter-metric, sample size, or significance.
- **Goalpost shifting** — the success criteria get re-negotiated after the data is in.
- **Tracking-plan drift** — events named inconsistently, dashboards become unreadable, PII leaks into properties.
- **Generic AI tools** — they hallucinate benchmarks and recommend "industry averages" that don't exist.
- **Stakeholder pushback** — the CPO names a metric, you disagree, you lose the room.

## What you get

- **Specific recommendations.** Skills ask 1–4 anchor questions (stage, audience, data availability, scope) before suggesting anything. No generic HEART dump.
- **Pre-registration over post-hoc.** `metrics-spec` produces a written, signed measurement plan with a Ship/Kill/Iterate decision rule **before** the change ships — so the success criteria can't be re-negotiated after the data is in.
- **Tool-agnostic instrumentation.** `metrics-instrumentation` produces a tracking plan (events, properties, naming, PII rules) eng can implement against — no vendor lock-in.
- **Adversarial review.** `metrics-review` stress-tests claims along five axes (definition, sample, comparison, window, counter-metric) — works on incoming claims (vendor case studies, "industry benchmarks") and on your own draft before you publish.
- **Honest math.** Significance tests, sample-size rules, counter-metrics. If a 14% lift isn't statistically meaningful, you'll be told.
- **Sourced references.** Every concrete claim links to a primary source — academic (Cohen, Kerr, Strathern, Sackett, Wasserstein-Lazar ASA), industry research (Kohavi KDD 2013, Dmitriev IEEE 2016, Kohavi-Tang-Xu 2020), legal standards (GDPR, CCPA, COPPA, CONSORT), UX research (NN/g, Baymard, MeasuringU, ACSI), and platform docs (Segment Spec). No "industry-cited" hand-waving.
- **Stakeholder language.** Translates design findings into PM-, leadership-, or board-ready stories with the format each audience expects.
- **No fabricated benchmarks.** If a number isn't in the source material, the skill says "I don't know" instead of inventing one.

## How skills work

Each skill is a folder under `skills/` with:

- `SKILL.md` — frontmatter (name, description, when to trigger) plus the main instructions.
- `references/` — deeper material the skill loads on demand (frameworks, checklists, formulas).

The agent reads frontmatter to decide when to load a skill, then follows the instructions inside.

## License

[MIT](LICENSE)
