#!/usr/bin/env bash

is_placeholder_command() {
  local command_value lowered
  command_value="$1"
  lowered="$(printf '%s' "$command_value" | tr '[:upper:]' '[:lower:]')"

  if [[ "$lowered" =~ ^[[:space:]]*echo([[:space:]]|$) ]]; then
    return 0
  fi

  if printf '%s' "$lowered" | grep -Eq '<[^>]+>'; then
    return 0
  fi

  if [[ "$lowered" =~ (^|[^a-z0-9_])(todo|tbd|placeholder|changeme|change_me|replace_me|example|dummy|sample|fixme)([^a-z0-9_]|$) ]]; then
    return 0
  fi

  return 1
}
