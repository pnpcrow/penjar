#!/usr/bin/env bash
set -eo pipefail

row_file="${1:-}"
index_file="${2:-../docs/technical-guide/developer/desktop-flutter-release-evidence-index.md}"
output_file="${3:-$index_file}"

if [[ -z "$row_file" ]]; then
  echo "usage: $0 <row-file> [index-file] [output-file]" >&2
  exit 1
fi

if [[ ! -f "$row_file" ]]; then
  echo "[release-evidence-index-update] missing row file: $row_file" >&2
  exit 1
fi

if [[ ! -f "$index_file" ]]; then
  echo "[release-evidence-index-update] missing index file: $index_file" >&2
  exit 1
fi

python_bin=""
if command -v python3 >/dev/null 2>&1; then
  python_bin="python3"
elif command -v python >/dev/null 2>&1; then
  python_bin="python"
else
  echo "[release-evidence-index-update] python runtime is required (python3 or python)." >&2
  exit 1
fi

"$python_bin" - "$row_file" "$index_file" "$output_file" <<'PY'
import pathlib
import sys

row_file = pathlib.Path(sys.argv[1])
index_file = pathlib.Path(sys.argv[2])
output_file = pathlib.Path(sys.argv[3])

row_candidates = [line.strip() for line in row_file.read_text(encoding="utf-8").splitlines() if line.strip()]
if not row_candidates:
    raise SystemExit(f"[release-evidence-index-update] row file is empty: {row_file}")

row = row_candidates[0]
if not (row.startswith("|") and row.endswith("|")):
    raise SystemExit(f"[release-evidence-index-update] invalid row format in {row_file}: {row}")

def parse_cells(table_row: str):
    return [cell.strip() for cell in table_row.strip().strip("|").split("|")]

new_cells = parse_cells(row)
if len(new_cells) < 8:
    raise SystemExit(
        f"[release-evidence-index-update] expected at least 8 columns in row: {row}"
    )

new_key = (new_cells[0], new_cells[2])  # RC + Platform

lines = index_file.read_text(encoding="utf-8").splitlines()

header_index = None
separator_index = None
for idx, line in enumerate(lines):
    if line.startswith("| RC | Version | Platform | Artifact manifest | Installer/Update report | CI run | Execution log reference | Decision |"):
        header_index = idx
        break

if header_index is None:
    raise SystemExit(f"[release-evidence-index-update] evidence table header not found in {index_file}")

for idx in range(header_index + 1, len(lines)):
    if lines[idx].startswith("|---|"):
        separator_index = idx
        break

if separator_index is None:
    raise SystemExit(f"[release-evidence-index-update] evidence table separator not found in {index_file}")

data_start = separator_index + 1
data_end = data_start
while data_end < len(lines) and lines[data_end].startswith("|"):
    data_end += 1

existing_rows = lines[data_start:data_end]
filtered_rows = []
for existing in existing_rows:
    cells = parse_cells(existing)
    if len(cells) >= 3 and (cells[0], cells[2]) == new_key:
        continue
    filtered_rows.append(existing)

updated_rows = [row] + filtered_rows
updated_lines = lines[:data_start] + updated_rows + lines[data_end:]

output_file.parent.mkdir(parents=True, exist_ok=True)
output_file.write_text("\n".join(updated_lines) + "\n", encoding="utf-8")
PY

echo "[release-evidence-index-update] generated: $output_file"
