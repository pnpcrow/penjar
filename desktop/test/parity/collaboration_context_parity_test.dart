import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:penjar_desktop/main.dart';

void main() {
  testWidgets('collaboration context parity scaffold interactions work', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PenjarDesktopApp());

    await tester.tap(find.byKey(const ValueKey<String>('nav-collaboration')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('collaboration-panel')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('collaboration-summary')),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('collaboration-toggle-peer')),
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('collaboration-toggle-peer')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Peer connected: reviewer@penjar.app.'),
      findsOneWidget,
    );
    expect(find.textContaining('Active sessions: 2'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('thread-create')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('thread-create')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Thread create failed: title is required.'),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey<String>('thread-title-input')),
      'Review button spacing',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('thread-create')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('thread-create')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Thread created: Review button spacing.'),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('thread-chip-thread-1')),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('thread-resolve')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('thread-resolve')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Thread resolved: Review button spacing.'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey<String>('thread-empty')), findsOneWidget);
  });
}
