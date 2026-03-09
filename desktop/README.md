# Penjar Desktop (Flutter)

Flutter workspace bootstrap for the Penjar desktop app.

## Getting Started

This module is the Phase C baseline for migrating desktop user-facing workflows to Flutter.

## Run Against Backend

Use the workspace script when you want the Flutter desktop app to talk to the
local backend through the remote-stub transport:

```bash
pnpm run desktop:run:remote-backend
```

Defaults:

- backend base URL: `http://127.0.0.1:6060`
- Flutter device: `macos`
- backend-executed operations:
  `sign-in,set-remember-session,restore-session,refresh-token,create-project,switch-project,create-file,delete-file`

Important:

- The script passes `--dart-define` values for `DesktopContractBundle.fromEnvironment()`.
- Raw sign-in credentials are forwarded to the backend by default in this mode so
  `/api/desktop/auth/sign-in` can authenticate real sessions.
- Session cookies are persisted through the remote-stub HTTP transport cookie jar.
- Workflow areas without backend desktop endpoints keep using the existing
  remote-stub delegate path unless you expand the backend operation list.

Useful overrides:

- `PENJAR_DESKTOP_FLUTTER_DEVICE`
- `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_BASE_URL`
- `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_OPERATIONS`
- `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_COOKIE_JAR_PATH`
- `PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_HEALTH_URL`

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
