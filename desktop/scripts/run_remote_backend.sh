#!/usr/bin/env bash
set -eo pipefail

default_backend_operations="sign-in,set-remember-session,restore-session,refresh-token,create-project,switch-project,create-file,delete-file"
backend_base_url="${PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_BASE_URL:-http://127.0.0.1:6060}"
backend_operations="${PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_OPERATIONS:-$default_backend_operations}"
forward_credentials="${PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_FORWARD_CREDENTIALS:-true}"

dart_defines=(
  "--dart-define=PENJAR_DESKTOP_CONTRACT_MODE=remote-stub"
  "--dart-define=PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_BASE_URL=${backend_base_url}"
  "--dart-define=PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_OPERATIONS=${backend_operations}"
  "--dart-define=PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_FORWARD_CREDENTIALS=${forward_credentials}"
)

append_optional_define() {
  local key="$1"
  local value="${!key:-}"
  if [[ -n "$value" ]]; then
    dart_defines+=("--dart-define=${key}=${value}")
  fi
}

append_optional_define "PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_COOKIE_JAR_PATH"
append_optional_define "PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_HEALTH_URL"
append_optional_define "PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_TIMEOUT_MS"
append_optional_define "PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_ALLOWED_STATUS_CODES"
append_optional_define "PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BLOCK_REASON"
append_optional_define "PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_TIMEOUT_MS"
append_optional_define "PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_BLOCK_REASON"
append_optional_define "PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_AUTH_TOKEN"
append_optional_define "PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_ENDPOINT_SET_REMEMBER_SESSION"
append_optional_define "PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_ENDPOINT_SIGN_IN"
append_optional_define "PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_ENDPOINT_RESTORE_SESSION"
append_optional_define "PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_ENDPOINT_REFRESH_TOKEN"
append_optional_define "PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_REQUIRE_STATE"
append_optional_define "PENJAR_DESKTOP_REMOTE_STUB_AUTH_BACKEND_SCHEMA_STRICT"

device_specified=0
for arg in "$@"; do
  case "$arg" in
    -d|--device-id|-d=*|--device-id=*)
      device_specified=1
      ;;
  esac
done

flutter_args=()
if [[ "$device_specified" -ne 1 ]]; then
  flutter_args=(-d "${PENJAR_DESKTOP_FLUTTER_DEVICE:-macos}")
fi

flutter run "${flutter_args[@]}" "${dart_defines[@]}" "$@"
