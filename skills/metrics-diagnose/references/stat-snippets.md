# Stat snippets

Copy-paste Python snippets for the four tests in [SKILL.md](../SKILL.md) Step 4. Run locally; paste the output back into the conversation if a follow-up interpretation is needed.

All snippets use `scipy` and `statsmodels` — both standard in any data-analysis Python install. If neither is available, the `requirements` line at the top of each block lists what to install.

Never paraphrase a snippet's output from memory. The whole point is that the numbers come from a real computation.

---

## Two-proportion z-test (Wilson CI)

Use when comparing two proportions: success rate, retention rate, adoption rate, drop-off, conversion.

```
# requirements: pip install statsmodels
from statsmodels.stats.proportion import proportions_ztest, confint_proportions_2indep
import math

# --- inputs ---
x1, n1 = 888, 1200    # before: successes, total
x2, n2 = 702, 1150    # after:  successes, total

p1, p2 = x1/n1, x2/n2
diff = p2 - p1

# z-test
stat, pval = proportions_ztest([x1, x2], [n1, n2])

# Wilson CI on the difference
ci_low, ci_high = confint_proportions_2indep(x2, n2, x1, n1, method="wald")

# Cohen's h (effect size for proportions)
h = 2 * (math.asin(math.sqrt(p2)) - math.asin(math.sqrt(p1)))

print(f"p1={p1:.4f}  p2={p2:.4f}  diff={diff:+.4f}")
print(f"z={stat:.3f}  p-value={pval:.4g}")
print(f"95% CI on diff: [{ci_low:+.4f}, {ci_high:+.4f}]")
print(f"Cohen's h = {h:.3f}  (small≈0.2, medium≈0.5, large≈0.8)")
```

Decision rule lives in [SKILL.md](../SKILL.md) Step 4 — match `p-value` and effect size to the four-row decision table.

---

## Welch's t-test (unequal variances)

Use for continuous metrics: time on task, session duration, NPS score, SUS score.

```
# requirements: pip install scipy numpy
from scipy import stats
import numpy as np

# --- inputs (raw observations, not summaries) ---
before = np.array([...])   # paste before-period values
after  = np.array([...])   # paste after-period values

t, pval = stats.ttest_ind(before, after, equal_var=False)

m1, m2 = before.mean(), after.mean()
s1, s2 = before.std(ddof=1), after.std(ddof=1)
n1, n2 = len(before), len(after)

# 95% CI on the mean difference (Welch's df)
diff = m2 - m1
se = (s1**2/n1 + s2**2/n2) ** 0.5
df = (s1**2/n1 + s2**2/n2)**2 / ((s1**2/n1)**2/(n1-1) + (s2**2/n2)**2/(n2-1))
crit = stats.t.ppf(0.975, df)
ci_low, ci_high = diff - crit*se, diff + crit*se

# Cohen's d (pooled SD)
pooled = (((n1-1)*s1**2 + (n2-1)*s2**2) / (n1+n2-2)) ** 0.5
d = diff / pooled

print(f"mean1={m1:.3f}  mean2={m2:.3f}  diff={diff:+.3f}")
print(f"t={t:.3f}  p-value={pval:.4g}  df={df:.1f}")
print(f"95% CI on diff: [{ci_low:+.3f}, {ci_high:+.3f}]")
print(f"Cohen's d = {d:.3f}  (small≈0.2, medium≈0.5, large≈0.8)")
```

If only summary statistics (mean, SD, n) are available rather than raw observations, use `scipy.stats.ttest_ind_from_stats` instead and compute the CI by hand from the printed `t` and `se`.

---

## Chi-square test of independence

Use for categorical count data: events per user bucketed into categories, error type distribution.

```
# requirements: pip install scipy
from scipy.stats import chi2_contingency

# --- inputs: 2D contingency table (rows = groups, cols = categories) ---
table = [
    [120,  80, 50],   # before:  category A, B, C counts
    [ 95, 110, 45],   # after:   category A, B, C counts
]

chi2, pval, dof, expected = chi2_contingency(table)

# Cramer's V (effect size)
n = sum(sum(row) for row in table)
min_dim = min(len(table) - 1, len(table[0]) - 1)
v = (chi2 / (n * min_dim)) ** 0.5

print(f"chi2={chi2:.3f}  p-value={pval:.4g}  dof={dof}")
print(f"Cramer's V = {v:.3f}  (small≈0.1, medium≈0.3, large≈0.5)")
print(f"Expected counts (check each ≥5 for chi-square validity):\n{expected}")
```

If any expected cell count is below 5, switch to Fisher's exact test (`scipy.stats.fisher_exact`) for 2x2 tables, or collapse low-count categories.

---

## MDE / power check (proportions)

Use when the z-test was **not significant** to check whether the test was underpowered. Computes the minimum detectable effect at 80% power for the current sample size.

```
# requirements: pip install statsmodels
from statsmodels.stats.power import NormalIndPower
from statsmodels.stats.proportion import proportion_effectsize

# --- inputs ---
p1 = 0.42           # baseline rate
n_per_group = 80    # current sample size per group
alpha = 0.05
power = 0.80

analysis = NormalIndPower()
# solve for the effect size (Cohen's h) detectable at the given n
h_mde = analysis.solve_power(effect_size=None, nobs1=n_per_group,
                             alpha=alpha, power=power, alternative="two-sided")

# convert Cohen's h back to a percentage-point MDE around p1
import math
phi1 = 2 * math.asin(math.sqrt(p1))
phi2 = phi1 + h_mde
p2_min = math.sin(phi2 / 2) ** 2
mde_pp = (p2_min - p1) * 100

print(f"At n={n_per_group}/group, baseline {p1:.0%}:")
print(f"  Cohen's h detectable = {h_mde:.3f}")
print(f"  MDE ≈ {mde_pp:+.1f} percentage points at 80% power")
```

Interpretation: if the observed change in the user's data is **smaller** than this MDE, the non-significant result means "underpowered," not "no effect." Report this back to the user explicitly — see [SKILL.md](../SKILL.md) Step 4 decision rule, row 4.

---

## Output format reminder

Every snippet result reported back to the user must follow the Step 4 block format:

> **Signal vs noise:** [Significant / Not significant / Underpowered]. [Test name], p=[value], 95% CI on the difference: [lower, upper], effect size [h/d]=[value] ([small/medium/large]). [One-sentence practical interpretation.]

The numbers in brackets come from the snippet output, not from memory.
