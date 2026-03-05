import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penjar_desktop/contracts/desktop_contract_bundle.dart';
import 'package:penjar_desktop/contracts/remote_stub_contracts.dart';

import 'parity_test_utils.dart';

class _AssetBackendSiblingDataEnvelopeParityTransportClient
    extends RemoteStubTransportClient {
  const _AssetBackendSiblingDataEnvelopeParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.importAsset) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'result': <String, Object?>{
            'meta': <String, Object?>{'requestId': 'req-asset-1'},
          },
          'data': <String, Object?>{
            'detail': 'Backend sibling data asset snapshot applied.',
            'assetState': <String, Object?>{
              'assets': <Map<String, Object?>>[
                <String, Object?>{
                  'id': 'asset-sibling',
                  'name': 'brand-kit.png',
                  'type': 'image',
                  'usedCount': 2,
                },
              ],
              'selectedAssetIndex': 0,
            },
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

void main() {
  testWidgets('asset management parity scaffold interactions work', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);
    await openWorkflowSection(tester, 'assets');

    expect(find.byKey(const ValueKey<String>('asset-panel')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('asset-summary')), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('asset-import')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('asset-import')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Asset import failed: asset name is required.'),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey<String>('asset-name-input')),
      'hero.png',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('asset-import')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('asset-import')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Asset imported: hero.png (image).'),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('asset-chip-asset-1')),
      findsOneWidget,
    );

    await tester.ensureVisible(find.byKey(const ValueKey<String>('asset-use')));
    await tester.tap(find.byKey(const ValueKey<String>('asset-use')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Asset used: hero.png (count 1).'),
      findsOneWidget,
    );
    expect(find.textContaining('used=1'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('asset-remove')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('asset-remove')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Asset removed: hero.png.'), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('asset-empty-selection')),
      findsOneWidget,
    );

    await tester.ensureVisible(find.byKey(const ValueKey<String>('asset-use')));
    await tester.tap(find.byKey(const ValueKey<String>('asset-use')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Asset use skipped: no asset selected.'),
      findsOneWidget,
    );
  });

  testWidgets(
    'asset management parity uses sibling data envelope when result lacks asset state',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AssetBackendSiblingDataEnvelopeParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'assets');

      await tester.enterText(
        find.byKey(const ValueKey<String>('asset-name-input')),
        'ignored.png',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('asset-import')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('asset-import')));
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sibling data asset snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('asset-chip-asset-sibling')),
        findsOneWidget,
      );
      expect(find.textContaining('used=2'), findsOneWidget);
    },
  );
}
