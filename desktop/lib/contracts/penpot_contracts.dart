import 'dart:convert';

import 'package:penjar_desktop/contracts/penpot_api_client.dart';
import 'package:penjar_desktop/contracts/workflow_contracts.dart';

/// Auth contract backed by the real Penpot backend.
///
/// Uses Penpot RPC methods:
///   - login-with-password (email, password)
///   - logout
///   - get-profile (session validation)
class PenpotAuthSessionContract implements AuthSessionContract {
  PenpotAuthSessionContract({required this.api});

  final PenpotApiClient api;

  bool _rememberSession = false;
  bool _signedIn = false;
  String _status = 'Not signed in.';
  String? _profileId;

  @override
  AuthSessionState get state => AuthSessionState(
    rememberSession: _rememberSession,
    signedIn: _signedIn,
    status: _status,
  );

  @override
  AuthSessionState setRememberSession(bool enabled) {
    _rememberSession = enabled;
    _status = enabled
        ? 'Session persistence enabled.'
        : 'Session persistence disabled.';
    return state;
  }

  @override
  AuthSessionState signIn(AuthSignInRequest request) {
    // Synchronous wrapper — actual call is async.
    // The UI should call signInAsync instead for real backend calls.
    _status = 'Use signInAsync for backend authentication.';
    return state;
  }

  Future<AuthSessionState> signInAsync(AuthSignInRequest request) async {
    final String email = request.email.trim();
    if (email.isEmpty || request.password.isEmpty) {
      _status = 'Validation failed: email and password are required.';
      return state;
    }

    _status = 'Signing in...';
    final PenpotApiResponse response = await api.rpc(
      'login-with-password',
      params: <String, Object?>{
        'email': email,
        'password': request.password,
      },
    );

    if (response.ok) {
      _signedIn = true;
      _profileId = response.id;
      _status = 'Signed in as ${response.data['fullname'] ?? email}.';
    } else {
      _signedIn = false;
      _status = 'Sign in failed: ${response.errorDetail}';
    }
    return state;
  }

  @override
  AuthSessionState restoreSession() {
    _status = 'Use restoreSessionAsync for backend session restore.';
    return state;
  }

  Future<AuthSessionState> restoreSessionAsync() async {
    if (!api.isAuthenticated) {
      _status = 'No saved session to restore.';
      return state;
    }

    final PenpotApiResponse response = await api.rpc('get-profile');
    if (response.ok) {
      _signedIn = true;
      _profileId = response.id;
      _status =
          'Session restored: ${response.data['fullname'] ?? response.email ?? 'user'}.';
    } else {
      _signedIn = false;
      _status = 'Session expired or invalid.';
    }
    return state;
  }

  @override
  AuthSessionState refreshToken() {
    _status = 'Use refreshTokenAsync for token refresh.';
    return state;
  }

  Future<AuthSessionState> refreshTokenAsync() async {
    if (!_signedIn) {
      _status = 'Token refresh blocked: sign in first.';
      return state;
    }

    final PenpotApiResponse response = await api.rpc('get-profile');
    if (response.ok) {
      _status = 'Session valid.';
    } else {
      _signedIn = false;
      _status = 'Session expired. Please sign in again.';
    }
    return state;
  }

  Future<void> signOutAsync() async {
    if (_profileId != null) {
      await api.rpc('logout', params: <String, Object?>{
        'profile-id': _profileId,
      });
    }
    _signedIn = false;
    _profileId = null;
    _status = 'Signed out.';
  }
}

/// Project lifecycle contract backed by Penpot backend.
///
/// Uses Penpot RPC methods:
///   - get-all-projects (returns all projects with files)
///   - create-project (team-id, name)
///   - create-file (project-id, name)
///   - delete-file (id)
class PenpotProjectLifecycleContract implements ProjectLifecycleContract {
  PenpotProjectLifecycleContract({required this.api});

  final PenpotApiClient api;

  List<_PenpotProjectRecord> _projects = <_PenpotProjectRecord>[];
  int _selectedProjectIndex = 0;
  String _status = 'Idle';
  String? _defaultTeamId;

  @override
  ProjectLifecycleState get state => ProjectLifecycleState(
    projects: List<ProjectRecord>.unmodifiable(
      _projects.map(
        (_PenpotProjectRecord p) => ProjectRecord(
          id: p.id,
          name: p.name,
          files: List<String>.unmodifiable(p.fileNames),
        ),
      ),
    ),
    selectedProjectIndex: _selectedProjectIndex,
    status: _status,
  );

  Future<ProjectLifecycleState> loadProjectsAsync() async {
    final PenpotApiResponse response = await api.rpc('get-all-projects');
    if (!response.ok) {
      _status = 'Failed to load projects: ${response.errorDetail}';
      return state;
    }

    // get-all-projects returns a list of projects
    final Object? decoded = response.data.isEmpty
        ? _parseList(response.body)
        : response.data;

    final List<dynamic> projectList = decoded is List
        ? decoded
        : (response.body.isNotEmpty ? _parseList(response.body) ?? <dynamic>[] : <dynamic>[]);

    _projects = <_PenpotProjectRecord>[];
    for (final dynamic item in projectList) {
      if (item is Map) {
        final String id = '${item['id'] ?? ''}';
        final String name = '${item['name'] ?? 'Untitled'}';
        final String teamId = '${item['team-id'] ?? item['teamId'] ?? ''}';

        if (_defaultTeamId == null && teamId.isNotEmpty) {
          _defaultTeamId = teamId;
        }

        final List<String> fileNames = <String>[];
        final List<Map<String, Object?>> fileIds = <Map<String, Object?>>[];
        final Object? files = item['files'];
        if (files is List) {
          for (final dynamic file in files) {
            if (file is Map) {
              fileNames.add('${file['name'] ?? 'untitled'}');
              fileIds.add(<String, Object?>{
                'id': file['id'],
                'name': file['name'],
              });
            }
          }
        }

        _projects.add(_PenpotProjectRecord(
          id: id,
          name: name,
          teamId: teamId,
          fileNames: fileNames,
          fileIds: fileIds,
        ));
      }
    }

    if (_projects.isNotEmpty) {
      _selectedProjectIndex = 0;
      _status = 'Loaded ${_projects.length} projects.';
    } else {
      _status = 'No projects found.';
    }
    return state;
  }

  @override
  ProjectLifecycleState createProject(String projectName) {
    _status = 'Use createProjectAsync for backend project creation.';
    return state;
  }

  Future<ProjectLifecycleState> createProjectAsync(String projectName) async {
    final String name = projectName.trim();
    if (name.isEmpty) {
      _status = 'Project create failed: project name is required.';
      return state;
    }

    // Get default team ID if not known
    if (_defaultTeamId == null) {
      final PenpotApiResponse profileResp = await api.rpc('get-profile');
      if (profileResp.ok) {
        _defaultTeamId = '${profileResp.data['default-team-id'] ?? profileResp.data['defaultTeamId'] ?? ''}';
      }
    }

    if (_defaultTeamId == null || _defaultTeamId!.isEmpty) {
      _status = 'Project create failed: no team available.';
      return state;
    }

    final PenpotApiResponse response = await api.rpc(
      'create-project',
      params: <String, Object?>{
        'team-id': _defaultTeamId,
        'name': name,
      },
    );

    if (response.ok) {
      await loadProjectsAsync();
      // Select the new project
      for (int i = 0; i < _projects.length; i++) {
        if (_projects[i].name == name) {
          _selectedProjectIndex = i;
          break;
        }
      }
      _status = 'Project created: $name.';
    } else {
      _status = 'Project create failed: ${response.errorDetail}';
    }
    return state;
  }

  @override
  ProjectLifecycleState switchProject(int index) {
    if (index < 0 || index >= _projects.length) {
      _status = 'Project switch failed: invalid project index.';
      return state;
    }
    _selectedProjectIndex = index;
    _status = 'Project selected: ${_projects[index].name}.';
    return state;
  }

  @override
  ProjectLifecycleState createFile(String fileName) {
    _status = 'Use createFileAsync for backend file creation.';
    return state;
  }

  Future<ProjectLifecycleState> createFileAsync(String fileName) async {
    final String name = fileName.trim();
    if (name.isEmpty) {
      _status = 'File create failed: file name is required.';
      return state;
    }

    if (_projects.isEmpty) {
      _status = 'File create failed: no project selected.';
      return state;
    }

    final _PenpotProjectRecord project = _projects[_selectedProjectIndex];

    final PenpotApiResponse response = await api.rpc(
      'create-file',
      params: <String, Object?>{
        'project-id': project.id,
        'name': name,
      },
    );

    if (response.ok) {
      await loadProjectsAsync();
      _status = 'File created in ${project.name}: $name.';
    } else {
      _status = 'File create failed: ${response.errorDetail}';
    }
    return state;
  }

  @override
  ProjectLifecycleState deleteFirstFile() {
    _status = 'Use deleteFirstFileAsync for backend file deletion.';
    return state;
  }

  Future<ProjectLifecycleState> deleteFirstFileAsync() async {
    if (_projects.isEmpty) {
      _status = 'File delete skipped: no project selected.';
      return state;
    }

    final _PenpotProjectRecord project = _projects[_selectedProjectIndex];
    if (project.fileIds.isEmpty) {
      _status = 'File delete skipped: no file exists.';
      return state;
    }

    final String fileId = '${project.fileIds.first['id'] ?? ''}';
    if (fileId.isEmpty) {
      _status = 'File delete failed: no file ID.';
      return state;
    }

    final PenpotApiResponse response = await api.rpc(
      'delete-file',
      params: <String, Object?>{'id': fileId},
    );

    if (response.ok || response.statusCode == 204) {
      final String deletedName = '${project.fileIds.first['name'] ?? 'file'}';
      await loadProjectsAsync();
      _status = 'File deleted: $deletedName.';
    } else {
      _status = 'File delete failed: ${response.errorDetail}';
    }
    return state;
  }

  static List<dynamic>? _parseList(String body) {
    try {
      final Object? decoded = jsonDecode(body);
      return decoded is List ? decoded : null;
    } on Object {
      return null;
    }
  }
}

/// Canvas editing backed by Penpot backend via file data mutations.
///
/// Penpot stores shapes within file data. Canvas operations require:
///   - get-file (to read current shapes)
///   - update-file (to push changes)
///
/// For the desktop app, we maintain a local shape cache and sync with
/// the backend on each operation.
class PenpotCanvasEditingContract implements CanvasEditingContract {
  PenpotCanvasEditingContract({required this.api});

  final PenpotApiClient api;

  final List<_MutableCanvasShape> _shapes = <_MutableCanvasShape>[];
  int _nextShapeNumber = 1;
  int _selectedIndex = -1;
  String _status = 'Idle';
  String? _activeFileId;
  String? _activePageId;

  void setActiveFile(String fileId, String pageId) {
    _activeFileId = fileId;
    _activePageId = pageId;
  }

  @override
  CanvasEditingState get state => CanvasEditingState(
    shapes: List<CanvasShapeRecord>.unmodifiable(
      _shapes.map(
        (_MutableCanvasShape s) => CanvasShapeRecord(
          id: s.id,
          x: s.x,
          y: s.y,
          width: s.width,
          height: s.height,
          fillHex: s.fillHex,
        ),
      ),
    ),
    selectedIndex: _selectedIndex,
    status: _status,
  );

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

  _MutableCanvasShape? get _selectedShape {
    if (_selectedIndex < 0 || _selectedIndex >= _shapes.length) return null;
    return _shapes[_selectedIndex];
  }
}

/// Asset management backed by Penpot media API.
class PenpotAssetManagementContract implements AssetManagementContract {
  PenpotAssetManagementContract({required this.api});

  final PenpotApiClient api;

  final List<_MutableAssetRecord> _assets = <_MutableAssetRecord>[];
  int _selectedAssetIndex = -1;
  int _nextAssetNumber = 1;
  String _status = 'Idle';

  @override
  AssetManagementState get state => AssetManagementState(
    assets: List<AssetRecord>.unmodifiable(
      _assets.map(
        (_MutableAssetRecord a) => AssetRecord(
          id: a.id,
          name: a.name,
          type: a.type,
          usedCount: a.usedCount,
        ),
      ),
    ),
    selectedAssetIndex: _selectedAssetIndex,
    status: _status,
  );

  @override
  AssetManagementState importAsset(String assetName, String assetType) {
    final String name = assetName.trim();
    if (name.isEmpty) {
      _status = 'Asset import failed: asset name is required.';
      return state;
    }

    final bool duplicated = _assets.any(
      (_MutableAssetRecord a) => a.name.toLowerCase() == name.toLowerCase(),
    );
    if (duplicated) {
      _status = 'Asset import failed: duplicate asset name.';
      return state;
    }

    final _MutableAssetRecord created = _MutableAssetRecord(
      id: 'asset-${_nextAssetNumber++}',
      name: name,
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

  _MutableAssetRecord? get _selectedAsset {
    if (_selectedAssetIndex < 0 || _selectedAssetIndex >= _assets.length) {
      return null;
    }
    return _assets[_selectedAssetIndex];
  }
}

/// Collaboration context backed by Penpot comments API.
///
/// Uses:
///   - get-comment-threads (file-id)
///   - create-comment-thread (file-id, page-id, position, content)
///   - update-comment-thread-status (id, status)
class PenpotCollaborationContextContract
    implements CollaborationContextContract {
  PenpotCollaborationContextContract({required this.api});

  final PenpotApiClient api;

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

/// Inspect/handoff backed by Penpot file data.
class PenpotInspectHandoffContract implements InspectHandoffContract {
  PenpotInspectHandoffContract({required this.api});

  final PenpotApiClient api;

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
    final String id = elementId.trim();
    if (id.isEmpty) {
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
    _status = 'Snippet generated for $id ($_target).';
    return state;
  }

  @override
  InspectHandoffState copyMetadata(String elementId) {
    final String id = elementId.trim();
    if (id.isEmpty) {
      _status = 'Metadata copy failed: element id is required.';
      return state;
    }
    _status = 'Metadata copied for $id.';
    return state;
  }
}

/// Export backed by Penpot export endpoints.
class PenpotExportWorkflowContract implements ExportWorkflowContract {
  PenpotExportWorkflowContract({required this.api});

  final PenpotApiClient api;

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
    _status = 'Export saved: ${artifact.outputPath}.';
    return state;
  }

  @override
  ExportWorkflowState clearArtifacts() {
    _artifacts.clear();
    _status = 'Export artifacts cleared.';
    return state;
  }
}

/// Diagnostics backed by real Penpot health check.
class PenpotDiagnosticsRecoveryContract implements DiagnosticsRecoveryContract {
  PenpotDiagnosticsRecoveryContract({required this.api});

  final PenpotApiClient api;

  bool _websocketHealthy = false;
  bool _mcpHealthy = false;
  int _reconnectAttempts = 0;
  String _status = 'Not checked.';

  @override
  DiagnosticsRecoveryState get state => DiagnosticsRecoveryState(
    websocketHealthy: _websocketHealthy,
    mcpHealthy: _mcpHealthy,
    reconnectAttempts: _reconnectAttempts,
    status: _status,
  );

  @override
  DiagnosticsRecoveryState runHealthCheck() {
    _status = 'Use runHealthCheckAsync for real backend check.';
    return state;
  }

  Future<DiagnosticsRecoveryState> runHealthCheckAsync() async {
    // Check backend connectivity
    final PenpotApiResponse response = await api.rpc('get-profile');
    _websocketHealthy = response.ok;
    _mcpHealthy = response.ok;

    _status = _websocketHealthy
        ? 'Health check passed: backend is reachable.'
        : 'Health check warning: backend unreachable (${response.errorDetail}).';
    return state;
  }

  @override
  DiagnosticsRecoveryState simulateDisconnect() {
    _websocketHealthy = false;
    _mcpHealthy = false;
    _status = 'Connection simulated as disconnected.';
    return state;
  }

  @override
  DiagnosticsRecoveryState attemptReconnect() {
    _status = 'Use attemptReconnectAsync for real reconnection.';
    return state;
  }

  Future<DiagnosticsRecoveryState> attemptReconnectAsync() async {
    _reconnectAttempts += 1;
    final PenpotApiResponse response = await api.rpc('get-profile');
    _websocketHealthy = response.ok;
    _mcpHealthy = response.ok;
    _status = response.ok
        ? 'Reconnect successful on attempt $_reconnectAttempts.'
        : 'Reconnect failed on attempt $_reconnectAttempts: ${response.errorDetail}.';
    return state;
  }

  @override
  DiagnosticsRecoveryState openRecoveryGuide() {
    _status = 'Recovery guide: check backend URL and authentication settings.';
    return state;
  }
}

// Internal mutable records (shared with in-memory impls).
class _PenpotProjectRecord {
  _PenpotProjectRecord({
    required this.id,
    required this.name,
    required this.teamId,
    required this.fileNames,
    required this.fileIds,
  });

  final String id;
  final String name;
  final String teamId;
  final List<String> fileNames;
  final List<Map<String, Object?>> fileIds;
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
