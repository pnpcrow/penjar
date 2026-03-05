import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:penjar_desktop/contracts/desktop_contract_bundle.dart';
import 'package:penjar_desktop/contracts/remote_stub_contracts.dart';

import 'parity_test_utils.dart';

void main() {
  testWidgets('remote-stub unavailable profile blocks workflow mutations', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(
      tester,
      contracts: DesktopContractBundle.remoteStub(
        faultProfile: const RemoteStubFaultProfile(unavailable: true),
      ),
    );

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
      find.textContaining('Remote bridge unavailable: sign-in.'),
      findsOneWidget,
    );

    await openWorkflowSection(tester, 'project');
    await tester.enterText(
      find.byKey(const ValueKey<String>('project-name-input')),
      'Blocked Project',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('project-create')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('project-create')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Remote bridge unavailable: create-project.'),
      findsOneWidget,
    );

    await openWorkflowSection(tester, 'diagnostics');
    expect(find.textContaining('Remote profile: unavailable'), findsOneWidget);
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('diagnostics-health-check')),
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('diagnostics-health-check')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Remote bridge unavailable: run-health-check.'),
      findsOneWidget,
    );
  });
}
