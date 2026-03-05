import 'package:flutter_test/flutter_test.dart';
import 'package:penjar_desktop/contracts/desktop_contract_bundle.dart';
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
}
