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
}
