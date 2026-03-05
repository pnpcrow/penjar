import 'package:penjar_desktop/contracts/workflow_contracts.dart';

const String _kRemoteStubPrefix = '[remote-stub] ';

String _decorateStatus(String status) {
  if (status.startsWith(_kRemoteStubPrefix)) {
    return status;
  }
  return '$_kRemoteStubPrefix$status';
}

AuthSessionState _decorateAuthState(AuthSessionState state) => AuthSessionState(
  rememberSession: state.rememberSession,
  signedIn: state.signedIn,
  status: _decorateStatus(state.status),
);

ProjectLifecycleState _decorateProjectState(ProjectLifecycleState state) =>
    ProjectLifecycleState(
      projects: state.projects,
      selectedProjectIndex: state.selectedProjectIndex,
      status: _decorateStatus(state.status),
    );

CanvasEditingState _decorateCanvasState(CanvasEditingState state) =>
    CanvasEditingState(
      shapes: state.shapes,
      selectedIndex: state.selectedIndex,
      status: _decorateStatus(state.status),
    );

AssetManagementState _decorateAssetState(AssetManagementState state) =>
    AssetManagementState(
      assets: state.assets,
      selectedAssetIndex: state.selectedAssetIndex,
      status: _decorateStatus(state.status),
    );

CollaborationContextState _decorateCollaborationState(
  CollaborationContextState state,
) => CollaborationContextState(
  peerActive: state.peerActive,
  threads: state.threads,
  selectedThreadIndex: state.selectedThreadIndex,
  status: _decorateStatus(state.status),
);

InspectHandoffState _decorateInspectState(InspectHandoffState state) =>
    InspectHandoffState(
      target: state.target,
      snippet: state.snippet,
      status: _decorateStatus(state.status),
    );

ExportWorkflowState _decorateExportState(ExportWorkflowState state) =>
    ExportWorkflowState(
      artifacts: state.artifacts,
      status: _decorateStatus(state.status),
    );

DiagnosticsRecoveryState _decorateDiagnosticsState(
  DiagnosticsRecoveryState state,
) => DiagnosticsRecoveryState(
  websocketHealthy: state.websocketHealthy,
  mcpHealthy: state.mcpHealthy,
  reconnectAttempts: state.reconnectAttempts,
  status: _decorateStatus(state.status),
);

class RemoteStubAuthSessionContract implements AuthSessionContract {
  RemoteStubAuthSessionContract({AuthSessionContract? delegate})
    : _delegate = delegate ?? InMemoryAuthSessionContract();

  final AuthSessionContract _delegate;

  @override
  AuthSessionState get state => _decorateAuthState(_delegate.state);

  @override
  AuthSessionState setRememberSession(bool enabled) =>
      _decorateAuthState(_delegate.setRememberSession(enabled));

  @override
  AuthSessionState signIn(AuthSignInRequest request) =>
      _decorateAuthState(_delegate.signIn(request));

  @override
  AuthSessionState restoreSession() =>
      _decorateAuthState(_delegate.restoreSession());

  @override
  AuthSessionState refreshToken() =>
      _decorateAuthState(_delegate.refreshToken());
}

class RemoteStubProjectLifecycleContract implements ProjectLifecycleContract {
  RemoteStubProjectLifecycleContract({ProjectLifecycleContract? delegate})
    : _delegate = delegate ?? InMemoryProjectLifecycleContract();

  final ProjectLifecycleContract _delegate;

  @override
  ProjectLifecycleState get state => _decorateProjectState(_delegate.state);

  @override
  ProjectLifecycleState createProject(String projectName) =>
      _decorateProjectState(_delegate.createProject(projectName));

  @override
  ProjectLifecycleState switchProject(int index) =>
      _decorateProjectState(_delegate.switchProject(index));

  @override
  ProjectLifecycleState createFile(String fileName) =>
      _decorateProjectState(_delegate.createFile(fileName));

  @override
  ProjectLifecycleState deleteFirstFile() =>
      _decorateProjectState(_delegate.deleteFirstFile());
}

class RemoteStubCanvasEditingContract implements CanvasEditingContract {
  RemoteStubCanvasEditingContract({CanvasEditingContract? delegate})
    : _delegate = delegate ?? InMemoryCanvasEditingContract();

  final CanvasEditingContract _delegate;

  @override
  CanvasEditingState get state => _decorateCanvasState(_delegate.state);

  @override
  CanvasEditingState createRectangle() =>
      _decorateCanvasState(_delegate.createRectangle());

  @override
  CanvasEditingState selectShape(int index) =>
      _decorateCanvasState(_delegate.selectShape(index));

  @override
  CanvasEditingState moveSelected() =>
      _decorateCanvasState(_delegate.moveSelected());

  @override
  CanvasEditingState resizeSelected() =>
      _decorateCanvasState(_delegate.resizeSelected());

  @override
  CanvasEditingState toggleFillSelected() =>
      _decorateCanvasState(_delegate.toggleFillSelected());
}

class RemoteStubAssetManagementContract implements AssetManagementContract {
  RemoteStubAssetManagementContract({AssetManagementContract? delegate})
    : _delegate = delegate ?? InMemoryAssetManagementContract();

  final AssetManagementContract _delegate;

  @override
  AssetManagementState get state => _decorateAssetState(_delegate.state);

  @override
  AssetManagementState importAsset(String assetName, String assetType) =>
      _decorateAssetState(_delegate.importAsset(assetName, assetType));

  @override
  AssetManagementState selectAsset(int index) =>
      _decorateAssetState(_delegate.selectAsset(index));

  @override
  AssetManagementState useSelectedAsset() =>
      _decorateAssetState(_delegate.useSelectedAsset());

  @override
  AssetManagementState removeSelectedAsset() =>
      _decorateAssetState(_delegate.removeSelectedAsset());
}

class RemoteStubCollaborationContextContract
    implements CollaborationContextContract {
  RemoteStubCollaborationContextContract({
    CollaborationContextContract? delegate,
  }) : _delegate = delegate ?? InMemoryCollaborationContextContract();

  final CollaborationContextContract _delegate;

  @override
  CollaborationContextState get state =>
      _decorateCollaborationState(_delegate.state);

  @override
  CollaborationContextState togglePeerPresence() =>
      _decorateCollaborationState(_delegate.togglePeerPresence());

  @override
  CollaborationContextState createThread(String title) =>
      _decorateCollaborationState(_delegate.createThread(title));

  @override
  CollaborationContextState selectThread(int index) =>
      _decorateCollaborationState(_delegate.selectThread(index));

  @override
  CollaborationContextState resolveSelectedThread() =>
      _decorateCollaborationState(_delegate.resolveSelectedThread());
}

class RemoteStubInspectHandoffContract implements InspectHandoffContract {
  RemoteStubInspectHandoffContract({InspectHandoffContract? delegate})
    : _delegate = delegate ?? InMemoryInspectHandoffContract();

  final InspectHandoffContract _delegate;

  @override
  InspectHandoffState get state => _decorateInspectState(_delegate.state);

  @override
  InspectHandoffState setTarget(String target) =>
      _decorateInspectState(_delegate.setTarget(target));

  @override
  InspectHandoffState generateSnippet(String elementId) =>
      _decorateInspectState(_delegate.generateSnippet(elementId));

  @override
  InspectHandoffState copyMetadata(String elementId) =>
      _decorateInspectState(_delegate.copyMetadata(elementId));
}

class RemoteStubExportWorkflowContract implements ExportWorkflowContract {
  RemoteStubExportWorkflowContract({ExportWorkflowContract? delegate})
    : _delegate = delegate ?? InMemoryExportWorkflowContract();

  final ExportWorkflowContract _delegate;

  @override
  ExportWorkflowState get state => _decorateExportState(_delegate.state);

  @override
  ExportWorkflowState runExport(ExportRequest request) =>
      _decorateExportState(_delegate.runExport(request));

  @override
  ExportWorkflowState saveLatest() =>
      _decorateExportState(_delegate.saveLatest());

  @override
  ExportWorkflowState clearArtifacts() =>
      _decorateExportState(_delegate.clearArtifacts());
}

class RemoteStubDiagnosticsRecoveryContract
    implements DiagnosticsRecoveryContract {
  RemoteStubDiagnosticsRecoveryContract({DiagnosticsRecoveryContract? delegate})
    : _delegate = delegate ?? InMemoryDiagnosticsRecoveryContract();

  final DiagnosticsRecoveryContract _delegate;

  @override
  DiagnosticsRecoveryState get state =>
      _decorateDiagnosticsState(_delegate.state);

  @override
  DiagnosticsRecoveryState runHealthCheck() =>
      _decorateDiagnosticsState(_delegate.runHealthCheck());

  @override
  DiagnosticsRecoveryState simulateDisconnect() =>
      _decorateDiagnosticsState(_delegate.simulateDisconnect());

  @override
  DiagnosticsRecoveryState attemptReconnect() =>
      _decorateDiagnosticsState(_delegate.attemptReconnect());

  @override
  DiagnosticsRecoveryState openRecoveryGuide() =>
      _decorateDiagnosticsState(_delegate.openRecoveryGuide());
}
