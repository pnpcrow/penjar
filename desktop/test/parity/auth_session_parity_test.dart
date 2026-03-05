import 'package:flutter/widgets.dart';
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
