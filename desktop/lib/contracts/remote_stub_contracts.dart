import 'package:penjar_desktop/contracts/workflow_contracts.dart';

const String _kRemoteStubPrefix = '[remote-stub] ';

String _decorateStatus(String status) {
  if (status.startsWith(_kRemoteStubPrefix)) {
    return status;
  }
  return '$_kRemoteStubPrefix$status';
}

String _blockedStatus(RemoteStubFaultProfile faultProfile, String operation) {
  return _decorateStatus('${faultProfile.reason}: $operation.');
}

class RemoteStubFaultProfile {
  const RemoteStubFaultProfile({
    this.unavailable = false,
    this.reason = 'Remote bridge unavailable',
  });

  final bool unavailable;
  final String reason;
}

AuthSessionState _decorateAuthState(AuthSessionState state, {String? status}) =>
    AuthSessionState(
      rememberSession: state.rememberSession,
      signedIn: state.signedIn,
      status: _decorateStatus(status ?? state.status),
    );

ProjectLifecycleState _decorateProjectState(
  ProjectLifecycleState state, {
  String? status,
}) => ProjectLifecycleState(
  projects: state.projects,
  selectedProjectIndex: state.selectedProjectIndex,
  status: _decorateStatus(status ?? state.status),
);

CanvasEditingState _decorateCanvasState(
  CanvasEditingState state, {
  String? status,
}) => CanvasEditingState(
  shapes: state.shapes,
  selectedIndex: state.selectedIndex,
  status: _decorateStatus(status ?? state.status),
);

AssetManagementState _decorateAssetState(
  AssetManagementState state, {
  String? status,
}) => AssetManagementState(
  assets: state.assets,
  selectedAssetIndex: state.selectedAssetIndex,
  status: _decorateStatus(status ?? state.status),
);

CollaborationContextState _decorateCollaborationState(
  CollaborationContextState state, {
  String? status,
}) => CollaborationContextState(
  peerActive: state.peerActive,
  threads: state.threads,
  selectedThreadIndex: state.selectedThreadIndex,
  status: _decorateStatus(status ?? state.status),
);

InspectHandoffState _decorateInspectState(
  InspectHandoffState state, {
  String? status,
}) => InspectHandoffState(
  target: state.target,
  snippet: state.snippet,
  status: _decorateStatus(status ?? state.status),
);

ExportWorkflowState _decorateExportState(
  ExportWorkflowState state, {
  String? status,
}) => ExportWorkflowState(
  artifacts: state.artifacts,
  status: _decorateStatus(status ?? state.status),
);

DiagnosticsRecoveryState _decorateDiagnosticsState(
  DiagnosticsRecoveryState state, {
  String? status,
}) => DiagnosticsRecoveryState(
  websocketHealthy: state.websocketHealthy,
  mcpHealthy: state.mcpHealthy,
  reconnectAttempts: state.reconnectAttempts,
  status: _decorateStatus(status ?? state.status),
);

class RemoteStubAuthSessionContract implements AuthSessionContract {
  RemoteStubAuthSessionContract({
    AuthSessionContract? delegate,
    this.faultProfile = const RemoteStubFaultProfile(),
  }) : _delegate = delegate ?? InMemoryAuthSessionContract();

  final AuthSessionContract _delegate;
  final RemoteStubFaultProfile faultProfile;
  String? _statusOverride;

  @override
  AuthSessionState get state =>
      _decorateAuthState(_delegate.state, status: _statusOverride);

  AuthSessionState _blocked(String operation) {
    _statusOverride = _blockedStatus(faultProfile, operation);
    return state;
  }

  void _clearOverride() {
    _statusOverride = null;
  }

  @override
  AuthSessionState setRememberSession(bool enabled) {
    if (faultProfile.unavailable) {
      return _blocked('set-remember-session');
    }
    _clearOverride();
    return _decorateAuthState(_delegate.setRememberSession(enabled));
  }

  @override
  AuthSessionState signIn(AuthSignInRequest request) {
    if (faultProfile.unavailable) {
      return _blocked('sign-in');
    }
    _clearOverride();
    return _decorateAuthState(_delegate.signIn(request));
  }

  @override
  AuthSessionState restoreSession() {
    if (faultProfile.unavailable) {
      return _blocked('restore-session');
    }
    _clearOverride();
    return _decorateAuthState(_delegate.restoreSession());
  }

  @override
  AuthSessionState refreshToken() {
    if (faultProfile.unavailable) {
      return _blocked('refresh-token');
    }
    _clearOverride();
    return _decorateAuthState(_delegate.refreshToken());
  }
}

class RemoteStubProjectLifecycleContract implements ProjectLifecycleContract {
  RemoteStubProjectLifecycleContract({
    ProjectLifecycleContract? delegate,
    this.faultProfile = const RemoteStubFaultProfile(),
  }) : _delegate = delegate ?? InMemoryProjectLifecycleContract();

  final ProjectLifecycleContract _delegate;
  final RemoteStubFaultProfile faultProfile;
  String? _statusOverride;

  @override
  ProjectLifecycleState get state =>
      _decorateProjectState(_delegate.state, status: _statusOverride);

  ProjectLifecycleState _blocked(String operation) {
    _statusOverride = _blockedStatus(faultProfile, operation);
    return state;
  }

  void _clearOverride() {
    _statusOverride = null;
  }

  @override
  ProjectLifecycleState createProject(String projectName) {
    if (faultProfile.unavailable) {
      return _blocked('create-project');
    }
    _clearOverride();
    return _decorateProjectState(_delegate.createProject(projectName));
  }

  @override
  ProjectLifecycleState switchProject(int index) {
    if (faultProfile.unavailable) {
      return _blocked('switch-project');
    }
    _clearOverride();
    return _decorateProjectState(_delegate.switchProject(index));
  }

  @override
  ProjectLifecycleState createFile(String fileName) {
    if (faultProfile.unavailable) {
      return _blocked('create-file');
    }
    _clearOverride();
    return _decorateProjectState(_delegate.createFile(fileName));
  }

  @override
  ProjectLifecycleState deleteFirstFile() {
    if (faultProfile.unavailable) {
      return _blocked('delete-file');
    }
    _clearOverride();
    return _decorateProjectState(_delegate.deleteFirstFile());
  }
}

class RemoteStubCanvasEditingContract implements CanvasEditingContract {
  RemoteStubCanvasEditingContract({
    CanvasEditingContract? delegate,
    this.faultProfile = const RemoteStubFaultProfile(),
  }) : _delegate = delegate ?? InMemoryCanvasEditingContract();

  final CanvasEditingContract _delegate;
  final RemoteStubFaultProfile faultProfile;
  String? _statusOverride;

  @override
  CanvasEditingState get state =>
      _decorateCanvasState(_delegate.state, status: _statusOverride);

  CanvasEditingState _blocked(String operation) {
    _statusOverride = _blockedStatus(faultProfile, operation);
    return state;
  }

  void _clearOverride() {
    _statusOverride = null;
  }

  @override
  CanvasEditingState createRectangle() {
    if (faultProfile.unavailable) {
      return _blocked('create-rectangle');
    }
    _clearOverride();
    return _decorateCanvasState(_delegate.createRectangle());
  }

  @override
  CanvasEditingState selectShape(int index) {
    if (faultProfile.unavailable) {
      return _blocked('select-shape');
    }
    _clearOverride();
    return _decorateCanvasState(_delegate.selectShape(index));
  }

  @override
  CanvasEditingState moveSelected() {
    if (faultProfile.unavailable) {
      return _blocked('move-shape');
    }
    _clearOverride();
    return _decorateCanvasState(_delegate.moveSelected());
  }

  @override
  CanvasEditingState resizeSelected() {
    if (faultProfile.unavailable) {
      return _blocked('resize-shape');
    }
    _clearOverride();
    return _decorateCanvasState(_delegate.resizeSelected());
  }

  @override
  CanvasEditingState toggleFillSelected() {
    if (faultProfile.unavailable) {
      return _blocked('toggle-fill');
    }
    _clearOverride();
    return _decorateCanvasState(_delegate.toggleFillSelected());
  }
}

class RemoteStubAssetManagementContract implements AssetManagementContract {
  RemoteStubAssetManagementContract({
    AssetManagementContract? delegate,
    this.faultProfile = const RemoteStubFaultProfile(),
  }) : _delegate = delegate ?? InMemoryAssetManagementContract();

  final AssetManagementContract _delegate;
  final RemoteStubFaultProfile faultProfile;
  String? _statusOverride;

  @override
  AssetManagementState get state =>
      _decorateAssetState(_delegate.state, status: _statusOverride);

  AssetManagementState _blocked(String operation) {
    _statusOverride = _blockedStatus(faultProfile, operation);
    return state;
  }

  void _clearOverride() {
    _statusOverride = null;
  }

  @override
  AssetManagementState importAsset(String assetName, String assetType) {
    if (faultProfile.unavailable) {
      return _blocked('import-asset');
    }
    _clearOverride();
    return _decorateAssetState(_delegate.importAsset(assetName, assetType));
  }

  @override
  AssetManagementState selectAsset(int index) {
    if (faultProfile.unavailable) {
      return _blocked('select-asset');
    }
    _clearOverride();
    return _decorateAssetState(_delegate.selectAsset(index));
  }

  @override
  AssetManagementState useSelectedAsset() {
    if (faultProfile.unavailable) {
      return _blocked('use-asset');
    }
    _clearOverride();
    return _decorateAssetState(_delegate.useSelectedAsset());
  }

  @override
  AssetManagementState removeSelectedAsset() {
    if (faultProfile.unavailable) {
      return _blocked('remove-asset');
    }
    _clearOverride();
    return _decorateAssetState(_delegate.removeSelectedAsset());
  }
}

class RemoteStubCollaborationContextContract
    implements CollaborationContextContract {
  RemoteStubCollaborationContextContract({
    CollaborationContextContract? delegate,
    this.faultProfile = const RemoteStubFaultProfile(),
  }) : _delegate = delegate ?? InMemoryCollaborationContextContract();

  final CollaborationContextContract _delegate;
  final RemoteStubFaultProfile faultProfile;
  String? _statusOverride;

  @override
  CollaborationContextState get state =>
      _decorateCollaborationState(_delegate.state, status: _statusOverride);

  CollaborationContextState _blocked(String operation) {
    _statusOverride = _blockedStatus(faultProfile, operation);
    return state;
  }

  void _clearOverride() {
    _statusOverride = null;
  }

  @override
  CollaborationContextState togglePeerPresence() {
    if (faultProfile.unavailable) {
      return _blocked('toggle-peer-presence');
    }
    _clearOverride();
    return _decorateCollaborationState(_delegate.togglePeerPresence());
  }

  @override
  CollaborationContextState createThread(String title) {
    if (faultProfile.unavailable) {
      return _blocked('create-thread');
    }
    _clearOverride();
    return _decorateCollaborationState(_delegate.createThread(title));
  }

  @override
  CollaborationContextState selectThread(int index) {
    if (faultProfile.unavailable) {
      return _blocked('select-thread');
    }
    _clearOverride();
    return _decorateCollaborationState(_delegate.selectThread(index));
  }

  @override
  CollaborationContextState resolveSelectedThread() {
    if (faultProfile.unavailable) {
      return _blocked('resolve-thread');
    }
    _clearOverride();
    return _decorateCollaborationState(_delegate.resolveSelectedThread());
  }
}

class RemoteStubInspectHandoffContract implements InspectHandoffContract {
  RemoteStubInspectHandoffContract({
    InspectHandoffContract? delegate,
    this.faultProfile = const RemoteStubFaultProfile(),
  }) : _delegate = delegate ?? InMemoryInspectHandoffContract();

  final InspectHandoffContract _delegate;
  final RemoteStubFaultProfile faultProfile;
  String? _statusOverride;

  @override
  InspectHandoffState get state =>
      _decorateInspectState(_delegate.state, status: _statusOverride);

  InspectHandoffState _blocked(String operation) {
    _statusOverride = _blockedStatus(faultProfile, operation);
    return state;
  }

  void _clearOverride() {
    _statusOverride = null;
  }

  @override
  InspectHandoffState setTarget(String target) {
    if (faultProfile.unavailable) {
      return _blocked('set-inspect-target');
    }
    _clearOverride();
    return _decorateInspectState(_delegate.setTarget(target));
  }

  @override
  InspectHandoffState generateSnippet(String elementId) {
    if (faultProfile.unavailable) {
      return _blocked('generate-snippet');
    }
    _clearOverride();
    return _decorateInspectState(_delegate.generateSnippet(elementId));
  }

  @override
  InspectHandoffState copyMetadata(String elementId) {
    if (faultProfile.unavailable) {
      return _blocked('copy-metadata');
    }
    _clearOverride();
    return _decorateInspectState(_delegate.copyMetadata(elementId));
  }
}

class RemoteStubExportWorkflowContract implements ExportWorkflowContract {
  RemoteStubExportWorkflowContract({
    ExportWorkflowContract? delegate,
    this.faultProfile = const RemoteStubFaultProfile(),
  }) : _delegate = delegate ?? InMemoryExportWorkflowContract();

  final ExportWorkflowContract _delegate;
  final RemoteStubFaultProfile faultProfile;
  String? _statusOverride;

  @override
  ExportWorkflowState get state =>
      _decorateExportState(_delegate.state, status: _statusOverride);

  ExportWorkflowState _blocked(String operation) {
    _statusOverride = _blockedStatus(faultProfile, operation);
    return state;
  }

  void _clearOverride() {
    _statusOverride = null;
  }

  @override
  ExportWorkflowState runExport(ExportRequest request) {
    if (faultProfile.unavailable) {
      return _blocked('run-export');
    }
    _clearOverride();
    return _decorateExportState(_delegate.runExport(request));
  }

  @override
  ExportWorkflowState saveLatest() {
    if (faultProfile.unavailable) {
      return _blocked('save-export');
    }
    _clearOverride();
    return _decorateExportState(_delegate.saveLatest());
  }

  @override
  ExportWorkflowState clearArtifacts() {
    if (faultProfile.unavailable) {
      return _blocked('clear-export-artifacts');
    }
    _clearOverride();
    return _decorateExportState(_delegate.clearArtifacts());
  }
}

class RemoteStubDiagnosticsRecoveryContract
    implements DiagnosticsRecoveryContract {
  RemoteStubDiagnosticsRecoveryContract({
    DiagnosticsRecoveryContract? delegate,
    this.faultProfile = const RemoteStubFaultProfile(),
  }) : _delegate = delegate ?? InMemoryDiagnosticsRecoveryContract();

  final DiagnosticsRecoveryContract _delegate;
  final RemoteStubFaultProfile faultProfile;
  String? _statusOverride;

  @override
  DiagnosticsRecoveryState get state =>
      _decorateDiagnosticsState(_delegate.state, status: _statusOverride);

  DiagnosticsRecoveryState _blocked(String operation) {
    _statusOverride = _blockedStatus(faultProfile, operation);
    return state;
  }

  void _clearOverride() {
    _statusOverride = null;
  }

  @override
  DiagnosticsRecoveryState runHealthCheck() {
    if (faultProfile.unavailable) {
      return _blocked('run-health-check');
    }
    _clearOverride();
    return _decorateDiagnosticsState(_delegate.runHealthCheck());
  }

  @override
  DiagnosticsRecoveryState simulateDisconnect() {
    if (faultProfile.unavailable) {
      return _blocked('simulate-disconnect');
    }
    _clearOverride();
    return _decorateDiagnosticsState(_delegate.simulateDisconnect());
  }

  @override
  DiagnosticsRecoveryState attemptReconnect() {
    if (faultProfile.unavailable) {
      return _blocked('attempt-reconnect');
    }
    _clearOverride();
    return _decorateDiagnosticsState(_delegate.attemptReconnect());
  }

  @override
  DiagnosticsRecoveryState openRecoveryGuide() {
    if (faultProfile.unavailable) {
      return _blocked('open-recovery-guide');
    }
    _clearOverride();
    return _decorateDiagnosticsState(_delegate.openRecoveryGuide());
  }
}
