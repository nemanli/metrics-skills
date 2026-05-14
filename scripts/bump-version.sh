#!/bin/bash
# bump-version.sh — update VERSION, plugin.json, and README badge in lockstep.
#
# Usage: bash scripts/bump-version.sh <semver>
# Example: bash scripts/bump-version.sh 1.1.0
#
# Exits 1 if the argument is not a semver string (MAJOR.MINOR.PATCH).

set -eu

NEW="${1:?usage: bump-version.sh <semver>}"

if ! echo "$NEW" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
  echo "error: '$NEW' is not a semver (expected MAJOR.MINOR.PATCH)" >&2
  exit 1
fi

REPO="$(cd "$(dirname "$0")/.." && pwd)"
OLD="$(cat "$REPO/VERSION" | tr -d '[:space:]')"

if [ "$OLD" = "$NEW" ]; then
  echo "VERSION already at $NEW — nothing to do"
  exit 0
fi

echo "$NEW" > "$REPO/VERSION"
sed -i.bak -E 's/"version": "[^"]+"/"version": "'"$NEW"'"/' "$REPO/.claude-plugin/plugin.json"
sed -i.bak -E 's|version-[0-9]+\.[0-9]+\.[0-9]+-blue|version-'"$NEW"'-blue|' "$REPO/README.md"
rm -f "$REPO/.claude-plugin/plugin.json.bak" "$REPO/README.md.bak"

echo "bumped $OLD → $NEW"
echo "  VERSION"
echo "  .claude-plugin/plugin.json"
echo "  README.md (badge)"
