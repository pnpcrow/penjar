#!/usr/bin/env bash
set -eo pipefail

extra_args=()

if [[ "${FLUTTER_NO_PUB:-0}" == "1" ]]; then
  extra_args+=(--no-pub)
fi

flutter test \
  "${extra_args[@]}" \
  test/contracts/desktop_contract_bundle_test.dart \
  test/contracts/workflow_contracts_test.dart
