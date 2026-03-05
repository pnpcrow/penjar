import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penjar_desktop/contracts/desktop_contract_bundle.dart';
import 'package:penjar_desktop/contracts/remote_stub_contracts.dart';

import 'parity_test_utils.dart';

class _FileBackendSiblingDataEnvelopeParityTransportClient
    extends RemoteStubTransportClient {
  const _FileBackendSiblingDataEnvelopeParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.createFile) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'result': <String, Object?>{
            'meta': <String, Object?>{'requestId': 'req-file-1'},
          },
          'data': <String, Object?>{
            'detail': 'Backend sibling data file snapshot applied.',
            'workflowState': <String, Object?>{
              'projects': <Map<String, Object?>>[
                <String, Object?>{
                  'id': 'project-core',
                  'name': 'Core Product',
                  'files': <String>['landing.penjar', 'spec.penjar'],
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
  testWidgets('file lifecycle parity scaffold interactions work', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);
    await openWorkflowSection(tester, 'project');

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

  testWidgets(
    'file lifecycle parity uses sibling data envelope when result lacks workflow state',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _FileBackendSiblingDataEnvelopeParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'project');

      await tester.enterText(
        find.byKey(const ValueKey<String>('file-name-input')),
        'ignored.penjar',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('file-create')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('file-create')));
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sibling data file snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey<String>('file-item-project-core-spec.penjar'),
        ),
        findsOneWidget,
      );
    },
  );
}
