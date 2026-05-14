# Install — Claude Code

Five skills: `metrics-basics`, `metrics-ux`, `metrics-diagnose`, `metrics-present`, `metrics-help`.

**Prerequisites:** [Claude Code](https://claude.ai/code) installed and authenticated.

## Method 1 — Plugin install (recommended)

Use Claude Code's built-in plugin system. No clone needed.

```
/plugin marketplace add https://github.com/nemanli/ux-metrics-skills.git
/plugin install ux-metrics-skills@ux-metrics-skills
```

Plugin files land in `~/.claude/plugins/marketplaces/ux-metrics-skills/`. To update, re-run the install command.

## Method 2 — Local plugin directory (for development)

Point Claude Code directly at a cloned repo. Useful when iterating on skills.

```bash
git clone https://github.com/nemanli/ux-metrics-skills.git
claude --plugin-dir /path/to/ux-metrics-skills
```

Edits to the cloned repo reflect on the next session start.

## Method 3 — Symlink to ~/.claude/skills/ (advanced)

Bypasses the plugin system. Skills load from the user-level skills directory.

```bash
git clone https://github.com/nemanli/ux-metrics-skills.git
mkdir -p ~/.claude/skills

ln -s /path/to/ux-metrics-skills/skills/metrics-basics   ~/.claude/skills/metrics-basics
ln -s /path/to/ux-metrics-skills/skills/metrics-ux       ~/.claude/skills/metrics-ux
ln -s /path/to/ux-metrics-skills/skills/metrics-diagnose ~/.claude/skills/metrics-diagnose
ln -s /path/to/ux-metrics-skills/skills/metrics-present  ~/.claude/skills/metrics-present
ln -s /path/to/ux-metrics-skills/skills/metrics-help     ~/.claude/skills/metrics-help
```

Replace `/path/to/ux-metrics-skills` with the absolute path where you cloned the repo (e.g. `/Users/yourname/Desktop/ux-metrics-skills`).

For a non-development install, use `cp -r` instead of `ln -s` and re-copy when the repo updates.

## Verify installation

Open a new Claude Code session and ask:

```
What skills do you have available?
```

You should see all five metrics skills listed.

For Method 1 (plugin), check `~/.claude/plugins/marketplaces/ux-metrics-skills/`.  
For Method 3 (symlink), check `~/.claude/skills/`.

## Validate the skill files

From the repo root:

```bash
bash scripts/validate-skills.sh
```

Expected output: `Checked 5 SKILL.md, 13 references. 0 error(s).`

**Windows users:** run via WSL or Git Bash. The script uses standard POSIX tools (`bash`, `awk`, `grep`, `find`).

## Troubleshooting

**Skills not showing up after install**  
Skills load at session start. Close and reopen Claude Code after installing.

**Plugin install failed**  
Check the marketplace was added: `/plugin marketplace list`. If missing, re-run `/plugin marketplace add`.

**Symlink shows but skill content missing** (Method 3)  
Check the symlink target: `ls -la ~/.claude/skills/metrics-ux` should show the absolute path to your repo. If the path has moved, remove and recreate the symlink.

**validate-skills.sh reports errors**  
The script prints one line per failure. Fix the flagged issue and re-run. Common causes: a reference file grew past 200 lines, or a markdown link path changed after a file move.

**Wrong skill triggers**  
Skills auto-select based on their `description` field. If the wrong skill triggers, start a new session and rephrase your prompt to match the target skill's signals. Use `/metrics-help` if unsure.

## Uninstall

**Method 1 — Plugin:**

```
/plugin uninstall ux-metrics-skills@ux-metrics-skills
```

**Method 2 — Local plugin directory:** stop passing `--plugin-dir` on Claude Code launch.

**Method 3 — Symlink/copy:**

```bash
rm -rf ~/.claude/skills/metrics-basics
rm -rf ~/.claude/skills/metrics-ux
rm -rf ~/.claude/skills/metrics-diagnose
rm -rf ~/.claude/skills/metrics-present
rm -rf ~/.claude/skills/metrics-help
```
