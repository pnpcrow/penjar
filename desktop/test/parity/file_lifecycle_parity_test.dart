import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:penjar_desktop/main.dart';

void main() {
  testWidgets('file lifecycle parity scaffold interactions work', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PenjarDesktopApp());

    await tester.tap(find.byKey(const ValueKey<String>('nav-project')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey<String>('file-name-input')),
      'spec.penjar',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('file-create')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('file-create')));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('File created in Core Product: spec.penjar.'),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('file-item-project-core-spec.penjar')),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('file-delete-first')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('file-delete-first')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('File deleted from Core Product: landing.penjar.'),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('file-delete-first')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('file-delete-first')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('File deleted from Core Product: spec.penjar.'),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('file-delete-first')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('file-delete-first')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('File delete skipped: no file exists.'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey<String>('file-empty')), findsOneWidget);
  });
}
