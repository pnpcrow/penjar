import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'parity_test_utils.dart';

void main() {
  testWidgets(
    'workflow state persists across navigation via shared contracts',
    (WidgetTester tester) async {
      await pumpDesktopApp(tester);
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
      expect(find.textContaining('Signed in (simulated).'), findsOneWidget);

      await openWorkflowSection(tester, 'project');
      await openWorkflowSection(tester, 'auth');

      expect(find.textContaining('Signed in (simulated).'), findsOneWidget);
    },
  );
}
