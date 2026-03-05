import 'dart:convert';
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

class RemoteStubBackendRoute {
  const RemoteStubBackendRoute({
    required this.workflow,
    required this.method,
    required this.endpoint,
  });

  final String workflow;
  final String method;
  final String endpoint;
}

class RemoteStubBackendRouteCatalog {
  const RemoteStubBackendRouteCatalog._();

  static const RemoteStubBackendRoute _defaultRoute = RemoteStubBackendRoute(
    workflow: 'contracts',
    method: 'POST',
    endpoint: '/api/desktop/contracts/operation',
  );

  static const Map<String, RemoteStubBackendRoute> _routes =
      <String, RemoteStubBackendRoute>{
        RemoteStubOperationIds.setRememberSession: RemoteStubBackendRoute(
          workflow: 'auth',
          method: 'PATCH',
          endpoint: '/api/desktop/auth/session/preferences',
        ),
        RemoteStubOperationIds.signIn: RemoteStubBackendRoute(
          workflow: 'auth',
          method: 'POST',
          endpoint: '/api/desktop/auth/sign-in',
        ),
        RemoteStubOperationIds.restoreSession: RemoteStubBackendRoute(
          workflow: 'auth',
          method: 'POST',
          endpoint: '/api/desktop/auth/session/restore',
        ),
        RemoteStubOperationIds.refreshToken: RemoteStubBackendRoute(
          workflow: 'auth',
          method: 'POST',
          endpoint: '/api/desktop/auth/token/refresh',
        ),
        RemoteStubOperationIds.createProject: RemoteStubBackendRoute(
          workflow: 'projects',
          method: 'POST',
          endpoint: '/api/desktop/projects',
        ),
        RemoteStubOperationIds.switchProject: RemoteStubBackendRoute(
          workflow: 'projects',
          method: 'POST',
          endpoint: '/api/desktop/projects/select',
        ),
        RemoteStubOperationIds.createFile: RemoteStubBackendRoute(
          workflow: 'projects',
          method: 'POST',
          endpoint: '/api/desktop/projects/files',
        ),
        RemoteStubOperationIds.deleteFile: RemoteStubBackendRoute(
          workflow: 'projects',
          method: 'DELETE',
          endpoint: '/api/desktop/projects/files/first',
        ),
        RemoteStubOperationIds.createRectangle: RemoteStubBackendRoute(
          workflow: 'canvas',
          method: 'POST',
          endpoint: '/api/desktop/canvas/shapes/rectangle',
        ),
        RemoteStubOperationIds.selectShape: RemoteStubBackendRoute(
          workflow: 'canvas',
          method: 'POST',
          endpoint: '/api/desktop/canvas/shapes/select',
        ),
        RemoteStubOperationIds.moveShape: RemoteStubBackendRoute(
          workflow: 'canvas',
          method: 'POST',
          endpoint: '/api/desktop/canvas/shapes/move',
        ),
        RemoteStubOperationIds.resizeShape: RemoteStubBackendRoute(
          workflow: 'canvas',
          method: 'POST',
          endpoint: '/api/desktop/canvas/shapes/resize',
        ),
        RemoteStubOperationIds.toggleFill: RemoteStubBackendRoute(
          workflow: 'canvas',
          method: 'POST',
          endpoint: '/api/desktop/canvas/shapes/fill/toggle',
        ),
        RemoteStubOperationIds.importAsset: RemoteStubBackendRoute(
          workflow: 'assets',
          method: 'POST',
          endpoint: '/api/desktop/assets/import',
        ),
        RemoteStubOperationIds.selectAsset: RemoteStubBackendRoute(
          workflow: 'assets',
          method: 'POST',
          endpoint: '/api/desktop/assets/select',
        ),
        RemoteStubOperationIds.useAsset: RemoteStubBackendRoute(
          workflow: 'assets',
          method: 'POST',
          endpoint: '/api/desktop/assets/use',
        ),
        RemoteStubOperationIds.removeAsset: RemoteStubBackendRoute(
          workflow: 'assets',
          method: 'DELETE',
          endpoint: '/api/desktop/assets/selected',
        ),
        RemoteStubOperationIds.togglePeerPresence: RemoteStubBackendRoute(
          workflow: 'collaboration',
          method: 'POST',
          endpoint: '/api/desktop/collaboration/presence/toggle',
        ),
        RemoteStubOperationIds.createThread: RemoteStubBackendRoute(
          workflow: 'collaboration',
          method: 'POST',
          endpoint: '/api/desktop/collaboration/threads',
        ),
        RemoteStubOperationIds.selectThread: RemoteStubBackendRoute(
          workflow: 'collaboration',
          method: 'POST',
          endpoint: '/api/desktop/collaboration/threads/select',
        ),
        RemoteStubOperationIds.resolveThread: RemoteStubBackendRoute(
          workflow: 'collaboration',
          method: 'POST',
          endpoint: '/api/desktop/collaboration/threads/resolve',
        ),
        RemoteStubOperationIds.setInspectTarget: RemoteStubBackendRoute(
          workflow: 'inspect',
          method: 'POST',
          endpoint: '/api/desktop/inspect/target',
        ),
        RemoteStubOperationIds.generateSnippet: RemoteStubBackendRoute(
          workflow: 'inspect',
          method: 'POST',
          endpoint: '/api/desktop/inspect/snippet',
        ),
        RemoteStubOperationIds.copyMetadata: RemoteStubBackendRoute(
          workflow: 'inspect',
          method: 'POST',
          endpoint: '/api/desktop/inspect/metadata/copy',
        ),
        RemoteStubOperationIds.runExport: RemoteStubBackendRoute(
          workflow: 'export',
          method: 'POST',
          endpoint: '/api/desktop/export/run',
        ),
        RemoteStubOperationIds.saveExport: RemoteStubBackendRoute(
          workflow: 'export',
          method: 'POST',
          endpoint: '/api/desktop/export/save',
        ),
        RemoteStubOperationIds.clearExportArtifacts: RemoteStubBackendRoute(
          workflow: 'export',
          method: 'DELETE',
          endpoint: '/api/desktop/export/artifacts',
        ),
        RemoteStubOperationIds.runHealthCheck: RemoteStubBackendRoute(
          workflow: 'diagnostics',
          method: 'POST',
          endpoint: '/api/desktop/diagnostics/health-check',
        ),
        RemoteStubOperationIds.simulateDisconnect: RemoteStubBackendRoute(
          workflow: 'diagnostics',
          method: 'POST',
          endpoint: '/api/desktop/diagnostics/disconnect/simulate',
        ),
        RemoteStubOperationIds.attemptReconnect: RemoteStubBackendRoute(
          workflow: 'diagnostics',
          method: 'POST',
          endpoint: '/api/desktop/diagnostics/reconnect',
        ),
        RemoteStubOperationIds.openRecoveryGuide: RemoteStubBackendRoute(
          workflow: 'diagnostics',
          method: 'POST',
          endpoint: '/api/desktop/diagnostics/recovery-guide/open',
        ),
      };

  static RemoteStubBackendRoute resolve(String operation) {
    final String normalized = _normalizeOperation(operation);
    return _routes[normalized] ?? _defaultRoute;
  }
}

RemoteStubTransportRequest _buildTransportRequest(
  String operation, {
  Map<String, Object?> payload = const <String, Object?>{},
}) {
  final String normalizedOperation = _normalizeOperation(operation);
  final RemoteStubBackendRoute route = RemoteStubBackendRouteCatalog.resolve(
    normalizedOperation,
  );
  return RemoteStubTransportRequest(
    operation: normalizedOperation,
    workflow: route.workflow,
    method: route.method,
    endpoint: route.endpoint,
    payload: payload.isEmpty
        ? const <String, Object?>{}
        : Map<String, Object?>.unmodifiable(payload),
  );
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
  const RemoteStubTransportRequest({
    required this.operation,
    this.workflow = 'contracts',
    this.method = 'POST',
    this.endpoint = '/api/desktop/contracts/operation',
    this.payload = const <String, Object?>{},
  });

  final String operation;
  final String workflow;
  final String method;
  final String endpoint;
  final Map<String, Object?> payload;
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
    required this.transportRequest,
    required this.healthUrl,
    required this.timeout,
    required this.allowedStatusCodes,
  });

  final RemoteStubTransportRequest transportRequest;
  final String healthUrl;
  final Duration timeout;
  final Set<int> allowedStatusCodes;

  String get operation => transportRequest.operation;
  String get workflow => transportRequest.workflow;
  String get method => transportRequest.method;
  String get endpoint => transportRequest.endpoint;
  Map<String, Object?> get payload => transportRequest.payload;
}

class RemoteStubHttpTransportProbeResult {
  const RemoteStubHttpTransportProbeResult({required this.allowed});

  const RemoteStubHttpTransportProbeResult.allowed() : allowed = true;

  const RemoteStubHttpTransportProbeResult.blocked() : allowed = false;

  final bool allowed;
}

class RemoteStubHttpBackendExecutionRequest {
  const RemoteStubHttpBackendExecutionRequest({
    required this.transportRequest,
    required this.baseUrl,
    required this.timeout,
    required this.blockedReason,
    this.authToken,
  });

  final RemoteStubTransportRequest transportRequest;
  final String baseUrl;
  final Duration timeout;
  final String blockedReason;
  final String? authToken;

  String get endpointUrl =>
      _resolveBackendEndpointUrl(baseUrl, transportRequest.endpoint);
}

class RemoteStubHttpBackendExecutionResult {
  const RemoteStubHttpBackendExecutionResult({
    required this.allowed,
    this.status,
  });

  const RemoteStubHttpBackendExecutionResult.allowed()
    : allowed = true,
      status = null;

  const RemoteStubHttpBackendExecutionResult.blocked([this.status])
    : allowed = false;

  final bool allowed;
  final String? status;
}

typedef RemoteStubHttpTransportProbe =
    RemoteStubHttpTransportProbeResult Function(
      RemoteStubHttpTransportProbeRequest request,
    );

typedef RemoteStubHttpBackendExecutionProbe =
    RemoteStubHttpBackendExecutionResult Function(
      RemoteStubHttpBackendExecutionRequest request,
    );

String _buildHttpUrlLabel(String url, {required String prefix}) {
  final String trimmed = url.trim();
  if (trimmed.isEmpty) {
    return '';
  }
  final Uri? uri = Uri.tryParse(trimmed);
  if (uri == null || uri.host.isEmpty) {
    return prefix;
  }
  final String scheme = uri.scheme.isEmpty ? 'http' : uri.scheme;
  final String path = uri.path.isEmpty ? '/' : uri.path;
  final String port = uri.hasPort ? ':${uri.port}' : '';
  return '$prefix:$scheme://${uri.host}$port$path';
}

String _buildCompositeHttpTransportLabel({
  required String healthUrl,
  required String backendBaseUrl,
}) {
  final List<String> parts = <String>[
    _buildHttpUrlLabel(healthUrl, prefix: 'http-health'),
    _buildHttpUrlLabel(backendBaseUrl, prefix: 'http-backend'),
  ].where((String value) => value.isNotEmpty).toList(growable: false);
  return parts.join(' · ');
}

String _resolveBackendEndpointUrl(String baseUrl, String endpoint) {
  final String trimmedEndpoint = endpoint.trim();
  if (trimmedEndpoint.startsWith('http://') ||
      trimmedEndpoint.startsWith('https://')) {
    return trimmedEndpoint;
  }
  final String normalizedBase = baseUrl.trim().replaceFirst(RegExp(r'/+$'), '');
  if (normalizedBase.isEmpty) {
    return trimmedEndpoint;
  }
  if (trimmedEndpoint.isEmpty) {
    return normalizedBase;
  }
  final String normalizedEndpoint = trimmedEndpoint.startsWith('/')
      ? trimmedEndpoint
      : '/$trimmedEndpoint';
  return '$normalizedBase$normalizedEndpoint';
}

class _CurlHttpResponse {
  const _CurlHttpResponse({required this.statusCode, required this.body});

  final int statusCode;
  final String body;
}

_CurlHttpResponse? _parseCurlHttpResponse(String stdoutText) {
  final List<String> lines = stdoutText.split(RegExp(r'[\r\n]+'));
  for (int index = lines.length - 1; index >= 0; index -= 1) {
    final String line = lines[index].trim();
    if (line.isEmpty) {
      continue;
    }
    final int? statusCode = int.tryParse(line);
    if (statusCode == null) {
      continue;
    }
    final String body = lines.take(index).join('\n').trim();
    return _CurlHttpResponse(statusCode: statusCode, body: body);
  }
  return null;
}

int? _parseCurlHttpStatusCode(String stdoutText) {
  return _parseCurlHttpResponse(stdoutText)?.statusCode;
}

String _extractBackendErrorMessage(String rawBody) {
  final String trimmed = rawBody.trim();
  if (trimmed.isEmpty) {
    return '';
  }
  try {
    final Object? decoded = jsonDecode(trimmed);
    if (decoded is Map<String, Object?>) {
      final Object? message = decoded['message'] ?? decoded['error'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }
      final Object? detail = decoded['detail'] ?? decoded['reason'];
      if (detail is String && detail.trim().isNotEmpty) {
        return detail.trim();
      }
    }
  } on FormatException {
    return trimmed;
  }
  return trimmed;
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

RemoteStubHttpBackendExecutionResult _defaultHttpBackendExecutionProbe(
  RemoteStubHttpBackendExecutionRequest request,
) {
  final String endpointUrl = request.endpointUrl;
  if (endpointUrl.isEmpty) {
    return RemoteStubHttpBackendExecutionResult.blocked(
      '${request.blockedReason}: ${request.transportRequest.operation}.',
    );
  }

  final double timeoutSeconds = request.timeout.inMilliseconds / 1000;
  final Map<String, Object?> requestBody = <String, Object?>{
    'operation': request.transportRequest.operation,
    'workflow': request.transportRequest.workflow,
    'payload': request.transportRequest.payload,
  };

  final List<String> args = <String>[
    '--silent',
    '--show-error',
    '--max-time',
    timeoutSeconds.toStringAsFixed(3),
    '--request',
    request.transportRequest.method,
    '--header',
    'Content-Type: application/json',
    '--write-out',
    r'\n%{http_code}',
    '--data',
    jsonEncode(requestBody),
    endpointUrl,
  ];

  final String authToken = request.authToken?.trim() ?? '';
  if (authToken.isNotEmpty) {
    args.insertAll(args.length - 3, <String>[
      '--header',
      'Authorization: Bearer $authToken',
    ]);
  }

  final ProcessResult executionResult;
  try {
    executionResult = Process.runSync('curl', args);
  } on ProcessException {
    return RemoteStubHttpBackendExecutionResult.blocked(
      '${request.blockedReason}: ${request.transportRequest.operation}.',
    );
  }

  if (executionResult.exitCode != 0) {
    return RemoteStubHttpBackendExecutionResult.blocked(
      '${request.blockedReason}: ${request.transportRequest.operation}.',
    );
  }

  final _CurlHttpResponse? response = _parseCurlHttpResponse(
    '${executionResult.stdout}',
  );
  if (response == null) {
    return RemoteStubHttpBackendExecutionResult.blocked(
      '${request.blockedReason}: ${request.transportRequest.operation}.',
    );
  }
  if (response.statusCode >= 200 && response.statusCode < 300) {
    return const RemoteStubHttpBackendExecutionResult.allowed();
  }

  final String backendMessage = _extractBackendErrorMessage(response.body);
  if (backendMessage.isNotEmpty) {
    return RemoteStubHttpBackendExecutionResult.blocked(
      '${request.blockedReason}: ${request.transportRequest.operation}. $backendMessage',
    );
  }
  return RemoteStubHttpBackendExecutionResult.blocked(
    '${request.blockedReason}: ${request.transportRequest.operation}. HTTP ${response.statusCode}.',
  );
}

class RemoteStubHttpTransportClient extends RemoteStubTransportClient {
  RemoteStubHttpTransportClient({
    String healthUrl = '',
    this.timeout = const Duration(seconds: 2),
    this.allowedStatusCodes = const <int>{200},
    this.blockedReason = 'Remote transport unavailable',
    String backendBaseUrl = '',
    this.backendTimeout = const Duration(seconds: 3),
    this.backendBlockedReason = 'Remote backend execution failed',
    this.backendAuthToken,
    RemoteStubHttpTransportProbe? probe,
    RemoteStubHttpBackendExecutionProbe? executionProbe,
  }) : healthUrl = healthUrl.trim(),
       backendBaseUrl = backendBaseUrl.trim(),
       _probe = probe ?? _defaultHttpTransportProbe,
       _executionProbe = executionProbe ?? _defaultHttpBackendExecutionProbe,
       transportLabel = _buildCompositeHttpTransportLabel(
         healthUrl: healthUrl,
         backendBaseUrl: backendBaseUrl,
       );

  final String healthUrl;
  final Duration timeout;
  final Set<int> allowedStatusCodes;
  final String blockedReason;
  final String backendBaseUrl;
  final Duration backendTimeout;
  final String backendBlockedReason;
  final String? backendAuthToken;
  final String transportLabel;
  final RemoteStubHttpTransportProbe _probe;
  final RemoteStubHttpBackendExecutionProbe _executionProbe;

  Set<int> get _effectiveAllowedStatusCodes {
    final Set<int> normalized = allowedStatusCodes
        .where((int code) => code >= 100 && code <= 599)
        .toSet();
    return normalized.isEmpty ? const <int>{200} : normalized;
  }

  @override
  RemoteStubTransportProfile get profile => RemoteStubTransportProfile(
    blockedReason: backendBaseUrl.isNotEmpty
        ? backendBlockedReason
        : blockedReason,
    transportLabel: transportLabel,
  );

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (healthUrl.isNotEmpty) {
      final RemoteStubHttpTransportProbeResult probeResult = _probe(
        RemoteStubHttpTransportProbeRequest(
          transportRequest: request,
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
    }

    if (backendBaseUrl.isNotEmpty) {
      final RemoteStubHttpBackendExecutionResult executionResult =
          _executionProbe(
            RemoteStubHttpBackendExecutionRequest(
              transportRequest: request,
              baseUrl: backendBaseUrl,
              timeout: backendTimeout,
              blockedReason: backendBlockedReason,
              authToken: backendAuthToken,
            ),
          );
      if (!executionResult.allowed) {
        return RemoteStubTransportResult.blocked(
          executionResult.status ??
              '$backendBlockedReason: ${request.operation}.',
        );
      }
    }

    if (healthUrl.isEmpty && backendBaseUrl.isEmpty) {
      return RemoteStubTransportResult.allow;
    }

    return RemoteStubTransportResult.allow;
  }
}

bool _allowRemoteStubOperation({
  required RemoteStubFaultProfile faultProfile,
  required RemoteStubTransportClient transportClient,
  required RemoteStubTransportRequest transportRequest,
  required void Function(String status) setStatusOverride,
}) {
  if (faultProfile.blocksOperation(transportRequest.operation)) {
    setStatusOverride(_blockedStatus(faultProfile, transportRequest.operation));
    return false;
  }

  final RemoteStubTransportResult transportResult = transportClient.execute(
    transportRequest,
  );
  if (!transportResult.allowed) {
    final String deniedStatus =
        transportResult.status ??
        '${faultProfile.reason}: ${transportRequest.operation}.';
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

  bool _allowOperation(
    String operation, {
    Map<String, Object?> payload = const <String, Object?>{},
  }) {
    return _allowRemoteStubOperation(
      faultProfile: faultProfile,
      transportClient: transportClient,
      transportRequest: _buildTransportRequest(operation, payload: payload),
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
    if (!_allowOperation(
      RemoteStubOperationIds.setRememberSession,
      payload: <String, Object?>{'rememberSession': enabled},
    )) {
      return state;
    }
    _clearOverride();
    return _decorateAuthState(_delegate.setRememberSession(enabled));
  }

  @override
  AuthSessionState signIn(AuthSignInRequest request) {
    if (!_allowOperation(
      RemoteStubOperationIds.signIn,
      payload: <String, Object?>{
        'email': request.email.trim(),
        'passwordLength': request.password.length,
      },
    )) {
      return state;
    }
    _clearOverride();
    return _decorateAuthState(_delegate.signIn(request));
  }

  @override
  AuthSessionState restoreSession() {
    if (!_allowOperation(
      RemoteStubOperationIds.restoreSession,
      payload: <String, Object?>{
        'rememberSessionEnabled': _delegate.state.rememberSession,
      },
    )) {
      return state;
    }
    _clearOverride();
    return _decorateAuthState(_delegate.restoreSession());
  }

  @override
  AuthSessionState refreshToken() {
    if (!_allowOperation(
      RemoteStubOperationIds.refreshToken,
      payload: <String, Object?>{'signedIn': _delegate.state.signedIn},
    )) {
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

  bool _allowOperation(
    String operation, {
    Map<String, Object?> payload = const <String, Object?>{},
  }) {
    return _allowRemoteStubOperation(
      faultProfile: faultProfile,
      transportClient: transportClient,
      transportRequest: _buildTransportRequest(operation, payload: payload),
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
    if (!_allowOperation(
      RemoteStubOperationIds.createProject,
      payload: <String, Object?>{'projectName': projectName.trim()},
    )) {
      return state;
    }
    _clearOverride();
    return _decorateProjectState(_delegate.createProject(projectName));
  }

  @override
  ProjectLifecycleState switchProject(int index) {
    if (!_allowOperation(
      RemoteStubOperationIds.switchProject,
      payload: <String, Object?>{
        'index': index,
        'projectCount': _delegate.state.projects.length,
      },
    )) {
      return state;
    }
    _clearOverride();
    return _decorateProjectState(_delegate.switchProject(index));
  }

  @override
  ProjectLifecycleState createFile(String fileName) {
    if (!_allowOperation(
      RemoteStubOperationIds.createFile,
      payload: <String, Object?>{
        'fileName': fileName.trim(),
        'selectedProjectId': _delegate.state.selectedProject.id,
      },
    )) {
      return state;
    }
    _clearOverride();
    return _decorateProjectState(_delegate.createFile(fileName));
  }

  @override
  ProjectLifecycleState deleteFirstFile() {
    if (!_allowOperation(
      RemoteStubOperationIds.deleteFile,
      payload: <String, Object?>{
        'selectedProjectId': _delegate.state.selectedProject.id,
        'hasFiles': _delegate.state.selectedProject.files.isNotEmpty,
      },
    )) {
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

  bool _allowOperation(
    String operation, {
    Map<String, Object?> payload = const <String, Object?>{},
  }) {
    return _allowRemoteStubOperation(
      faultProfile: faultProfile,
      transportClient: transportClient,
      transportRequest: _buildTransportRequest(operation, payload: payload),
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
    if (!_allowOperation(
      RemoteStubOperationIds.createRectangle,
      payload: const <String, Object?>{'shapeType': 'rectangle'},
    )) {
      return state;
    }
    _clearOverride();
    return _decorateCanvasState(_delegate.createRectangle());
  }

  @override
  CanvasEditingState selectShape(int index) {
    if (!_allowOperation(
      RemoteStubOperationIds.selectShape,
      payload: <String, Object?>{
        'index': index,
        'shapeCount': _delegate.state.shapes.length,
      },
    )) {
      return state;
    }
    _clearOverride();
    return _decorateCanvasState(_delegate.selectShape(index));
  }

  @override
  CanvasEditingState moveSelected() {
    if (!_allowOperation(
      RemoteStubOperationIds.moveShape,
      payload: <String, Object?>{
        'selectedShapeId': _delegate.state.selectedShape?.id ?? '',
      },
    )) {
      return state;
    }
    _clearOverride();
    return _decorateCanvasState(_delegate.moveSelected());
  }

  @override
  CanvasEditingState resizeSelected() {
    if (!_allowOperation(
      RemoteStubOperationIds.resizeShape,
      payload: <String, Object?>{
        'selectedShapeId': _delegate.state.selectedShape?.id ?? '',
      },
    )) {
      return state;
    }
    _clearOverride();
    return _decorateCanvasState(_delegate.resizeSelected());
  }

  @override
  CanvasEditingState toggleFillSelected() {
    if (!_allowOperation(
      RemoteStubOperationIds.toggleFill,
      payload: <String, Object?>{
        'selectedShapeId': _delegate.state.selectedShape?.id ?? '',
        'currentFill': _delegate.state.selectedShape?.fillHex ?? '',
      },
    )) {
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

  bool _allowOperation(
    String operation, {
    Map<String, Object?> payload = const <String, Object?>{},
  }) {
    return _allowRemoteStubOperation(
      faultProfile: faultProfile,
      transportClient: transportClient,
      transportRequest: _buildTransportRequest(operation, payload: payload),
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
    if (!_allowOperation(
      RemoteStubOperationIds.importAsset,
      payload: <String, Object?>{
        'assetName': assetName.trim(),
        'assetType': assetType,
      },
    )) {
      return state;
    }
    _clearOverride();
    return _decorateAssetState(_delegate.importAsset(assetName, assetType));
  }

  @override
  AssetManagementState selectAsset(int index) {
    if (!_allowOperation(
      RemoteStubOperationIds.selectAsset,
      payload: <String, Object?>{
        'index': index,
        'assetCount': _delegate.state.assets.length,
      },
    )) {
      return state;
    }
    _clearOverride();
    return _decorateAssetState(_delegate.selectAsset(index));
  }

  @override
  AssetManagementState useSelectedAsset() {
    if (!_allowOperation(
      RemoteStubOperationIds.useAsset,
      payload: <String, Object?>{
        'selectedAssetId': _delegate.state.selectedAsset?.id ?? '',
      },
    )) {
      return state;
    }
    _clearOverride();
    return _decorateAssetState(_delegate.useSelectedAsset());
  }

  @override
  AssetManagementState removeSelectedAsset() {
    if (!_allowOperation(
      RemoteStubOperationIds.removeAsset,
      payload: <String, Object?>{
        'selectedAssetId': _delegate.state.selectedAsset?.id ?? '',
      },
    )) {
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

  bool _allowOperation(
    String operation, {
    Map<String, Object?> payload = const <String, Object?>{},
  }) {
    return _allowRemoteStubOperation(
      faultProfile: faultProfile,
      transportClient: transportClient,
      transportRequest: _buildTransportRequest(operation, payload: payload),
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
    if (!_allowOperation(
      RemoteStubOperationIds.togglePeerPresence,
      payload: <String, Object?>{'peerActive': _delegate.state.peerActive},
    )) {
      return state;
    }
    _clearOverride();
    return _decorateCollaborationState(_delegate.togglePeerPresence());
  }

  @override
  CollaborationContextState createThread(String title) {
    if (!_allowOperation(
      RemoteStubOperationIds.createThread,
      payload: <String, Object?>{'title': title.trim()},
    )) {
      return state;
    }
    _clearOverride();
    return _decorateCollaborationState(_delegate.createThread(title));
  }

  @override
  CollaborationContextState selectThread(int index) {
    if (!_allowOperation(
      RemoteStubOperationIds.selectThread,
      payload: <String, Object?>{
        'index': index,
        'threadCount': _delegate.state.threads.length,
      },
    )) {
      return state;
    }
    _clearOverride();
    return _decorateCollaborationState(_delegate.selectThread(index));
  }

  @override
  CollaborationContextState resolveSelectedThread() {
    if (!_allowOperation(
      RemoteStubOperationIds.resolveThread,
      payload: <String, Object?>{
        'selectedThreadId': _delegate.state.selectedThread?.id ?? '',
      },
    )) {
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

  bool _allowOperation(
    String operation, {
    Map<String, Object?> payload = const <String, Object?>{},
  }) {
    return _allowRemoteStubOperation(
      faultProfile: faultProfile,
      transportClient: transportClient,
      transportRequest: _buildTransportRequest(operation, payload: payload),
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
    if (!_allowOperation(
      RemoteStubOperationIds.setInspectTarget,
      payload: <String, Object?>{'target': target},
    )) {
      return state;
    }
    _clearOverride();
    return _decorateInspectState(_delegate.setTarget(target));
  }

  @override
  InspectHandoffState generateSnippet(String elementId) {
    if (!_allowOperation(
      RemoteStubOperationIds.generateSnippet,
      payload: <String, Object?>{
        'elementId': elementId.trim(),
        'target': _delegate.state.target,
      },
    )) {
      return state;
    }
    _clearOverride();
    return _decorateInspectState(_delegate.generateSnippet(elementId));
  }

  @override
  InspectHandoffState copyMetadata(String elementId) {
    if (!_allowOperation(
      RemoteStubOperationIds.copyMetadata,
      payload: <String, Object?>{'elementId': elementId.trim()},
    )) {
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

  bool _allowOperation(
    String operation, {
    Map<String, Object?> payload = const <String, Object?>{},
  }) {
    return _allowRemoteStubOperation(
      faultProfile: faultProfile,
      transportClient: transportClient,
      transportRequest: _buildTransportRequest(operation, payload: payload),
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
    if (!_allowOperation(
      RemoteStubOperationIds.runExport,
      payload: <String, Object?>{
        'fileName': request.fileName.trim(),
        'format': request.format,
        'scale': request.scale,
        'includeBackground': request.includeBackground,
      },
    )) {
      return state;
    }
    _clearOverride();
    return _decorateExportState(_delegate.runExport(request));
  }

  @override
  ExportWorkflowState saveLatest() {
    if (!_allowOperation(
      RemoteStubOperationIds.saveExport,
      payload: <String, Object?>{
        'hasArtifact': _delegate.state.latestArtifact != null,
      },
    )) {
      return state;
    }
    _clearOverride();
    return _decorateExportState(_delegate.saveLatest());
  }

  @override
  ExportWorkflowState clearArtifacts() {
    if (!_allowOperation(
      RemoteStubOperationIds.clearExportArtifacts,
      payload: <String, Object?>{
        'artifactCount': _delegate.state.artifacts.length,
      },
    )) {
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

  bool _allowOperation(
    String operation, {
    Map<String, Object?> payload = const <String, Object?>{},
  }) {
    return _allowRemoteStubOperation(
      faultProfile: faultProfile,
      transportClient: transportClient,
      transportRequest: _buildTransportRequest(operation, payload: payload),
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
    if (!_allowOperation(
      RemoteStubOperationIds.runHealthCheck,
      payload: <String, Object?>{
        'websocketHealthy': _delegate.state.websocketHealthy,
        'mcpHealthy': _delegate.state.mcpHealthy,
      },
    )) {
      return state;
    }
    _clearOverride();
    return _decorateDiagnosticsState(_delegate.runHealthCheck());
  }

  @override
  DiagnosticsRecoveryState simulateDisconnect() {
    if (!_allowOperation(
      RemoteStubOperationIds.simulateDisconnect,
      payload: <String, Object?>{
        'websocketHealthy': _delegate.state.websocketHealthy,
        'mcpHealthy': _delegate.state.mcpHealthy,
      },
    )) {
      return state;
    }
    _clearOverride();
    return _decorateDiagnosticsState(_delegate.simulateDisconnect());
  }

  @override
  DiagnosticsRecoveryState attemptReconnect() {
    if (!_allowOperation(
      RemoteStubOperationIds.attemptReconnect,
      payload: <String, Object?>{
        'reconnectAttempts': _delegate.state.reconnectAttempts,
      },
    )) {
      return state;
    }
    _clearOverride();
    return _decorateDiagnosticsState(_delegate.attemptReconnect());
  }

  @override
  DiagnosticsRecoveryState openRecoveryGuide() {
    if (!_allowOperation(
      RemoteStubOperationIds.openRecoveryGuide,
      payload: <String, Object?>{
        'reconnectAttempts': _delegate.state.reconnectAttempts,
        'websocketHealthy': _delegate.state.websocketHealthy,
      },
    )) {
      return state;
    }
    _clearOverride();
    return _decorateDiagnosticsState(_delegate.openRecoveryGuide());
  }
}
