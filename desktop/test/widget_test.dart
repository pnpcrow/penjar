import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:penjar_desktop/main.dart';

void main() {
  testWidgets('desktop shell shows title and switches workflow section', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PenjarDesktopApp());

    expect(find.text('Penjar Desktop'), findsOneWidget);
    expect(find.text('Desktop Shell Runtime'), findsAtLeastNWidgets(1));
    expect(find.textContaining('Status: In progress'), findsOneWidget);
    expect(find.textContaining('Contract Mode: in-memory'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('nav-inspect')));
    await tester.pumpAndSettle();

    expect(find.text('Inspect & Code Handoff'), findsAtLeastNWidgets(1));
    expect(find.textContaining('Status: In progress'), findsOneWidget);
    expect(find.textContaining('Contract Mode: in-memory'), findsOneWidget);
  });
}
