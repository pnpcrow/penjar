import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

const String _kRemoteStubSecureStorageDefaultKey =
    'penjar.desktop.remote_stub.auth_state.v1';

Set<String> _parseBlockedOperations(
  String raw, {
  Set<String>? allowedOperations,
}) {
  final Set<String> normalizedOperations = <String>{};
  for (final String token in raw.split(',')) {
    final String normalized = token.trim().toLowerCase();
    if (normalized.isEmpty) {
      continue;
    }
    if (allowedOperations == null || allowedOperations.contains(normalized)) {
      normalizedOperations.add(normalized);
    }
  }
  return normalizedOperations;
}

Set<String> _normalizeOperationSet(Set<String> operations) {
  final Set<String> normalized = <String>{};
  for (final String operation in operations) {
    final String item = operation.trim().toLowerCase();
    if (item.isNotEmpty) {
      normalized.add(item);
    }
  }
  return normalized;
}

int _parsePositiveIntOrDefault(String raw, {required int fallback}) {
  final int? value = int.tryParse(raw.trim());
  if (value == null || value <= 0) {
    return fallback;
  }
  return value;
}

Set<int> _parseAllowedHttpStatusCodes(String raw) {
  final Set<int> statusCodes = <int>{};
  for (final String token in raw.split(',')) {
    final int? code = int.tryParse(token.trim());
    if (code == null) {
      continue;
    }
    if (code >= 100 && code <= 599) {
      statusCodes.add(code);
    }
  }
  return statusCodes;
}

Map<String, Object?> _coerceJsonMap(Object? value) {
  if (value is Map<String, Object?>) {
    return value;
  }
  if (value is Map) {
    final Map<String, Object?> mapped = <String, Object?>{};
    value.forEach((Object? key, Object? item) {
      mapped['$key'] = item;
    });
    return mapped;
  }
  return const <String, Object?>{};
}

bool? _coerceJsonBool(Object? value) {
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

String? _coerceJsonString(Object? value) {
  if (value is! String) {
    return null;
  }
  final String trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

AuthSessionState? _parseRemoteStubAuthInitialState(String rawJson) {
  final String trimmed = rawJson.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  final Object? decoded;
  try {
    decoded = jsonDecode(trimmed);
  } on FormatException {
    return null;
  }

  final Map<String, Object?> root = _coerceJsonMap(decoded);
  if (root.isEmpty) {
    return null;
  }
  final Map<String, Object?> state =
      _coerceJsonMap(root['authState']).isNotEmpty
      ? _coerceJsonMap(root['authState'])
      : root;

  return AuthSessionState(
    rememberSession: _coerceJsonBool(state['rememberSession']) ?? false,
    signedIn: _coerceJsonBool(state['signedIn']) ?? false,
    status:
        _coerceJsonString(state['status']) ??
        _coerceJsonString(root['status']) ??
        'Idle',
  );
}

DesktopRemoteStubProfile _buildRemoteStubProfile({
  required RemoteStubFaultProfile faultProfile,
  required RemoteStubTransportClient transportClient,
}) {
  final RemoteStubTransportProfile transportProfile = transportClient.profile;

  return DesktopRemoteStubProfile(
    unavailable: faultProfile.unavailable,
    blockedOperations: _normalizeOperationSet(faultProfile.blockedOperations),
    transportBlockedOperations: _normalizeOperationSet(
      transportProfile.blockedOperations,
    ),
    transportBlockedReason: transportProfile.blockedReason,
    transportLabel: transportProfile.transportLabel,
  );
}

RemoteStubTransportClient _buildRemoteStubTransportClientFromEnvironment() {
  final String healthUrl = const String.fromEnvironment(
    'PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_HEALTH_URL',
  ).trim();
  final String backendBaseUrl = const String.fromEnvironment(
    'PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_BASE_URL',
  ).trim();
  final Set<String> blockedOperations = _parseBlockedOperations(
    const String.fromEnvironment(
      'PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BLOCKED_OPERATIONS',
    ),
    allowedOperations: RemoteStubOperationIds.all,
  );
  final String blockedReason = const String.fromEnvironment(
    'PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BLOCK_REASON',
    defaultValue: 'Remote transport unavailable',
  ).trim();
  final String backendBlockedReason = const String.fromEnvironment(
    'PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_BLOCK_REASON',
    defaultValue: 'Remote backend execution failed',
  ).trim();
  final String backendAuthToken = const String.fromEnvironment(
    'PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_AUTH_TOKEN',
  ).trim();

  if (healthUrl.isNotEmpty || backendBaseUrl.isNotEmpty) {
    final int timeoutMillis = _parsePositiveIntOrDefault(
      const String.fromEnvironment(
        'PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_TIMEOUT_MS',
      ),
      fallback: 2000,
    );
    final Set<int> allowedStatusCodes = _parseAllowedHttpStatusCodes(
      const String.fromEnvironment(
        'PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_ALLOWED_STATUS_CODES',
      ),
    );
    final int backendTimeoutMillis = _parsePositiveIntOrDefault(
      const String.fromEnvironment(
        'PENJAR_DESKTOP_REMOTE_STUB_TRANSPORT_BACKEND_TIMEOUT_MS',
      ),
      fallback: 3000,
    );
    return RemoteStubHttpTransportClient(
      healthUrl: healthUrl,
      timeout: Duration(milliseconds: timeoutMillis),
      allowedStatusCodes: allowedStatusCodes.isEmpty
          ? const <int>{200}
          : allowedStatusCodes,
      blockedReason: blockedReason.isEmpty
          ? 'Remote transport unavailable'
          : blockedReason,
      backendBaseUrl: backendBaseUrl,
      backendTimeout: Duration(milliseconds: backendTimeoutMillis),
      backendBlockedReason: backendBlockedReason.isEmpty
          ? 'Remote backend execution failed'
          : backendBlockedReason,
      backendAuthToken: backendAuthToken.isEmpty ? null : backendAuthToken,
    );
  }

  if (blockedOperations.isEmpty) {
    return const RemoteStubNoopTransportClient();
  }

  return RemoteStubScriptedTransportClient(
    blockedOperations: blockedOperations,
    blockedReason: blockedReason.isEmpty
        ? 'Remote transport unavailable'
        : blockedReason,
  );
}

RemoteStubAuthStateStore _buildRemoteStubAuthStateStoreFromEnvironment() {
  final String authStateLoadCommand = const String.fromEnvironment(
    'PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_LOAD_COMMAND',
  ).trim();
  final String authStateSaveCommand = const String.fromEnvironment(
    'PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_SAVE_COMMAND',
  ).trim();
  if (authStateLoadCommand.isNotEmpty || authStateSaveCommand.isNotEmpty) {
    return RemoteStubCommandAuthStateStore(
      loadCommand: authStateLoadCommand,
      saveCommand: authStateSaveCommand,
    );
  }

  final String authStatePath = const String.fromEnvironment(
    'PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_PATH',
  ).trim();
  if (authStatePath.isEmpty) {
    return const RemoteStubNoopAuthStateStore();
  }
  return RemoteStubFileAuthStateStore(authStatePath);
}

bool _secureStorageAuthStateEnabledFromEnvironment() {
  return _envFlagEnabled(
    const String.fromEnvironment(
      'PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_ENABLED',
    ),
  );
}

String _secureStorageAuthStateKeyFromEnvironment() {
  final String key = const String.fromEnvironment(
    'PENJAR_DESKTOP_REMOTE_STUB_AUTH_SECURE_STORAGE_KEY',
  ).trim();
  return key.isEmpty ? _kRemoteStubSecureStorageDefaultKey : key;
}

Future<RemoteStubAuthStateStore>
_buildRemoteStubAuthStateStoreFromEnvironmentAsync({
  FlutterSecureStorage? secureStorage,
}) async {
  if (!_secureStorageAuthStateEnabledFromEnvironment()) {
    return _buildRemoteStubAuthStateStoreFromEnvironment();
  }

  final FlutterSecureStorage storage =
      secureStorage ?? const FlutterSecureStorage();
  final String storageKey = _secureStorageAuthStateKeyFromEnvironment();
  AuthSessionState? initialSnapshot;
  try {
    final String? rawSnapshot = await storage.read(key: storageKey);
    initialSnapshot = _parseRemoteStubAuthInitialState(rawSnapshot ?? '');
  } on Object {
    initialSnapshot = null;
  }

  return RemoteStubSecureSnapshotAuthStateStore(
    initialSnapshot: initialSnapshot,
    snapshotWriter: (String snapshotJson) {
      return storage.write(key: storageKey, value: snapshotJson);
    },
  );
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

class DesktopRemoteStubProfile {
  const DesktopRemoteStubProfile({
    required this.unavailable,
    this.blockedOperations = const <String>{},
    this.transportBlockedOperations = const <String>{},
    this.transportBlockedReason = 'Remote transport unavailable',
    this.transportLabel = '',
  });

  final bool unavailable;
  final Set<String> blockedOperations;
  final Set<String> transportBlockedOperations;
  final String transportBlockedReason;
  final String transportLabel;

  bool get isEmpty =>
      !unavailable &&
      blockedOperations.isEmpty &&
      transportBlockedOperations.isEmpty &&
      transportLabel.trim().isEmpty;

  String get summaryLabel {
    if (isEmpty) {
      return 'none';
    }

    final List<String> parts = <String>[];
    if (unavailable) {
      parts.add('unavailable');
    }
    if (blockedOperations.isNotEmpty) {
      final List<String> values = blockedOperations.toList()..sort();
      parts.add('fault blocks: ${values.join(',')}');
    }
    if (transportBlockedOperations.isNotEmpty) {
      final List<String> values = transportBlockedOperations.toList()..sort();
      parts.add('transport blocks: ${values.join(',')}');
    }
    if (transportLabel.trim().isNotEmpty) {
      parts.add('transport: $transportLabel');
    }
    return parts.join(' · ');
  }
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
    this.remoteStubProfile,
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
      allowedOperations: RemoteStubOperationIds.all,
    );
    final RemoteStubTransportClient transportClient =
        _buildRemoteStubTransportClientFromEnvironment();
    final RemoteStubAuthStateStore remoteStubAuthStateStore =
        _buildRemoteStubAuthStateStoreFromEnvironment();
    final AuthSessionState? remoteStubAuthInitialState =
        _parseRemoteStubAuthInitialState(
          const String.fromEnvironment(
            'PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_JSON',
          ),
        );

    return DesktopContractBundle.fromMode(
      mode,
      remoteStubFaultProfile: RemoteStubFaultProfile(
        unavailable: remoteStubUnavailable,
        blockedOperations: blockedOperations,
      ),
      remoteStubTransportClient: transportClient,
      remoteStubAuthStateStore: remoteStubAuthStateStore,
      remoteStubAuthInitialState: remoteStubAuthInitialState,
    );
  }

  static Future<DesktopContractBundle> loadFromEnvironment({
    FlutterSecureStorage? secureStorage,
  }) async {
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
      allowedOperations: RemoteStubOperationIds.all,
    );
    final RemoteStubTransportClient transportClient =
        _buildRemoteStubTransportClientFromEnvironment();
    final RemoteStubAuthStateStore remoteStubAuthStateStore =
        await _buildRemoteStubAuthStateStoreFromEnvironmentAsync(
          secureStorage: secureStorage,
        );
    final AuthSessionState? remoteStubAuthInitialState =
        _parseRemoteStubAuthInitialState(
          const String.fromEnvironment(
            'PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_JSON',
          ),
        );

    return DesktopContractBundle.fromMode(
      mode,
      remoteStubFaultProfile: RemoteStubFaultProfile(
        unavailable: remoteStubUnavailable,
        blockedOperations: blockedOperations,
      ),
      remoteStubTransportClient: transportClient,
      remoteStubAuthStateStore: remoteStubAuthStateStore,
      remoteStubAuthInitialState: remoteStubAuthInitialState,
    );
  }

  factory DesktopContractBundle.fromMode(
    DesktopContractMode mode, {
    RemoteStubFaultProfile remoteStubFaultProfile =
        const RemoteStubFaultProfile(),
    RemoteStubTransportClient remoteStubTransportClient =
        const RemoteStubNoopTransportClient(),
    RemoteStubAuthStateStore remoteStubAuthStateStore =
        const RemoteStubNoopAuthStateStore(),
    AuthSessionState? remoteStubAuthInitialState,
    DesktopRemoteStubProfile? remoteStubProfile,
  }) {
    return switch (mode) {
      DesktopContractMode.inMemory => DesktopContractBundle.inMemory(),
      DesktopContractMode.remoteStub => DesktopContractBundle.remoteStub(
        faultProfile: remoteStubFaultProfile,
        transportClient: remoteStubTransportClient,
        authStateStore: remoteStubAuthStateStore,
        authInitialState: remoteStubAuthInitialState,
        remoteStubProfile:
            remoteStubProfile ??
            _buildRemoteStubProfile(
              faultProfile: remoteStubFaultProfile,
              transportClient: remoteStubTransportClient,
            ),
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
    RemoteStubTransportClient transportClient =
        const RemoteStubNoopTransportClient(),
    RemoteStubAuthStateStore authStateStore =
        const RemoteStubNoopAuthStateStore(),
    AuthSessionState? authInitialState,
    DesktopRemoteStubProfile? remoteStubProfile,
  }) {
    return DesktopContractBundle(
      mode: DesktopContractMode.remoteStub,
      authSession: RemoteStubAuthSessionContract(
        faultProfile: faultProfile,
        transportClient: transportClient,
        authStateStore: authStateStore,
        initialState: authInitialState,
      ),
      projectLifecycle: RemoteStubProjectLifecycleContract(
        faultProfile: faultProfile,
        transportClient: transportClient,
      ),
      canvasEditing: RemoteStubCanvasEditingContract(
        faultProfile: faultProfile,
        transportClient: transportClient,
      ),
      assetManagement: RemoteStubAssetManagementContract(
        faultProfile: faultProfile,
        transportClient: transportClient,
      ),
      collaborationContext: RemoteStubCollaborationContextContract(
        faultProfile: faultProfile,
        transportClient: transportClient,
      ),
      inspectHandoff: RemoteStubInspectHandoffContract(
        faultProfile: faultProfile,
        transportClient: transportClient,
      ),
      exportWorkflow: RemoteStubExportWorkflowContract(
        faultProfile: faultProfile,
        transportClient: transportClient,
      ),
      diagnosticsRecovery: RemoteStubDiagnosticsRecoveryContract(
        faultProfile: faultProfile,
        transportClient: transportClient,
      ),
      remoteStubProfile:
          remoteStubProfile ??
          _buildRemoteStubProfile(
            faultProfile: faultProfile,
            transportClient: transportClient,
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
  final DesktopRemoteStubProfile? remoteStubProfile;
}
