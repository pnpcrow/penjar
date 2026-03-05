import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penjar_desktop/contracts/desktop_contract_bundle.dart';
import 'package:penjar_desktop/contracts/remote_stub_contracts.dart';

import 'parity_test_utils.dart';

class _DiagnosticsBackendSiblingDataEnvelopeParityTransportClient
    extends RemoteStubTransportClient {
  const _DiagnosticsBackendSiblingDataEnvelopeParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.runHealthCheck) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'result': <String, Object?>{
            'meta': <String, Object?>{'requestId': 'req-diagnostics-1'},
          },
          'data': <String, Object?>{
            'detail': 'Backend sibling data diagnostics snapshot applied.',
            'diagnosticsState': <String, Object?>{
              'websocketHealthy': false,
              'mcpHealthy': true,
              'reconnectAttempts': 7,
            },
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

void main() {
  testWidgets('diagnostics recovery parity scaffold interactions work', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);
    await openWorkflowSection(tester, 'diagnostics');

    expect(
      find.byKey(const ValueKey<String>('diagnostics-panel')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('diagnostics-summary')),
      findsOneWidget,
    );
    expect(find.textContaining('Contract mode: in-memory'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('diagnostics-health-check')),
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('diagnostics-health-check')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining(
        'Health check passed: websocket and MCP are connected.',
      ),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('diagnostics-drop-connection')),
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('diagnostics-drop-connection')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('WebSocket disconnected; MCP stream unavailable.'),
      findsOneWidget,
    );
    expect(find.textContaining('WebSocket: down'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('diagnostics-reconnect')),
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('diagnostics-reconnect')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Reconnect successful on attempt 1.'),
      findsOneWidget,
    );
    expect(find.textContaining('reconnect attempts: 1'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('diagnostics-open-guide')),
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('diagnostics-open-guide')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Recovery guide opened (simulated).'),
      findsOneWidget,
    );
  });

  testWidgets(
    'diagnostics parity uses sibling data envelope when result lacks diagnostics state',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _DiagnosticsBackendSiblingDataEnvelopeParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'diagnostics');

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('diagnostics-health-check')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('diagnostics-health-check')),
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sibling data diagnostics snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('WebSocket: down'), findsOneWidget);
      expect(find.textContaining('MCP: up'), findsOneWidget);
      expect(find.textContaining('reconnect attempts: 7'), findsOneWidget);
    },
  );
}
