import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:penjar_desktop/main.dart';

void main() {
  testWidgets(
    'workflow state persists across navigation via shared contracts',
    (WidgetTester tester) async {
      await tester.pumpWidget(const PenjarDesktopApp());

      await tester.tap(find.byKey(const ValueKey<String>('nav-auth')));
      await tester.pumpAndSettle();

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

      await tester.tap(find.byKey(const ValueKey<String>('nav-project')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey<String>('nav-auth')));
      await tester.pumpAndSettle();

      expect(find.textContaining('Signed in (simulated).'), findsOneWidget);
    },
  );
}
