class ExportRequest {
  const ExportRequest({
    required this.fileName,
    required this.format,
    required this.scale,
    required this.includeBackground,
  });

  final String fileName;
  final String format;
  final String scale;
  final bool includeBackground;
}

class ExportArtifact {
  const ExportArtifact({
    required this.id,
    required this.fileName,
    required this.format,
    required this.scale,
    required this.includeBackground,
  });

  final String id;
  final String fileName;
  final String format;
  final String scale;
  final bool includeBackground;

  String get outputPath => '/exports/$fileName.$format';
}

class ExportWorkflowState {
  const ExportWorkflowState({required this.artifacts, required this.status});

  final List<ExportArtifact> artifacts;
  final String status;

  ExportArtifact? get latestArtifact {
    if (artifacts.isEmpty) {
      return null;
    }
    return artifacts.last;
  }
}

abstract class ExportWorkflowContract {
  ExportWorkflowState get state;
  ExportWorkflowState runExport(ExportRequest request);
  ExportWorkflowState saveLatest();
  ExportWorkflowState clearArtifacts();
}

class InMemoryExportWorkflowContract implements ExportWorkflowContract {
  final List<ExportArtifact> _artifacts = <ExportArtifact>[];
  int _nextExportNumber = 1;
  String _status = 'Idle';

  @override
  ExportWorkflowState get state => ExportWorkflowState(
    artifacts: List<ExportArtifact>.unmodifiable(_artifacts),
    status: _status,
  );

  @override
  ExportWorkflowState runExport(ExportRequest request) {
    final String fileName = request.fileName.trim();
    if (fileName.isEmpty) {
      _status = 'Export failed: file name is required.';
      return state;
    }

    final ExportArtifact created = ExportArtifact(
      id: 'export-${_nextExportNumber++}',
      fileName: fileName,
      format: request.format,
      scale: request.scale,
      includeBackground: request.includeBackground,
    );
    _artifacts.add(created);
    _status = 'Export completed: ${created.outputPath}.';
    return state;
  }

  @override
  ExportWorkflowState saveLatest() {
    final ExportArtifact? artifact = state.latestArtifact;
    if (artifact == null) {
      _status = 'Save failed: no export artifact is available.';
      return state;
    }

    _status = 'Export saved (simulated): ${artifact.outputPath}.';
    return state;
  }

  @override
  ExportWorkflowState clearArtifacts() {
    _artifacts.clear();
    _status = 'Export artifacts cleared.';
    return state;
  }
}

class DiagnosticsRecoveryState {
  const DiagnosticsRecoveryState({
    required this.websocketHealthy,
    required this.mcpHealthy,
    required this.reconnectAttempts,
    required this.status,
  });

  final bool websocketHealthy;
  final bool mcpHealthy;
  final int reconnectAttempts;
  final String status;
}

abstract class DiagnosticsRecoveryContract {
  DiagnosticsRecoveryState get state;
  DiagnosticsRecoveryState runHealthCheck();
  DiagnosticsRecoveryState simulateDisconnect();
  DiagnosticsRecoveryState attemptReconnect();
  DiagnosticsRecoveryState openRecoveryGuide();
}

class InMemoryDiagnosticsRecoveryContract
    implements DiagnosticsRecoveryContract {
  bool _websocketHealthy = true;
  bool _mcpHealthy = true;
  int _reconnectAttempts = 0;
  String _status = 'Idle';

  @override
  DiagnosticsRecoveryState get state => DiagnosticsRecoveryState(
    websocketHealthy: _websocketHealthy,
    mcpHealthy: _mcpHealthy,
    reconnectAttempts: _reconnectAttempts,
    status: _status,
  );

  @override
  DiagnosticsRecoveryState runHealthCheck() {
    _status = _websocketHealthy && _mcpHealthy
        ? 'Health check passed: websocket and MCP are connected.'
        : 'Health check warning: connectivity issue detected.';
    return state;
  }

  @override
  DiagnosticsRecoveryState simulateDisconnect() {
    _websocketHealthy = false;
    _mcpHealthy = false;
    _status = 'WebSocket disconnected; MCP stream unavailable.';
    return state;
  }

  @override
  DiagnosticsRecoveryState attemptReconnect() {
    if (_websocketHealthy && _mcpHealthy) {
      _status = 'Reconnect skipped: session is already healthy.';
      return state;
    }

    _reconnectAttempts += 1;
    _websocketHealthy = true;
    _mcpHealthy = true;
    _status = 'Reconnect successful on attempt $_reconnectAttempts.';
    return state;
  }

  @override
  DiagnosticsRecoveryState openRecoveryGuide() {
    _status = 'Recovery guide opened (simulated).';
    return state;
  }
}
