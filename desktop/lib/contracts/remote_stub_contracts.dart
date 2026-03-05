import 'dart:io';

import 'package:penjar_desktop/contracts/workflow_contracts.dart';

const String _kRemoteStubPrefix = '[remote-stub] ';

String _normalizeOperation(String operation) => operation.trim().toLowerCase();

final Expando<Set<String>> _normalizedOperationSetCache = Expando<Set<String>>(
  'normalizedRemoteStubOperationSet',
);

Set<String> _normalizedOperationSet(Set<String> operations) {
  final Set<String>? cached = _normalizedOperationSetCache[operations];
  if (cached != null) {
    return cached;
  }
  final Set<String> normalized = operations.map(_normalizeOperation).toSet();
  _normalizedOperationSetCache[operations] = normalized;
  return normalized;
}

class RemoteStubOperationIds {
  const RemoteStubOperationIds._();

  static const String setRememberSession = 'set-remember-session';
  static const String signIn = 'sign-in';
  static const String restoreSession = 'restore-session';
  static const String refreshToken = 'refresh-token';

  static const String createProject = 'create-project';
  static const String switchProject = 'switch-project';
  static const String createFile = 'create-file';
  static const String deleteFile = 'delete-file';

  static const String createRectangle = 'create-rectangle';
  static const String selectShape = 'select-shape';
  static const String moveShape = 'move-shape';
  static const String resizeShape = 'resize-shape';
  static const String toggleFill = 'toggle-fill';

  static const String importAsset = 'import-asset';
  static const String selectAsset = 'select-asset';
  static const String useAsset = 'use-asset';
  static const String removeAsset = 'remove-asset';

  static const String togglePeerPresence = 'toggle-peer-presence';
  static const String createThread = 'create-thread';
  static const String selectThread = 'select-thread';
  static const String resolveThread = 'resolve-thread';

  static const String setInspectTarget = 'set-inspect-target';
  static const String generateSnippet = 'generate-snippet';
  static const String copyMetadata = 'copy-metadata';

  static const String runExport = 'run-export';
  static const String saveExport = 'save-export';
  static const String clearExportArtifacts = 'clear-export-artifacts';

  static const String runHealthCheck = 'run-health-check';
  static const String simulateDisconnect = 'simulate-disconnect';
  static const String attemptReconnect = 'attempt-reconnect';
  static const String openRecoveryGuide = 'open-recovery-guide';

  static const Set<String> all = <String>{
    setRememberSession,
    signIn,
    restoreSession,
    refreshToken,
    createProject,
    switchProject,
    createFile,
    deleteFile,
    createRectangle,
    selectShape,
    moveShape,
    resizeShape,
    toggleFill,
    importAsset,
    selectAsset,
    useAsset,
    removeAsset,
    togglePeerPresence,
    createThread,
    selectThread,
    resolveThread,
    setInspectTarget,
    generateSnippet,
    copyMetadata,
    runExport,
    saveExport,
    clearExportArtifacts,
    runHealthCheck,
    simulateDisconnect,
    attemptReconnect,
    openRecoveryGuide,
  };
}

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
    return _normalizedOperationSet(
      blockedOperations,
    ).contains(_normalizeOperation(operation));
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

class RemoteStubTransportProfile {
  const RemoteStubTransportProfile({
    this.blockedOperations = const <String>{},
    this.blockedReason = 'Remote transport unavailable',
    this.transportLabel = '',
  });

  final Set<String> blockedOperations;
  final String blockedReason;
  final String transportLabel;

  bool get isEmpty =>
      blockedOperations.isEmpty && transportLabel.trim().isEmpty;
}

abstract class RemoteStubTransportClient {
  const RemoteStubTransportClient();

  RemoteStubTransportResult execute(RemoteStubTransportRequest request);

  RemoteStubTransportProfile get profile => const RemoteStubTransportProfile();
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
    return _normalizedOperationSet(
      blockedOperations,
    ).contains(_normalizeOperation(operation));
  }

  @override
  RemoteStubTransportProfile get profile => RemoteStubTransportProfile(
    blockedOperations: _normalizedOperationSet(blockedOperations),
    blockedReason: blockedReason,
  );

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

class RemoteStubHttpTransportProbeRequest {
  const RemoteStubHttpTransportProbeRequest({
    required this.operation,
    required this.healthUrl,
    required this.timeout,
    required this.allowedStatusCodes,
  });

  final String operation;
  final String healthUrl;
  final Duration timeout;
  final Set<int> allowedStatusCodes;
}

class RemoteStubHttpTransportProbeResult {
  const RemoteStubHttpTransportProbeResult({required this.allowed});

  const RemoteStubHttpTransportProbeResult.allowed() : allowed = true;

  const RemoteStubHttpTransportProbeResult.blocked() : allowed = false;

  final bool allowed;
}

typedef RemoteStubHttpTransportProbe =
    RemoteStubHttpTransportProbeResult Function(
      RemoteStubHttpTransportProbeRequest request,
    );

String _buildHttpTransportLabel(String healthUrl) {
  final String trimmed = healthUrl.trim();
  if (trimmed.isEmpty) {
    return '';
  }
  final Uri? uri = Uri.tryParse(trimmed);
  if (uri == null || uri.host.isEmpty) {
    return 'http-health';
  }
  final String scheme = uri.scheme.isEmpty ? 'http' : uri.scheme;
  final String path = uri.path.isEmpty ? '/' : uri.path;
  final String port = uri.hasPort ? ':${uri.port}' : '';
  return 'http-health:$scheme://${uri.host}$port$path';
}

int? _parseCurlHttpStatusCode(String stdoutText) {
  final List<String> lines = stdoutText.split(RegExp(r'[\r\n]+'));
  for (int index = lines.length - 1; index >= 0; index -= 1) {
    final String line = lines[index].trim();
    if (line.isEmpty) {
      continue;
    }
    return int.tryParse(line);
  }
  return null;
}

RemoteStubHttpTransportProbeResult _defaultHttpTransportProbe(
  RemoteStubHttpTransportProbeRequest request,
) {
  final double timeoutSeconds = request.timeout.inMilliseconds / 1000;
  final ProcessResult probeResult;
  try {
    probeResult = Process.runSync('curl', <String>[
      '--silent',
      '--show-error',
      '--max-time',
      timeoutSeconds.toStringAsFixed(3),
      '--write-out',
      r'\n%{http_code}',
      request.healthUrl,
    ]);
  } on ProcessException {
    return const RemoteStubHttpTransportProbeResult.blocked();
  }
  if (probeResult.exitCode != 0) {
    return const RemoteStubHttpTransportProbeResult.blocked();
  }

  final int? statusCode = _parseCurlHttpStatusCode('${probeResult.stdout}');
  if (statusCode == null) {
    return const RemoteStubHttpTransportProbeResult.blocked();
  }
  if (request.allowedStatusCodes.contains(statusCode)) {
    return const RemoteStubHttpTransportProbeResult.allowed();
  }
  return const RemoteStubHttpTransportProbeResult.blocked();
}

class RemoteStubHttpTransportClient extends RemoteStubTransportClient {
  RemoteStubHttpTransportClient({
    required String healthUrl,
    this.timeout = const Duration(seconds: 2),
    this.allowedStatusCodes = const <int>{200},
    this.blockedReason = 'Remote transport unavailable',
    RemoteStubHttpTransportProbe? probe,
  }) : healthUrl = healthUrl.trim(),
       _probe = probe ?? _defaultHttpTransportProbe,
       transportLabel = _buildHttpTransportLabel(healthUrl);

  final String healthUrl;
  final Duration timeout;
  final Set<int> allowedStatusCodes;
  final String blockedReason;
  final String transportLabel;
  final RemoteStubHttpTransportProbe _probe;

  Set<int> get _effectiveAllowedStatusCodes {
    final Set<int> normalized = allowedStatusCodes
        .where((int code) => code >= 100 && code <= 599)
        .toSet();
    return normalized.isEmpty ? const <int>{200} : normalized;
  }

  @override
  RemoteStubTransportProfile get profile => RemoteStubTransportProfile(
    blockedReason: blockedReason,
    transportLabel: transportLabel,
  );

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (healthUrl.isEmpty) {
      return RemoteStubTransportResult.allow;
    }
    final RemoteStubHttpTransportProbeResult probeResult = _probe(
      RemoteStubHttpTransportProbeRequest(
        operation: request.operation,
        healthUrl: healthUrl,
        timeout: timeout,
        allowedStatusCodes: _effectiveAllowedStatusCodes,
      ),
    );
    if (!probeResult.allowed) {
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
    if (!_allowOperation(RemoteStubOperationIds.setRememberSession)) {
      return state;
    }
    _clearOverride();
    return _decorateAuthState(_delegate.setRememberSession(enabled));
  }

  @override
  AuthSessionState signIn(AuthSignInRequest request) {
    if (!_allowOperation(RemoteStubOperationIds.signIn)) {
      return state;
    }
    _clearOverride();
    return _decorateAuthState(_delegate.signIn(request));
  }

  @override
  AuthSessionState restoreSession() {
    if (!_allowOperation(RemoteStubOperationIds.restoreSession)) {
      return state;
    }
    _clearOverride();
    return _decorateAuthState(_delegate.restoreSession());
  }

  @override
  AuthSessionState refreshToken() {
    if (!_allowOperation(RemoteStubOperationIds.refreshToken)) {
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
    if (!_allowOperation(RemoteStubOperationIds.createProject)) {
      return state;
    }
    _clearOverride();
    return _decorateProjectState(_delegate.createProject(projectName));
  }

  @override
  ProjectLifecycleState switchProject(int index) {
    if (!_allowOperation(RemoteStubOperationIds.switchProject)) {
      return state;
    }
    _clearOverride();
    return _decorateProjectState(_delegate.switchProject(index));
  }

  @override
  ProjectLifecycleState createFile(String fileName) {
    if (!_allowOperation(RemoteStubOperationIds.createFile)) {
      return state;
    }
    _clearOverride();
    return _decorateProjectState(_delegate.createFile(fileName));
  }

  @override
  ProjectLifecycleState deleteFirstFile() {
    if (!_allowOperation(RemoteStubOperationIds.deleteFile)) {
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
    if (!_allowOperation(RemoteStubOperationIds.createRectangle)) {
      return state;
    }
    _clearOverride();
    return _decorateCanvasState(_delegate.createRectangle());
  }

  @override
  CanvasEditingState selectShape(int index) {
    if (!_allowOperation(RemoteStubOperationIds.selectShape)) {
      return state;
    }
    _clearOverride();
    return _decorateCanvasState(_delegate.selectShape(index));
  }

  @override
  CanvasEditingState moveSelected() {
    if (!_allowOperation(RemoteStubOperationIds.moveShape)) {
      return state;
    }
    _clearOverride();
    return _decorateCanvasState(_delegate.moveSelected());
  }

  @override
  CanvasEditingState resizeSelected() {
    if (!_allowOperation(RemoteStubOperationIds.resizeShape)) {
      return state;
    }
    _clearOverride();
    return _decorateCanvasState(_delegate.resizeSelected());
  }

  @override
  CanvasEditingState toggleFillSelected() {
    if (!_allowOperation(RemoteStubOperationIds.toggleFill)) {
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
    if (!_allowOperation(RemoteStubOperationIds.importAsset)) {
      return state;
    }
    _clearOverride();
    return _decorateAssetState(_delegate.importAsset(assetName, assetType));
  }

  @override
  AssetManagementState selectAsset(int index) {
    if (!_allowOperation(RemoteStubOperationIds.selectAsset)) {
      return state;
    }
    _clearOverride();
    return _decorateAssetState(_delegate.selectAsset(index));
  }

  @override
  AssetManagementState useSelectedAsset() {
    if (!_allowOperation(RemoteStubOperationIds.useAsset)) {
      return state;
    }
    _clearOverride();
    return _decorateAssetState(_delegate.useSelectedAsset());
  }

  @override
  AssetManagementState removeSelectedAsset() {
    if (!_allowOperation(RemoteStubOperationIds.removeAsset)) {
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
    if (!_allowOperation(RemoteStubOperationIds.togglePeerPresence)) {
      return state;
    }
    _clearOverride();
    return _decorateCollaborationState(_delegate.togglePeerPresence());
  }

  @override
  CollaborationContextState createThread(String title) {
    if (!_allowOperation(RemoteStubOperationIds.createThread)) {
      return state;
    }
    _clearOverride();
    return _decorateCollaborationState(_delegate.createThread(title));
  }

  @override
  CollaborationContextState selectThread(int index) {
    if (!_allowOperation(RemoteStubOperationIds.selectThread)) {
      return state;
    }
    _clearOverride();
    return _decorateCollaborationState(_delegate.selectThread(index));
  }

  @override
  CollaborationContextState resolveSelectedThread() {
    if (!_allowOperation(RemoteStubOperationIds.resolveThread)) {
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
    if (!_allowOperation(RemoteStubOperationIds.setInspectTarget)) {
      return state;
    }
    _clearOverride();
    return _decorateInspectState(_delegate.setTarget(target));
  }

  @override
  InspectHandoffState generateSnippet(String elementId) {
    if (!_allowOperation(RemoteStubOperationIds.generateSnippet)) {
      return state;
    }
    _clearOverride();
    return _decorateInspectState(_delegate.generateSnippet(elementId));
  }

  @override
  InspectHandoffState copyMetadata(String elementId) {
    if (!_allowOperation(RemoteStubOperationIds.copyMetadata)) {
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
    if (!_allowOperation(RemoteStubOperationIds.runExport)) {
      return state;
    }
    _clearOverride();
    return _decorateExportState(_delegate.runExport(request));
  }

  @override
  ExportWorkflowState saveLatest() {
    if (!_allowOperation(RemoteStubOperationIds.saveExport)) {
      return state;
    }
    _clearOverride();
    return _decorateExportState(_delegate.saveLatest());
  }

  @override
  ExportWorkflowState clearArtifacts() {
    if (!_allowOperation(RemoteStubOperationIds.clearExportArtifacts)) {
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
    if (!_allowOperation(RemoteStubOperationIds.runHealthCheck)) {
      return state;
    }
    _clearOverride();
    return _decorateDiagnosticsState(_delegate.runHealthCheck());
  }

  @override
  DiagnosticsRecoveryState simulateDisconnect() {
    if (!_allowOperation(RemoteStubOperationIds.simulateDisconnect)) {
      return state;
    }
    _clearOverride();
    return _decorateDiagnosticsState(_delegate.simulateDisconnect());
  }

  @override
  DiagnosticsRecoveryState attemptReconnect() {
    if (!_allowOperation(RemoteStubOperationIds.attemptReconnect)) {
      return state;
    }
    _clearOverride();
    return _decorateDiagnosticsState(_delegate.attemptReconnect());
  }

  @override
  DiagnosticsRecoveryState openRecoveryGuide() {
    if (!_allowOperation(RemoteStubOperationIds.openRecoveryGuide)) {
      return state;
    }
    _clearOverride();
    return _decorateDiagnosticsState(_delegate.openRecoveryGuide());
  }
}
