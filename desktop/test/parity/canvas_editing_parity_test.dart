import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penjar_desktop/contracts/desktop_contract_bundle.dart';
import 'package:penjar_desktop/contracts/remote_stub_contracts.dart';

import 'parity_test_utils.dart';

class _CanvasBackendSiblingDataEnvelopeParityTransportClient
    extends RemoteStubTransportClient {
  const _CanvasBackendSiblingDataEnvelopeParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.createRectangle) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'result': <String, Object?>{
            'meta': <String, Object?>{'requestId': 'req-canvas-1'},
          },
          'data': <String, Object?>{
            'detail': 'Backend sibling data canvas snapshot applied.',
            'canvasState': <String, Object?>{
              'shapes': <Map<String, Object?>>[
                <String, Object?>{
                  'id': 'rect-sibling',
                  'x': 32.0,
                  'y': 18.0,
                  'width': 144.0,
                  'height': 96.0,
                  'fillHex': '#FF8A00',
                },
              ],
              'selectedIndex': 0,
            },
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

void main() {
  testWidgets('canvas editing parity scaffold interactions work', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);
    await openWorkflowSection(tester, 'canvas');

    expect(find.byKey(const ValueKey<String>('canvas-panel')), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('canvas-shape-empty')),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('canvas-create-rect')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('canvas-create-rect')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Rectangle created: rect-1.'), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('canvas-shape-rect-1')),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('canvas-move')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('canvas-move')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Moved rect-1 to (20, 15).'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('canvas-resize')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('canvas-resize')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Resized rect-1 to 140x100.'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('canvas-toggle-fill')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('canvas-toggle-fill')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Fill updated for rect-1: #FF8A00.'),
      findsOneWidget,
    );
    expect(find.textContaining('fill=#FF8A00'), findsOneWidget);
  });

  testWidgets(
    'canvas editing parity uses sibling data envelope when result lacks canvas state',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _CanvasBackendSiblingDataEnvelopeParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'canvas');

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('canvas-create-rect')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('canvas-create-rect')),
      );
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sibling data canvas snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('canvas-shape-rect-sibling')),
        findsOneWidget,
      );
      expect(find.textContaining('fill=#FF8A00'), findsOneWidget);
    },
  );
}
