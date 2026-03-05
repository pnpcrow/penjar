import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:penjar_desktop/main.dart';

void main() {
  testWidgets('export workflow parity scaffold interactions work', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PenjarDesktopApp());

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('nav-export')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('nav-export')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('export-panel')), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('export-summary')),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey<String>('export-file-name')),
      '',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('export-run')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('export-run')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Export failed: file name is required.'),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey<String>('export-file-name')),
      'landing',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('export-run')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('export-run')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Export completed: /exports/landing.png.'),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('export-chip-export-1')),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('export-save-latest')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('export-save-latest')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Export saved (simulated): /exports/landing.png.'),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('export-clear')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('export-clear')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Export artifacts cleared.'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('export-empty')), findsOneWidget);
  });
}
