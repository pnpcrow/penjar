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

    return DesktopContractBundle.fromMode(
      mode,
      remoteStubFaultProfile: RemoteStubFaultProfile(
        unavailable: remoteStubUnavailable,
        blockedOperations: blockedOperations,
      ),
      remoteStubTransportClient: transportClient,
    );
  }

  factory DesktopContractBundle.fromMode(
    DesktopContractMode mode, {
    RemoteStubFaultProfile remoteStubFaultProfile =
        const RemoteStubFaultProfile(),
    RemoteStubTransportClient remoteStubTransportClient =
        const RemoteStubNoopTransportClient(),
    DesktopRemoteStubProfile? remoteStubProfile,
  }) {
    return switch (mode) {
      DesktopContractMode.inMemory => DesktopContractBundle.inMemory(),
      DesktopContractMode.remoteStub => DesktopContractBundle.remoteStub(
        faultProfile: remoteStubFaultProfile,
        transportClient: remoteStubTransportClient,
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
    DesktopRemoteStubProfile? remoteStubProfile,
  }) {
    return DesktopContractBundle(
      mode: DesktopContractMode.remoteStub,
      authSession: RemoteStubAuthSessionContract(
        faultProfile: faultProfile,
        transportClient: transportClient,
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
