# Eval Runbook

Run before every version bump. Takes ~30 minutes.

## When to run

- Before bumping VERSION (any semver increment)
- After any SKILL.md change
- After any reference file change

## Setup

Each test must run in a **fresh Claude Code session** — never in the same chat as a previous test. Context carry-over contaminates auto-trigger testing.

Model: Claude Sonnet (latest). Effort: Medium.

## Step 1 — Run the cases

Open `evals/cases.yaml` in each skill folder. For each case:

1. Open a new Claude Code session
2. Paste the `prompt` field exactly as written
3. Copy the full response

Skills with cases:
- `skills/metrics-ux/evals/cases.yaml` — 5 cases
- `skills/metrics-diagnose/evals/cases.yaml` — 3 cases
- `skills/metrics-present/evals/cases.yaml` — 2 cases

## Step 2 — Score each case

For each response, check against `expected_behavior` and `anti_pattern` in the case file.

**Checklist scoring:**
- All `expected_behavior` items present → candidate PASS
- Any `anti_pattern` item present → FAIL

**Borderline cases:** paste the prompt + response + expected_behavior into a new Claude Code session and ask: "Act as an independent LLM judge. Did this response pass or fail? Verdict and one-line reason."

## Step 3 — Record results

Create `docs/evals-results-YYYY-MM-DD.md` with the following sections:
- Summary table (test id, skill triggered, verdict)
- Detailed results (prompt, expected, actual, verdict per case)
- Issues logged (anything worth fixing later)
- Fixes applied this session (if any mid-session fix was needed)

## Step 4 — Fix and re-test

If any case FAILs:
1. Identify the root cause (skill rule missing, anti-pattern not covered, wrong mode detection)
2. Apply the minimal fix to the relevant SKILL.md or reference file
3. Re-run the failed case in a fresh session
4. Record the fix in the results file

## Step 5 — Validate and commit

```bash
bash scripts/validate-skills.sh
```

Expected: `Checked 5 SKILL.md, 13 references. 0 error(s).`

Then commit: eval results file + any skill fixes together in one commit.

## Pass threshold

**10/10 required to ship.** Any open FAIL blocks the version bump.

## Model comparison (optional)

To compare models, run the same cases on Opus and Haiku after completing the Sonnet run. Record results in the same results file under a separate "Model comparison" section.
