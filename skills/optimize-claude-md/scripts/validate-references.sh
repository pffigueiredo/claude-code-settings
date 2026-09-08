#!/usr/bin/env bash
# Validate that all docs/ references in a CLAUDE.md point to existing files.
# Usage: validate-references.sh <path-to-CLAUDE.md>
#
# Checks for:
# - docs/filename.md references that point to missing files
# - @docs/ prefix usage (anti-pattern)
# - Orphan docs (files in docs/ not referenced from CLAUDE.md)

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <path-to-CLAUDE.md>"
  exit 1
fi

CLAUDE_MD="$1"
PROJECT_DIR="$(dirname "$CLAUDE_MD")"
ERRORS=0
WARNINGS=0

if [ ! -f "$CLAUDE_MD" ]; then
  echo "ERROR: File not found: $CLAUDE_MD"
  exit 1
fi

echo "Validating references in: $CLAUDE_MD"
echo "Project directory: $PROJECT_DIR"
echo "---"

# Check for @docs/ anti-pattern
AT_REFS=$(grep -n '@docs/' "$CLAUDE_MD" 2>/dev/null || true)
if [ -n "$AT_REFS" ]; then
  echo "ERROR: Found @docs/ prefix (loads file into context every time):"
  echo "$AT_REFS"
  echo "  Fix: Remove the @ prefix, use docs/filename.md instead"
  echo ""
  ERRORS=$((ERRORS + 1))
fi

# Extract docs/ references and check each one exists
REFS=$(grep -oE 'docs/[a-zA-Z0-9_/-]+\.md' "$CLAUDE_MD" 2>/dev/null | sort -u || true)
if [ -z "$REFS" ]; then
  echo "No docs/ references found in $CLAUDE_MD"
else
  echo "Checking referenced files:"
  while IFS= read -r ref; do
    full_path="$PROJECT_DIR/$ref"
    if [ -f "$full_path" ]; then
      lines=$(wc -l < "$full_path" | tr -d ' ')
      echo "  OK: $ref ($lines lines)"
    else
      echo "  MISSING: $ref -> $full_path does not exist"
      ERRORS=$((ERRORS + 1))
    fi
  done <<< "$REFS"
fi

echo ""

# Check for orphan docs (docs/ files not referenced in CLAUDE.md)
DOCS_DIR="$PROJECT_DIR/docs"
if [ -d "$DOCS_DIR" ]; then
  echo "Checking for orphan docs:"
  for doc_file in "$DOCS_DIR"/*.md; do
    [ -f "$doc_file" ] || continue
    relative="docs/$(basename "$doc_file")"
    if ! grep -q "$relative" "$CLAUDE_MD" 2>/dev/null; then
      echo "  ORPHAN: $relative (not referenced in CLAUDE.md)"
      WARNINGS=$((WARNINGS + 1))
    fi
  done
  if [ "$WARNINGS" -eq 0 ]; then
    echo "  No orphans found."
  fi
else
  echo "No docs/ directory found (nothing to check for orphans)."
fi

echo ""
echo "---"
echo "Results: $ERRORS error(s), $WARNINGS warning(s)"

if [ "$ERRORS" -gt 0 ]; then
  exit 1
fi
exit 0
