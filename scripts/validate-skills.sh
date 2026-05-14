#!/bin/bash
# validate-skills.sh — checks every SKILL.md and reference file in skills/.
#
# Default mode (~2s): frontmatter, line counts, internal markdown links.
# --external mode (~5-15min): also verifies http(s) links return 2xx/3xx.
#
# Exit 0 = pass, 1 = fail. Prints one line per file plus a summary.

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"

CHECK_EXTERNAL=0
if [ "${1:-}" = "--external" ]; then
  CHECK_EXTERNAL=1
fi

ERRORS=0
SKILL_COUNT=0
REF_COUNT=0

# Required frontmatter fields (presence only, value may be empty).
REQUIRED_FIELDS="name description allowed-tools"

# Line limits (inclusive).
SKILL_LIMIT=500
REF_LIMIT=200

# ---------- helpers ----------

fail() {
  echo "FAIL $1"
  ERRORS=$((ERRORS + 1))
}

pass() {
  echo "OK   $1"
}

# Extract frontmatter block (between the first two --- lines) from a file.
# Echoes empty if no frontmatter.
extract_frontmatter() {
  awk '
    /^---$/ { count++; if (count == 1) next; if (count == 2) exit }
    count == 1 { print }
  ' "$1"
}

# Check that a frontmatter block contains a given field key.
# Field is present if a line starts with "<key>:" (value can be empty).
has_field() {
  local fm="$1"
  local key="$2"
  echo "$fm" | grep -qE "^${key}:"
}

# Extract relative markdown links from a file.
# Matches [text](path) where path does NOT start with http(s):// or #.
# Prints one path per line.
extract_internal_links() {
  grep -oE '\[[^]]+\]\([^)]+\)' "$1" \
    | sed -E 's/.*\(([^)]+)\).*/\1/' \
    | grep -vE '^https?://' \
    | grep -vE '^#' \
    | sed -E 's/#.*$//'
}

# Extract http(s) links from a file. One URL per line.
extract_external_links() {
  grep -oE 'https?://[^[:space:])]+' "$1" \
    | sed -E 's/[.,;:]+$//'
}

# ---------- per-file validators ----------

validate_skill_md() {
  local file="$1"
  local rel="${file#$REPO_ROOT/}"
  local issues=""

  local lines
  lines=$(wc -l < "$file" | tr -d ' ')

  if [ "$lines" -gt "$SKILL_LIMIT" ]; then
    issues="$issues; $lines lines > $SKILL_LIMIT limit"
  fi

  local fm
  fm=$(extract_frontmatter "$file")
  if [ -z "$fm" ]; then
    issues="$issues; missing frontmatter"
  else
    for key in $REQUIRED_FIELDS; do
      if ! has_field "$fm" "$key"; then
        issues="$issues; frontmatter missing '$key'"
      fi
    done
  fi

  validate_links "$file" issues

  if [ -n "$issues" ]; then
    fail "$rel${issues}"
  else
    pass "$rel ($lines lines)"
  fi
}

validate_reference_md() {
  local file="$1"
  local rel="${file#$REPO_ROOT/}"
  local issues=""

  local lines
  lines=$(wc -l < "$file" | tr -d ' ')

  if [ "$lines" -gt "$REF_LIMIT" ]; then
    issues="$issues; $lines lines > $REF_LIMIT limit"
  fi

  validate_links "$file" issues

  if [ -n "$issues" ]; then
    fail "$rel${issues}"
  else
    pass "$rel ($lines lines)"
  fi
}

# Resolves internal links relative to the file's directory.
# Appends to the named issues variable (passed by name, bash 3.2 compatible).
validate_links() {
  local file="$1"
  local issues_var="$2"
  local file_dir
  file_dir="$(dirname "$file")"

  local link
  while IFS= read -r link; do
    [ -z "$link" ] && continue
    local target
    if [ "${link:0:1}" = "/" ]; then
      target="$REPO_ROOT$link"
    else
      target="$file_dir/$link"
    fi
    if [ ! -e "$target" ]; then
      eval "$issues_var=\"\$$issues_var; broken internal link: $link\""
    fi
  done < <(extract_internal_links "$file")

  if [ "$CHECK_EXTERNAL" = "1" ]; then
    while IFS= read -r url; do
      [ -z "$url" ] && continue
      local code
      code=$(curl -s -o /dev/null -L --max-time 10 -w "%{http_code}" \
        -A "Mozilla/5.0 (validate-skills.sh)" "$url" 2>/dev/null)
      if ! echo "$code" | grep -qE '^(2|3)[0-9][0-9]$'; then
        eval "$issues_var=\"\$$issues_var; external link $code: $url\""
      fi
    done < <(extract_external_links "$file")
  fi
}

# ---------- main ----------

if [ ! -d "$SKILLS_DIR" ]; then
  echo "FAIL skills/ directory not found at $SKILLS_DIR"
  exit 1
fi

echo "Validating skills in $SKILLS_DIR"
if [ "$CHECK_EXTERNAL" = "1" ]; then
  echo "Mode: full (frontmatter + line counts + internal + external links)"
else
  echo "Mode: fast (frontmatter + line counts + internal links). Use --external for full."
fi
echo

# SKILL.md files
while IFS= read -r file; do
  validate_skill_md "$file"
  SKILL_COUNT=$((SKILL_COUNT + 1))
done < <(find "$SKILLS_DIR" -mindepth 2 -maxdepth 2 -name SKILL.md | sort)

# Reference files
while IFS= read -r file; do
  validate_reference_md "$file"
  REF_COUNT=$((REF_COUNT + 1))
done < <(find "$SKILLS_DIR" -path '*/references/*.md' | sort)

echo
echo "Checked $SKILL_COUNT SKILL.md, $REF_COUNT references. $ERRORS error(s)."

if [ "$ERRORS" -gt 0 ]; then
  exit 1
fi
exit 0
