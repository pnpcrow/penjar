import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penjar_desktop/contracts/desktop_contract_bundle.dart';
import 'package:penjar_desktop/contracts/remote_stub_contracts.dart';

import 'parity_test_utils.dart';

class _AuthBackendParityTransportClient extends RemoteStubTransportClient {
  const _AuthBackendParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'code': 401,
          'message': 'Backend token expired.',
          'state': <String, Object?>{'sessionToken': 'expired-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendCodeOnlyParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendCodeOnlyParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'code': 401,
          'state': <String, Object?>{'sessionToken': 'expired-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendStatusCodeParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendStatusCodeParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'statusCode': 401,
          'state': <String, Object?>{'sessionToken': 'expired-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendStatusCodeSnakeCaseParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendStatusCodeSnakeCaseParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status_code': 403,
          'state': <String, Object?>{'sessionToken': 'expired-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendFailureFlagSnakeCaseParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendFailureFlagSnakeCaseParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'is_success': false,
          'state': <String, Object?>{'sessionToken': 'expired-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendFailureFlagIsOkParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendFailureFlagIsOkParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'isOk': false,
          'state': <String, Object?>{'sessionToken': 'expired-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendSnakeCaseStateAliasParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendSnakeCaseStateAliasParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend snake-case sign-in snapshot applied.',
          'state': <String, Object?>{
            'signed_in': true,
            'remember_session': true,
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendSignedOutAliasParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendSignedOutAliasParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'state': <String, Object?>{
            'signed_out': true,
            'sessionToken': 'expired-session',
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendSessionTimeoutParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendSessionTimeoutParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'code': 'SESSION_TIMEOUT',
          'state': <String, Object?>{'sessionToken': 'timed-out-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

void main() {
  testWidgets('auth/session parity scaffold interactions work', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);
    await openWorkflowSection(tester, 'auth');

    expect(
      find.byKey(const ValueKey<String>('auth-session-panel')),
      findsOneWidget,
    );
    expect(find.textContaining('Status: Idle'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('auth-sign-in')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining(
        'Validation failed: email and password are required.',
      ),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey<String>('auth-email')),
      'designer@penjar.app',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('auth-password')),
      'desktop-pass',
    );

    await tester.tap(find.byKey(const ValueKey<String>('auth-remember')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('auth-sign-in')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Signed in (simulated).'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('auth-refresh-token')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('auth-refresh-token')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Token refreshed (simulated).'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('auth-restore-session')),
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('auth-restore-session')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Session restored (simulated).'),
      findsOneWidget,
    );
  });

  testWidgets(
    'auth/session parity applies backend auth snapshots and signed-out transitions',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient: const _AuthBackendParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Status: [remote-stub] Backend token expired.'),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity maps code-only backend failure to deterministic auth-required status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendCodeOnlyParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Status: [remote-stub] Authentication required.'),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity maps statusCode backend failure to deterministic auth-required status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendStatusCodeParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Status: [remote-stub] Authentication required.'),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity maps status_code backend failure to deterministic auth-required status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendStatusCodeSnakeCaseParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Status: [remote-stub] Authentication required.'),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity maps snake-case failure flag to deterministic auth-failed status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendFailureFlagSnakeCaseParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend auth request failed.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity maps isOk failure flag to deterministic auth-failed status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendFailureFlagIsOkParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend auth request failed.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity normalizes snake_case signed-in state aliases',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendSnakeCaseStateAliasParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'Status: [remote-stub] Backend snake-case sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      final CheckboxListTile rememberSessionTile = tester.widget(
        find.byKey(const ValueKey<String>('auth-remember')),
      );
      expect(rememberSessionTile.value, isTrue);

      expect(find.textContaining('Signed in (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity maps signed_out alias to deterministic auth-required status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendSignedOutAliasParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Status: [remote-stub] Backend sign-in snapshot applied.'),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Status: [remote-stub] Authentication required.'),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity maps session-timeout backend failure to deterministic session-expired status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendSessionTimeoutParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Status: [remote-stub] Backend session expired.'),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity required-state mode blocks empty backend payload fallback',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubAuthRequireBackendState: true,
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'Status: [remote-stub] Backend auth state payload required.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Signed in (simulated).'), findsNothing);
    },
  );
}
