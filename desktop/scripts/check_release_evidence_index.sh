#!/usr/bin/env bash
set -eo pipefail

index_file="../docs/technical-guide/developer/desktop-flutter-release-evidence-index.md"

if [[ ! -f "$index_file" ]]; then
  echo "[release-evidence-check] missing index file: $index_file" >&2
  exit 1
fi

errors=0
line_no=0

while IFS= read -r line; do
  line_no=$((line_no + 1))

  # Process only table rows and skip header/separator rows.
  if [[ "$line" != \|* ]]; then
    continue
  fi
  if [[ "$line" == *"|---|"* ]]; then
    continue
  fi
  if [[ "$line" == *"| RC |"* ]]; then
    continue
  fi

  normalized="$(printf '%s' "$line" | tr '[:upper:]' '[:lower:]')"

  has_promoted=0
  if [[ "$normalized" == *"| promoted"* ]]; then
    has_promoted=1
  fi

  has_blocked=0
  if [[ "$normalized" == *"| blocked"* ]]; then
    has_blocked=1
  fi

  if [[ $has_promoted -eq 0 && $has_blocked -eq 0 ]]; then
    echo "[release-evidence-check] line $line_no missing valid decision column: $line" >&2
    errors=$((errors + 1))
    continue
  fi

  if [[ $has_promoted -eq 1 ]]; then
    if [[ "$normalized" == *"tbd"* ]]; then
      echo "[release-evidence-check] line $line_no promoted row includes TBD field(s): $line" >&2
      errors=$((errors + 1))
    fi

    if [[ "$normalized" == *"placeholder"* ]]; then
      echo "[release-evidence-check] line $line_no promoted row includes placeholder value(s): $line" >&2
      errors=$((errors + 1))
    fi
  fi

done < "$index_file"

if [[ $errors -gt 0 ]]; then
  echo "[release-evidence-check] failed with $errors issue(s)." >&2
  exit 1
fi

echo "[release-evidence-check] passed."
