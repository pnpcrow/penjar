import 'package:flutter_test/flutter_test.dart';
import 'package:penjar_desktop/contracts/desktop_contract_bundle.dart';
import 'package:penjar_desktop/contracts/remote_stub_contracts.dart';
import 'package:penjar_desktop/contracts/workflow_contracts.dart';

void main() {
  test('in-memory bundle exposes reusable workflow contracts', () {
    final DesktopContractBundle bundle = DesktopContractBundle.inMemory();

    expect(bundle.mode, DesktopContractMode.inMemory);
    expect(bundle.authSession.state.status, 'Idle');
    bundle.authSession.signIn(
      const AuthSignInRequest(
        email: 'designer@penjar.app',
        password: 'desktop-pass',
      ),
    );
    expect(bundle.authSession.state.status, 'Signed in (simulated).');

    expect(bundle.projectLifecycle.state.projects, hasLength(1));
    expect(bundle.canvasEditing.state.shapes, isEmpty);
    expect(bundle.assetManagement.state.assets, isEmpty);
    expect(bundle.collaborationContext.state.threads, isEmpty);
    expect(bundle.inspectHandoff.state.status, 'Idle');
    expect(bundle.exportWorkflow.state.status, 'Idle');
    expect(bundle.diagnosticsRecovery.state.status, 'Idle');
    expect(bundle.remoteStubProfile, isNull);
  });

  test('contract mode parser supports remote-stub aliases', () {
    expect(
      DesktopContractMode.fromEnv('remote-stub'),
      DesktopContractMode.remoteStub,
    );
    expect(
      DesktopContractMode.fromEnv('remote_stub'),
      DesktopContractMode.remoteStub,
    );
    expect(
      DesktopContractMode.fromEnv('remote'),
      DesktopContractMode.remoteStub,
    );
    expect(
      DesktopContractMode.fromEnv('in-memory'),
      DesktopContractMode.inMemory,
    );
    expect(DesktopContractMode.fromEnv(null), DesktopContractMode.inMemory);
  });

  test('remote-stub bundle uses dedicated adapters with prefixed statuses', () {
    final DesktopContractBundle bundle = DesktopContractBundle.remoteStub();

    expect(bundle.mode, DesktopContractMode.remoteStub);
    expect(bundle.authSession, isA<RemoteStubAuthSessionContract>());
    expect(bundle.projectLifecycle, isA<RemoteStubProjectLifecycleContract>());
    expect(bundle.canvasEditing, isA<RemoteStubCanvasEditingContract>());
    expect(bundle.assetManagement, isA<RemoteStubAssetManagementContract>());
    expect(
      bundle.collaborationContext,
      isA<RemoteStubCollaborationContextContract>(),
    );
    expect(bundle.inspectHandoff, isA<RemoteStubInspectHandoffContract>());
    expect(bundle.exportWorkflow, isA<RemoteStubExportWorkflowContract>());
    expect(
      bundle.diagnosticsRecovery,
      isA<RemoteStubDiagnosticsRecoveryContract>(),
    );
    expect(bundle.remoteStubProfile, isNotNull);
    expect(bundle.remoteStubProfile?.isEmpty, isTrue);
    expect(bundle.authSession.state.status, '[remote-stub] Idle');

    bundle.authSession.signIn(
      const AuthSignInRequest(
        email: 'designer@penjar.app',
        password: 'desktop-pass',
      ),
    );
    expect(
      bundle.authSession.state.status,
      '[remote-stub] Signed in (simulated).',
    );
  });

  test('fromMode routes mode to matching bundle factory', () {
    final DesktopContractBundle inMemoryBundle = DesktopContractBundle.fromMode(
      DesktopContractMode.inMemory,
    );
    final DesktopContractBundle remoteStubBundle =
        DesktopContractBundle.fromMode(DesktopContractMode.remoteStub);
    final DesktopContractBundle blockedRemoteStubBundle =
        DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubFaultProfile: const RemoteStubFaultProfile(
            unavailable: true,
          ),
        );

    expect(inMemoryBundle.mode, DesktopContractMode.inMemory);
    expect(inMemoryBundle.remoteStubProfile, isNull);
    expect(remoteStubBundle.mode, DesktopContractMode.remoteStub);
    expect(remoteStubBundle.remoteStubProfile, isNotNull);
    expect(remoteStubBundle.authSession.state.status, '[remote-stub] Idle');

    blockedRemoteStubBundle.authSession.signIn(
      const AuthSignInRequest(
        email: 'designer@penjar.app',
        password: 'desktop-pass',
      ),
    );
    expect(
      blockedRemoteStubBundle.authSession.state.status,
      '[remote-stub] Remote bridge unavailable: sign-in.',
    );
    expect(blockedRemoteStubBundle.remoteStubProfile?.unavailable, isTrue);
  });

  test('remote-stub unavailable profile blocks mutating operations', () {
    final DesktopContractBundle bundle = DesktopContractBundle.remoteStub(
      faultProfile: const RemoteStubFaultProfile(unavailable: true),
    );

    bundle.authSession.signIn(
      const AuthSignInRequest(
        email: 'designer@penjar.app',
        password: 'desktop-pass',
      ),
    );
    expect(bundle.authSession.state.signedIn, isFalse);
    expect(
      bundle.authSession.state.status,
      '[remote-stub] Remote bridge unavailable: sign-in.',
    );

    bundle.projectLifecycle.createProject('Remote Fail');
    expect(bundle.projectLifecycle.state.projects, hasLength(1));
    expect(
      bundle.projectLifecycle.state.status,
      '[remote-stub] Remote bridge unavailable: create-project.',
    );

    bundle.exportWorkflow.runExport(
      const ExportRequest(
        fileName: 'landing',
        format: 'png',
        scale: '2x',
        includeBackground: true,
      ),
    );
    expect(bundle.exportWorkflow.state.artifacts, isEmpty);
    expect(
      bundle.exportWorkflow.state.status,
      '[remote-stub] Remote bridge unavailable: run-export.',
    );
  });

  test('remote-stub blocked operations profile blocks selected operations', () {
    final DesktopContractBundle bundle = DesktopContractBundle.fromMode(
      DesktopContractMode.remoteStub,
      remoteStubFaultProfile: const RemoteStubFaultProfile(
        blockedOperations: <String>{'sign-in'},
      ),
    );

    bundle.authSession.signIn(
      const AuthSignInRequest(
        email: 'designer@penjar.app',
        password: 'desktop-pass',
      ),
    );
    expect(bundle.authSession.state.signedIn, isFalse);
    expect(
      bundle.authSession.state.status,
      '[remote-stub] Remote bridge unavailable: sign-in.',
    );
    expect(
      bundle.remoteStubProfile?.blockedOperations,
      contains(RemoteStubOperationIds.signIn),
    );

    bundle.projectLifecycle.createProject('Allowed Project');
    expect(bundle.projectLifecycle.state.projects, hasLength(2));
    expect(
      bundle.projectLifecycle.state.status,
      '[remote-stub] Project created: Allowed Project.',
    );
  });

  test(
    'remote-stub transport client blocks selected operations independently',
    () {
      final DesktopContractBundle bundle = DesktopContractBundle.fromMode(
        DesktopContractMode.remoteStub,
        remoteStubTransportClient: const RemoteStubScriptedTransportClient(
          blockedOperations: <String>{'create-project'},
          blockedReason: 'Remote transport unavailable',
        ),
      );

      bundle.authSession.signIn(
        const AuthSignInRequest(
          email: 'designer@penjar.app',
          password: 'desktop-pass',
        ),
      );
      expect(bundle.authSession.state.signedIn, isTrue);
      expect(
        bundle.authSession.state.status,
        '[remote-stub] Signed in (simulated).',
      );

      bundle.projectLifecycle.createProject('Transport Blocked');
      expect(bundle.projectLifecycle.state.projects, hasLength(1));
      expect(
        bundle.projectLifecycle.state.status,
        '[remote-stub] Remote transport unavailable: create-project.',
      );
      expect(
        bundle.remoteStubProfile?.transportBlockedOperations,
        contains(RemoteStubOperationIds.createProject),
      );
    },
  );
}
