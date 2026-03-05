import 'package:flutter/material.dart';
import 'package:penjar_desktop/contracts/workflow_contracts.dart';

void main() {
  runApp(const PenjarDesktopApp());
}

class PenjarDesktopApp extends StatelessWidget {
  const PenjarDesktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Penjar Desktop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007A61),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const DesktopShellPage(),
    );
  }
}

class WorkflowSection {
  const WorkflowSection({
    required this.id,
    required this.label,
    required this.description,
    required this.owner,
    required this.status,
    required this.icon,
  });

  final String id;
  final String label;
  final String description;
  final String owner;
  final String status;
  final IconData icon;
}

const List<WorkflowSection> kSections = <WorkflowSection>[
  WorkflowSection(
    id: 'shell',
    label: 'Desktop Shell Runtime',
    description:
        'Flutter desktop workspace bootstrap is complete. Shell migration is now in progress and routing/state integration is the next target.',
    owner: 'Desktop Flutter Program',
    status: 'In progress',
    icon: Icons.desktop_windows_outlined,
  ),
  WorkflowSection(
    id: 'auth',
    label: 'Authentication & Session',
    description:
        'Auth/session Flutter surface baseline is in progress with sign-in, restore, and token refresh interaction scaffolding.',
    owner: 'Auth + Desktop Integration',
    status: 'In progress',
    icon: Icons.lock_outline,
  ),
  WorkflowSection(
    id: 'project',
    label: 'Project & File Lifecycle',
    description:
        'Project/file Flutter surface baseline is in progress with local lifecycle interaction scaffolding.',
    owner: 'Workspace Navigation',
    status: 'In progress',
    icon: Icons.folder_open_outlined,
  ),
  WorkflowSection(
    id: 'canvas',
    label: 'Canvas Editing',
    description: 'Canvas editing Flutter surface baseline is in progress.',
    owner: 'Workspace Core',
    status: 'In progress',
    icon: Icons.draw_outlined,
  ),
  WorkflowSection(
    id: 'assets',
    label: 'Asset Management',
    description:
        'Asset management Flutter surface baseline is in progress with import/select/use/remove interaction scaffolding.',
    owner: 'Workspace Core',
    status: 'In progress',
    icon: Icons.photo_library_outlined,
  ),
  WorkflowSection(
    id: 'collaboration',
    label: 'Collaboration Context',
    description:
        'Collaboration Flutter surface baseline is in progress with presence and thread lifecycle interaction scaffolding.',
    owner: 'Collaboration + Realtime',
    status: 'In progress',
    icon: Icons.group_outlined,
  ),
  WorkflowSection(
    id: 'inspect',
    label: 'Inspect & Code Handoff',
    description:
        'Inspect/code handoff Flutter surface baseline is in progress with metadata/code-snippet scaffolding.',
    owner: 'Inspect/Handoff',
    status: 'In progress',
    icon: Icons.analytics_outlined,
  ),
  WorkflowSection(
    id: 'export',
    label: 'Export Workflows',
    description:
        'Export workflow Flutter surface baseline is in progress with format/options/save interaction scaffolding.',
    owner: 'Export Pipeline',
    status: 'In progress',
    icon: Icons.ios_share_outlined,
  ),
  WorkflowSection(
    id: 'diagnostics',
    label: 'Diagnostics & Recovery',
    description:
        'Diagnostics/recovery Flutter surface baseline is in progress with health/reconnect/remediation interaction scaffolding.',
    owner: 'Platform Reliability',
    status: 'In progress',
    icon: Icons.health_and_safety_outlined,
  ),
];

class DesktopShellPage extends StatefulWidget {
  const DesktopShellPage({super.key});

  @override
  State<DesktopShellPage> createState() => _DesktopShellPageState();
}

class _DesktopShellPageState extends State<DesktopShellPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final WorkflowSection section = kSections[_selectedIndex];
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Penjar Desktop')),
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            scrollable: true,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: kSections
                .map(
                  (WorkflowSection item) => NavigationRailDestination(
                    icon: Icon(item.icon),
                    label: Text(
                      item.label,
                      key: ValueKey<String>('nav-${item.id}'),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 0,
                color: colorScheme.surfaceContainerLow,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                section.label,
                                key: const ValueKey<String>('section-title'),
                                style: textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: <Widget>[
                                  Chip(
                                    label: Text('Status: ${section.status}'),
                                  ),
                                  Chip(label: Text('Owner: ${section.owner}')),
                                ],
                              ),
                              const SizedBox(height: 20),
                              if (section.id == 'auth')
                                const AuthSessionPanel()
                              else if (section.id == 'project')
                                const ProjectLifecyclePanel()
                              else if (section.id == 'canvas')
                                const CanvasEditingPanel()
                              else if (section.id == 'assets')
                                const AssetManagementPanel()
                              else if (section.id == 'collaboration')
                                const CollaborationContextPanel()
                              else if (section.id == 'inspect')
                                const InspectHandoffPanel()
                              else if (section.id == 'export')
                                const ExportWorkflowPanel()
                              else if (section.id == 'diagnostics')
                                const DiagnosticsRecoveryPanel()
                              else
                                Text(
                                  section.description,
                                  key: const ValueKey<String>(
                                    'section-description',
                                  ),
                                  style: textTheme.bodyLarge,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthSessionPanel extends StatefulWidget {
  const AuthSessionPanel({super.key});

  @override
  State<AuthSessionPanel> createState() => _AuthSessionPanelState();
}

class _AuthSessionPanelState extends State<AuthSessionPanel> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberSession = false;
  bool _signedIn = false;
  String _status = 'Idle';

  @override
  void initState() {
    super.initState();
    _emailController.text = 'designer@penjar.app';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _setStatus(String status) {
    setState(() {
      _status = status;
    });
  }

  void _signIn() {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _setStatus('Validation failed: email and password are required.');
      return;
    }

    setState(() {
      _signedIn = true;
      _status = 'Signed in (simulated).';
    });
  }

  void _restoreSession() {
    if (!_rememberSession) {
      _setStatus('Session restore blocked: enable Remember Session first.');
      return;
    }
    _setStatus('Session restored (simulated).');
  }

  void _refreshToken() {
    if (!_signedIn) {
      _setStatus('Token refresh blocked: sign in first.');
      return;
    }
    _setStatus('Token refreshed (simulated).');
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      key: const ValueKey<String>('auth-session-panel'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Auth/session parity scaffold for Flutter desktop.',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        TextField(
          key: const ValueKey<String>('auth-email'),
          controller: _emailController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Email',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          key: const ValueKey<String>('auth-password'),
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Password',
          ),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          key: const ValueKey<String>('auth-remember'),
          title: const Text('Remember Session'),
          value: _rememberSession,
          contentPadding: EdgeInsets.zero,
          onChanged: (bool? value) {
            setState(() {
              _rememberSession = value ?? false;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            FilledButton(
              key: const ValueKey<String>('auth-sign-in'),
              onPressed: _signIn,
              child: const Text('Sign In'),
            ),
            OutlinedButton(
              key: const ValueKey<String>('auth-restore-session'),
              onPressed: _restoreSession,
              child: const Text('Restore Session'),
            ),
            OutlinedButton(
              key: const ValueKey<String>('auth-refresh-token'),
              onPressed: _refreshToken,
              child: const Text('Refresh Token'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Status: $_status',
          key: const ValueKey<String>('auth-status'),
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _ProjectRecord {
  _ProjectRecord({required this.id, required this.name, required this.files});

  final String id;
  String name;
  final List<String> files;
}

class ProjectLifecyclePanel extends StatefulWidget {
  const ProjectLifecyclePanel({super.key});

  @override
  State<ProjectLifecyclePanel> createState() => _ProjectLifecyclePanelState();
}

class _ProjectLifecyclePanelState extends State<ProjectLifecyclePanel> {
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _fileNameController = TextEditingController();
  final List<_ProjectRecord> _projects = <_ProjectRecord>[
    _ProjectRecord(
      id: 'project-core',
      name: 'Core Product',
      files: <String>['landing.penjar'],
    ),
  ];
  int _selectedProjectIndex = 0;
  String _status = 'Idle';
  int _nextProjectNumber = 1;

  @override
  void dispose() {
    _projectNameController.dispose();
    _fileNameController.dispose();
    super.dispose();
  }

  _ProjectRecord get _selectedProject => _projects[_selectedProjectIndex];

  void _setStatus(String status) {
    setState(() {
      _status = status;
    });
  }

  void _createProject() {
    final String projectName = _projectNameController.text.trim();
    if (projectName.isEmpty) {
      _setStatus('Project create failed: project name is required.');
      return;
    }

    setState(() {
      final _ProjectRecord created = _ProjectRecord(
        id: 'project-${_nextProjectNumber++}',
        name: projectName,
        files: <String>[],
      );
      _projects.add(created);
      _selectedProjectIndex = _projects.length - 1;
      _projectNameController.clear();
      _status = 'Project created: ${created.name}.';
    });
  }

  void _switchProject(int index) {
    setState(() {
      _selectedProjectIndex = index;
      _status = 'Project selected: ${_selectedProject.name}.';
    });
  }

  void _createFile() {
    final String fileName = _fileNameController.text.trim();
    if (fileName.isEmpty) {
      _setStatus('File create failed: file name is required.');
      return;
    }

    setState(() {
      _selectedProject.files.add(fileName);
      _fileNameController.clear();
      _status = 'File created in ${_selectedProject.name}: $fileName.';
    });
  }

  void _deleteFirstFile() {
    if (_selectedProject.files.isEmpty) {
      _setStatus('File delete skipped: no file exists.');
      return;
    }

    setState(() {
      final String removed = _selectedProject.files.removeAt(0);
      _status = 'File deleted from ${_selectedProject.name}: $removed.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      key: const ValueKey<String>('project-file-panel'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Project/file lifecycle parity scaffold for Flutter desktop.',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        Text(
          'Projects: ${_projects.length} · Files in selected: ${_selectedProject.files.length}',
          key: const ValueKey<String>('project-summary'),
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        TextField(
          key: const ValueKey<String>('project-name-input'),
          controller: _projectNameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'New Project Name',
          ),
        ),
        const SizedBox(height: 8),
        FilledButton(
          key: const ValueKey<String>('project-create'),
          onPressed: _createProject,
          child: const Text('Create Project'),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List<Widget>.generate(_projects.length, (int index) {
            final _ProjectRecord project = _projects[index];
            final bool selected = index == _selectedProjectIndex;
            return ChoiceChip(
              key: ValueKey<String>('project-chip-${project.id}'),
              label: Text(project.name),
              selected: selected,
              onSelected: (_) => _switchProject(index),
            );
          }),
        ),
        const SizedBox(height: 16),
        TextField(
          key: const ValueKey<String>('file-name-input'),
          controller: _fileNameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'New File Name',
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            OutlinedButton(
              key: const ValueKey<String>('file-create'),
              onPressed: _createFile,
              child: const Text('Create File'),
            ),
            OutlinedButton(
              key: const ValueKey<String>('file-delete-first'),
              onPressed: _deleteFirstFile,
              child: const Text('Delete First File'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_selectedProject.files.isEmpty)
          Text(
            'No files in ${_selectedProject.name}.',
            key: const ValueKey<String>('file-empty'),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _selectedProject.files
                .map(
                  (String file) => Text(
                    file,
                    key: ValueKey<String>(
                      'file-item-${_selectedProject.id}-$file',
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        const SizedBox(height: 16),
        Text(
          'Status: $_status',
          key: const ValueKey<String>('project-status'),
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _CanvasShape {
  _CanvasShape({
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

class CanvasEditingPanel extends StatefulWidget {
  const CanvasEditingPanel({super.key});

  @override
  State<CanvasEditingPanel> createState() => _CanvasEditingPanelState();
}

class _CanvasEditingPanelState extends State<CanvasEditingPanel> {
  final List<_CanvasShape> _shapes = <_CanvasShape>[];
  int _nextShapeNumber = 1;
  int _selectedIndex = -1;
  String _status = 'Idle';

  _CanvasShape? get _selectedShape {
    if (_selectedIndex < 0 || _selectedIndex >= _shapes.length) {
      return null;
    }
    return _shapes[_selectedIndex];
  }

  void _setStatus(String status) {
    setState(() {
      _status = status;
    });
  }

  void _createRectangle() {
    setState(() {
      final _CanvasShape shape = _CanvasShape(
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
    });
  }

  void _moveSelected() {
    final _CanvasShape? shape = _selectedShape;
    if (shape == null) {
      _setStatus('Move skipped: no shape selected.');
      return;
    }
    setState(() {
      shape.x += 10;
      shape.y += 5;
      _status =
          'Moved ${shape.id} to (${shape.x.toInt()}, ${shape.y.toInt()}).';
    });
  }

  void _resizeSelected() {
    final _CanvasShape? shape = _selectedShape;
    if (shape == null) {
      _setStatus('Resize skipped: no shape selected.');
      return;
    }
    setState(() {
      shape.width += 20;
      shape.height += 20;
      _status =
          'Resized ${shape.id} to ${shape.width.toInt()}x${shape.height.toInt()}.';
    });
  }

  void _toggleFillSelected() {
    final _CanvasShape? shape = _selectedShape;
    if (shape == null) {
      _setStatus('Fill toggle skipped: no shape selected.');
      return;
    }
    setState(() {
      shape.fillHex = shape.fillHex == '#007A61' ? '#FF8A00' : '#007A61';
      _status = 'Fill updated for ${shape.id}: ${shape.fillHex}.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final _CanvasShape? shape = _selectedShape;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      key: const ValueKey<String>('canvas-panel'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Canvas editing parity scaffold for Flutter desktop.',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        FilledButton(
          key: const ValueKey<String>('canvas-create-rect'),
          onPressed: _createRectangle,
          child: const Text('Create Rectangle'),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List<Widget>.generate(_shapes.length, (int index) {
            final _CanvasShape item = _shapes[index];
            final bool selected = index == _selectedIndex;
            return ChoiceChip(
              key: ValueKey<String>('canvas-shape-${item.id}'),
              label: Text(item.id),
              selected: selected,
              onSelected: (_) {
                setState(() {
                  _selectedIndex = index;
                  _status = 'Shape selected: ${item.id}.';
                });
              },
            );
          }),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            OutlinedButton(
              key: const ValueKey<String>('canvas-move'),
              onPressed: _moveSelected,
              child: const Text('Move (+10,+5)'),
            ),
            OutlinedButton(
              key: const ValueKey<String>('canvas-resize'),
              onPressed: _resizeSelected,
              child: const Text('Resize (+20,+20)'),
            ),
            OutlinedButton(
              key: const ValueKey<String>('canvas-toggle-fill'),
              onPressed: _toggleFillSelected,
              child: const Text('Toggle Fill'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (shape == null)
          const Text(
            'No shape selected.',
            key: ValueKey<String>('canvas-shape-empty'),
          )
        else
          Text(
            'Selected ${shape.id}: x=${shape.x.toInt()}, y=${shape.y.toInt()}, w=${shape.width.toInt()}, h=${shape.height.toInt()}, fill=${shape.fillHex}',
            key: const ValueKey<String>('canvas-shape-metrics'),
          ),
        const SizedBox(height: 16),
        Text(
          'Status: $_status',
          key: const ValueKey<String>('canvas-status'),
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _AssetRecord {
  _AssetRecord({required this.id, required this.name, required this.type});

  final String id;
  final String name;
  final String type;
  int usedCount = 0;
}

class AssetManagementPanel extends StatefulWidget {
  const AssetManagementPanel({super.key});

  @override
  State<AssetManagementPanel> createState() => _AssetManagementPanelState();
}

class _AssetManagementPanelState extends State<AssetManagementPanel> {
  final TextEditingController _assetNameController = TextEditingController();
  final List<_AssetRecord> _assets = <_AssetRecord>[];
  final List<String> _assetTypes = <String>['image', 'icon', 'vector'];
  int _nextAssetNumber = 1;
  int _selectedAssetIndex = -1;
  String _selectedAssetType = 'image';
  String _status = 'Idle';

  @override
  void dispose() {
    _assetNameController.dispose();
    super.dispose();
  }

  _AssetRecord? get _selectedAsset {
    if (_selectedAssetIndex < 0 || _selectedAssetIndex >= _assets.length) {
      return null;
    }
    return _assets[_selectedAssetIndex];
  }

  void _setStatus(String status) {
    setState(() {
      _status = status;
    });
  }

  void _importAsset() {
    final String name = _assetNameController.text.trim();
    if (name.isEmpty) {
      _setStatus('Asset import failed: asset name is required.');
      return;
    }

    final bool duplicated = _assets.any(
      (_AssetRecord asset) => asset.name.toLowerCase() == name.toLowerCase(),
    );
    if (duplicated) {
      _setStatus('Asset import failed: duplicate asset name.');
      return;
    }

    setState(() {
      final _AssetRecord created = _AssetRecord(
        id: 'asset-${_nextAssetNumber++}',
        name: name,
        type: _selectedAssetType,
      );
      _assets.add(created);
      _selectedAssetIndex = _assets.length - 1;
      _assetNameController.clear();
      _status = 'Asset imported: ${created.name} (${created.type}).';
    });
  }

  void _selectAsset(int index) {
    setState(() {
      _selectedAssetIndex = index;
      _status = 'Asset selected: ${_selectedAsset!.name}.';
    });
  }

  void _useSelectedAsset() {
    final _AssetRecord? asset = _selectedAsset;
    if (asset == null) {
      _setStatus('Asset use skipped: no asset selected.');
      return;
    }

    setState(() {
      asset.usedCount += 1;
      _status = 'Asset used: ${asset.name} (count ${asset.usedCount}).';
    });
  }

  void _removeSelectedAsset() {
    final _AssetRecord? asset = _selectedAsset;
    if (asset == null) {
      _setStatus('Asset remove skipped: no asset selected.');
      return;
    }

    setState(() {
      final String removedName = asset.name;
      _assets.removeAt(_selectedAssetIndex);
      if (_assets.isEmpty) {
        _selectedAssetIndex = -1;
      } else if (_selectedAssetIndex >= _assets.length) {
        _selectedAssetIndex = _assets.length - 1;
      }
      _status = 'Asset removed: $removedName.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final _AssetRecord? asset = _selectedAsset;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      key: const ValueKey<String>('asset-panel'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Asset management parity scaffold for Flutter desktop.',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        Text(
          'Assets: ${_assets.length}',
          key: const ValueKey<String>('asset-summary'),
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        TextField(
          key: const ValueKey<String>('asset-name-input'),
          controller: _assetNameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Asset Name',
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          key: const ValueKey<String>('asset-type-input'),
          initialValue: _selectedAssetType,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Asset Type',
          ),
          items: _assetTypes
              .map(
                (String type) =>
                    DropdownMenuItem<String>(value: type, child: Text(type)),
              )
              .toList(growable: false),
          onChanged: (String? value) {
            if (value == null) {
              return;
            }
            setState(() {
              _selectedAssetType = value;
            });
          },
        ),
        const SizedBox(height: 8),
        FilledButton(
          key: const ValueKey<String>('asset-import'),
          onPressed: _importAsset,
          child: const Text('Import Asset'),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List<Widget>.generate(_assets.length, (int index) {
            final _AssetRecord item = _assets[index];
            final bool selected = index == _selectedAssetIndex;
            return ChoiceChip(
              key: ValueKey<String>('asset-chip-${item.id}'),
              label: Text(item.name),
              selected: selected,
              onSelected: (_) => _selectAsset(index),
            );
          }),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            OutlinedButton(
              key: const ValueKey<String>('asset-use'),
              onPressed: _useSelectedAsset,
              child: const Text('Use Asset'),
            ),
            OutlinedButton(
              key: const ValueKey<String>('asset-remove'),
              onPressed: _removeSelectedAsset,
              child: const Text('Remove Asset'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (asset == null)
          const Text(
            'No asset selected.',
            key: ValueKey<String>('asset-empty-selection'),
          )
        else
          Text(
            'Selected ${asset.name}: type=${asset.type}, used=${asset.usedCount}',
            key: const ValueKey<String>('asset-metrics'),
          ),
        const SizedBox(height: 16),
        Text(
          'Status: $_status',
          key: const ValueKey<String>('asset-status'),
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _ThreadRecord {
  _ThreadRecord({required this.id, required this.title});

  final String id;
  final String title;
}

class CollaborationContextPanel extends StatefulWidget {
  const CollaborationContextPanel({super.key});

  @override
  State<CollaborationContextPanel> createState() =>
      _CollaborationContextPanelState();
}

class _CollaborationContextPanelState extends State<CollaborationContextPanel> {
  final TextEditingController _threadTitleController = TextEditingController();
  final List<_ThreadRecord> _threads = <_ThreadRecord>[];
  int _nextThreadNumber = 1;
  int _selectedThreadIndex = -1;
  bool _peerActive = false;
  String _status = 'Idle';

  @override
  void dispose() {
    _threadTitleController.dispose();
    super.dispose();
  }

  _ThreadRecord? get _selectedThread {
    if (_selectedThreadIndex < 0 || _selectedThreadIndex >= _threads.length) {
      return null;
    }
    return _threads[_selectedThreadIndex];
  }

  void _setStatus(String status) {
    setState(() {
      _status = status;
    });
  }

  void _togglePeerPresence() {
    setState(() {
      _peerActive = !_peerActive;
      _status = _peerActive
          ? 'Peer connected: reviewer@penjar.app.'
          : 'Peer disconnected: reviewer@penjar.app.';
    });
  }

  void _createThread() {
    final String title = _threadTitleController.text.trim();
    if (title.isEmpty) {
      _setStatus('Thread create failed: title is required.');
      return;
    }

    setState(() {
      final _ThreadRecord created = _ThreadRecord(
        id: 'thread-${_nextThreadNumber++}',
        title: title,
      );
      _threads.add(created);
      _selectedThreadIndex = _threads.length - 1;
      _threadTitleController.clear();
      _status = 'Thread created: ${created.title}.';
    });
  }

  void _selectThread(int index) {
    setState(() {
      _selectedThreadIndex = index;
      _status = 'Thread selected: ${_selectedThread!.title}.';
    });
  }

  void _resolveSelectedThread() {
    final _ThreadRecord? thread = _selectedThread;
    if (thread == null) {
      _setStatus('Thread resolve skipped: no thread selected.');
      return;
    }

    setState(() {
      final String resolved = thread.title;
      _threads.removeAt(_selectedThreadIndex);
      if (_threads.isEmpty) {
        _selectedThreadIndex = -1;
      } else if (_selectedThreadIndex >= _threads.length) {
        _selectedThreadIndex = _threads.length - 1;
      }
      _status = 'Thread resolved: $resolved.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final int activeSessions = _peerActive ? 2 : 1;
    final _ThreadRecord? thread = _selectedThread;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      key: const ValueKey<String>('collaboration-panel'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Collaboration context parity scaffold for Flutter desktop.',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        Text(
          'Active sessions: $activeSessions · Open threads: ${_threads.length}',
          key: const ValueKey<String>('collaboration-summary'),
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          key: const ValueKey<String>('collaboration-toggle-peer'),
          onPressed: _togglePeerPresence,
          child: Text(_peerActive ? 'Disconnect Peer' : 'Connect Peer'),
        ),
        const SizedBox(height: 16),
        TextField(
          key: const ValueKey<String>('thread-title-input'),
          controller: _threadTitleController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Thread Title',
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            FilledButton(
              key: const ValueKey<String>('thread-create'),
              onPressed: _createThread,
              child: const Text('Create Thread'),
            ),
            OutlinedButton(
              key: const ValueKey<String>('thread-resolve'),
              onPressed: _resolveSelectedThread,
              child: const Text('Resolve Selected Thread'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_threads.isEmpty)
          const Text('No open threads.', key: ValueKey<String>('thread-empty'))
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List<Widget>.generate(_threads.length, (int index) {
              final _ThreadRecord item = _threads[index];
              final bool selected = index == _selectedThreadIndex;
              return ChoiceChip(
                key: ValueKey<String>('thread-chip-${item.id}'),
                label: Text(item.title),
                selected: selected,
                onSelected: (_) => _selectThread(index),
              );
            }),
          ),
        const SizedBox(height: 16),
        if (thread != null)
          Text(
            'Selected thread: ${thread.title}',
            key: const ValueKey<String>('thread-selected'),
          ),
        const SizedBox(height: 8),
        Text(
          'Status: $_status',
          key: const ValueKey<String>('collaboration-status'),
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class InspectHandoffPanel extends StatefulWidget {
  const InspectHandoffPanel({super.key});

  @override
  State<InspectHandoffPanel> createState() => _InspectHandoffPanelState();
}

class _InspectHandoffPanelState extends State<InspectHandoffPanel> {
  final TextEditingController _elementIdController = TextEditingController();
  final List<String> _targets = <String>['css', 'flutter', 'swiftui'];
  String _target = 'flutter';
  String _snippet = 'No snippet generated.';
  String _status = 'Idle';

  @override
  void initState() {
    super.initState();
    _elementIdController.text = 'button/primary';
  }

  @override
  void dispose() {
    _elementIdController.dispose();
    super.dispose();
  }

  void _setStatus(String status) {
    setState(() {
      _status = status;
    });
  }

  void _generateSnippet() {
    final String elementId = _elementIdController.text.trim();
    if (elementId.isEmpty) {
      _setStatus('Snippet generation failed: element id is required.');
      return;
    }

    final String snippet = switch (_target) {
      'css' => '.button-primary { border-radius: 8px; padding: 12px 16px; }',
      'swiftui' =>
        'Text("Primary")\n  .padding(.horizontal, 16)\n  .padding(.vertical, 12)',
      _ =>
        'Container(\n  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),\n  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),\n)',
    };

    setState(() {
      _snippet = snippet;
      _status = 'Snippet generated for $elementId ($_target).';
    });
  }

  void _copyMetadata() {
    final String elementId = _elementIdController.text.trim();
    if (elementId.isEmpty) {
      _setStatus('Metadata copy failed: element id is required.');
      return;
    }
    _setStatus('Metadata copied (simulated) for $elementId.');
  }

  @override
  Widget build(BuildContext context) {
    final String elementId = _elementIdController.text.trim();
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      key: const ValueKey<String>('inspect-panel'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Inspect/code handoff parity scaffold for Flutter desktop.',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        TextField(
          key: const ValueKey<String>('inspect-element-id'),
          controller: _elementIdController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Element ID',
          ),
          onChanged: (_) {
            setState(() {});
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          key: const ValueKey<String>('inspect-target'),
          initialValue: _target,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Code Target',
          ),
          items: _targets
              .map(
                (String target) => DropdownMenuItem<String>(
                  value: target,
                  child: Text(target),
                ),
              )
              .toList(growable: false),
          onChanged: (String? value) {
            if (value == null) {
              return;
            }
            setState(() {
              _target = value;
            });
          },
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            FilledButton(
              key: const ValueKey<String>('inspect-generate-snippet'),
              onPressed: _generateSnippet,
              child: const Text('Generate Snippet'),
            ),
            OutlinedButton(
              key: const ValueKey<String>('inspect-copy-metadata'),
              onPressed: _copyMetadata,
              child: const Text('Copy Metadata'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Inspect metadata: id=${elementId.isEmpty ? '<empty>' : elementId}, target=$_target',
          key: const ValueKey<String>('inspect-metadata'),
        ),
        const SizedBox(height: 12),
        Text(_snippet, key: const ValueKey<String>('inspect-snippet')),
        const SizedBox(height: 12),
        Text(
          'Status: $_status',
          key: const ValueKey<String>('inspect-status'),
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class ExportWorkflowPanel extends StatefulWidget {
  const ExportWorkflowPanel({super.key});

  @override
  State<ExportWorkflowPanel> createState() => _ExportWorkflowPanelState();
}

class _ExportWorkflowPanelState extends State<ExportWorkflowPanel> {
  final ExportWorkflowContract _contract = InMemoryExportWorkflowContract();
  final TextEditingController _fileNameController = TextEditingController();
  final List<String> _formats = <String>['png', 'svg', 'pdf'];
  final List<String> _scales = <String>['1x', '2x', '3x'];
  String _selectedFormat = 'png';
  String _selectedScale = '2x';
  bool _includeBackground = true;

  @override
  void initState() {
    super.initState();
    _fileNameController.text = 'landing';
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  void _runExport() {
    setState(() {
      _contract.runExport(
        ExportRequest(
          fileName: _fileNameController.text,
          format: _selectedFormat,
          scale: _selectedScale,
          includeBackground: _includeBackground,
        ),
      );
    });
  }

  void _saveLatest() {
    setState(() {
      _contract.saveLatest();
    });
  }

  void _clearArtifacts() {
    setState(() {
      _contract.clearArtifacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ExportWorkflowState exportState = _contract.state;
    final ExportArtifact? latest = exportState.latestArtifact;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      key: const ValueKey<String>('export-panel'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Export workflow parity scaffold for Flutter desktop.',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        Text(
          'Artifacts: ${exportState.artifacts.length}',
          key: const ValueKey<String>('export-summary'),
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        TextField(
          key: const ValueKey<String>('export-file-name'),
          controller: _fileNameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Output File Name',
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          key: const ValueKey<String>('export-format'),
          initialValue: _selectedFormat,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Format',
          ),
          items: _formats
              .map(
                (String format) => DropdownMenuItem<String>(
                  value: format,
                  child: Text(format.toUpperCase()),
                ),
              )
              .toList(growable: false),
          onChanged: (String? value) {
            if (value == null) {
              return;
            }
            setState(() {
              _selectedFormat = value;
            });
          },
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          key: const ValueKey<String>('export-scale'),
          initialValue: _selectedScale,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Scale',
          ),
          items: _scales
              .map(
                (String scale) =>
                    DropdownMenuItem<String>(value: scale, child: Text(scale)),
              )
              .toList(growable: false),
          onChanged: (String? value) {
            if (value == null) {
              return;
            }
            setState(() {
              _selectedScale = value;
            });
          },
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          key: const ValueKey<String>('export-background'),
          title: const Text('Include Background'),
          value: _includeBackground,
          contentPadding: EdgeInsets.zero,
          onChanged: (bool? value) {
            setState(() {
              _includeBackground = value ?? true;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            FilledButton(
              key: const ValueKey<String>('export-run'),
              onPressed: _runExport,
              child: const Text('Run Export'),
            ),
            OutlinedButton(
              key: const ValueKey<String>('export-save-latest'),
              onPressed: _saveLatest,
              child: const Text('Save Latest'),
            ),
            OutlinedButton(
              key: const ValueKey<String>('export-clear'),
              onPressed: _clearArtifacts,
              child: const Text('Clear Artifacts'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (latest == null)
          const Text(
            'No export artifact available.',
            key: ValueKey<String>('export-empty'),
          )
        else
          Text(
            'Latest: ${latest.outputPath} · scale=${latest.scale} · background=${latest.includeBackground}',
            key: const ValueKey<String>('export-latest'),
          ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List<Widget>.generate(exportState.artifacts.length, (
            int index,
          ) {
            final ExportArtifact artifact = exportState.artifacts[index];
            return Chip(
              key: ValueKey<String>('export-chip-${artifact.id}'),
              label: Text(artifact.outputPath),
            );
          }),
        ),
        const SizedBox(height: 12),
        Text(
          'Status: ${exportState.status}',
          key: const ValueKey<String>('export-status'),
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class DiagnosticsRecoveryPanel extends StatefulWidget {
  const DiagnosticsRecoveryPanel({super.key});

  @override
  State<DiagnosticsRecoveryPanel> createState() =>
      _DiagnosticsRecoveryPanelState();
}

class _DiagnosticsRecoveryPanelState extends State<DiagnosticsRecoveryPanel> {
  final DiagnosticsRecoveryContract _contract =
      InMemoryDiagnosticsRecoveryContract();

  void _runHealthCheck() {
    setState(() {
      _contract.runHealthCheck();
    });
  }

  void _simulateDrop() {
    setState(() {
      _contract.simulateDisconnect();
    });
  }

  void _attemptReconnect() {
    setState(() {
      _contract.attemptReconnect();
    });
  }

  void _openRecoveryGuide() {
    setState(() {
      _contract.openRecoveryGuide();
    });
  }

  @override
  Widget build(BuildContext context) {
    final DiagnosticsRecoveryState diagnosticsState = _contract.state;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String websocketLabel = diagnosticsState.websocketHealthy
        ? 'up'
        : 'down';
    final String mcpLabel = diagnosticsState.mcpHealthy ? 'up' : 'down';

    return Column(
      key: const ValueKey<String>('diagnostics-panel'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Diagnostics/recovery parity scaffold for Flutter desktop.',
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        Text(
          'WebSocket: $websocketLabel · MCP: $mcpLabel · reconnect attempts: ${diagnosticsState.reconnectAttempts}',
          key: const ValueKey<String>('diagnostics-summary'),
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            FilledButton(
              key: const ValueKey<String>('diagnostics-health-check'),
              onPressed: _runHealthCheck,
              child: const Text('Run Health Check'),
            ),
            OutlinedButton(
              key: const ValueKey<String>('diagnostics-drop-connection'),
              onPressed: _simulateDrop,
              child: const Text('Simulate Disconnect'),
            ),
            OutlinedButton(
              key: const ValueKey<String>('diagnostics-reconnect'),
              onPressed: _attemptReconnect,
              child: const Text('Attempt Reconnect'),
            ),
            OutlinedButton(
              key: const ValueKey<String>('diagnostics-open-guide'),
              onPressed: _openRecoveryGuide,
              child: const Text('Open Recovery Guide'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Status: ${diagnosticsState.status}',
          key: const ValueKey<String>('diagnostics-status'),
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}
