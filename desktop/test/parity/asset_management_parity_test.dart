import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:penjar_desktop/main.dart';

void main() {
  testWidgets('asset management parity scaffold interactions work', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PenjarDesktopApp());

    await tester.tap(find.byKey(const ValueKey<String>('nav-assets')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('asset-panel')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('asset-summary')), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('asset-import')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('asset-import')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Asset import failed: asset name is required.'),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey<String>('asset-name-input')),
      'hero.png',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('asset-import')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('asset-import')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Asset imported: hero.png (image).'),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('asset-chip-asset-1')),
      findsOneWidget,
    );

    await tester.ensureVisible(find.byKey(const ValueKey<String>('asset-use')));
    await tester.tap(find.byKey(const ValueKey<String>('asset-use')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Asset used: hero.png (count 1).'),
      findsOneWidget,
    );
    expect(find.textContaining('used=1'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('asset-remove')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('asset-remove')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Asset removed: hero.png.'), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('asset-empty-selection')),
      findsOneWidget,
    );

    await tester.ensureVisible(find.byKey(const ValueKey<String>('asset-use')));
    await tester.tap(find.byKey(const ValueKey<String>('asset-use')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Asset use skipped: no asset selected.'),
      findsOneWidget,
    );
  });
}
