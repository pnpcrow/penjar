import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penjar_desktop/contracts/desktop_contract_bundle.dart';
import 'package:penjar_desktop/contracts/remote_stub_contracts.dart';

import 'parity_test_utils.dart';

class _ProjectBackendSiblingDataEnvelopeParityTransportClient
    extends RemoteStubTransportClient {
  const _ProjectBackendSiblingDataEnvelopeParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.createProject) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'result': <String, Object?>{
            'meta': <String, Object?>{'requestId': 'req-project-1'},
          },
          'data': <String, Object?>{
            'detail': 'Backend sibling data project snapshot applied.',
            'workflowState': <String, Object?>{
              'projects': <Map<String, Object?>>[
                <String, Object?>{
                  'id': 'project-sibling-envelope',
                  'name': 'Sibling Envelope Project',
                  'files': <String>['sibling-envelope.penjar'],
                },
              ],
              'selectedProjectIndex': 0,
            },
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

void main() {
  testWidgets('project lifecycle parity scaffold interactions work', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);
    await openWorkflowSection(tester, 'project');

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

  testWidgets(
    'project lifecycle parity uses sibling data envelope when result lacks workflow state',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _ProjectBackendSiblingDataEnvelopeParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'project');

      await tester.enterText(
        find.byKey(const ValueKey<String>('project-name-input')),
        'ignored',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('project-create')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('project-create')));
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sibling data project snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(find.text('Sibling Envelope Project'), findsOneWidget);
    },
  );
}
