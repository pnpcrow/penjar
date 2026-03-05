import 'package:penjar_desktop/contracts/workflow_contracts.dart';

enum DesktopContractMode {
  inMemory,
  remoteStub;

  static DesktopContractMode fromEnv(String? rawMode) {
    switch (rawMode?.trim().toLowerCase()) {
      case 'remote-stub':
      case 'remote_stub':
      case 'remote':
        return DesktopContractMode.remoteStub;
      default:
        return DesktopContractMode.inMemory;
    }
  }

  String get label => switch (this) {
    DesktopContractMode.inMemory => 'in-memory',
    DesktopContractMode.remoteStub => 'remote-stub',
  };
}

class DesktopContractBundle {
  const DesktopContractBundle({
    required this.mode,
    required this.authSession,
    required this.projectLifecycle,
    required this.canvasEditing,
    required this.assetManagement,
    required this.collaborationContext,
    required this.inspectHandoff,
    required this.exportWorkflow,
    required this.diagnosticsRecovery,
  });

  factory DesktopContractBundle.fromEnvironment() {
    final DesktopContractMode mode = DesktopContractMode.fromEnv(
      const String.fromEnvironment('PENJAR_DESKTOP_CONTRACT_MODE'),
    );

    return switch (mode) {
      DesktopContractMode.inMemory => DesktopContractBundle.inMemory(),
      DesktopContractMode.remoteStub => DesktopContractBundle.remoteStub(),
    };
  }

  factory DesktopContractBundle.inMemory() {
    return DesktopContractBundle(
      mode: DesktopContractMode.inMemory,
      authSession: InMemoryAuthSessionContract(),
      projectLifecycle: InMemoryProjectLifecycleContract(),
      canvasEditing: InMemoryCanvasEditingContract(),
      assetManagement: InMemoryAssetManagementContract(),
      collaborationContext: InMemoryCollaborationContextContract(),
      inspectHandoff: InMemoryInspectHandoffContract(),
      exportWorkflow: InMemoryExportWorkflowContract(),
      diagnosticsRecovery: InMemoryDiagnosticsRecoveryContract(),
    );
  }

  // Remote-stub mode keeps contracts fully local for now, while exposing
  // a runtime switch for upcoming backend adapter wiring.
  factory DesktopContractBundle.remoteStub() {
    return DesktopContractBundle(
      mode: DesktopContractMode.remoteStub,
      authSession: InMemoryAuthSessionContract(),
      projectLifecycle: InMemoryProjectLifecycleContract(),
      canvasEditing: InMemoryCanvasEditingContract(),
      assetManagement: InMemoryAssetManagementContract(),
      collaborationContext: InMemoryCollaborationContextContract(),
      inspectHandoff: InMemoryInspectHandoffContract(),
      exportWorkflow: InMemoryExportWorkflowContract(),
      diagnosticsRecovery: InMemoryDiagnosticsRecoveryContract(),
    );
  }

  final DesktopContractMode mode;
  final AuthSessionContract authSession;
  final ProjectLifecycleContract projectLifecycle;
  final CanvasEditingContract canvasEditing;
  final AssetManagementContract assetManagement;
  final CollaborationContextContract collaborationContext;
  final InspectHandoffContract inspectHandoff;
  final ExportWorkflowContract exportWorkflow;
  final DiagnosticsRecoveryContract diagnosticsRecovery;
}
