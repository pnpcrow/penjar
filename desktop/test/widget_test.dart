import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:penjar_desktop/contracts/desktop_contract_bundle.dart';
import 'package:penjar_desktop/main.dart';

void main() {
  test('resolveInitialSectionId prioritizes launch args over env section', () {
    expect(
      resolveInitialSectionId(
        launchArgs: <String>['--penjar-section=inspect'],
        envInitialSectionId: 'auth',
      ),
      'inspect',
    );
    expect(
      resolveInitialSectionId(
        launchArgs: <String>['--penjar-section=unknown'],
        envInitialSectionId: 'auth',
      ),
      'auth',
    );
  });

  test('resolveInitialSectionId parses penjar deep-link routes', () {
    expect(
      resolveInitialSectionId(
        launchArgs: <String>['penjar://section/collaboration'],
        envInitialSectionId: 'shell',
      ),
      'collaboration',
    );
    expect(
      resolveInitialSectionId(
        launchArgs: <String>['--penjar-route=penjar://open?section=assets'],
        envInitialSectionId: 'shell',
      ),
      'assets',
    );
    expect(
      resolveInitialSectionId(
        launchArgs: <String>['--penjar-route=/workspace/section/export'],
        envInitialSectionId: 'shell',
      ),
      'export',
    );
  });

  testWidgets('desktop shell shows title and switches workflow section', (
    WidgetTester tester,
  ) async {
    final String expectedContractModeLabel = DesktopContractMode.fromEnv(
      const String.fromEnvironment('PENJAR_DESKTOP_CONTRACT_MODE'),
    ).label;

    await tester.pumpWidget(const PenjarDesktopApp());

    expect(find.text('Penjar Desktop'), findsOneWidget);
    expect(find.text('Desktop Shell Runtime'), findsAtLeastNWidgets(1));
    expect(find.textContaining('Status: In progress'), findsOneWidget);
    expect(
      find.textContaining('Contract Mode: $expectedContractModeLabel'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey<String>('nav-inspect')));
    await tester.pumpAndSettle();

    expect(find.text('Inspect & Code Handoff'), findsAtLeastNWidgets(1));
    expect(find.textContaining('Status: In progress'), findsOneWidget);
    expect(
      find.textContaining('Contract Mode: $expectedContractModeLabel'),
      findsOneWidget,
    );
  });

  testWidgets('desktop shell honors initial section route id', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const PenjarDesktopApp(initialSectionId: 'inspect'),
    );

    expect(find.text('Inspect & Code Handoff'), findsAtLeastNWidgets(1));
    expect(find.byKey(const ValueKey<String>('inspect-panel')), findsOneWidget);
  });

  testWidgets('desktop shell honors launch route parser output', (
    WidgetTester tester,
  ) async {
    final String initialSection = resolveInitialSectionId(
      launchArgs: <String>['--penjar-route=penjar://section/diagnostics'],
      envInitialSectionId: 'shell',
    );
    await tester.pumpWidget(PenjarDesktopApp(initialSectionId: initialSection));

    expect(
      find.byKey(const ValueKey<String>('diagnostics-panel')),
      findsOneWidget,
    );
    expect(find.text('Diagnostics & Recovery'), findsAtLeastNWidgets(1));
  });
}
