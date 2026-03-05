import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penjar_desktop/contracts/desktop_contract_bundle.dart';
import 'package:penjar_desktop/contracts/remote_stub_contracts.dart';

import 'parity_test_utils.dart';

class _InspectBackendSiblingDataEnvelopeParityTransportClient
    extends RemoteStubTransportClient {
  const _InspectBackendSiblingDataEnvelopeParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.generateSnippet) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'result': <String, Object?>{
            'meta': <String, Object?>{'requestId': 'req-inspect-1'},
          },
          'data': <String, Object?>{
            'detail': 'Backend sibling data inspect snapshot applied.',
            'inspectState': <String, Object?>{
              'target': 'swiftui',
              'snippet': 'Text("Remote")',
            },
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

void main() {
  testWidgets('inspect handoff parity scaffold interactions work', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);
    await openWorkflowSection(tester, 'inspect');

    expect(find.byKey(const ValueKey<String>('inspect-panel')), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('inspect-metadata')),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey<String>('inspect-element-id')),
      '',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('inspect-generate-snippet')),
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('inspect-generate-snippet')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Snippet generation failed: element id is required.'),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey<String>('inspect-element-id')),
      'button/primary',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('inspect-generate-snippet')),
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('inspect-generate-snippet')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Snippet generated for button/primary (flutter).'),
      findsOneWidget,
    );
    expect(find.textContaining('Container('), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('inspect-copy-metadata')),
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('inspect-copy-metadata')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Metadata copied (simulated) for button/primary.'),
      findsOneWidget,
    );
  });

  testWidgets(
    'inspect parity uses sibling data envelope when result lacks inspect state',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _InspectBackendSiblingDataEnvelopeParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'inspect');

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('inspect-generate-snippet')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('inspect-generate-snippet')),
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sibling data inspect snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Text("Remote")'), findsOneWidget);
      expect(find.textContaining('target=swiftui'), findsOneWidget);
    },
  );
}
