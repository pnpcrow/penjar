import 'package:penjar_desktop/contracts/remote_stub_contracts.dart';
import 'package:penjar_desktop/contracts/workflow_contracts.dart';

bool _envFlagEnabled(String raw) {
  switch (raw.trim().toLowerCase()) {
    case '1':
    case 'true':
    case 'yes':
    case 'on':
      return true;
    default:
      return false;
  }
}

Set<String> _parseBlockedOperations(String raw) {
  final Set<String> normalizedOperations = <String>{};
  for (final String token in raw.split(',')) {
    final String normalized = token.trim().toLowerCase();
    if (normalized.isNotEmpty) {
      normalizedOperations.add(normalized);
    }
  }
  return normalizedOperations;
}

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
    final bool remoteStubUnavailable = _envFlagEnabled(
      const String.fromEnvironment('PENJAR_DESKTOP_REMOTE_STUB_UNAVAILABLE'),
    );
    final Set<String> blockedOperations = _parseBlockedOperations(
      const String.fromEnvironment(
        'PENJAR_DESKTOP_REMOTE_STUB_BLOCKED_OPERATIONS',
      ),
    );

    return DesktopContractBundle.fromMode(
      mode,
      remoteStubFaultProfile: RemoteStubFaultProfile(
        unavailable: remoteStubUnavailable,
        blockedOperations: blockedOperations,
      ),
    );
  }

  factory DesktopContractBundle.fromMode(
    DesktopContractMode mode, {
    RemoteStubFaultProfile remoteStubFaultProfile =
        const RemoteStubFaultProfile(),
  }) {
    return switch (mode) {
      DesktopContractMode.inMemory => DesktopContractBundle.inMemory(),
      DesktopContractMode.remoteStub => DesktopContractBundle.remoteStub(
        faultProfile: remoteStubFaultProfile,
      ),
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

  factory DesktopContractBundle.remoteStub({
    RemoteStubFaultProfile faultProfile = const RemoteStubFaultProfile(),
  }) {
    return DesktopContractBundle(
      mode: DesktopContractMode.remoteStub,
      authSession: RemoteStubAuthSessionContract(faultProfile: faultProfile),
      projectLifecycle: RemoteStubProjectLifecycleContract(
        faultProfile: faultProfile,
      ),
      canvasEditing: RemoteStubCanvasEditingContract(
        faultProfile: faultProfile,
      ),
      assetManagement: RemoteStubAssetManagementContract(
        faultProfile: faultProfile,
      ),
      collaborationContext: RemoteStubCollaborationContextContract(
        faultProfile: faultProfile,
      ),
      inspectHandoff: RemoteStubInspectHandoffContract(
        faultProfile: faultProfile,
      ),
      exportWorkflow: RemoteStubExportWorkflowContract(
        faultProfile: faultProfile,
      ),
      diagnosticsRecovery: RemoteStubDiagnosticsRecoveryContract(
        faultProfile: faultProfile,
      ),
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
