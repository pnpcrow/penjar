import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:penjar_desktop/contracts/desktop_contract_bundle.dart';

import 'parity_test_utils.dart';

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
}
