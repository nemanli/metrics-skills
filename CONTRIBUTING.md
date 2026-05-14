# Contributing to metrics-skills

Thanks for your interest in contributing! This is a collection of skills that help UX designers choose, diagnose, and present UX and product metrics.

## Adding a New Skill

1. Open an issue first to align on scope before building.
2. Create a directory under `skills/` with a kebab-case name.
3. Add a `SKILL.md` with YAML frontmatter: `name`, `description`, `allowed-tools`.
4. Add reference files under `skills/<name>/references/` for content that doesn't fit in `SKILL.md`.
5. Run `bash scripts/validate-skills.sh` — must exit 0 before opening a PR.

The `description` field controls auto-triggering. Use the "Use when X. Skip for Z." pattern — list the situations that should trigger the skill, then explicitly list what should not. Example:

```
description: Use when the user asks how to measure UX outcomes. Use when the user describes a redesign and wants metrics. Skip for diagnosing a metric drop (use metrics-diagnose). Skip for stakeholder presentations (use metrics-present).
```

The `allowed-tools` field lists which Claude tools the skill is permitted to use (e.g. `Read` for skills that load CSVs). Leave it empty if the skill only generates text.

Specific triggers and explicit skips reduce false positives — without them, skills steal each other's prompts.

## Skill Quality Bar

Skills should be:

- **Specific** — actionable steps, not vague advice
- **Grounded** — every concrete claim needs a source: a primary reference (paper, official doc, author's own publication) or a widely-cited industry practice
- **Minimal** — only the content needed to guide the agent correctly

## Structure

Three profiles:

| Profile | Skills | Required sections |
|---|---|---|
| A — Content | metrics-ux, metrics-diagnose, metrics-present | Overview, When to Use, Process, Example, Common Pitfalls, Red Flags |
| B — Foundational | metrics-basics | Overview, When to Use, References |
| C — Router | metrics-help | Overview, When to Use, Routing |

Line limits: `SKILL.md` ≤ 500 lines · reference files ≤ 200 lines. If you hit the limit, move content to a reference file — don't compress meaning.

A skill may read a reference file from another skill. A skill may not invoke another skill directly.

## What Not to Do

- Don't duplicate content between skills — link to shared references instead
- Don't add vague guidance that isn't actionable
- Don't put reference material inside the skill directory root — use `references/`
- Don't make unverified claims — if there's no source, weaken ("commonly cited", "typically") or remove the claim
- Don't name analytics tools (Mixpanel, Amplitude, PostHog, etc.) unprompted — wait until the user asks or has confirmed which tools they already use

