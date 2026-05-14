# Metrics Skills

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](VERSION)

A data analyst in five Claude Code skills. Pick the right metric, explain why a number moved, defend the result — without the analyst.

## Install

### Claude Code (recommended)

```
/plugin marketplace add nemanli/metrics-skills
/plugin install metrics-skills@metrics-skills
```

**SSH errors?** The marketplace clones repos via SSH. If you don't have SSH keys set up on GitHub, either [add your SSH key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh) or use the full HTTPS URL to force HTTPS cloning:

```
/plugin marketplace add https://github.com/nemanli/metrics-skills.git
/plugin install metrics-skills@metrics-skills
```

**Or, clone locally:**

```bash
git clone https://github.com/nemanli/metrics-skills.git
claude --plugin-dir /path/to/metrics-skills
```

For symlink or copy install, see [docs/install-claude-code.md](docs/install-claude-code.md).

## Skills

| Skill | Role | Use when |
|---|---|---|
| `metrics-ux` | Pick metrics | Choosing what to measure |
| `metrics-diagnose` | Explain why a number moved | A metric moved unexpectedly |
| `metrics-present` | Build the stakeholder story | Communicating results to stakeholders |
| `metrics-basics` | Shared foundation | Learning HEART, terms, or measurement philosophy |
| `metrics-help` | Fallback router | The prompt is ambiguous |

## The problem

UX and product designers are asked to defend their work with numbers. Most don't have a data analyst on call. The common failure modes:

- **Vanity metrics** — page views and session counts that say nothing about the design change.
- **Single-number victory claims** — "+15% conversion" without a counter-metric, sample size, or significance.
- **Generic AI tools** — they hallucinate benchmarks and recommend "industry averages" that don't exist.
- **Stakeholder pushback** — the CPO names a metric, you disagree, you lose the room.

## What you get

- **Specific recommendations.** Skills ask 1–4 anchor questions (stage, audience, data availability, scope) before suggesting anything. No generic HEART dump.
- **Honest math.** Significance tests, sample-size rules, counter-metrics. If a 14% lift isn't statistically meaningful, you'll be told.
- **Sourced references.** Every concrete claim links to a primary source (NN/g, Baymard, MeasuringU, ACSI) or is marked as industry-cited.
- **Stakeholder language.** Translates design findings into PM-, leadership-, or board-ready stories with the format each audience expects.
- **No fabricated benchmarks.** If a number isn't in the source material, the skill says "I don't know" instead of inventing one.

## How skills work

Each skill is a folder under `skills/` with:

- `SKILL.md` — frontmatter (name, description, when to trigger) plus the main instructions.
- `references/` — deeper material the skill loads on demand (frameworks, checklists, formulas).
- `evals/` — prompts and rubrics used to test skill behavior.

The agent reads frontmatter to decide when to load a skill, then follows the instructions inside.

## License

[MIT](LICENSE)
