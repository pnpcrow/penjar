import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:penjar_desktop/contracts/workflow_contracts.dart';

const String _kRemoteStubPrefix = '[remote-stub] ';

String _normalizeOperation(String operation) => operation.trim().toLowerCase();

bool _isAuthOperation(String operation) {
  switch (_normalizeOperation(operation)) {
    case RemoteStubOperationIds.setRememberSession:
    case RemoteStubOperationIds.signIn:
    case RemoteStubOperationIds.restoreSession:
    case RemoteStubOperationIds.refreshToken:
      return true;
  }
  return false;
}

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
  const RemoteStubTransportResult({
    this.allowed = true,
    this.status,
    this.responsePayload = const <String, Object?>{},
  });

  static const RemoteStubTransportResult allow = RemoteStubTransportResult();

  factory RemoteStubTransportResult.allowedWithPayload(
    Map<String, Object?> responsePayload,
  ) => RemoteStubTransportResult(
    responsePayload: Map<String, Object?>.unmodifiable(responsePayload),
  );

  factory RemoteStubTransportResult.blocked(String status) =>
      RemoteStubTransportResult(allowed: false, status: status);

  final bool allowed;
  final String? status;
  final Map<String, Object?> responsePayload;
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
    this.responsePayload = const <String, Object?>{},
  });

  const RemoteStubHttpBackendExecutionResult.allowed({
    this.responsePayload = const <String, Object?>{},
  }) : allowed = true,
       status = null;

  factory RemoteStubHttpBackendExecutionResult.allowedWithPayload(
    Map<String, Object?> responsePayload,
  ) => RemoteStubHttpBackendExecutionResult(
    allowed: true,
    responsePayload: Map<String, Object?>.unmodifiable(responsePayload),
  );

  const RemoteStubHttpBackendExecutionResult.blocked([this.status])
    : allowed = false,
      responsePayload = const <String, Object?>{};

  final bool allowed;
  final String? status;
  final Map<String, Object?> responsePayload;
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
  int backendEndpointOverrideCount = 0,
}) {
  final List<String> parts = <String>[
    _buildHttpUrlLabel(healthUrl, prefix: 'http-health'),
    _buildHttpUrlLabel(backendBaseUrl, prefix: 'http-backend'),
  ].where((String value) => value.isNotEmpty).toList(growable: true);
  if (backendEndpointOverrideCount > 0) {
    parts.add('http-backend-overrides:$backendEndpointOverrideCount');
  }
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

Map<String, String> _normalizeBackendEndpointOverrides(
  Map<String, String> overrides,
) {
  if (overrides.isEmpty) {
    return const <String, String>{};
  }
  final Map<String, String> normalized = <String, String>{};
  for (final MapEntry<String, String> entry in overrides.entries) {
    final String operation = _normalizeOperation(entry.key);
    if (!RemoteStubOperationIds.all.contains(operation)) {
      continue;
    }
    final String endpoint = entry.value.trim();
    if (endpoint.isEmpty) {
      continue;
    }
    normalized[operation] = endpoint;
  }
  if (normalized.isEmpty) {
    return const <String, String>{};
  }
  return Map<String, String>.unmodifiable(normalized);
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

Map<String, Object?> _coerceStringKeyedMap(Object? value) {
  if (value is Map<String, Object?>) {
    return value;
  }
  if (value is Map) {
    final Map<String, Object?> mapped = <String, Object?>{};
    value.forEach((Object? key, Object? entryValue) {
      mapped['$key'] = entryValue;
    });
    return mapped;
  }
  return const <String, Object?>{};
}

List<Map<String, Object?>> _coerceMapList(Object? value) {
  if (value is! List) {
    return const <Map<String, Object?>>[];
  }
  return value
      .map(_coerceStringKeyedMap)
      .where((Map<String, Object?> item) => item.isNotEmpty)
      .toList(growable: false);
}

String? _coerceNonEmptyString(Object? value) {
  if (value is! String) {
    return null;
  }
  final String trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

String? _coerceBackendCodeString(Object? value) {
  final String? asString = _coerceNonEmptyString(value);
  if (asString != null) {
    return asString;
  }
  if (value is num) {
    return value.toString();
  }
  return null;
}

bool? _coerceBool(Object? value) {
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  if (value is String) {
    final String lowered = value.trim().toLowerCase();
    if (lowered == 'true' || lowered == '1') {
      return true;
    }
    if (lowered == 'false' || lowered == '0') {
      return false;
    }
  }
  return null;
}

int? _coerceInt(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value.trim());
  }
  return null;
}

double? _coerceDouble(Object? value) {
  if (value is double) {
    return value;
  }
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value.trim());
  }
  return null;
}

List<String> _coerceStringList(Object? value) {
  if (value is! List) {
    return const <String>[];
  }
  return value
      .map(_coerceNonEmptyString)
      .whereType<String>()
      .toList(growable: false);
}

Map<String, Object?> _extractBackendSuccessPayload(String rawBody) {
  final String trimmed = rawBody.trim();
  if (trimmed.isEmpty) {
    return const <String, Object?>{};
  }
  try {
    final Object? decoded = jsonDecode(trimmed);
    return _coerceStringKeyedMap(decoded);
  } on FormatException {
    return const <String, Object?>{};
  }
}

Map<String, Object?> _extractBackendEnvelopePayload(
  Map<String, Object?> responsePayload,
) {
  Map<String, Object?> currentPayload = responsePayload;
  final Set<Object> visitedPayloads = Set<Object>.identity()
    ..add(currentPayload);
  while (true) {
    Map<String, Object?>? nextPayload;
    for (final String key in const <String>['result', 'data', 'payload']) {
      final Map<String, Object?> nestedPayload = _coerceStringKeyedMap(
        currentPayload[key],
      );
      if (nestedPayload.isNotEmpty) {
        if (visitedPayloads.contains(nestedPayload)) {
          continue;
        }
        nextPayload = nestedPayload;
        break;
      }
    }
    if (nextPayload == null) {
      break;
    }
    visitedPayloads.add(nextPayload);
    currentPayload = nextPayload;
  }
  return currentPayload;
}

List<Map<String, Object?>> _collectBackendEnvelopePayloads(
  Map<String, Object?> responsePayload,
) {
  final List<Map<String, Object?>> collectedPayloads = <Map<String, Object?>>[];
  final List<Map<String, Object?>> queue = <Map<String, Object?>>[
    responsePayload,
  ];
  final Set<Object> visitedPayloads = Set<Object>.identity()
    ..add(responsePayload);
  for (int index = 0; index < queue.length; index += 1) {
    final Map<String, Object?> currentPayload = queue[index];
    for (final String key in const <String>['result', 'data', 'payload']) {
      final Map<String, Object?> nestedPayload = _coerceStringKeyedMap(
        currentPayload[key],
      );
      if (nestedPayload.isEmpty || visitedPayloads.contains(nestedPayload)) {
        continue;
      }
      visitedPayloads.add(nestedPayload);
      collectedPayloads.add(nestedPayload);
      queue.add(nestedPayload);
    }
  }
  return collectedPayloads;
}

List<Map<String, Object?>> _dedupeBackendPayloads(
  Iterable<Map<String, Object?>> payloads, {
  Iterable<Map<String, Object?>> excludedPayloads =
      const <Map<String, Object?>>[],
}) {
  final Set<Object> visitedPayloads = Set<Object>.identity();
  for (final Map<String, Object?> payload in excludedPayloads) {
    visitedPayloads.add(payload);
  }
  final List<Map<String, Object?>> dedupedPayloads = <Map<String, Object?>>[];
  for (final Map<String, Object?> payload in payloads) {
    if (visitedPayloads.add(payload)) {
      dedupedPayloads.add(payload);
    }
  }
  return dedupedPayloads;
}

Map<String, Object?> _extractBackendStatePayload(
  Map<String, Object?> responsePayload, {
  required Map<String, Object?> envelopePayload,
  required List<String> aliases,
  List<Map<String, Object?>> additionalPayloads =
      const <Map<String, Object?>>[],
}) {
  for (final Map<String, Object?> source in <Map<String, Object?>>[
    responsePayload,
    envelopePayload,
    ...additionalPayloads,
  ]) {
    for (final String alias in <String>['state', 'workflowState', ...aliases]) {
      final Map<String, Object?> aliasPayload = _coerceStringKeyedMap(
        source[alias],
      );
      if (aliasPayload.isNotEmpty) {
        return aliasPayload;
      }
    }
  }
  if (!identical(envelopePayload, responsePayload)) {
    return envelopePayload;
  }
  return responsePayload;
}

const Set<String> _authRememberSessionAliasKeys = <String>{
  'rememberSession',
  'remember',
  'persistSession',
  'remember_session',
  'persist_session',
};

const List<String> _authRememberSessionAliases = <String>[
  'rememberSession',
  'remember',
  'persistSession',
  'remember_session',
  'persist_session',
];

const Set<String> _authSignedInAliasKeys = <String>{
  'signedIn',
  'isAuthenticated',
  'authenticated',
  'isLoggedIn',
  'loggedIn',
  'signed_in',
  'is_signed_in',
  'is_authenticated',
  'is_logged_in',
  'logged_in',
};

const List<String> _authSignedInAliases = <String>[
  'signedIn',
  'isAuthenticated',
  'authenticated',
  'isLoggedIn',
  'loggedIn',
  'signed_in',
  'is_signed_in',
  'is_authenticated',
  'is_logged_in',
  'logged_in',
];

const Set<String> _authSignedOutAliasKeys = <String>{
  'signedOut',
  'isSignedOut',
  'loggedOut',
  'isLoggedOut',
  'signed_out',
  'is_signed_out',
  'logged_out',
  'is_logged_out',
};

const List<String> _authSignedOutAliases = <String>[
  'signedOut',
  'isSignedOut',
  'loggedOut',
  'isLoggedOut',
  'signed_out',
  'is_signed_out',
  'logged_out',
  'is_logged_out',
];

const List<String> _authCredentialAliases = <String>[
  'accessToken',
  'token',
  'sessionToken',
  'refreshToken',
  'sessionId',
  'idToken',
];

const List<String> _authUserPayloadAliases = <String>[
  'user',
  'profile',
  'account',
];

const List<String> _authFailureFlagAliases = <String>[
  'success',
  'ok',
  'isSuccess',
  'isOk',
  'is_success',
  'is_ok',
];

bool _containsAnyKey(Map<String, Object?> payload, Set<String> keys) {
  for (final String key in keys) {
    if (payload.containsKey(key)) {
      return true;
    }
  }
  return false;
}

bool _containsAnyKeyInSources(
  List<Map<String, Object?>> sources,
  Set<String> keys,
) {
  for (final Map<String, Object?> source in sources) {
    if (_containsAnyKey(source, keys)) {
      return true;
    }
  }
  return false;
}

Object? _firstPresentValue(Map<String, Object?> payload, List<String> aliases) {
  for (final String alias in aliases) {
    if (payload.containsKey(alias)) {
      return payload[alias];
    }
  }
  return null;
}

Object? _firstPresentValueInSources(
  List<Map<String, Object?>> sources,
  List<String> aliases,
) {
  for (final Map<String, Object?> source in sources) {
    final Object? value = _firstPresentValue(source, aliases);
    if (value != null) {
      return value;
    }
  }
  return null;
}

bool _containsAnyNonEmptyString(
  Map<String, Object?> payload,
  List<String> aliases,
) {
  for (final String alias in aliases) {
    if (_coerceNonEmptyString(payload[alias]) != null) {
      return true;
    }
  }
  return false;
}

bool _containsAnyNonEmptyStringInSources(
  List<Map<String, Object?>> sources,
  List<String> aliases,
) {
  for (final Map<String, Object?> source in sources) {
    if (_containsAnyNonEmptyString(source, aliases)) {
      return true;
    }
  }
  return false;
}

bool _containsExplicitFalseInSources(
  List<Map<String, Object?>> sources,
  List<String> aliases,
) {
  for (final Map<String, Object?> source in sources) {
    if (_containsExplicitFalseInContainer(source, aliases)) {
      return true;
    }
  }
  return false;
}

bool _containsExplicitFalseInContainer(
  Object? value,
  List<String> aliases, [
  Set<Object>? visited,
]) {
  final Set<Object> visitedValues = visited ?? Set<Object>.identity();
  if (value is Map || value is List) {
    if (!visitedValues.add(value!)) {
      return false;
    }
  }
  final Map<String, Object?> payload = _coerceStringKeyedMap(value);
  if (payload.isNotEmpty) {
    for (final String alias in aliases) {
      if (!payload.containsKey(alias)) {
        continue;
      }
      final bool? resolved = _coerceBool(payload[alias]);
      if (resolved == false) {
        return true;
      }
    }
    for (final String alias in const <String>[
      'error',
      'errors',
      'failure',
      'failures',
      'meta',
      'result',
      'data',
      'payload',
      'state',
      'auth',
      'authentication',
      'session',
      'tokens',
    ]) {
      if (_containsExplicitFalseInContainer(
        payload[alias],
        aliases,
        visitedValues,
      )) {
        return true;
      }
    }
  }
  if (value is List) {
    for (final Object? item in value) {
      if (_containsExplicitFalseInContainer(item, aliases, visitedValues)) {
        return true;
      }
    }
  }
  return false;
}

bool _hasBackendStatus({
  required Map<String, Object?> responsePayload,
  required Map<String, Object?> envelopePayload,
  required Map<String, Object?> statePayload,
  List<Map<String, Object?>> additionalPayloads =
      const <Map<String, Object?>>[],
}) {
  for (final Map<String, Object?> payload in <Map<String, Object?>>[
    responsePayload,
    envelopePayload,
    statePayload,
    ...additionalPayloads,
  ]) {
    if (_resolveBackendStatusFromPayload(payload) != null) {
      return true;
    }
  }
  return false;
}

String _resolveBackendStatusValue({
  required Map<String, Object?> responsePayload,
  required Map<String, Object?> envelopePayload,
  required Map<String, Object?> statePayload,
  required String fallbackStatus,
  List<Map<String, Object?>> additionalPayloads =
      const <Map<String, Object?>>[],
}) {
  final String? resolvedStatus = _tryResolveBackendStatusValue(
    responsePayload: responsePayload,
    envelopePayload: envelopePayload,
    statePayload: statePayload,
    additionalPayloads: additionalPayloads,
  );
  return resolvedStatus ?? fallbackStatus;
}

String _resolveAuthBackendStatusValue({
  required Map<String, Object?> responsePayload,
  required Map<String, Object?> envelopePayload,
  required Map<String, Object?> statePayload,
  required String fallbackStatus,
  required bool signedIn,
  required bool signedOutByCode,
  required bool sessionExpiredByCode,
  required bool signedOutByStateAlias,
  required bool hasExplicitFailureFlag,
  List<Map<String, Object?>> additionalPayloads =
      const <Map<String, Object?>>[],
}) {
  final String? explicitStatus = _tryResolveBackendStatusValue(
    responsePayload: responsePayload,
    envelopePayload: envelopePayload,
    statePayload: statePayload,
    additionalPayloads: additionalPayloads,
  );
  if (explicitStatus != null) {
    return explicitStatus;
  }
  final String? fallbackMappedStatus = _resolveAuthBackendFallbackStatus(
    signedIn: signedIn,
    signedOutByCode: signedOutByCode,
    sessionExpiredByCode: sessionExpiredByCode,
    signedOutByStateAlias: signedOutByStateAlias,
    hasExplicitFailureFlag: hasExplicitFailureFlag,
  );
  return fallbackMappedStatus ?? fallbackStatus;
}

String? _resolveAuthBackendFallbackStatus({
  required bool signedIn,
  required bool signedOutByCode,
  required bool sessionExpiredByCode,
  required bool signedOutByStateAlias,
  required bool hasExplicitFailureFlag,
}) {
  if (signedIn) {
    return null;
  }
  if (signedOutByCode) {
    return sessionExpiredByCode
        ? 'Backend session expired.'
        : 'Authentication required.';
  }
  if (signedOutByStateAlias) {
    return 'Authentication required.';
  }
  if (hasExplicitFailureFlag) {
    return 'Backend auth request failed.';
  }
  return null;
}

String? _tryResolveBackendStatusValue({
  required Map<String, Object?> responsePayload,
  required Map<String, Object?> envelopePayload,
  required Map<String, Object?> statePayload,
  List<Map<String, Object?>> additionalPayloads =
      const <Map<String, Object?>>[],
}) {
  for (final Map<String, Object?> payload in <Map<String, Object?>>[
    responsePayload,
    envelopePayload,
    statePayload,
    ...additionalPayloads,
  ]) {
    final String? status = _resolveBackendStatusFromPayload(payload);
    if (status != null) {
      return status;
    }
  }
  return null;
}

String? _resolveBackendStatusFromPayload(
  Map<String, Object?> payload, {
  Set<Object>? visited,
}) {
  final Set<Object> visitedValues = visited ?? Set<Object>.identity();
  for (final String alias in const <String>[
    'status',
    'message',
    'detail',
    'reason',
    'error',
    'errorMessage',
    'description',
  ]) {
    final String? direct = _coerceNonEmptyString(payload[alias]);
    if (direct != null) {
      return direct;
    }
  }
  for (final String alias in const <String>[
    'error',
    'errors',
    'failure',
    'failures',
  ]) {
    final String? nested = _resolveBackendStatusFromContainer(
      payload[alias],
      visitedValues,
    );
    if (nested != null) {
      return nested;
    }
  }
  return null;
}

String? _resolveBackendStatusFromContainer(
  Object? value, [
  Set<Object>? visited,
]) {
  final Set<Object> visitedValues = visited ?? Set<Object>.identity();
  if (value is Map || value is List) {
    if (!visitedValues.add(value!)) {
      return null;
    }
  }
  final String? direct = _coerceNonEmptyString(value);
  if (direct != null) {
    return direct;
  }
  final Map<String, Object?> payload = _coerceStringKeyedMap(value);
  if (payload.isNotEmpty) {
    return _resolveBackendStatusFromPayload(payload, visited: visitedValues);
  }
  if (value is List) {
    for (final Object? item in value) {
      final String? nested = _resolveBackendStatusFromContainer(
        item,
        visitedValues,
      );
      if (nested != null) {
        return nested;
      }
    }
  }
  return null;
}

String? _resolveBackendCodeValue({
  required Map<String, Object?> responsePayload,
  required Map<String, Object?> envelopePayload,
  required Map<String, Object?> statePayload,
  List<Map<String, Object?>> additionalPayloads =
      const <Map<String, Object?>>[],
}) {
  for (final Map<String, Object?> payload in <Map<String, Object?>>[
    responsePayload,
    envelopePayload,
    statePayload,
    ...additionalPayloads,
  ]) {
    final String? code = _resolveBackendCodeFromPayload(payload);
    if (code != null) {
      return code;
    }
  }
  return null;
}

String? _resolveBackendCodeFromPayload(
  Map<String, Object?> payload, {
  Set<Object>? visited,
}) {
  final Set<Object> visitedValues = visited ?? Set<Object>.identity();
  final String? directCode =
      _coerceBackendCodeString(payload['code']) ??
      _coerceBackendCodeString(payload['errorCode']) ??
      _coerceBackendCodeString(payload['reasonCode']) ??
      _coerceBackendCodeString(payload['statusCode']) ??
      _coerceBackendCodeString(payload['httpStatus']) ??
      _coerceBackendCodeString(payload['status_code']) ??
      _coerceBackendCodeString(payload['http_status']);
  if (directCode != null) {
    return directCode;
  }
  for (final String alias in const <String>[
    'error',
    'errors',
    'failure',
    'failures',
  ]) {
    final String? nestedCode = _resolveBackendCodeFromContainer(
      payload[alias],
      visitedValues,
    );
    if (nestedCode != null) {
      return nestedCode;
    }
  }
  return null;
}

String? _resolveBackendCodeFromContainer(
  Object? value, [
  Set<Object>? visited,
]) {
  final Set<Object> visitedValues = visited ?? Set<Object>.identity();
  if (value is Map || value is List) {
    if (!visitedValues.add(value!)) {
      return null;
    }
  }
  final String? stringCode = _coerceBackendCodeString(value);
  if (stringCode != null) {
    return stringCode;
  }
  final Map<String, Object?> payload = _coerceStringKeyedMap(value);
  if (payload.isNotEmpty) {
    return _resolveBackendCodeFromPayload(payload, visited: visitedValues);
  }
  if (value is List) {
    for (final Object? item in value) {
      final String? nestedCode = _resolveBackendCodeFromContainer(
        item,
        visitedValues,
      );
      if (nestedCode != null) {
        return nestedCode;
      }
    }
  }
  return null;
}

class _BackendCodeClassification {
  const _BackendCodeClassification({
    required this.signedOut,
    required this.sessionExpired,
  });

  final bool signedOut;
  final bool sessionExpired;
}

const List<String> _backendSessionExpiredCodeMarkers = <String>[
  'tokenexpired',
  'sessionexpired',
  'sessiontimeout',
  'sessiontimedout',
  'expiredtoken',
  'expiredsession',
  'invalidtoken',
  'accesstokenexpired',
  'refreshtokenexpired',
  'jwtexpired',
];

const List<String> _backendSignedOutOnlyCodeMarkers = <String>[
  'authrequired',
  'unauthorized',
  'unauthenticated',
  'signedout',
  'loggedout',
];

const List<String> _backendSignedOutCodeMarkers = <String>[
  ..._backendSignedOutOnlyCodeMarkers,
  ..._backendSessionExpiredCodeMarkers,
];

final Map<String, _BackendCodeClassification> _backendExactCodeClassifications =
    _buildBackendExactCodeClassifications();
final Map<String, _BackendCodeClassification>
_backendRawExactCodeClassifications = _buildBackendRawExactCodeClassifications(
  _backendExactCodeClassifications,
);
final int _backendSignedOutOnlyCodeMarkerMinLength = _markerMinLength(
  _backendSignedOutOnlyCodeMarkers,
);
final int _backendSessionExpiredCodeMarkerMinLength = _markerMinLength(
  _backendSessionExpiredCodeMarkers,
);

Map<String, _BackendCodeClassification>
_buildBackendExactCodeClassifications() {
  final Map<String, _BackendCodeClassification> classifications =
      <String, _BackendCodeClassification>{};
  final Set<String> sessionExpiredMarkers = _backendSessionExpiredCodeMarkers
      .toSet();
  for (final String marker in _backendSignedOutCodeMarkers) {
    classifications[marker] = sessionExpiredMarkers.contains(marker)
        ? const _BackendCodeClassification(
            signedOut: true,
            sessionExpired: true,
          )
        : const _BackendCodeClassification(
            signedOut: true,
            sessionExpired: false,
          );
  }
  return Map<String, _BackendCodeClassification>.unmodifiable(classifications);
}

Map<String, _BackendCodeClassification>
_buildBackendRawExactCodeClassifications(
  Map<String, _BackendCodeClassification> exactClassifications,
) {
  final Map<String, _BackendCodeClassification> rawExactClassifications =
      <String, _BackendCodeClassification>{};
  for (final MapEntry<String, _BackendCodeClassification> entry
      in exactClassifications.entries) {
    rawExactClassifications[entry.key] = entry.value;
    rawExactClassifications[entry.key.toUpperCase()] = entry.value;
  }
  return Map<String, _BackendCodeClassification>.unmodifiable(
    rawExactClassifications,
  );
}

int _markerMinLength(List<String> markers) {
  if (markers.isEmpty) {
    return 0;
  }
  int minLength = markers.first.length;
  for (int index = 1; index < markers.length; index++) {
    final int markerLength = markers[index].length;
    if (markerLength < minLength) {
      minLength = markerLength;
    }
  }
  return minLength;
}

_BackendCodeClassification _classifyBackendCode(String rawCode) {
  final String trimmed = rawCode.trim();
  if (trimmed == '419' || trimmed == '440') {
    return const _BackendCodeClassification(
      signedOut: true,
      sessionExpired: true,
    );
  }
  if (trimmed == '401' || trimmed == '403') {
    return const _BackendCodeClassification(
      signedOut: true,
      sessionExpired: false,
    );
  }
  final _BackendCodeClassification? rawExactClassification =
      _backendRawExactCodeClassifications[trimmed];
  if (rawExactClassification != null) {
    return rawExactClassification;
  }
  final String compact = _compactBackendCodeFromTrimmed(trimmed);
  final int compactLength = compact.length;
  if (compactLength == 0) {
    return const _BackendCodeClassification(
      signedOut: false,
      sessionExpired: false,
    );
  }
  final _BackendCodeClassification? exactClassification =
      _backendExactCodeClassifications[compact];
  if (exactClassification != null) {
    return exactClassification;
  }

  final int sessionExpiredMarkerMinLength =
      _backendSessionExpiredCodeMarkerMinLength;
  if (compactLength >= sessionExpiredMarkerMinLength) {
    final List<String> sessionExpiredMarkers =
        _backendSessionExpiredCodeMarkers;
    final int markerCount = sessionExpiredMarkers.length;
    for (int markerIndex = 0; markerIndex < markerCount; markerIndex++) {
      if (compact.contains(sessionExpiredMarkers[markerIndex])) {
        return const _BackendCodeClassification(
          signedOut: true,
          sessionExpired: true,
        );
      }
    }
  }

  final int signedOutOnlyMarkerMinLength =
      _backendSignedOutOnlyCodeMarkerMinLength;
  if (compactLength < signedOutOnlyMarkerMinLength) {
    return const _BackendCodeClassification(
      signedOut: false,
      sessionExpired: false,
    );
  }

  final List<String> signedOutOnlyMarkers = _backendSignedOutOnlyCodeMarkers;
  final int markerCount = signedOutOnlyMarkers.length;
  for (int markerIndex = 0; markerIndex < markerCount; markerIndex++) {
    if (compact.contains(signedOutOnlyMarkers[markerIndex])) {
      return const _BackendCodeClassification(
        signedOut: true,
        sessionExpired: false,
      );
    }
  }

  return const _BackendCodeClassification(
    signedOut: false,
    sessionExpired: false,
  );
}

String _compactBackendCodeFromTrimmed(String trimmedCode) {
  final int codeLength = trimmedCode.length;
  int firstUppercaseCompactIndex = -1;
  int firstNonCompactIndex = -1;
  for (int index = 0; index < codeLength; index++) {
    final int codeUnit = trimmedCode.codeUnitAt(index);
    if (_isBackendCodeCompactCodeUnit(codeUnit)) {
      continue;
    }
    if (_isBackendCodeAsciiUpperAlphaCodeUnit(codeUnit)) {
      if (firstUppercaseCompactIndex == -1) {
        firstUppercaseCompactIndex = index;
      }
      continue;
    }
    firstNonCompactIndex = index;
    break;
  }
  if (firstNonCompactIndex == -1) {
    return firstUppercaseCompactIndex == -1
        ? trimmedCode
        : _compactBackendAsciiLowercase(
            trimmedCode,
            startInclusive: firstUppercaseCompactIndex,
            endExclusive: codeLength,
          );
  }
  StringBuffer? outputBuffer;
  if (firstNonCompactIndex > 0) {
    final StringBuffer prefixBuffer = outputBuffer ??= StringBuffer();
    if (firstUppercaseCompactIndex == -1) {
      _appendCompactBackendAsciiRange(
        prefixBuffer,
        trimmedCode,
        startInclusive: 0,
        endExclusive: firstNonCompactIndex,
      );
    } else {
      if (firstUppercaseCompactIndex > 0) {
        _appendCompactBackendAsciiRange(
          prefixBuffer,
          trimmedCode,
          startInclusive: 0,
          endExclusive: firstUppercaseCompactIndex,
        );
      }
      _appendCompactBackendAsciiLowercaseRange(
        prefixBuffer,
        trimmedCode,
        startInclusive: firstUppercaseCompactIndex,
        endExclusive: firstNonCompactIndex,
      );
    }
  }
  if (trimmedCode.codeUnitAt(firstNonCompactIndex) > 127) {
    final StringBuffer unicodeBuffer = outputBuffer ??= StringBuffer();
    _appendCompactBackendUnicodeLowercasedRange(
      unicodeBuffer,
      trimmedCode,
      startInclusive: firstNonCompactIndex,
    );
    return unicodeBuffer.toString();
  }
  for (int index = firstNonCompactIndex + 1; index < codeLength; index++) {
    final int codeUnit = trimmedCode.codeUnitAt(index);
    if (codeUnit > 127) {
      final StringBuffer unicodeBuffer = outputBuffer ??= StringBuffer();
      _appendCompactBackendUnicodeLowercasedRange(
        unicodeBuffer,
        trimmedCode,
        startInclusive: index,
      );
      return unicodeBuffer.toString();
    }
    if (_isBackendCodeCompactCodeUnit(codeUnit)) {
      final StringBuffer appendBuffer = outputBuffer ??= StringBuffer();
      appendBuffer.writeCharCode(codeUnit);
      continue;
    }
    if (_isBackendCodeAsciiUpperAlphaCodeUnit(codeUnit)) {
      final StringBuffer appendBuffer = outputBuffer ??= StringBuffer();
      appendBuffer.writeCharCode(_toLowerAsciiCodeUnit(codeUnit));
    }
  }
  return outputBuffer?.toString() ?? '';
}

String _compactBackendAsciiLowercase(
  String code, {
  required int startInclusive,
  required int endExclusive,
}) {
  final StringBuffer buffer = StringBuffer();
  if (startInclusive > 0) {
    _appendCompactBackendAsciiRange(
      buffer,
      code,
      startInclusive: 0,
      endExclusive: startInclusive,
    );
  }
  _appendCompactBackendAsciiLowercaseRange(
    buffer,
    code,
    startInclusive: startInclusive,
    endExclusive: endExclusive,
  );
  return buffer.toString();
}

void _appendCompactBackendAsciiLowercaseRange(
  StringBuffer buffer,
  String code, {
  required int startInclusive,
  required int endExclusive,
}) {
  for (int index = startInclusive; index < endExclusive; index++) {
    final int codeUnit = code.codeUnitAt(index);
    buffer.writeCharCode(
      _isBackendCodeAsciiUpperAlphaCodeUnit(codeUnit)
          ? _toLowerAsciiCodeUnit(codeUnit)
          : codeUnit,
    );
  }
}

void _appendCompactBackendAsciiRange(
  StringBuffer buffer,
  String code, {
  required int startInclusive,
  required int endExclusive,
}) {
  for (int index = startInclusive; index < endExclusive; index++) {
    buffer.writeCharCode(code.codeUnitAt(index));
  }
}

void _appendCompactBackendUnicodeLowercasedRange(
  StringBuffer buffer,
  String code, {
  required int startInclusive,
}) {
  final String lowered = startInclusive == 0
      ? code.toLowerCase()
      : code.substring(startInclusive).toLowerCase();
  for (int index = 0; index < lowered.length; index++) {
    final int codeUnit = lowered.codeUnitAt(index);
    if (_isBackendCodeCompactCodeUnit(codeUnit)) {
      buffer.writeCharCode(codeUnit);
    }
  }
}

bool _isBackendCodeCompactCodeUnit(int codeUnit) {
  return (codeUnit >= 48 && codeUnit <= 57) ||
      (codeUnit >= 97 && codeUnit <= 122);
}

bool _isBackendCodeAsciiUpperAlphaCodeUnit(int codeUnit) {
  return codeUnit >= 65 && codeUnit <= 90;
}

int _toLowerAsciiCodeUnit(int codeUnit) {
  return codeUnit + 32;
}

int _clampIndex(int index, {required int itemCount}) {
  if (itemCount <= 0) {
    return 0;
  }
  if (index < 0) {
    return 0;
  }
  if (index >= itemCount) {
    return itemCount - 1;
  }
  return index;
}

int _clampOptionalIndex(int index, {required int itemCount}) {
  if (itemCount <= 0) {
    return -1;
  }
  if (index < 0) {
    return -1;
  }
  if (index >= itemCount) {
    return itemCount - 1;
  }
  return index;
}

AuthSessionState? _authStateFromBackendPayload(
  Map<String, Object?> responsePayload,
  AuthSessionState currentState,
) {
  if (responsePayload.isEmpty) {
    return null;
  }
  final Map<String, Object?> envelopePayload = _extractBackendEnvelopePayload(
    responsePayload,
  );
  final List<Map<String, Object?>> additionalEnvelopePayloads =
      _dedupeBackendPayloads(
        _collectBackendEnvelopePayloads(responsePayload),
        excludedPayloads: <Map<String, Object?>>[
          responsePayload,
          envelopePayload,
        ],
      );
  final Map<String, Object?> statePayload = _extractBackendStatePayload(
    responsePayload,
    envelopePayload: envelopePayload,
    aliases: const <String>['authState'],
    additionalPayloads: additionalEnvelopePayloads,
  );
  final Map<String, Object?> sessionPayload = _coerceStringKeyedMap(
    _firstPresentValue(statePayload, const <String>[
      'session',
      'sessionState',
      'sessionInfo',
    ]),
  );
  final Map<String, Object?> tokenPayload = _coerceStringKeyedMap(
    _firstPresentValue(statePayload, const <String>[
      'tokens',
      'tokenState',
      'credentials',
    ]),
  );
  final Map<String, Object?> authPayload = _coerceStringKeyedMap(
    _firstPresentValue(statePayload, const <String>['auth', 'authentication']),
  );
  final List<Map<String, Object?>> authSources = <Map<String, Object?>>[
    statePayload,
    authPayload,
    sessionPayload,
    tokenPayload,
  ];
  final List<Map<String, Object?>> statusDetectionSources =
      _dedupeBackendPayloads(
        <Map<String, Object?>>[...additionalEnvelopePayloads, ...authSources],
        excludedPayloads: <Map<String, Object?>>[
          responsePayload,
          envelopePayload,
          statePayload,
        ],
      );

  final bool hasRememberSessionFields = _containsAnyKeyInSources(
    authSources,
    _authRememberSessionAliasKeys,
  );
  final bool hasSignedInFields = _containsAnyKeyInSources(
    authSources,
    _authSignedInAliasKeys,
  );
  final bool hasSignedOutFields = _containsAnyKeyInSources(
    authSources,
    _authSignedOutAliasKeys,
  );
  final bool hasCredentialFields = _containsAnyNonEmptyStringInSources(
    authSources,
    _authCredentialAliases,
  );
  final bool hasUserPayload = _coerceStringKeyedMap(
    _firstPresentValueInSources(<Map<String, Object?>>[
      statePayload,
      authPayload,
    ], _authUserPayloadAliases),
  ).isNotEmpty;
  final bool hasExplicitFailureFlag = _containsExplicitFalseInSources(
    <Map<String, Object?>>[
      responsePayload,
      envelopePayload,
      ...statusDetectionSources,
      statePayload,
    ],
    _authFailureFlagAliases,
  );
  final bool hasFields =
      hasRememberSessionFields ||
      hasSignedInFields ||
      hasSignedOutFields ||
      hasCredentialFields ||
      hasUserPayload;
  final bool hasStatus = _hasBackendStatus(
    responsePayload: responsePayload,
    envelopePayload: envelopePayload,
    statePayload: statePayload,
    additionalPayloads: statusDetectionSources,
  );
  if (!hasFields && !hasStatus) {
    return null;
  }

  final bool? resolvedRememberSession = _coerceBool(
    _firstPresentValueInSources(authSources, _authRememberSessionAliases),
  );
  final bool? resolvedSignedIn = _coerceBool(
    _firstPresentValueInSources(authSources, _authSignedInAliases),
  );
  final bool? resolvedSignedOut = _coerceBool(
    _firstPresentValueInSources(authSources, _authSignedOutAliases),
  );
  final bool signedOutByStateSignal =
      resolvedSignedOut == true || resolvedSignedIn == false;
  final String? backendCode = _resolveBackendCodeValue(
    responsePayload: responsePayload,
    envelopePayload: envelopePayload,
    statePayload: statePayload,
    additionalPayloads: statusDetectionSources,
  );
  final _BackendCodeClassification backendCodeClassification =
      backendCode == null
      ? const _BackendCodeClassification(
          signedOut: false,
          sessionExpired: false,
        )
      : _classifyBackendCode(backendCode);
  final bool signedOutByCode = backendCodeClassification.signedOut;
  final bool sessionExpiredByCode = backendCodeClassification.sessionExpired;
  final bool nextSignedIn;
  if (resolvedSignedIn != null) {
    nextSignedIn = resolvedSignedIn;
  } else if (resolvedSignedOut == true) {
    nextSignedIn = false;
  } else if (signedOutByCode || hasExplicitFailureFlag) {
    nextSignedIn = false;
  } else if (hasCredentialFields || hasUserPayload) {
    nextSignedIn = true;
  } else {
    nextSignedIn = currentState.signedIn;
  }

  return AuthSessionState(
    rememberSession: resolvedRememberSession ?? currentState.rememberSession,
    signedIn: nextSignedIn,
    status: _resolveAuthBackendStatusValue(
      responsePayload: responsePayload,
      envelopePayload: envelopePayload,
      statePayload: statePayload,
      fallbackStatus: currentState.status,
      signedIn: nextSignedIn,
      signedOutByCode: signedOutByCode,
      sessionExpiredByCode: sessionExpiredByCode,
      signedOutByStateAlias: signedOutByStateSignal,
      hasExplicitFailureFlag: hasExplicitFailureFlag,
      additionalPayloads: statusDetectionSources,
    ),
  );
}

ProjectLifecycleState? _projectStateFromBackendPayload(
  Map<String, Object?> responsePayload,
  ProjectLifecycleState currentState,
) {
  if (responsePayload.isEmpty) {
    return null;
  }
  final Map<String, Object?> envelopePayload = _extractBackendEnvelopePayload(
    responsePayload,
  );
  final List<Map<String, Object?>> additionalEnvelopePayloads =
      _dedupeBackendPayloads(
        _collectBackendEnvelopePayloads(responsePayload),
        excludedPayloads: <Map<String, Object?>>[
          responsePayload,
          envelopePayload,
        ],
      );
  final Map<String, Object?> statePayload = _extractBackendStatePayload(
    responsePayload,
    envelopePayload: envelopePayload,
    aliases: const <String>['projectState', 'projectsState'],
    additionalPayloads: additionalEnvelopePayloads,
  );
  final bool hasFields = _containsAnyKey(statePayload, const <String>{
    'projects',
    'selectedProjectIndex',
  });
  final bool hasStatus = _hasBackendStatus(
    responsePayload: responsePayload,
    envelopePayload: envelopePayload,
    statePayload: statePayload,
    additionalPayloads: additionalEnvelopePayloads,
  );
  if (!hasFields && !hasStatus) {
    return null;
  }

  List<ProjectRecord> projects = currentState.projects;
  if (statePayload.containsKey('projects')) {
    final List<Map<String, Object?>> projectItems = _coerceMapList(
      statePayload['projects'],
    );
    final List<ProjectRecord> parsedProjects = <ProjectRecord>[];
    for (int index = 0; index < projectItems.length; index += 1) {
      final Map<String, Object?> item = projectItems[index];
      parsedProjects.add(
        ProjectRecord(
          id:
              _coerceNonEmptyString(item['id']) ??
              'project-backend-${index + 1}',
          name: _coerceNonEmptyString(item['name']) ?? 'Backend Project',
          files: List<String>.unmodifiable(_coerceStringList(item['files'])),
        ),
      );
    }
    if (parsedProjects.isNotEmpty) {
      projects = List<ProjectRecord>.unmodifiable(parsedProjects);
    }
  }

  final int selectedProjectIndex = _clampIndex(
    _coerceInt(statePayload['selectedProjectIndex']) ??
        currentState.selectedProjectIndex,
    itemCount: projects.length,
  );

  return ProjectLifecycleState(
    projects: projects,
    selectedProjectIndex: selectedProjectIndex,
    status: _resolveBackendStatusValue(
      responsePayload: responsePayload,
      envelopePayload: envelopePayload,
      statePayload: statePayload,
      fallbackStatus: currentState.status,
      additionalPayloads: additionalEnvelopePayloads,
    ),
  );
}

CanvasEditingState? _canvasStateFromBackendPayload(
  Map<String, Object?> responsePayload,
  CanvasEditingState currentState,
) {
  if (responsePayload.isEmpty) {
    return null;
  }
  final Map<String, Object?> envelopePayload = _extractBackendEnvelopePayload(
    responsePayload,
  );
  final List<Map<String, Object?>> additionalEnvelopePayloads =
      _dedupeBackendPayloads(
        _collectBackendEnvelopePayloads(responsePayload),
        excludedPayloads: <Map<String, Object?>>[
          responsePayload,
          envelopePayload,
        ],
      );
  final Map<String, Object?> statePayload = _extractBackendStatePayload(
    responsePayload,
    envelopePayload: envelopePayload,
    aliases: const <String>['canvasState'],
    additionalPayloads: additionalEnvelopePayloads,
  );
  final bool hasFields = _containsAnyKey(statePayload, const <String>{
    'shapes',
    'selectedIndex',
  });
  final bool hasStatus = _hasBackendStatus(
    responsePayload: responsePayload,
    envelopePayload: envelopePayload,
    statePayload: statePayload,
    additionalPayloads: additionalEnvelopePayloads,
  );
  if (!hasFields && !hasStatus) {
    return null;
  }

  List<CanvasShapeRecord> shapes = currentState.shapes;
  if (statePayload.containsKey('shapes')) {
    final List<Map<String, Object?>> shapeItems = _coerceMapList(
      statePayload['shapes'],
    );
    final List<CanvasShapeRecord> parsedShapes = <CanvasShapeRecord>[];
    for (int index = 0; index < shapeItems.length; index += 1) {
      final Map<String, Object?> item = shapeItems[index];
      parsedShapes.add(
        CanvasShapeRecord(
          id: _coerceNonEmptyString(item['id']) ?? 'rect-backend-${index + 1}',
          x: _coerceDouble(item['x']) ?? 10,
          y: _coerceDouble(item['y']) ?? 10,
          width: _coerceDouble(item['width']) ?? 120,
          height: _coerceDouble(item['height']) ?? 80,
          fillHex: _coerceNonEmptyString(item['fillHex']) ?? '#007A61',
        ),
      );
    }
    shapes = List<CanvasShapeRecord>.unmodifiable(parsedShapes);
  }

  final int selectedIndex = _clampOptionalIndex(
    _coerceInt(statePayload['selectedIndex']) ?? currentState.selectedIndex,
    itemCount: shapes.length,
  );

  return CanvasEditingState(
    shapes: shapes,
    selectedIndex: selectedIndex,
    status: _resolveBackendStatusValue(
      responsePayload: responsePayload,
      envelopePayload: envelopePayload,
      statePayload: statePayload,
      fallbackStatus: currentState.status,
      additionalPayloads: additionalEnvelopePayloads,
    ),
  );
}

AssetManagementState? _assetStateFromBackendPayload(
  Map<String, Object?> responsePayload,
  AssetManagementState currentState,
) {
  if (responsePayload.isEmpty) {
    return null;
  }
  final Map<String, Object?> envelopePayload = _extractBackendEnvelopePayload(
    responsePayload,
  );
  final List<Map<String, Object?>> additionalEnvelopePayloads =
      _dedupeBackendPayloads(
        _collectBackendEnvelopePayloads(responsePayload),
        excludedPayloads: <Map<String, Object?>>[
          responsePayload,
          envelopePayload,
        ],
      );
  final Map<String, Object?> statePayload = _extractBackendStatePayload(
    responsePayload,
    envelopePayload: envelopePayload,
    aliases: const <String>['assetState', 'assetsState'],
    additionalPayloads: additionalEnvelopePayloads,
  );
  final bool hasFields = _containsAnyKey(statePayload, const <String>{
    'assets',
    'selectedAssetIndex',
  });
  final bool hasStatus = _hasBackendStatus(
    responsePayload: responsePayload,
    envelopePayload: envelopePayload,
    statePayload: statePayload,
    additionalPayloads: additionalEnvelopePayloads,
  );
  if (!hasFields && !hasStatus) {
    return null;
  }

  List<AssetRecord> assets = currentState.assets;
  if (statePayload.containsKey('assets')) {
    final List<Map<String, Object?>> assetItems = _coerceMapList(
      statePayload['assets'],
    );
    final List<AssetRecord> parsedAssets = <AssetRecord>[];
    for (int index = 0; index < assetItems.length; index += 1) {
      final Map<String, Object?> item = assetItems[index];
      parsedAssets.add(
        AssetRecord(
          id: _coerceNonEmptyString(item['id']) ?? 'asset-backend-${index + 1}',
          name: _coerceNonEmptyString(item['name']) ?? 'backend-asset',
          type: _coerceNonEmptyString(item['type']) ?? 'image',
          usedCount: (_coerceInt(item['usedCount']) ?? 0).clamp(0, 1 << 30),
        ),
      );
    }
    assets = List<AssetRecord>.unmodifiable(parsedAssets);
  }

  final int selectedAssetIndex = _clampOptionalIndex(
    _coerceInt(statePayload['selectedAssetIndex']) ??
        currentState.selectedAssetIndex,
    itemCount: assets.length,
  );

  return AssetManagementState(
    assets: assets,
    selectedAssetIndex: selectedAssetIndex,
    status: _resolveBackendStatusValue(
      responsePayload: responsePayload,
      envelopePayload: envelopePayload,
      statePayload: statePayload,
      fallbackStatus: currentState.status,
      additionalPayloads: additionalEnvelopePayloads,
    ),
  );
}

CollaborationContextState? _collaborationStateFromBackendPayload(
  Map<String, Object?> responsePayload,
  CollaborationContextState currentState,
) {
  if (responsePayload.isEmpty) {
    return null;
  }
  final Map<String, Object?> envelopePayload = _extractBackendEnvelopePayload(
    responsePayload,
  );
  final List<Map<String, Object?>> additionalEnvelopePayloads =
      _dedupeBackendPayloads(
        _collectBackendEnvelopePayloads(responsePayload),
        excludedPayloads: <Map<String, Object?>>[
          responsePayload,
          envelopePayload,
        ],
      );
  final Map<String, Object?> statePayload = _extractBackendStatePayload(
    responsePayload,
    envelopePayload: envelopePayload,
    aliases: const <String>['collaborationState'],
    additionalPayloads: additionalEnvelopePayloads,
  );
  final bool hasFields = _containsAnyKey(statePayload, const <String>{
    'peerActive',
    'threads',
    'selectedThreadIndex',
  });
  final bool hasStatus = _hasBackendStatus(
    responsePayload: responsePayload,
    envelopePayload: envelopePayload,
    statePayload: statePayload,
    additionalPayloads: additionalEnvelopePayloads,
  );
  if (!hasFields && !hasStatus) {
    return null;
  }

  List<ThreadRecord> threads = currentState.threads;
  if (statePayload.containsKey('threads')) {
    final List<Map<String, Object?>> threadItems = _coerceMapList(
      statePayload['threads'],
    );
    final List<ThreadRecord> parsedThreads = <ThreadRecord>[];
    for (int index = 0; index < threadItems.length; index += 1) {
      final Map<String, Object?> item = threadItems[index];
      parsedThreads.add(
        ThreadRecord(
          id:
              _coerceNonEmptyString(item['id']) ??
              'thread-backend-${index + 1}',
          title: _coerceNonEmptyString(item['title']) ?? 'Backend Thread',
        ),
      );
    }
    threads = List<ThreadRecord>.unmodifiable(parsedThreads);
  }

  final int selectedThreadIndex = _clampOptionalIndex(
    _coerceInt(statePayload['selectedThreadIndex']) ??
        currentState.selectedThreadIndex,
    itemCount: threads.length,
  );

  return CollaborationContextState(
    peerActive:
        _coerceBool(statePayload['peerActive']) ?? currentState.peerActive,
    threads: threads,
    selectedThreadIndex: selectedThreadIndex,
    status: _resolveBackendStatusValue(
      responsePayload: responsePayload,
      envelopePayload: envelopePayload,
      statePayload: statePayload,
      fallbackStatus: currentState.status,
      additionalPayloads: additionalEnvelopePayloads,
    ),
  );
}

InspectHandoffState? _inspectStateFromBackendPayload(
  Map<String, Object?> responsePayload,
  InspectHandoffState currentState,
) {
  if (responsePayload.isEmpty) {
    return null;
  }
  final Map<String, Object?> envelopePayload = _extractBackendEnvelopePayload(
    responsePayload,
  );
  final List<Map<String, Object?>> additionalEnvelopePayloads =
      _dedupeBackendPayloads(
        _collectBackendEnvelopePayloads(responsePayload),
        excludedPayloads: <Map<String, Object?>>[
          responsePayload,
          envelopePayload,
        ],
      );
  final Map<String, Object?> statePayload = _extractBackendStatePayload(
    responsePayload,
    envelopePayload: envelopePayload,
    aliases: const <String>['inspectState'],
    additionalPayloads: additionalEnvelopePayloads,
  );
  final bool hasFields = _containsAnyKey(statePayload, const <String>{
    'target',
    'snippet',
  });
  final bool hasStatus = _hasBackendStatus(
    responsePayload: responsePayload,
    envelopePayload: envelopePayload,
    statePayload: statePayload,
    additionalPayloads: additionalEnvelopePayloads,
  );
  if (!hasFields && !hasStatus) {
    return null;
  }
  return InspectHandoffState(
    target:
        _coerceNonEmptyString(statePayload['target']) ?? currentState.target,
    snippet:
        _coerceNonEmptyString(statePayload['snippet']) ?? currentState.snippet,
    status: _resolveBackendStatusValue(
      responsePayload: responsePayload,
      envelopePayload: envelopePayload,
      statePayload: statePayload,
      fallbackStatus: currentState.status,
      additionalPayloads: additionalEnvelopePayloads,
    ),
  );
}

ExportWorkflowState? _exportStateFromBackendPayload(
  Map<String, Object?> responsePayload,
  ExportWorkflowState currentState,
) {
  if (responsePayload.isEmpty) {
    return null;
  }
  final Map<String, Object?> envelopePayload = _extractBackendEnvelopePayload(
    responsePayload,
  );
  final List<Map<String, Object?>> additionalEnvelopePayloads =
      _dedupeBackendPayloads(
        _collectBackendEnvelopePayloads(responsePayload),
        excludedPayloads: <Map<String, Object?>>[
          responsePayload,
          envelopePayload,
        ],
      );
  final Map<String, Object?> statePayload = _extractBackendStatePayload(
    responsePayload,
    envelopePayload: envelopePayload,
    aliases: const <String>['exportState'],
    additionalPayloads: additionalEnvelopePayloads,
  );
  final bool hasFields = _containsAnyKey(statePayload, const <String>{
    'artifacts',
  });
  final bool hasStatus = _hasBackendStatus(
    responsePayload: responsePayload,
    envelopePayload: envelopePayload,
    statePayload: statePayload,
    additionalPayloads: additionalEnvelopePayloads,
  );
  if (!hasFields && !hasStatus) {
    return null;
  }

  List<ExportArtifact> artifacts = currentState.artifacts;
  if (statePayload.containsKey('artifacts')) {
    final List<Map<String, Object?>> artifactItems = _coerceMapList(
      statePayload['artifacts'],
    );
    final List<ExportArtifact> parsedArtifacts = <ExportArtifact>[];
    for (int index = 0; index < artifactItems.length; index += 1) {
      final Map<String, Object?> item = artifactItems[index];
      parsedArtifacts.add(
        ExportArtifact(
          id:
              _coerceNonEmptyString(item['id']) ??
              'export-backend-${index + 1}',
          fileName:
              _coerceNonEmptyString(item['fileName']) ??
              'backend-artifact-${index + 1}',
          format: _coerceNonEmptyString(item['format']) ?? 'png',
          scale: _coerceNonEmptyString(item['scale']) ?? '1x',
          includeBackground: _coerceBool(item['includeBackground']) ?? true,
        ),
      );
    }
    artifacts = List<ExportArtifact>.unmodifiable(parsedArtifacts);
  }

  return ExportWorkflowState(
    artifacts: artifacts,
    status: _resolveBackendStatusValue(
      responsePayload: responsePayload,
      envelopePayload: envelopePayload,
      statePayload: statePayload,
      fallbackStatus: currentState.status,
      additionalPayloads: additionalEnvelopePayloads,
    ),
  );
}

DiagnosticsRecoveryState? _diagnosticsStateFromBackendPayload(
  Map<String, Object?> responsePayload,
  DiagnosticsRecoveryState currentState,
) {
  if (responsePayload.isEmpty) {
    return null;
  }
  final Map<String, Object?> envelopePayload = _extractBackendEnvelopePayload(
    responsePayload,
  );
  final List<Map<String, Object?>> additionalEnvelopePayloads =
      _dedupeBackendPayloads(
        _collectBackendEnvelopePayloads(responsePayload),
        excludedPayloads: <Map<String, Object?>>[
          responsePayload,
          envelopePayload,
        ],
      );
  final Map<String, Object?> statePayload = _extractBackendStatePayload(
    responsePayload,
    envelopePayload: envelopePayload,
    aliases: const <String>['diagnosticsState'],
    additionalPayloads: additionalEnvelopePayloads,
  );
  final bool hasFields = _containsAnyKey(statePayload, const <String>{
    'websocketHealthy',
    'mcpHealthy',
    'reconnectAttempts',
  });
  final bool hasStatus = _hasBackendStatus(
    responsePayload: responsePayload,
    envelopePayload: envelopePayload,
    statePayload: statePayload,
    additionalPayloads: additionalEnvelopePayloads,
  );
  if (!hasFields && !hasStatus) {
    return null;
  }
  return DiagnosticsRecoveryState(
    websocketHealthy:
        _coerceBool(statePayload['websocketHealthy']) ??
        currentState.websocketHealthy,
    mcpHealthy:
        _coerceBool(statePayload['mcpHealthy']) ?? currentState.mcpHealthy,
    reconnectAttempts:
        _coerceInt(statePayload['reconnectAttempts']) ??
        currentState.reconnectAttempts,
    status: _resolveBackendStatusValue(
      responsePayload: responsePayload,
      envelopePayload: envelopePayload,
      statePayload: statePayload,
      fallbackStatus: currentState.status,
      additionalPayloads: additionalEnvelopePayloads,
    ),
  );
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
    final Map<String, Object?> responsePayload = _extractBackendSuccessPayload(
      response.body,
    );
    if (responsePayload.isNotEmpty) {
      return RemoteStubHttpBackendExecutionResult.allowedWithPayload(
        responsePayload,
      );
    }
    return const RemoteStubHttpBackendExecutionResult.allowed();
  }

  final String backendMessage = _extractBackendErrorMessage(response.body);
  if (_isAuthOperation(request.transportRequest.operation)) {
    final Map<String, Object?> payload = <String, Object?>{
      ..._extractBackendSuccessPayload(response.body),
      'code': response.statusCode,
    };
    if (backendMessage.isNotEmpty && !payload.containsKey('message')) {
      payload['message'] = backendMessage;
    }
    return RemoteStubHttpBackendExecutionResult.allowedWithPayload(payload);
  }
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
    Map<String, String> backendEndpointOverrides = const <String, String>{},
    this.backendTimeout = const Duration(seconds: 3),
    this.backendBlockedReason = 'Remote backend execution failed',
    this.backendAuthToken,
    RemoteStubHttpTransportProbe? probe,
    RemoteStubHttpBackendExecutionProbe? executionProbe,
  }) : healthUrl = healthUrl.trim(),
       backendBaseUrl = backendBaseUrl.trim(),
       backendEndpointOverrides = _normalizeBackendEndpointOverrides(
         backendEndpointOverrides,
       ),
       _probe = probe ?? _defaultHttpTransportProbe,
       _executionProbe = executionProbe ?? _defaultHttpBackendExecutionProbe,
       transportLabel = _buildCompositeHttpTransportLabel(
         healthUrl: healthUrl,
         backendBaseUrl: backendBaseUrl,
         backendEndpointOverrideCount: backendEndpointOverrides.length,
       );

  final String healthUrl;
  final Duration timeout;
  final Set<int> allowedStatusCodes;
  final String blockedReason;
  final String backendBaseUrl;
  final Map<String, String> backendEndpointOverrides;
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
    final RemoteStubTransportRequest effectiveRequest =
        _requestWithBackendEndpointOverride(request);
    if (healthUrl.isNotEmpty) {
      final RemoteStubHttpTransportProbeResult probeResult = _probe(
        RemoteStubHttpTransportProbeRequest(
          transportRequest: effectiveRequest,
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
              transportRequest: effectiveRequest,
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
      if (executionResult.responsePayload.isNotEmpty) {
        return RemoteStubTransportResult.allowedWithPayload(
          executionResult.responsePayload,
        );
      }
    }

    if (healthUrl.isEmpty && backendBaseUrl.isEmpty) {
      return RemoteStubTransportResult.allow;
    }

    return RemoteStubTransportResult.allow;
  }

  RemoteStubTransportRequest _requestWithBackendEndpointOverride(
    RemoteStubTransportRequest request,
  ) {
    final String? endpointOverride = backendEndpointOverrides[request.operation]
        ?.trim();
    if (endpointOverride == null ||
        endpointOverride.isEmpty ||
        endpointOverride == request.endpoint) {
      return request;
    }
    return RemoteStubTransportRequest(
      operation: request.operation,
      workflow: request.workflow,
      method: request.method,
      endpoint: endpointOverride,
      payload: request.payload,
    );
  }
}

RemoteStubTransportResult? _allowRemoteStubOperation({
  required RemoteStubFaultProfile faultProfile,
  required RemoteStubTransportClient transportClient,
  required RemoteStubTransportRequest transportRequest,
  required void Function(String status) setStatusOverride,
}) {
  if (faultProfile.blocksOperation(transportRequest.operation)) {
    setStatusOverride(_blockedStatus(faultProfile, transportRequest.operation));
    return null;
  }

  final RemoteStubTransportResult transportResult = transportClient.execute(
    transportRequest,
  );
  if (!transportResult.allowed) {
    final String deniedStatus =
        transportResult.status ??
        '${faultProfile.reason}: ${transportRequest.operation}.';
    setStatusOverride(_decorateStatus(deniedStatus));
    return null;
  }

  return transportResult;
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

String _stripRemoteStubPrefix(String status) {
  if (!status.startsWith(_kRemoteStubPrefix)) {
    return status;
  }
  return status.substring(_kRemoteStubPrefix.length);
}

AuthSessionState _undecorateAuthState(AuthSessionState state) =>
    AuthSessionState(
      rememberSession: state.rememberSession,
      signedIn: state.signedIn,
      status: _stripRemoteStubPrefix(state.status),
    );

abstract class RemoteStubAuthStateStore {
  const RemoteStubAuthStateStore();

  AuthSessionState? load();

  void save(AuthSessionState state);
}

class RemoteStubNoopAuthStateStore extends RemoteStubAuthStateStore {
  const RemoteStubNoopAuthStateStore();

  @override
  AuthSessionState? load() => null;

  @override
  void save(AuthSessionState state) {}
}

class RemoteStubMemoryAuthStateStore extends RemoteStubAuthStateStore {
  RemoteStubMemoryAuthStateStore([this._snapshot]);

  AuthSessionState? _snapshot;

  @override
  AuthSessionState? load() => _snapshot;

  @override
  void save(AuthSessionState state) {
    _snapshot = state;
  }
}

class RemoteStubFileAuthStateStore extends RemoteStubAuthStateStore {
  RemoteStubFileAuthStateStore(this.path);

  final String path;

  String get _normalizedPath => path.trim();

  @override
  AuthSessionState? load() {
    if (_normalizedPath.isEmpty) {
      return null;
    }

    final File snapshotFile = File(_normalizedPath);
    if (!snapshotFile.existsSync()) {
      return null;
    }

    try {
      final Object? decoded = jsonDecode(snapshotFile.readAsStringSync());
      final Map<String, Object?> payload = _coerceStringKeyedMap(decoded);
      if (payload.isEmpty) {
        return null;
      }
      return AuthSessionState(
        rememberSession: _coerceBool(payload['rememberSession']) ?? false,
        signedIn: _coerceBool(payload['signedIn']) ?? false,
        status: _coerceNonEmptyString(payload['status']) ?? 'Idle',
      );
    } on FileSystemException {
      return null;
    } on FormatException {
      return null;
    }
  }

  @override
  void save(AuthSessionState state) {
    if (_normalizedPath.isEmpty) {
      return;
    }

    final File snapshotFile = File(_normalizedPath);
    try {
      snapshotFile.parent.createSync(recursive: true);
      snapshotFile.writeAsStringSync(
        jsonEncode(<String, Object?>{
          'rememberSession': state.rememberSession,
          'signedIn': state.signedIn,
          'status': state.status,
        }),
        flush: true,
      );
    } on FileSystemException {
      return;
    }
  }
}

class RemoteStubCommandExecutionRequest {
  const RemoteStubCommandExecutionRequest({
    required this.command,
    this.environment = const <String, String>{},
  });

  final String command;
  final Map<String, String> environment;
}

class RemoteStubCommandExecutionResult {
  const RemoteStubCommandExecutionResult({
    required this.exitCode,
    this.stdout = '',
  });

  final int exitCode;
  final String stdout;
}

typedef RemoteStubCommandRunner =
    RemoteStubCommandExecutionResult Function(
      RemoteStubCommandExecutionRequest request,
    );

RemoteStubCommandExecutionResult _defaultRemoteStubCommandRunner(
  RemoteStubCommandExecutionRequest request,
) {
  final String command = request.command.trim();
  if (command.isEmpty) {
    return const RemoteStubCommandExecutionResult(exitCode: 1);
  }

  final ProcessResult result = Platform.isWindows
      ? Process.runSync('cmd', <String>[
          '/C',
          command,
        ], environment: request.environment)
      : Process.runSync('sh', <String>[
          '-c',
          command,
        ], environment: request.environment);
  return RemoteStubCommandExecutionResult(
    exitCode: result.exitCode,
    stdout: '${result.stdout}',
  );
}

class RemoteStubCommandAuthStateStore extends RemoteStubAuthStateStore {
  RemoteStubCommandAuthStateStore({
    this.loadCommand = '',
    this.saveCommand = '',
    RemoteStubCommandRunner? commandRunner,
  }) : _commandRunner = commandRunner ?? _defaultRemoteStubCommandRunner;

  final String loadCommand;
  final String saveCommand;
  final RemoteStubCommandRunner _commandRunner;

  @override
  AuthSessionState? load() {
    final String command = loadCommand.trim();
    if (command.isEmpty) {
      return null;
    }

    final RemoteStubCommandExecutionResult result = _commandRunner(
      RemoteStubCommandExecutionRequest(command: command),
    );
    if (result.exitCode != 0) {
      return null;
    }
    try {
      final Object? decoded = jsonDecode(result.stdout.trim());
      final Map<String, Object?> payload = _coerceStringKeyedMap(decoded);
      if (payload.isEmpty) {
        return null;
      }
      return AuthSessionState(
        rememberSession: _coerceBool(payload['rememberSession']) ?? false,
        signedIn: _coerceBool(payload['signedIn']) ?? false,
        status: _coerceNonEmptyString(payload['status']) ?? 'Idle',
      );
    } on FormatException {
      return null;
    }
  }

  @override
  void save(AuthSessionState state) {
    final String command = saveCommand.trim();
    if (command.isEmpty) {
      return;
    }

    _commandRunner(
      RemoteStubCommandExecutionRequest(
        command: command,
        environment: <String, String>{
          'PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_JSON':
              jsonEncode(<String, Object?>{
                'rememberSession': state.rememberSession,
                'signedIn': state.signedIn,
                'status': state.status,
              }),
        },
      ),
    );
  }
}

typedef RemoteStubSnapshotWriter = Future<void> Function(String snapshotJson);

class RemoteStubSecureSnapshotAuthStateStore extends RemoteStubAuthStateStore {
  RemoteStubSecureSnapshotAuthStateStore({
    AuthSessionState? initialSnapshot,
    required RemoteStubSnapshotWriter snapshotWriter,
  }) : _snapshot = initialSnapshot,
       _snapshotWriter = snapshotWriter;

  AuthSessionState? _snapshot;
  final RemoteStubSnapshotWriter _snapshotWriter;

  @override
  AuthSessionState? load() => _snapshot;

  @override
  void save(AuthSessionState state) {
    _snapshot = state;
    final String snapshotJson = jsonEncode(<String, Object?>{
      'rememberSession': state.rememberSession,
      'signedIn': state.signedIn,
      'status': state.status,
    });
    unawaited(
      _snapshotWriter(
        snapshotJson,
      ).catchError((Object error, StackTrace stackTrace) {}),
    );
  }
}

class RemoteStubCompositeAuthStateStore extends RemoteStubAuthStateStore {
  const RemoteStubCompositeAuthStateStore({
    required this.primary,
    required this.secondary,
  });

  final RemoteStubAuthStateStore primary;
  final RemoteStubAuthStateStore secondary;

  @override
  AuthSessionState? load() => primary.load() ?? secondary.load();

  @override
  void save(AuthSessionState state) {
    primary.save(state);
    secondary.save(state);
  }
}

class RemoteStubAuthSessionContract implements AuthSessionContract {
  RemoteStubAuthSessionContract({
    AuthSessionContract? delegate,
    this.faultProfile = const RemoteStubFaultProfile(),
    this.transportClient = const RemoteStubNoopTransportClient(),
    this.authStateStore = const RemoteStubNoopAuthStateStore(),
    this.strictBackendSchema = false,
    this.requireBackendState = false,
    this.forwardSignInCredentials = false,
    AuthSessionState? initialState,
  }) : _delegate = delegate ?? InMemoryAuthSessionContract() {
    final AuthSessionState? restoredState =
        initialState ?? authStateStore.load();
    if (restoredState != null) {
      _stateSnapshot = _decorateAuthState(restoredState);
    }
  }

  final AuthSessionContract _delegate;
  final RemoteStubFaultProfile faultProfile;
  final RemoteStubTransportClient transportClient;
  final RemoteStubAuthStateStore authStateStore;
  final bool strictBackendSchema;
  final bool requireBackendState;
  final bool forwardSignInCredentials;
  AuthSessionState? _stateSnapshot;
  String? _statusOverride;

  AuthSessionState get _currentState =>
      _stateSnapshot ?? _decorateAuthState(_delegate.state);

  @override
  AuthSessionState get state {
    final AuthSessionState baseState = _currentState;
    if (_statusOverride == null) {
      return baseState;
    }
    return _decorateAuthState(baseState, status: _statusOverride);
  }

  RemoteStubTransportResult? _allowOperation(
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

  Map<String, Object?> _signInTransportPayload(AuthSignInRequest request) {
    final Map<String, Object?> payload = <String, Object?>{
      'email': request.email.trim(),
      'passwordLength': request.password.length,
    };
    if (forwardSignInCredentials) {
      payload['password'] = request.password;
    }
    return payload;
  }

  AuthSessionState _resolveNextState({
    required RemoteStubTransportResult transportResult,
    required AuthSessionState Function() delegateFallback,
  }) {
    final AuthSessionState previousState = _currentState;
    final Map<String, Object?> responsePayload =
        transportResult.responsePayload;
    final AuthSessionState? backendState = _authStateFromBackendPayload(
      responsePayload,
      previousState,
    );
    if (backendState != null) {
      _stateSnapshot = _decorateAuthState(backendState);
    } else if (strictBackendSchema && responsePayload.isNotEmpty) {
      _stateSnapshot = _decorateAuthState(
        previousState,
        status: 'Backend auth schema validation failed.',
      );
    } else if (requireBackendState) {
      _stateSnapshot = _decorateAuthState(
        previousState,
        status: 'Backend auth state payload required.',
      );
    } else {
      _stateSnapshot = _decorateAuthState(delegateFallback());
    }
    authStateStore.save(_undecorateAuthState(_stateSnapshot!));
    return _stateSnapshot!;
  }

  @override
  AuthSessionState setRememberSession(bool enabled) {
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.setRememberSession,
      payload: <String, Object?>{'rememberSession': enabled},
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: () => _delegate.setRememberSession(enabled),
    );
  }

  @override
  AuthSessionState signIn(AuthSignInRequest request) {
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.signIn,
      payload: _signInTransportPayload(request),
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: () => _delegate.signIn(request),
    );
  }

  @override
  AuthSessionState restoreSession() {
    final AuthSessionState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.restoreSession,
      payload: <String, Object?>{
        'rememberSessionEnabled': current.rememberSession,
      },
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: _delegate.restoreSession,
    );
  }

  @override
  AuthSessionState refreshToken() {
    final AuthSessionState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.refreshToken,
      payload: <String, Object?>{'signedIn': current.signedIn},
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: _delegate.refreshToken,
    );
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
  ProjectLifecycleState? _stateSnapshot;
  String? _statusOverride;

  ProjectLifecycleState get _currentState =>
      _stateSnapshot ?? _decorateProjectState(_delegate.state);

  @override
  ProjectLifecycleState get state {
    final ProjectLifecycleState baseState = _currentState;
    if (_statusOverride == null) {
      return baseState;
    }
    return _decorateProjectState(baseState, status: _statusOverride);
  }

  RemoteStubTransportResult? _allowOperation(
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

  ProjectLifecycleState _resolveNextState({
    required RemoteStubTransportResult transportResult,
    required ProjectLifecycleState Function() delegateFallback,
  }) {
    final ProjectLifecycleState previousState = _currentState;
    final ProjectLifecycleState? backendState = _projectStateFromBackendPayload(
      transportResult.responsePayload,
      previousState,
    );
    _stateSnapshot = _decorateProjectState(backendState ?? delegateFallback());
    return _stateSnapshot!;
  }

  @override
  ProjectLifecycleState createProject(String projectName) {
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.createProject,
      payload: <String, Object?>{'projectName': projectName.trim()},
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: () => _delegate.createProject(projectName),
    );
  }

  @override
  ProjectLifecycleState switchProject(int index) {
    final ProjectLifecycleState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.switchProject,
      payload: <String, Object?>{
        'index': index,
        'projectCount': current.projects.length,
      },
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: () => _delegate.switchProject(index),
    );
  }

  @override
  ProjectLifecycleState createFile(String fileName) {
    final ProjectLifecycleState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.createFile,
      payload: <String, Object?>{
        'fileName': fileName.trim(),
        'selectedProjectId': current.selectedProject.id,
      },
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: () => _delegate.createFile(fileName),
    );
  }

  @override
  ProjectLifecycleState deleteFirstFile() {
    final ProjectLifecycleState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.deleteFile,
      payload: <String, Object?>{
        'selectedProjectId': current.selectedProject.id,
        'hasFiles': current.selectedProject.files.isNotEmpty,
      },
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: _delegate.deleteFirstFile,
    );
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
  CanvasEditingState? _stateSnapshot;
  String? _statusOverride;

  CanvasEditingState get _currentState =>
      _stateSnapshot ?? _decorateCanvasState(_delegate.state);

  @override
  CanvasEditingState get state {
    final CanvasEditingState baseState = _currentState;
    if (_statusOverride == null) {
      return baseState;
    }
    return _decorateCanvasState(baseState, status: _statusOverride);
  }

  RemoteStubTransportResult? _allowOperation(
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

  CanvasEditingState _resolveNextState({
    required RemoteStubTransportResult transportResult,
    required CanvasEditingState Function() delegateFallback,
  }) {
    final CanvasEditingState previousState = _currentState;
    final CanvasEditingState? backendState = _canvasStateFromBackendPayload(
      transportResult.responsePayload,
      previousState,
    );
    _stateSnapshot = _decorateCanvasState(backendState ?? delegateFallback());
    return _stateSnapshot!;
  }

  @override
  CanvasEditingState createRectangle() {
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.createRectangle,
      payload: const <String, Object?>{'shapeType': 'rectangle'},
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: _delegate.createRectangle,
    );
  }

  @override
  CanvasEditingState selectShape(int index) {
    final CanvasEditingState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.selectShape,
      payload: <String, Object?>{
        'index': index,
        'shapeCount': current.shapes.length,
      },
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: () => _delegate.selectShape(index),
    );
  }

  @override
  CanvasEditingState moveSelected() {
    final CanvasEditingState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.moveShape,
      payload: <String, Object?>{
        'selectedShapeId': current.selectedShape?.id ?? '',
      },
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: _delegate.moveSelected,
    );
  }

  @override
  CanvasEditingState resizeSelected() {
    final CanvasEditingState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.resizeShape,
      payload: <String, Object?>{
        'selectedShapeId': current.selectedShape?.id ?? '',
      },
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: _delegate.resizeSelected,
    );
  }

  @override
  CanvasEditingState toggleFillSelected() {
    final CanvasEditingState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.toggleFill,
      payload: <String, Object?>{
        'selectedShapeId': current.selectedShape?.id ?? '',
        'currentFill': current.selectedShape?.fillHex ?? '',
      },
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: _delegate.toggleFillSelected,
    );
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
  AssetManagementState? _stateSnapshot;
  String? _statusOverride;

  AssetManagementState get _currentState =>
      _stateSnapshot ?? _decorateAssetState(_delegate.state);

  @override
  AssetManagementState get state {
    final AssetManagementState baseState = _currentState;
    if (_statusOverride == null) {
      return baseState;
    }
    return _decorateAssetState(baseState, status: _statusOverride);
  }

  RemoteStubTransportResult? _allowOperation(
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

  AssetManagementState _resolveNextState({
    required RemoteStubTransportResult transportResult,
    required AssetManagementState Function() delegateFallback,
  }) {
    final AssetManagementState previousState = _currentState;
    final AssetManagementState? backendState = _assetStateFromBackendPayload(
      transportResult.responsePayload,
      previousState,
    );
    _stateSnapshot = _decorateAssetState(backendState ?? delegateFallback());
    return _stateSnapshot!;
  }

  @override
  AssetManagementState importAsset(String assetName, String assetType) {
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.importAsset,
      payload: <String, Object?>{
        'assetName': assetName.trim(),
        'assetType': assetType,
      },
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: () => _delegate.importAsset(assetName, assetType),
    );
  }

  @override
  AssetManagementState selectAsset(int index) {
    final AssetManagementState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.selectAsset,
      payload: <String, Object?>{
        'index': index,
        'assetCount': current.assets.length,
      },
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: () => _delegate.selectAsset(index),
    );
  }

  @override
  AssetManagementState useSelectedAsset() {
    final AssetManagementState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.useAsset,
      payload: <String, Object?>{
        'selectedAssetId': current.selectedAsset?.id ?? '',
      },
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: _delegate.useSelectedAsset,
    );
  }

  @override
  AssetManagementState removeSelectedAsset() {
    final AssetManagementState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.removeAsset,
      payload: <String, Object?>{
        'selectedAssetId': current.selectedAsset?.id ?? '',
      },
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: _delegate.removeSelectedAsset,
    );
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
  CollaborationContextState? _stateSnapshot;
  String? _statusOverride;

  CollaborationContextState get _currentState =>
      _stateSnapshot ?? _decorateCollaborationState(_delegate.state);

  @override
  CollaborationContextState get state {
    final CollaborationContextState baseState = _currentState;
    if (_statusOverride == null) {
      return baseState;
    }
    return _decorateCollaborationState(baseState, status: _statusOverride);
  }

  RemoteStubTransportResult? _allowOperation(
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

  CollaborationContextState _resolveNextState({
    required RemoteStubTransportResult transportResult,
    required CollaborationContextState Function() delegateFallback,
  }) {
    final CollaborationContextState previousState = _currentState;
    final CollaborationContextState? backendState =
        _collaborationStateFromBackendPayload(
          transportResult.responsePayload,
          previousState,
        );
    _stateSnapshot = _decorateCollaborationState(
      backendState ?? delegateFallback(),
    );
    return _stateSnapshot!;
  }

  @override
  CollaborationContextState togglePeerPresence() {
    final CollaborationContextState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.togglePeerPresence,
      payload: <String, Object?>{'peerActive': current.peerActive},
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: _delegate.togglePeerPresence,
    );
  }

  @override
  CollaborationContextState createThread(String title) {
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.createThread,
      payload: <String, Object?>{'title': title.trim()},
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: () => _delegate.createThread(title),
    );
  }

  @override
  CollaborationContextState selectThread(int index) {
    final CollaborationContextState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.selectThread,
      payload: <String, Object?>{
        'index': index,
        'threadCount': current.threads.length,
      },
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: () => _delegate.selectThread(index),
    );
  }

  @override
  CollaborationContextState resolveSelectedThread() {
    final CollaborationContextState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.resolveThread,
      payload: <String, Object?>{
        'selectedThreadId': current.selectedThread?.id ?? '',
      },
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: _delegate.resolveSelectedThread,
    );
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
  InspectHandoffState? _stateSnapshot;
  String? _statusOverride;

  InspectHandoffState get _currentState =>
      _stateSnapshot ?? _decorateInspectState(_delegate.state);

  @override
  InspectHandoffState get state {
    final InspectHandoffState baseState = _currentState;
    if (_statusOverride == null) {
      return baseState;
    }
    return _decorateInspectState(baseState, status: _statusOverride);
  }

  RemoteStubTransportResult? _allowOperation(
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

  InspectHandoffState _resolveNextState({
    required RemoteStubTransportResult transportResult,
    required InspectHandoffState Function() delegateFallback,
  }) {
    final InspectHandoffState previousState = _currentState;
    final InspectHandoffState? backendState = _inspectStateFromBackendPayload(
      transportResult.responsePayload,
      previousState,
    );
    _stateSnapshot = _decorateInspectState(backendState ?? delegateFallback());
    return _stateSnapshot!;
  }

  @override
  InspectHandoffState setTarget(String target) {
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.setInspectTarget,
      payload: <String, Object?>{'target': target},
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: () => _delegate.setTarget(target),
    );
  }

  @override
  InspectHandoffState generateSnippet(String elementId) {
    final InspectHandoffState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.generateSnippet,
      payload: <String, Object?>{
        'elementId': elementId.trim(),
        'target': current.target,
      },
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: () => _delegate.generateSnippet(elementId),
    );
  }

  @override
  InspectHandoffState copyMetadata(String elementId) {
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.copyMetadata,
      payload: <String, Object?>{'elementId': elementId.trim()},
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: () => _delegate.copyMetadata(elementId),
    );
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
  ExportWorkflowState? _stateSnapshot;
  String? _statusOverride;

  ExportWorkflowState get _currentState =>
      _stateSnapshot ?? _decorateExportState(_delegate.state);

  @override
  ExportWorkflowState get state {
    final ExportWorkflowState baseState = _currentState;
    if (_statusOverride == null) {
      return baseState;
    }
    return _decorateExportState(baseState, status: _statusOverride);
  }

  RemoteStubTransportResult? _allowOperation(
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

  ExportWorkflowState _resolveNextState({
    required RemoteStubTransportResult transportResult,
    required ExportWorkflowState Function() delegateFallback,
  }) {
    final ExportWorkflowState previousState = _currentState;
    final ExportWorkflowState? backendState = _exportStateFromBackendPayload(
      transportResult.responsePayload,
      previousState,
    );
    _stateSnapshot = _decorateExportState(backendState ?? delegateFallback());
    return _stateSnapshot!;
  }

  @override
  ExportWorkflowState runExport(ExportRequest request) {
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.runExport,
      payload: <String, Object?>{
        'fileName': request.fileName.trim(),
        'format': request.format,
        'scale': request.scale,
        'includeBackground': request.includeBackground,
      },
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: () => _delegate.runExport(request),
    );
  }

  @override
  ExportWorkflowState saveLatest() {
    final ExportWorkflowState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.saveExport,
      payload: <String, Object?>{'hasArtifact': current.latestArtifact != null},
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: _delegate.saveLatest,
    );
  }

  @override
  ExportWorkflowState clearArtifacts() {
    final ExportWorkflowState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.clearExportArtifacts,
      payload: <String, Object?>{'artifactCount': current.artifacts.length},
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: _delegate.clearArtifacts,
    );
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
  DiagnosticsRecoveryState? _stateSnapshot;
  String? _statusOverride;

  DiagnosticsRecoveryState get _currentState =>
      _stateSnapshot ?? _decorateDiagnosticsState(_delegate.state);

  @override
  DiagnosticsRecoveryState get state {
    final DiagnosticsRecoveryState baseState = _currentState;
    if (_statusOverride == null) {
      return baseState;
    }
    return _decorateDiagnosticsState(baseState, status: _statusOverride);
  }

  RemoteStubTransportResult? _allowOperation(
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

  DiagnosticsRecoveryState _resolveNextState({
    required RemoteStubTransportResult transportResult,
    required DiagnosticsRecoveryState Function() delegateFallback,
  }) {
    final DiagnosticsRecoveryState previousState = _currentState;
    final DiagnosticsRecoveryState? backendState =
        _diagnosticsStateFromBackendPayload(
          transportResult.responsePayload,
          previousState,
        );
    _stateSnapshot = _decorateDiagnosticsState(
      backendState ?? delegateFallback(),
    );
    return _stateSnapshot!;
  }

  @override
  DiagnosticsRecoveryState runHealthCheck() {
    final DiagnosticsRecoveryState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.runHealthCheck,
      payload: <String, Object?>{
        'websocketHealthy': current.websocketHealthy,
        'mcpHealthy': current.mcpHealthy,
      },
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: _delegate.runHealthCheck,
    );
  }

  @override
  DiagnosticsRecoveryState simulateDisconnect() {
    final DiagnosticsRecoveryState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.simulateDisconnect,
      payload: <String, Object?>{
        'websocketHealthy': current.websocketHealthy,
        'mcpHealthy': current.mcpHealthy,
      },
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: _delegate.simulateDisconnect,
    );
  }

  @override
  DiagnosticsRecoveryState attemptReconnect() {
    final DiagnosticsRecoveryState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.attemptReconnect,
      payload: <String, Object?>{
        'reconnectAttempts': current.reconnectAttempts,
      },
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: _delegate.attemptReconnect,
    );
  }

  @override
  DiagnosticsRecoveryState openRecoveryGuide() {
    final DiagnosticsRecoveryState current = _currentState;
    final RemoteStubTransportResult? transportResult = _allowOperation(
      RemoteStubOperationIds.openRecoveryGuide,
      payload: <String, Object?>{
        'reconnectAttempts': current.reconnectAttempts,
        'websocketHealthy': current.websocketHealthy,
      },
    );
    if (transportResult == null) {
      return state;
    }
    _clearOverride();
    return _resolveNextState(
      transportResult: transportResult,
      delegateFallback: _delegate.openRecoveryGuide,
    );
  }
}
