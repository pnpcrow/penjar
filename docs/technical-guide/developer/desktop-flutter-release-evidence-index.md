---
title: Desktop Flutter Release Evidence Index
desc: Traceable index of desktop release candidate validation evidence across platforms.
---

# Desktop Flutter Release Evidence Index

This index tracks release validation evidence for desktop release candidates.

## Related artifacts

- [Desktop Flutter Release Validation Baseline](/technical-guide/developer/desktop-flutter-release-validation-baseline/)
- [Desktop Flutter Development Runbook](/technical-guide/developer/desktop-flutter-development-runbook/)
- [Web + Desktop Phase C Execution Log](/technical-guide/developer/web-mcp-phase-c-execution-log/)

## Evidence record schema

Each release candidate record should include:

1. RC identifier and target version.
2. Platform artifact manifest (hash, signing fingerprint, output path).
3. Installer/update validation report links.
4. CI workflow run links.
5. Execution log unit reference.
6. Release decision (`promoted` / `blocked`) with reason.

## Release evidence table

| RC | Version | Platform | Artifact manifest | Installer/Update report | CI run | Execution log reference | Decision |
|---|---|---|---|---|---|---|---|
| RC-PLACEHOLDER | 0.0.0-placeholder | macOS | TBD | TBD | TBD | TBD | blocked (placeholder) |
| RC-PLACEHOLDER | 0.0.0-placeholder | Windows | TBD | TBD | TBD | TBD | blocked (placeholder) |

## Maintenance rules

1. Do not mark `promoted` unless all required baseline gates are evidenced.
2. Keep one row per `RC + platform` pair.
3. Add latest entry at top for quick audit visibility.
4. Keep artifact/report links immutable after promotion.
