import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penjar_desktop/contracts/desktop_contract_bundle.dart';
import 'package:penjar_desktop/contracts/remote_stub_contracts.dart';

import 'parity_test_utils.dart';

class _ExportBackendSiblingDataEnvelopeParityTransportClient
    extends RemoteStubTransportClient {
  const _ExportBackendSiblingDataEnvelopeParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.runExport) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'result': <String, Object?>{
            'meta': <String, Object?>{'requestId': 'req-export-1'},
          },
          'data': <String, Object?>{
            'detail': 'Backend sibling data export snapshot applied.',
            'exportState': <String, Object?>{
              'artifacts': <Map<String, Object?>>[
                <String, Object?>{
                  'id': 'export-sibling',
                  'fileName': 'remote-landing',
                  'format': 'svg',
                  'scale': '3x',
                  'includeBackground': false,
                },
              ],
            },
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

void main() {
  testWidgets('export workflow parity scaffold interactions work', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);
    await openWorkflowSection(tester, 'export');

    expect(find.byKey(const ValueKey<String>('export-panel')), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('export-summary')),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey<String>('export-file-name')),
      '',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('export-run')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('export-run')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Export failed: file name is required.'),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey<String>('export-file-name')),
      'landing',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('export-run')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('export-run')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Export completed: /exports/landing.png.'),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('export-chip-export-1')),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('export-save-latest')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('export-save-latest')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Export saved (simulated): /exports/landing.png.'),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('export-clear')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('export-clear')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Export artifacts cleared.'), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('export-empty')), findsOneWidget);
  });

  testWidgets(
    'export parity uses sibling data envelope when result lacks export state',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _ExportBackendSiblingDataEnvelopeParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'export');

      await tester.enterText(
        find.byKey(const ValueKey<String>('export-file-name')),
        'ignored',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('export-run')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('export-run')));
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sibling data export snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('export-chip-export-sibling')),
        findsOneWidget,
      );
      expect(
        find.textContaining('/exports/remote-landing.svg'),
        findsAtLeastNWidgets(1),
      );
    },
  );
}
