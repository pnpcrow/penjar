#!/usr/bin/env bash
set -eo pipefail

report_file="${1:-release/reports/desktop_command_inventory_report.md}"
package_file="${2:-../package.json}"
shift "$(( $# > 0 ? 1 : 0 ))"
shift "$(( $# > 0 ? 1 : 0 ))"

doc_files=("$@")
if [[ "${#doc_files[@]}" -eq 0 ]]; then
  doc_files=(
    "../docs/technical-guide/developer/desktop-flutter-development-runbook.md"
    "../docs/technical-guide/developer/desktop-flutter-release-validation-baseline.md"
  )
fi

if [[ ! -f "$package_file" ]]; then
  echo "[desktop-command-inventory] package file not found: $package_file" >&2
  exit 1
fi

for doc_file in "${doc_files[@]}"; do
  if [[ ! -f "$doc_file" ]]; then
    echo "[desktop-command-inventory] doc file not found: $doc_file" >&2
    exit 1
  fi
done

python_bin=""
if command -v python3 >/dev/null 2>&1; then
  python_bin="python3"
elif command -v python >/dev/null 2>&1; then
  python_bin="python"
else
  echo "[desktop-command-inventory] python runtime is required (python3 or python)." >&2
  exit 1
fi

mkdir -p "$(dirname "$report_file")"

"$python_bin" - "$report_file" "$package_file" "${doc_files[@]}" <<'PY'
import datetime
import json
import pathlib
import re
import sys

report_path = pathlib.Path(sys.argv[1])
package_path = pathlib.Path(sys.argv[2])
doc_paths = [pathlib.Path(item) for item in sys.argv[3:]]

with package_path.open("r", encoding="utf-8") as fh:
    package_json = json.load(fh)

scripts = package_json.get("scripts")
if not isinstance(scripts, dict):
    raise SystemExit(f"[desktop-command-inventory] invalid scripts map in {package_path}")

pattern = re.compile(r"pnpm run ([A-Za-z0-9:_-]+)")
command_sources = {}

for doc_path in doc_paths:
    with doc_path.open("r", encoding="utf-8") as fh:
        for line_no, line in enumerate(fh, start=1):
            for match in pattern.finditer(line):
                command = match.group(1)
                source = f"{doc_path}:{line_no}"
                command_sources.setdefault(command, [])
                if source not in command_sources[command]:
                    command_sources[command].append(source)

detected_commands = sorted(command_sources.keys())
missing_commands = [command for command in detected_commands if command not in scripts]
status = "passed"
if missing_commands or not detected_commands:
    status = "failed"

report_lines = [
    "# Desktop Command Inventory Report",
    "",
    f"- Generated at (UTC): {datetime.datetime.now(datetime.timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')}",
    f"- Package file: {package_path}",
    f"- Scanned docs count: {len(doc_paths)}",
    f"- Detected command count: {len(detected_commands)}",
    f"- Missing command count: {len(missing_commands)}",
    f"- Status: {status}",
    "",
    "## Scanned docs",
]

for doc_path in doc_paths:
    report_lines.append(f"- {doc_path}")

report_lines.extend(["", "## Detected commands"])
if detected_commands:
    for command in detected_commands:
        sources = ", ".join(command_sources[command])
        report_lines.append(f"- `{command}` ({sources})")
else:
    report_lines.append("- none")

report_lines.extend(["", "## Missing commands"])
if missing_commands:
    for command in missing_commands:
        report_lines.append(f"- `{command}`")
else:
    report_lines.append("- none")

report_path.write_text("\n".join(report_lines) + "\n", encoding="utf-8")

if not detected_commands:
    raise SystemExit("[desktop-command-inventory] no `pnpm run` commands detected in scanned docs.")

if missing_commands:
    raise SystemExit(
        "[desktop-command-inventory] missing commands in package.json scripts: "
        + ", ".join(missing_commands)
    )
PY

echo "[desktop-command-inventory] passed. report: $report_file"
