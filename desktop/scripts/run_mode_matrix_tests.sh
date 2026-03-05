#!/usr/bin/env bash
set -eo pipefail

extra_args=()

if [[ "${FLUTTER_NO_PUB:-0}" == "1" ]]; then
  extra_args+=(--no-pub)
fi

flutter test \
  "${extra_args[@]}" \
  test/widget_test.dart

flutter test \
  "${extra_args[@]}" \
  --dart-define=PENJAR_DESKTOP_CONTRACT_MODE=remote-stub \
  test/widget_test.dart
