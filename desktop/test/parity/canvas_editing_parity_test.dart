import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:penjar_desktop/main.dart';

void main() {
  testWidgets('canvas editing parity scaffold interactions work', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PenjarDesktopApp());

    await tester.tap(find.byKey(const ValueKey<String>('nav-canvas')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('canvas-panel')), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('canvas-shape-empty')),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('canvas-create-rect')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('canvas-create-rect')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Rectangle created: rect-1.'), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('canvas-shape-rect-1')),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('canvas-move')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('canvas-move')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Moved rect-1 to (20, 15).'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('canvas-resize')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('canvas-resize')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Resized rect-1 to 140x100.'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('canvas-toggle-fill')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('canvas-toggle-fill')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Fill updated for rect-1: #FF8A00.'),
      findsOneWidget,
    );
    expect(find.textContaining('fill=#FF8A00'), findsOneWidget);
  });
}
