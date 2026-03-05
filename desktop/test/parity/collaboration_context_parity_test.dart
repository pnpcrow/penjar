import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penjar_desktop/contracts/desktop_contract_bundle.dart';
import 'package:penjar_desktop/contracts/remote_stub_contracts.dart';

import 'parity_test_utils.dart';

class _CollaborationBackendSiblingDataEnvelopeParityTransportClient
    extends RemoteStubTransportClient {
  const _CollaborationBackendSiblingDataEnvelopeParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.createThread) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'result': <String, Object?>{
            'meta': <String, Object?>{'requestId': 'req-collaboration-1'},
          },
          'data': <String, Object?>{
            'detail': 'Backend sibling data collaboration snapshot applied.',
            'collaborationState': <String, Object?>{
              'peerActive': true,
              'threads': <Map<String, Object?>>[
                <String, Object?>{
                  'id': 'thread-sibling',
                  'title': 'Backend Review',
                },
              ],
              'selectedThreadIndex': 0,
            },
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

void main() {
  testWidgets('collaboration context parity scaffold interactions work', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);
    await openWorkflowSection(tester, 'collaboration');

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

  testWidgets(
    'collaboration parity uses sibling data envelope when result lacks collaboration state',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _CollaborationBackendSiblingDataEnvelopeParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'collaboration');

      await tester.enterText(
        find.byKey(const ValueKey<String>('thread-title-input')),
        'ignored',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('thread-create')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('thread-create')));
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sibling data collaboration snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('thread-chip-thread-sibling')),
        findsOneWidget,
      );
      expect(find.textContaining('Active sessions: 2'), findsOneWidget);
    },
  );
}
