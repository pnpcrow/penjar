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

class CanvasShapeRecord {
  const CanvasShapeRecord({
    required this.id,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.fillHex,
  });

  final String id;
  final double x;
  final double y;
  final double width;
  final double height;
  final String fillHex;
}

class CanvasEditingState {
  const CanvasEditingState({
    required this.shapes,
    required this.selectedIndex,
    required this.status,
  });

  final List<CanvasShapeRecord> shapes;
  final int selectedIndex;
  final String status;

  CanvasShapeRecord? get selectedShape {
    if (selectedIndex < 0 || selectedIndex >= shapes.length) {
      return null;
    }
    return shapes[selectedIndex];
  }
}

abstract class CanvasEditingContract {
  CanvasEditingState get state;
  CanvasEditingState createRectangle();
  CanvasEditingState selectShape(int index);
  CanvasEditingState moveSelected();
  CanvasEditingState resizeSelected();
  CanvasEditingState toggleFillSelected();
}

class _MutableCanvasShape {
  _MutableCanvasShape({
    required this.id,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.fillHex,
  });

  final String id;
  double x;
  double y;
  double width;
  double height;
  String fillHex;
}

class InMemoryCanvasEditingContract implements CanvasEditingContract {
  final List<_MutableCanvasShape> _shapes = <_MutableCanvasShape>[];
  int _nextShapeNumber = 1;
  int _selectedIndex = -1;
  String _status = 'Idle';

  @override
  CanvasEditingState get state => CanvasEditingState(
    shapes: List<CanvasShapeRecord>.unmodifiable(
      _shapes.map(
        (_MutableCanvasShape shape) => CanvasShapeRecord(
          id: shape.id,
          x: shape.x,
          y: shape.y,
          width: shape.width,
          height: shape.height,
          fillHex: shape.fillHex,
        ),
      ),
    ),
    selectedIndex: _selectedIndex,
    status: _status,
  );

  _MutableCanvasShape? get _selectedShape {
    if (_selectedIndex < 0 || _selectedIndex >= _shapes.length) {
      return null;
    }
    return _shapes[_selectedIndex];
  }

  @override
  CanvasEditingState createRectangle() {
    final _MutableCanvasShape shape = _MutableCanvasShape(
      id: 'rect-${_nextShapeNumber++}',
      x: 10,
      y: 10,
      width: 120,
      height: 80,
      fillHex: '#007A61',
    );
    _shapes.add(shape);
    _selectedIndex = _shapes.length - 1;
    _status = 'Rectangle created: ${shape.id}.';
    return state;
  }

  @override
  CanvasEditingState selectShape(int index) {
    if (index < 0 || index >= _shapes.length) {
      _status = 'Shape select failed: invalid index.';
      return state;
    }
    _selectedIndex = index;
    _status = 'Shape selected: ${_shapes[index].id}.';
    return state;
  }

  @override
  CanvasEditingState moveSelected() {
    final _MutableCanvasShape? shape = _selectedShape;
    if (shape == null) {
      _status = 'Move skipped: no shape selected.';
      return state;
    }
    shape.x += 10;
    shape.y += 5;
    _status = 'Moved ${shape.id} to (${shape.x.toInt()}, ${shape.y.toInt()}).';
    return state;
  }

  @override
  CanvasEditingState resizeSelected() {
    final _MutableCanvasShape? shape = _selectedShape;
    if (shape == null) {
      _status = 'Resize skipped: no shape selected.';
      return state;
    }
    shape.width += 20;
    shape.height += 20;
    _status =
        'Resized ${shape.id} to ${shape.width.toInt()}x${shape.height.toInt()}.';
    return state;
  }

  @override
  CanvasEditingState toggleFillSelected() {
    final _MutableCanvasShape? shape = _selectedShape;
    if (shape == null) {
      _status = 'Fill toggle skipped: no shape selected.';
      return state;
    }
    shape.fillHex = shape.fillHex == '#007A61' ? '#FF8A00' : '#007A61';
    _status = 'Fill updated for ${shape.id}: ${shape.fillHex}.';
    return state;
  }
}

class AssetRecord {
  const AssetRecord({
    required this.id,
    required this.name,
    required this.type,
    required this.usedCount,
  });

  final String id;
  final String name;
  final String type;
  final int usedCount;
}

class AssetManagementState {
  const AssetManagementState({
    required this.assets,
    required this.selectedAssetIndex,
    required this.status,
  });

  final List<AssetRecord> assets;
  final int selectedAssetIndex;
  final String status;

  AssetRecord? get selectedAsset {
    if (selectedAssetIndex < 0 || selectedAssetIndex >= assets.length) {
      return null;
    }
    return assets[selectedAssetIndex];
  }
}

abstract class AssetManagementContract {
  AssetManagementState get state;
  AssetManagementState importAsset(String assetName, String assetType);
  AssetManagementState selectAsset(int index);
  AssetManagementState useSelectedAsset();
  AssetManagementState removeSelectedAsset();
}

class _MutableAssetRecord {
  _MutableAssetRecord({
    required this.id,
    required this.name,
    required this.type,
  });

  final String id;
  final String name;
  final String type;
  int usedCount = 0;
}

class InMemoryAssetManagementContract implements AssetManagementContract {
  final List<_MutableAssetRecord> _assets = <_MutableAssetRecord>[];
  int _selectedAssetIndex = -1;
  int _nextAssetNumber = 1;
  String _status = 'Idle';

  @override
  AssetManagementState get state => AssetManagementState(
    assets: List<AssetRecord>.unmodifiable(
      _assets.map(
        (_MutableAssetRecord asset) => AssetRecord(
          id: asset.id,
          name: asset.name,
          type: asset.type,
          usedCount: asset.usedCount,
        ),
      ),
    ),
    selectedAssetIndex: _selectedAssetIndex,
    status: _status,
  );

  _MutableAssetRecord? get _selectedAsset {
    if (_selectedAssetIndex < 0 || _selectedAssetIndex >= _assets.length) {
      return null;
    }
    return _assets[_selectedAssetIndex];
  }

  @override
  AssetManagementState importAsset(String assetName, String assetType) {
    final String normalizedName = assetName.trim();
    if (normalizedName.isEmpty) {
      _status = 'Asset import failed: asset name is required.';
      return state;
    }

    final bool duplicated = _assets.any(
      (_MutableAssetRecord asset) =>
          asset.name.toLowerCase() == normalizedName.toLowerCase(),
    );
    if (duplicated) {
      _status = 'Asset import failed: duplicate asset name.';
      return state;
    }

    final _MutableAssetRecord created = _MutableAssetRecord(
      id: 'asset-${_nextAssetNumber++}',
      name: normalizedName,
      type: assetType,
    );
    _assets.add(created);
    _selectedAssetIndex = _assets.length - 1;
    _status = 'Asset imported: ${created.name} (${created.type}).';
    return state;
  }

  @override
  AssetManagementState selectAsset(int index) {
    if (index < 0 || index >= _assets.length) {
      _status = 'Asset select failed: invalid index.';
      return state;
    }

    _selectedAssetIndex = index;
    _status = 'Asset selected: ${_assets[index].name}.';
    return state;
  }

  @override
  AssetManagementState useSelectedAsset() {
    final _MutableAssetRecord? asset = _selectedAsset;
    if (asset == null) {
      _status = 'Asset use skipped: no asset selected.';
      return state;
    }

    asset.usedCount += 1;
    _status = 'Asset used: ${asset.name} (count ${asset.usedCount}).';
    return state;
  }

  @override
  AssetManagementState removeSelectedAsset() {
    final _MutableAssetRecord? asset = _selectedAsset;
    if (asset == null) {
      _status = 'Asset remove skipped: no asset selected.';
      return state;
    }

    final String removedName = asset.name;
    _assets.removeAt(_selectedAssetIndex);
    if (_assets.isEmpty) {
      _selectedAssetIndex = -1;
    } else if (_selectedAssetIndex >= _assets.length) {
      _selectedAssetIndex = _assets.length - 1;
    }
    _status = 'Asset removed: $removedName.';
    return state;
  }
}

class ThreadRecord {
  const ThreadRecord({required this.id, required this.title});

  final String id;
  final String title;
}

class CollaborationContextState {
  const CollaborationContextState({
    required this.peerActive,
    required this.threads,
    required this.selectedThreadIndex,
    required this.status,
  });

  final bool peerActive;
  final List<ThreadRecord> threads;
  final int selectedThreadIndex;
  final String status;

  int get activeSessions => peerActive ? 2 : 1;

  ThreadRecord? get selectedThread {
    if (selectedThreadIndex < 0 || selectedThreadIndex >= threads.length) {
      return null;
    }
    return threads[selectedThreadIndex];
  }
}

abstract class CollaborationContextContract {
  CollaborationContextState get state;
  CollaborationContextState togglePeerPresence();
  CollaborationContextState createThread(String title);
  CollaborationContextState selectThread(int index);
  CollaborationContextState resolveSelectedThread();
}

class InMemoryCollaborationContextContract
    implements CollaborationContextContract {
  final List<ThreadRecord> _threads = <ThreadRecord>[];
  int _nextThreadNumber = 1;
  int _selectedThreadIndex = -1;
  bool _peerActive = false;
  String _status = 'Idle';

  @override
  CollaborationContextState get state => CollaborationContextState(
    peerActive: _peerActive,
    threads: List<ThreadRecord>.unmodifiable(_threads),
    selectedThreadIndex: _selectedThreadIndex,
    status: _status,
  );

  @override
  CollaborationContextState togglePeerPresence() {
    _peerActive = !_peerActive;
    _status = _peerActive
        ? 'Peer connected: reviewer@penjar.app.'
        : 'Peer disconnected: reviewer@penjar.app.';
    return state;
  }

  @override
  CollaborationContextState createThread(String title) {
    final String normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty) {
      _status = 'Thread create failed: title is required.';
      return state;
    }

    final ThreadRecord created = ThreadRecord(
      id: 'thread-${_nextThreadNumber++}',
      title: normalizedTitle,
    );
    _threads.add(created);
    _selectedThreadIndex = _threads.length - 1;
    _status = 'Thread created: ${created.title}.';
    return state;
  }

  @override
  CollaborationContextState selectThread(int index) {
    if (index < 0 || index >= _threads.length) {
      _status = 'Thread select failed: invalid index.';
      return state;
    }
    _selectedThreadIndex = index;
    _status = 'Thread selected: ${_threads[index].title}.';
    return state;
  }

  @override
  CollaborationContextState resolveSelectedThread() {
    final ThreadRecord? thread = state.selectedThread;
    if (thread == null) {
      _status = 'Thread resolve skipped: no thread selected.';
      return state;
    }

    final String resolved = thread.title;
    _threads.removeAt(_selectedThreadIndex);
    if (_threads.isEmpty) {
      _selectedThreadIndex = -1;
    } else if (_selectedThreadIndex >= _threads.length) {
      _selectedThreadIndex = _threads.length - 1;
    }
    _status = 'Thread resolved: $resolved.';
    return state;
  }
}

class InspectHandoffState {
  const InspectHandoffState({
    required this.target,
    required this.snippet,
    required this.status,
  });

  final String target;
  final String snippet;
  final String status;
}

abstract class InspectHandoffContract {
  InspectHandoffState get state;
  InspectHandoffState setTarget(String target);
  InspectHandoffState generateSnippet(String elementId);
  InspectHandoffState copyMetadata(String elementId);
}

class InMemoryInspectHandoffContract implements InspectHandoffContract {
  String _target = 'flutter';
  String _snippet = 'No snippet generated.';
  String _status = 'Idle';

  @override
  InspectHandoffState get state =>
      InspectHandoffState(target: _target, snippet: _snippet, status: _status);

  @override
  InspectHandoffState setTarget(String target) {
    _target = target;
    return state;
  }

  @override
  InspectHandoffState generateSnippet(String elementId) {
    final String normalizedId = elementId.trim();
    if (normalizedId.isEmpty) {
      _status = 'Snippet generation failed: element id is required.';
      return state;
    }

    _snippet = switch (_target) {
      'css' => '.button-primary { border-radius: 8px; padding: 12px 16px; }',
      'swiftui' =>
        'Text("Primary")\n  .padding(.horizontal, 16)\n  .padding(.vertical, 12)',
      _ =>
        'Container(\n  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),\n  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),\n)',
    };
    _status = 'Snippet generated for $normalizedId ($_target).';
    return state;
  }

  @override
  InspectHandoffState copyMetadata(String elementId) {
    final String normalizedId = elementId.trim();
    if (normalizedId.isEmpty) {
      _status = 'Metadata copy failed: element id is required.';
      return state;
    }
    _status = 'Metadata copied (simulated) for $normalizedId.';
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
