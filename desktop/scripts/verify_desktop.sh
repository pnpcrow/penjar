#!/usr/bin/env bash
set -eo pipefail

flutter pub get
flutter test --no-pub
FLUTTER_NO_PUB=1 ./scripts/run_parity_tests.sh
FLUTTER_NO_PUB=1 ./scripts/run_mode_matrix_tests.sh
flutter analyze --no-pub

if [[ "${INCLUDE_BUILD:-0}" == "1" ]]; then
  flutter build macos --debug --no-pub
fi
