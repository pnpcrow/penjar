#!/usr/bin/env bash
set -eo pipefail

if [[ "${SKIP_PUB_GET:-0}" != "1" ]]; then
  flutter pub get
fi

./scripts/check_release_script_syntax.sh

flutter test --no-pub
FLUTTER_NO_PUB=1 ./scripts/run_parity_tests.sh
FLUTTER_NO_PUB=1 ./scripts/run_mode_matrix_tests.sh
flutter analyze --no-pub

if [[ "${INCLUDE_BUILD:-0}" == "1" ]]; then
  flutter build macos --debug --no-pub
fi
