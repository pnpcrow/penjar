import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:penjar_desktop/main.dart';

void main() {
  testWidgets('diagnostics recovery parity scaffold interactions work', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PenjarDesktopApp());

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('nav-diagnostics')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('nav-diagnostics')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('diagnostics-panel')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('diagnostics-summary')),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('diagnostics-health-check')),
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('diagnostics-health-check')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining(
        'Health check passed: websocket and MCP are connected.',
      ),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('diagnostics-drop-connection')),
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('diagnostics-drop-connection')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('WebSocket disconnected; MCP stream unavailable.'),
      findsOneWidget,
    );
    expect(find.textContaining('WebSocket: down'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('diagnostics-reconnect')),
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('diagnostics-reconnect')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Reconnect successful on attempt 1.'),
      findsOneWidget,
    );
    expect(find.textContaining('reconnect attempts: 1'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('diagnostics-open-guide')),
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('diagnostics-open-guide')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Recovery guide opened (simulated).'),
      findsOneWidget,
    );
  });
}
