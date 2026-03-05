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
    this.blockedOperations = const <String>{},
  });

  final bool unavailable;
  final String reason;
  final Set<String> blockedOperations;

  bool blocksOperation(String operation) {
    if (unavailable) {
      return true;
    }

    final String normalizedOperation = operation.trim().toLowerCase();
    for (final String blockedOperation in blockedOperations) {
      if (blockedOperation.trim().toLowerCase() == normalizedOperation) {
        return true;
      }
    }
    return false;
  }
}

class RemoteStubTransportRequest {
  const RemoteStubTransportRequest({required this.operation});

  final String operation;
}

class RemoteStubTransportResult {
  const RemoteStubTransportResult({this.allowed = true, this.status});

  static const RemoteStubTransportResult allow = RemoteStubTransportResult();

  factory RemoteStubTransportResult.blocked(String status) =>
      RemoteStubTransportResult(allowed: false, status: status);

  final bool allowed;
  final String? status;
}

abstract class RemoteStubTransportClient {
  const RemoteStubTransportClient();

  RemoteStubTransportResult execute(RemoteStubTransportRequest request);
}

class RemoteStubNoopTransportClient extends RemoteStubTransportClient {
  const RemoteStubNoopTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    return RemoteStubTransportResult.allow;
  }
}

class RemoteStubScriptedTransportClient extends RemoteStubTransportClient {
  const RemoteStubScriptedTransportClient({
    this.blockedOperations = const <String>{},
    this.blockedReason = 'Remote transport unavailable',
  });

  final Set<String> blockedOperations;
  final String blockedReason;

  bool _isBlocked(String operation) {
    final String normalizedOperation = operation.trim().toLowerCase();
    for (final String blockedOperation in blockedOperations) {
      if (blockedOperation.trim().toLowerCase() == normalizedOperation) {
        return true;
      }
    }
    return false;
  }

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (_isBlocked(request.operation)) {
      return RemoteStubTransportResult.blocked(
        '$blockedReason: ${request.operation}.',
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

bool _allowRemoteStubOperation({
  required RemoteStubFaultProfile faultProfile,
  required RemoteStubTransportClient transportClient,
  required String operation,
  required void Function(String status) setStatusOverride,
}) {
  if (faultProfile.blocksOperation(operation)) {
    setStatusOverride(_blockedStatus(faultProfile, operation));
    return false;
  }

  final RemoteStubTransportResult transportResult = transportClient.execute(
    RemoteStubTransportRequest(operation: operation),
  );
  if (!transportResult.allowed) {
    final String deniedStatus =
        transportResult.status ?? '${faultProfile.reason}: $operation.';
    setStatusOverride(_decorateStatus(deniedStatus));
    return false;
  }

  return true;
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
    this.transportClient = const RemoteStubNoopTransportClient(),
  }) : _delegate = delegate ?? InMemoryAuthSessionContract();

  final AuthSessionContract _delegate;
  final RemoteStubFaultProfile faultProfile;
  final RemoteStubTransportClient transportClient;
  String? _statusOverride;

  @override
  AuthSessionState get state =>
      _decorateAuthState(_delegate.state, status: _statusOverride);

  bool _allowOperation(String operation) {
    return _allowRemoteStubOperation(
      faultProfile: faultProfile,
      transportClient: transportClient,
      operation: operation,
      setStatusOverride: (String status) {
        _statusOverride = status;
      },
    );
  }

  void _clearOverride() {
    _statusOverride = null;
  }

  @override
  AuthSessionState setRememberSession(bool enabled) {
    if (!_allowOperation('set-remember-session')) {
      return state;
    }
    _clearOverride();
    return _decorateAuthState(_delegate.setRememberSession(enabled));
  }

  @override
  AuthSessionState signIn(AuthSignInRequest request) {
    if (!_allowOperation('sign-in')) {
      return state;
    }
    _clearOverride();
    return _decorateAuthState(_delegate.signIn(request));
  }

  @override
  AuthSessionState restoreSession() {
    if (!_allowOperation('restore-session')) {
      return state;
    }
    _clearOverride();
    return _decorateAuthState(_delegate.restoreSession());
  }

  @override
  AuthSessionState refreshToken() {
    if (!_allowOperation('refresh-token')) {
      return state;
    }
    _clearOverride();
    return _decorateAuthState(_delegate.refreshToken());
  }
}

class RemoteStubProjectLifecycleContract implements ProjectLifecycleContract {
  RemoteStubProjectLifecycleContract({
    ProjectLifecycleContract? delegate,
    this.faultProfile = const RemoteStubFaultProfile(),
    this.transportClient = const RemoteStubNoopTransportClient(),
  }) : _delegate = delegate ?? InMemoryProjectLifecycleContract();

  final ProjectLifecycleContract _delegate;
  final RemoteStubFaultProfile faultProfile;
  final RemoteStubTransportClient transportClient;
  String? _statusOverride;

  @override
  ProjectLifecycleState get state =>
      _decorateProjectState(_delegate.state, status: _statusOverride);

  bool _allowOperation(String operation) {
    return _allowRemoteStubOperation(
      faultProfile: faultProfile,
      transportClient: transportClient,
      operation: operation,
      setStatusOverride: (String status) {
        _statusOverride = status;
      },
    );
  }

  void _clearOverride() {
    _statusOverride = null;
  }

  @override
  ProjectLifecycleState createProject(String projectName) {
    if (!_allowOperation('create-project')) {
      return state;
    }
    _clearOverride();
    return _decorateProjectState(_delegate.createProject(projectName));
  }

  @override
  ProjectLifecycleState switchProject(int index) {
    if (!_allowOperation('switch-project')) {
      return state;
    }
    _clearOverride();
    return _decorateProjectState(_delegate.switchProject(index));
  }

  @override
  ProjectLifecycleState createFile(String fileName) {
    if (!_allowOperation('create-file')) {
      return state;
    }
    _clearOverride();
    return _decorateProjectState(_delegate.createFile(fileName));
  }

  @override
  ProjectLifecycleState deleteFirstFile() {
    if (!_allowOperation('delete-file')) {
      return state;
    }
    _clearOverride();
    return _decorateProjectState(_delegate.deleteFirstFile());
  }
}

class RemoteStubCanvasEditingContract implements CanvasEditingContract {
  RemoteStubCanvasEditingContract({
    CanvasEditingContract? delegate,
    this.faultProfile = const RemoteStubFaultProfile(),
    this.transportClient = const RemoteStubNoopTransportClient(),
  }) : _delegate = delegate ?? InMemoryCanvasEditingContract();

  final CanvasEditingContract _delegate;
  final RemoteStubFaultProfile faultProfile;
  final RemoteStubTransportClient transportClient;
  String? _statusOverride;

  @override
  CanvasEditingState get state =>
      _decorateCanvasState(_delegate.state, status: _statusOverride);

  bool _allowOperation(String operation) {
    return _allowRemoteStubOperation(
      faultProfile: faultProfile,
      transportClient: transportClient,
      operation: operation,
      setStatusOverride: (String status) {
        _statusOverride = status;
      },
    );
  }

  void _clearOverride() {
    _statusOverride = null;
  }

  @override
  CanvasEditingState createRectangle() {
    if (!_allowOperation('create-rectangle')) {
      return state;
    }
    _clearOverride();
    return _decorateCanvasState(_delegate.createRectangle());
  }

  @override
  CanvasEditingState selectShape(int index) {
    if (!_allowOperation('select-shape')) {
      return state;
    }
    _clearOverride();
    return _decorateCanvasState(_delegate.selectShape(index));
  }

  @override
  CanvasEditingState moveSelected() {
    if (!_allowOperation('move-shape')) {
      return state;
    }
    _clearOverride();
    return _decorateCanvasState(_delegate.moveSelected());
  }

  @override
  CanvasEditingState resizeSelected() {
    if (!_allowOperation('resize-shape')) {
      return state;
    }
    _clearOverride();
    return _decorateCanvasState(_delegate.resizeSelected());
  }

  @override
  CanvasEditingState toggleFillSelected() {
    if (!_allowOperation('toggle-fill')) {
      return state;
    }
    _clearOverride();
    return _decorateCanvasState(_delegate.toggleFillSelected());
  }
}

class RemoteStubAssetManagementContract implements AssetManagementContract {
  RemoteStubAssetManagementContract({
    AssetManagementContract? delegate,
    this.faultProfile = const RemoteStubFaultProfile(),
    this.transportClient = const RemoteStubNoopTransportClient(),
  }) : _delegate = delegate ?? InMemoryAssetManagementContract();

  final AssetManagementContract _delegate;
  final RemoteStubFaultProfile faultProfile;
  final RemoteStubTransportClient transportClient;
  String? _statusOverride;

  @override
  AssetManagementState get state =>
      _decorateAssetState(_delegate.state, status: _statusOverride);

  bool _allowOperation(String operation) {
    return _allowRemoteStubOperation(
      faultProfile: faultProfile,
      transportClient: transportClient,
      operation: operation,
      setStatusOverride: (String status) {
        _statusOverride = status;
      },
    );
  }

  void _clearOverride() {
    _statusOverride = null;
  }

  @override
  AssetManagementState importAsset(String assetName, String assetType) {
    if (!_allowOperation('import-asset')) {
      return state;
    }
    _clearOverride();
    return _decorateAssetState(_delegate.importAsset(assetName, assetType));
  }

  @override
  AssetManagementState selectAsset(int index) {
    if (!_allowOperation('select-asset')) {
      return state;
    }
    _clearOverride();
    return _decorateAssetState(_delegate.selectAsset(index));
  }

  @override
  AssetManagementState useSelectedAsset() {
    if (!_allowOperation('use-asset')) {
      return state;
    }
    _clearOverride();
    return _decorateAssetState(_delegate.useSelectedAsset());
  }

  @override
  AssetManagementState removeSelectedAsset() {
    if (!_allowOperation('remove-asset')) {
      return state;
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
    this.transportClient = const RemoteStubNoopTransportClient(),
  }) : _delegate = delegate ?? InMemoryCollaborationContextContract();

  final CollaborationContextContract _delegate;
  final RemoteStubFaultProfile faultProfile;
  final RemoteStubTransportClient transportClient;
  String? _statusOverride;

  @override
  CollaborationContextState get state =>
      _decorateCollaborationState(_delegate.state, status: _statusOverride);

  bool _allowOperation(String operation) {
    return _allowRemoteStubOperation(
      faultProfile: faultProfile,
      transportClient: transportClient,
      operation: operation,
      setStatusOverride: (String status) {
        _statusOverride = status;
      },
    );
  }

  void _clearOverride() {
    _statusOverride = null;
  }

  @override
  CollaborationContextState togglePeerPresence() {
    if (!_allowOperation('toggle-peer-presence')) {
      return state;
    }
    _clearOverride();
    return _decorateCollaborationState(_delegate.togglePeerPresence());
  }

  @override
  CollaborationContextState createThread(String title) {
    if (!_allowOperation('create-thread')) {
      return state;
    }
    _clearOverride();
    return _decorateCollaborationState(_delegate.createThread(title));
  }

  @override
  CollaborationContextState selectThread(int index) {
    if (!_allowOperation('select-thread')) {
      return state;
    }
    _clearOverride();
    return _decorateCollaborationState(_delegate.selectThread(index));
  }

  @override
  CollaborationContextState resolveSelectedThread() {
    if (!_allowOperation('resolve-thread')) {
      return state;
    }
    _clearOverride();
    return _decorateCollaborationState(_delegate.resolveSelectedThread());
  }
}

class RemoteStubInspectHandoffContract implements InspectHandoffContract {
  RemoteStubInspectHandoffContract({
    InspectHandoffContract? delegate,
    this.faultProfile = const RemoteStubFaultProfile(),
    this.transportClient = const RemoteStubNoopTransportClient(),
  }) : _delegate = delegate ?? InMemoryInspectHandoffContract();

  final InspectHandoffContract _delegate;
  final RemoteStubFaultProfile faultProfile;
  final RemoteStubTransportClient transportClient;
  String? _statusOverride;

  @override
  InspectHandoffState get state =>
      _decorateInspectState(_delegate.state, status: _statusOverride);

  bool _allowOperation(String operation) {
    return _allowRemoteStubOperation(
      faultProfile: faultProfile,
      transportClient: transportClient,
      operation: operation,
      setStatusOverride: (String status) {
        _statusOverride = status;
      },
    );
  }

  void _clearOverride() {
    _statusOverride = null;
  }

  @override
  InspectHandoffState setTarget(String target) {
    if (!_allowOperation('set-inspect-target')) {
      return state;
    }
    _clearOverride();
    return _decorateInspectState(_delegate.setTarget(target));
  }

  @override
  InspectHandoffState generateSnippet(String elementId) {
    if (!_allowOperation('generate-snippet')) {
      return state;
    }
    _clearOverride();
    return _decorateInspectState(_delegate.generateSnippet(elementId));
  }

  @override
  InspectHandoffState copyMetadata(String elementId) {
    if (!_allowOperation('copy-metadata')) {
      return state;
    }
    _clearOverride();
    return _decorateInspectState(_delegate.copyMetadata(elementId));
  }
}

class RemoteStubExportWorkflowContract implements ExportWorkflowContract {
  RemoteStubExportWorkflowContract({
    ExportWorkflowContract? delegate,
    this.faultProfile = const RemoteStubFaultProfile(),
    this.transportClient = const RemoteStubNoopTransportClient(),
  }) : _delegate = delegate ?? InMemoryExportWorkflowContract();

  final ExportWorkflowContract _delegate;
  final RemoteStubFaultProfile faultProfile;
  final RemoteStubTransportClient transportClient;
  String? _statusOverride;

  @override
  ExportWorkflowState get state =>
      _decorateExportState(_delegate.state, status: _statusOverride);

  bool _allowOperation(String operation) {
    return _allowRemoteStubOperation(
      faultProfile: faultProfile,
      transportClient: transportClient,
      operation: operation,
      setStatusOverride: (String status) {
        _statusOverride = status;
      },
    );
  }

  void _clearOverride() {
    _statusOverride = null;
  }

  @override
  ExportWorkflowState runExport(ExportRequest request) {
    if (!_allowOperation('run-export')) {
      return state;
    }
    _clearOverride();
    return _decorateExportState(_delegate.runExport(request));
  }

  @override
  ExportWorkflowState saveLatest() {
    if (!_allowOperation('save-export')) {
      return state;
    }
    _clearOverride();
    return _decorateExportState(_delegate.saveLatest());
  }

  @override
  ExportWorkflowState clearArtifacts() {
    if (!_allowOperation('clear-export-artifacts')) {
      return state;
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
    this.transportClient = const RemoteStubNoopTransportClient(),
  }) : _delegate = delegate ?? InMemoryDiagnosticsRecoveryContract();

  final DiagnosticsRecoveryContract _delegate;
  final RemoteStubFaultProfile faultProfile;
  final RemoteStubTransportClient transportClient;
  String? _statusOverride;

  @override
  DiagnosticsRecoveryState get state =>
      _decorateDiagnosticsState(_delegate.state, status: _statusOverride);

  bool _allowOperation(String operation) {
    return _allowRemoteStubOperation(
      faultProfile: faultProfile,
      transportClient: transportClient,
      operation: operation,
      setStatusOverride: (String status) {
        _statusOverride = status;
      },
    );
  }

  void _clearOverride() {
    _statusOverride = null;
  }

  @override
  DiagnosticsRecoveryState runHealthCheck() {
    if (!_allowOperation('run-health-check')) {
      return state;
    }
    _clearOverride();
    return _decorateDiagnosticsState(_delegate.runHealthCheck());
  }

  @override
  DiagnosticsRecoveryState simulateDisconnect() {
    if (!_allowOperation('simulate-disconnect')) {
      return state;
    }
    _clearOverride();
    return _decorateDiagnosticsState(_delegate.simulateDisconnect());
  }

  @override
  DiagnosticsRecoveryState attemptReconnect() {
    if (!_allowOperation('attempt-reconnect')) {
      return state;
    }
    _clearOverride();
    return _decorateDiagnosticsState(_delegate.attemptReconnect());
  }

  @override
  DiagnosticsRecoveryState openRecoveryGuide() {
    if (!_allowOperation('open-recovery-guide')) {
      return state;
    }
    _clearOverride();
    return _decorateDiagnosticsState(_delegate.openRecoveryGuide());
  }
}
