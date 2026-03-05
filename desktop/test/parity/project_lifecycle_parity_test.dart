import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:penjar_desktop/main.dart';

void main() {
  testWidgets('project lifecycle parity scaffold interactions work', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PenjarDesktopApp());

    await tester.tap(find.byKey(const ValueKey<String>('nav-project')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('project-file-panel')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('project-summary')),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('project-create')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('project-create')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Project create failed: project name is required.'),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey<String>('project-name-input')),
      'Mobile Revamp',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('project-create')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('project-create')));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Project created: Mobile Revamp.'),
      findsOneWidget,
    );
    expect(find.text('Mobile Revamp'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey<String>('project-chip-project-core')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Project selected: Core Product.'),
      findsOneWidget,
    );
  });
}
