import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:penjar_desktop/contracts/desktop_contract_bundle.dart';
import 'package:penjar_desktop/contracts/remote_stub_contracts.dart';

import 'parity_test_utils.dart';

class _StrictSchemaMalformedAuthTransportClient
    extends RemoteStubTransportClient {
  const _StrictSchemaMalformedAuthTransportClient({
    this.malformedOperations = const <String>{RemoteStubOperationIds.signIn},
  });

  final Set<String> malformedOperations;

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (malformedOperations.contains(request.operation)) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'unexpected': <String, Object?>{'shape': true},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _RefreshUnauthorizedAuthTransportClient
    extends RemoteStubTransportClient {
  const _RefreshUnauthorizedAuthTransportClient();

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

void main() {
  testWidgets('remote-stub mode surfaces mode and prefixed workflow states', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester, contracts: DesktopContractBundle.remoteStub());

    expect(find.textContaining('Contract Mode: remote-stub'), findsOneWidget);

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
      find.textContaining('Status: [remote-stub] Signed in (simulated).'),
      findsOneWidget,
    );

    await openWorkflowSection(tester, 'diagnostics');
    expect(find.textContaining('Contract mode: remote-stub'), findsOneWidget);
    expect(find.textContaining('Remote profile: none'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('diagnostics-health-check')),
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('diagnostics-health-check')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining(
        'Status: [remote-stub] Health check passed: websocket and MCP are connected.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('remote-stub mode surfaces strict backend schema profile label', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(
      tester,
      contracts: DesktopContractBundle.fromMode(
        DesktopContractMode.remoteStub,
        remoteStubAuthStrictBackendSchema: true,
      ),
    );

    await openWorkflowSection(tester, 'diagnostics');
    expect(find.textContaining('Contract mode: remote-stub'), findsOneWidget);
    expect(
      find.textContaining('Remote profile: auth-backend-schema: strict'),
      findsOneWidget,
    );
  });

  testWidgets(
    'remote-stub mode surfaces required backend auth state profile label',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubAuthRequireBackendState: true,
        ),
      );

      await openWorkflowSection(tester, 'diagnostics');
      expect(find.textContaining('Contract mode: remote-stub'), findsOneWidget);
      expect(
        find.textContaining('Remote profile: auth-backend-state: required'),
        findsOneWidget,
      );
    },
  );

  testWidgets('strict schema mode blocks malformed auth sign-in fallback', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(
      tester,
      contracts: DesktopContractBundle.fromMode(
        DesktopContractMode.remoteStub,
        remoteStubAuthStrictBackendSchema: true,
        remoteStubTransportClient:
            const _StrictSchemaMalformedAuthTransportClient(),
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
        'Status: [remote-stub] Backend auth schema validation failed.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('Signed in (simulated).'), findsNothing);
  });

  testWidgets(
    'remote-stub mode surfaces forwarded auth sign-in payload profile label',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubAuthForwardSignInCredentials: true,
        ),
      );

      await openWorkflowSection(tester, 'diagnostics');
      expect(
        find.textContaining('Remote profile: auth-sign-in-payload: forwarded'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'strict schema mode blocks malformed restore/refresh auth fallback',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubAuthStrictBackendSchema: true,
          remoteStubTransportClient:
              const _StrictSchemaMalformedAuthTransportClient(
                malformedOperations: <String>{
                  RemoteStubOperationIds.restoreSession,
                  RemoteStubOperationIds.refreshToken,
                },
              ),
        ),
      );

      await openWorkflowSection(tester, 'auth');

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-restore-session')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-restore-session')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend auth schema validation failed.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Session restored (simulated).'),
        findsNothing,
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
          'Status: [remote-stub] Backend auth schema validation failed.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'required backend auth state mode blocks empty sign-in delegate fallback',
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

  testWidgets(
    'backend execution transport auto-enables required backend auth state mode',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient: RemoteStubHttpTransportClient(
            backendBaseUrl: 'https://api.penjar.app',
            executionProbe: (_) =>
                const RemoteStubHttpBackendExecutionResult.allowed(),
          ),
        ),
      );

      await openWorkflowSection(tester, 'diagnostics');
      final Text diagnosticsProfileText = tester.widget(
        find.byKey(const ValueKey<String>('diagnostics-remote-profile')),
      );
      expect(
        diagnosticsProfileText.data,
        contains('auth-backend-state: required'),
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

  testWidgets(
    'backend signed-out response forces signed-out state after prior sign-in',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _RefreshUnauthorizedAuthTransportClient(),
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
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsNothing,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );
}
