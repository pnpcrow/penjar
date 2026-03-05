import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'parity_test_utils.dart';

void main() {
  testWidgets('inspect handoff parity scaffold interactions work', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);
    await openWorkflowSection(tester, 'inspect');

    expect(find.byKey(const ValueKey<String>('inspect-panel')), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('inspect-metadata')),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey<String>('inspect-element-id')),
      '',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('inspect-generate-snippet')),
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('inspect-generate-snippet')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Snippet generation failed: element id is required.'),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey<String>('inspect-element-id')),
      'button/primary',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('inspect-generate-snippet')),
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('inspect-generate-snippet')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Snippet generated for button/primary (flutter).'),
      findsOneWidget,
    );
    expect(find.textContaining('Container('), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('inspect-copy-metadata')),
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('inspect-copy-metadata')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Metadata copied (simulated) for button/primary.'),
      findsOneWidget,
    );
  });
}
