import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:penjar_desktop/contracts/desktop_contract_bundle.dart';
import 'package:penjar_desktop/main.dart';

Future<void> pumpDesktopApp(
  WidgetTester tester, {
  DesktopContractBundle? contracts,
}) async {
  await tester.pumpWidget(PenjarDesktopApp(contracts: contracts));
}

Future<void> openWorkflowSection(WidgetTester tester, String sectionId) async {
  final Finder navFinder = find.byKey(ValueKey<String>('nav-$sectionId'));
  await tester.ensureVisible(navFinder);
  await tester.tap(navFinder);
  await tester.pumpAndSettle();
}
