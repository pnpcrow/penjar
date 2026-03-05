class AuthSignInRequest {
  const AuthSignInRequest({required this.email, required this.password});

  final String email;
  final String password;
}

class AuthSessionState {
  const AuthSessionState({
    required this.rememberSession,
    required this.signedIn,
    required this.status,
  });

  final bool rememberSession;
  final bool signedIn;
  final String status;
}

abstract class AuthSessionContract {
  AuthSessionState get state;
  AuthSessionState setRememberSession(bool enabled);
  AuthSessionState signIn(AuthSignInRequest request);
  AuthSessionState restoreSession();
  AuthSessionState refreshToken();
}

class InMemoryAuthSessionContract implements AuthSessionContract {
  bool _rememberSession = false;
  bool _signedIn = false;
  String _status = 'Idle';

  @override
  AuthSessionState get state => AuthSessionState(
    rememberSession: _rememberSession,
    signedIn: _signedIn,
    status: _status,
  );

  @override
  AuthSessionState setRememberSession(bool enabled) {
    _rememberSession = enabled;
    return state;
  }

  @override
  AuthSessionState signIn(AuthSignInRequest request) {
    final String email = request.email.trim();
    if (email.isEmpty || request.password.isEmpty) {
      _status = 'Validation failed: email and password are required.';
      return state;
    }

    _signedIn = true;
    _status = 'Signed in (simulated).';
    return state;
  }

  @override
  AuthSessionState restoreSession() {
    if (!_rememberSession) {
      _status = 'Session restore blocked: enable Remember Session first.';
      return state;
    }
    _status = 'Session restored (simulated).';
    return state;
  }

  @override
  AuthSessionState refreshToken() {
    if (!_signedIn) {
      _status = 'Token refresh blocked: sign in first.';
      return state;
    }
    _status = 'Token refreshed (simulated).';
    return state;
  }
}

class ProjectRecord {
  const ProjectRecord({
    required this.id,
    required this.name,
    required this.files,
  });

  final String id;
  final String name;
  final List<String> files;
}

class ProjectLifecycleState {
  const ProjectLifecycleState({
    required this.projects,
    required this.selectedProjectIndex,
    required this.status,
  });

  final List<ProjectRecord> projects;
  final int selectedProjectIndex;
  final String status;

  ProjectRecord get selectedProject => projects[selectedProjectIndex];
}

abstract class ProjectLifecycleContract {
  ProjectLifecycleState get state;
  ProjectLifecycleState createProject(String projectName);
  ProjectLifecycleState switchProject(int index);
  ProjectLifecycleState createFile(String fileName);
  ProjectLifecycleState deleteFirstFile();
}

class _MutableProjectRecord {
  _MutableProjectRecord({
    required this.id,
    required this.name,
    required this.files,
  });

  final String id;
  String name;
  final List<String> files;
}

class InMemoryProjectLifecycleContract implements ProjectLifecycleContract {
  final List<_MutableProjectRecord> _projects = <_MutableProjectRecord>[
    _MutableProjectRecord(
      id: 'project-core',
      name: 'Core Product',
      files: <String>['landing.penjar'],
    ),
  ];
  int _selectedProjectIndex = 0;
  int _nextProjectNumber = 1;
  String _status = 'Idle';

  @override
  ProjectLifecycleState get state => ProjectLifecycleState(
    projects: List<ProjectRecord>.unmodifiable(
      _projects.map(
        (_MutableProjectRecord project) => ProjectRecord(
          id: project.id,
          name: project.name,
          files: List<String>.unmodifiable(project.files),
        ),
      ),
    ),
    selectedProjectIndex: _selectedProjectIndex,
    status: _status,
  );

  _MutableProjectRecord get _selectedProject =>
      _projects[_selectedProjectIndex];

  @override
  ProjectLifecycleState createProject(String projectName) {
    final String normalizedName = projectName.trim();
    if (normalizedName.isEmpty) {
      _status = 'Project create failed: project name is required.';
      return state;
    }

    final _MutableProjectRecord created = _MutableProjectRecord(
      id: 'project-${_nextProjectNumber++}',
      name: normalizedName,
      files: <String>[],
    );
    _projects.add(created);
    _selectedProjectIndex = _projects.length - 1;
    _status = 'Project created: ${created.name}.';
    return state;
  }

  @override
  ProjectLifecycleState switchProject(int index) {
    if (index < 0 || index >= _projects.length) {
      _status = 'Project switch failed: invalid project index.';
      return state;
    }

    _selectedProjectIndex = index;
    _status = 'Project selected: ${_selectedProject.name}.';
    return state;
  }

  @override
  ProjectLifecycleState createFile(String fileName) {
    final String normalizedName = fileName.trim();
    if (normalizedName.isEmpty) {
      _status = 'File create failed: file name is required.';
      return state;
    }

    _selectedProject.files.add(normalizedName);
    _status = 'File created in ${_selectedProject.name}: $normalizedName.';
    return state;
  }

  @override
  ProjectLifecycleState deleteFirstFile() {
    if (_selectedProject.files.isEmpty) {
      _status = 'File delete skipped: no file exists.';
      return state;
    }

    final String removed = _selectedProject.files.removeAt(0);
    _status = 'File deleted from ${_selectedProject.name}: $removed.';
    return state;
  }
}

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
