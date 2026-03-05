import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:penjar_desktop/contracts/desktop_contract_bundle.dart';
import 'package:penjar_desktop/contracts/workflow_contracts.dart';

const String kDefaultInitialSectionId = String.fromEnvironment(
  'PENJAR_DESKTOP_INITIAL_SECTION',
);
const String kDesktopLaunchRouteChannelName = 'penjar/desktop/launch_route';

void main(List<String> args) {
  runApp(
    PenjarDesktopApp(
      initialSectionId: resolveInitialSectionId(launchArgs: args),
    ),
  );
}

class PenjarDesktopApp extends StatelessWidget {
  const PenjarDesktopApp({
    super.key,
    this.contracts,
    this.initialSectionId = kDefaultInitialSectionId,
  });

  final DesktopContractBundle? contracts;
  final String initialSectionId;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Penjar Desktop',
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'penjar-desktop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF007A61),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: DesktopShellPage(
        contracts: contracts,
        initialSectionId: initialSectionId,
      ),
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

final Set<String> _knownSectionIds = kSections
    .map((WorkflowSection section) => section.id)
    .toSet();

String resolveInitialSectionId({
  required List<String> launchArgs,
  String envInitialSectionId = kDefaultInitialSectionId,
}) {
  for (final String launchArg in launchArgs) {
    final String? parsedFromArgs = _parseSectionIdFromLaunchArg(launchArg);
    if (parsedFromArgs != null) {
      return parsedFromArgs;
    }
  }
  return _normalizeSectionId(envInitialSectionId) ?? '';
}

String? _parseSectionIdFromLaunchArg(String launchArg) {
  final String normalizedArg = launchArg.trim();
  if (normalizedArg.isEmpty) {
    return null;
  }
  const String sectionPrefix = '--penjar-section=';
  if (normalizedArg.startsWith(sectionPrefix)) {
    return _normalizeSectionId(normalizedArg.substring(sectionPrefix.length));
  }
  const String routePrefix = '--penjar-route=';
  if (normalizedArg.startsWith(routePrefix)) {
    return _parseSectionIdFromRouteExpression(
      normalizedArg.substring(routePrefix.length),
    );
  }
  return _parseSectionIdFromRouteExpression(normalizedArg);
}

String? _parseSectionIdFromRouteExpression(String routeExpression) {
  final String trimmed = routeExpression.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  final String? directSectionId = _normalizeSectionId(trimmed);
  if (directSectionId != null) {
    return directSectionId;
  }

  final Uri? uri = Uri.tryParse(trimmed);
  if (uri == null) {
    return null;
  }

  final String? querySectionId = _normalizeSectionId(
    uri.queryParameters['section'] ?? '',
  );
  if (querySectionId != null) {
    return querySectionId;
  }

  if (uri.host.isNotEmpty) {
    if (uri.host == 'section' && uri.pathSegments.isNotEmpty) {
      final String? hostedSection = _normalizeSectionId(uri.pathSegments.first);
      if (hostedSection != null) {
        return hostedSection;
      }
    }
    final String? hostSection = _normalizeSectionId(uri.host);
    if (hostSection != null) {
      return hostSection;
    }
  }

  return _extractSectionIdFromPath(uri.pathSegments);
}

String? _extractSectionIdFromPath(List<String> pathSegments) {
  if (pathSegments.isEmpty) {
    return null;
  }

  final List<String> normalized = pathSegments
      .map((String item) => item.trim().toLowerCase())
      .where((String item) => item.isNotEmpty)
      .toList(growable: false);
  if (normalized.isEmpty) {
    return null;
  }

  final int sectionKeywordIndex = normalized.indexOf('section');
  if (sectionKeywordIndex >= 0 && sectionKeywordIndex + 1 < normalized.length) {
    final String? sectionFromKeyword = _normalizeSectionId(
      normalized[sectionKeywordIndex + 1],
    );
    if (sectionFromKeyword != null) {
      return sectionFromKeyword;
    }
  }

  for (final String candidate in normalized) {
    final String? parsed = _normalizeSectionId(candidate);
    if (parsed != null) {
      return parsed;
    }
  }

  return null;
}

String? _normalizeSectionId(String rawSectionId) {
  final String normalized = rawSectionId.trim().toLowerCase();
  if (normalized.isEmpty) {
    return null;
  }
  if (!_knownSectionIds.contains(normalized)) {
    return null;
  }
  return normalized;
}

int _sectionIndexFromId(String sectionId) {
  final String normalized = sectionId.trim().toLowerCase();
  if (normalized.isEmpty) {
    return 0;
  }
  final int matchedIndex = kSections.indexWhere(
    (WorkflowSection section) => section.id == normalized,
  );
  return matchedIndex < 0 ? 0 : matchedIndex;
}

class DesktopShellPage extends StatefulWidget {
  const DesktopShellPage({
    super.key,
    this.contracts,
    this.initialSectionId = '',
  });

  final DesktopContractBundle? contracts;
  final String initialSectionId;

  @override
  State<DesktopShellPage> createState() => _DesktopShellPageState();
}

class _DesktopShellPageState extends State<DesktopShellPage>
    with RestorationMixin {
  static const MethodChannel _launchRouteChannel = MethodChannel(
    kDesktopLaunchRouteChannelName,
  );
  late final DesktopContractBundle _contracts =
      widget.contracts ?? DesktopContractBundle.fromEnvironment();
  final RestorableInt _selectedIndex = RestorableInt(0);

  int get _effectiveSelectedIndex {
    if (_selectedIndex.value < 0 || _selectedIndex.value >= kSections.length) {
      return 0;
    }
    return _selectedIndex.value;
  }

  @override
  String get restorationId => 'desktop-shell';

  @override
  void initState() {
    super.initState();
    _initializeLaunchRouteBridge();
  }

  void _initializeLaunchRouteBridge() {
    _launchRouteChannel.setMethodCallHandler(_handleLaunchRouteCall);
    _consumePendingLaunchRoute();
  }

  Future<void> _consumePendingLaunchRoute() async {
    try {
      final String? launchRoute = await _launchRouteChannel
          .invokeMethod<String>('consumeLaunchRoute');
      _applyLaunchRoute(launchRoute);
    } on MissingPluginException {
      // Host launch-route channel is optional in tests/non-native contexts.
    } on PlatformException {
      // Ignore host bridge errors and continue with existing shell state.
    }
  }

  Future<Object?> _handleLaunchRouteCall(MethodCall call) async {
    if (call.method != 'onLaunchRoute') {
      return null;
    }
    final Object? arguments = call.arguments;
    _applyLaunchRoute(arguments is String ? arguments : null);
    return null;
  }

  void _applyLaunchRoute(String? launchRoute) {
    if (!mounted) {
      return;
    }
    final String? sectionId = _parseSectionIdFromRouteExpression(
      launchRoute ?? '',
    );
    if (sectionId == null) {
      return;
    }
    final int nextIndex = _sectionIndexFromId(sectionId);
    if (_selectedIndex.value == nextIndex) {
      return;
    }
    setState(() {
      _selectedIndex.value = nextIndex;
    });
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    final bool hasSerializedSelection =
        bucket?.contains('selected_section_index') ?? false;
    registerForRestoration(_selectedIndex, 'selected_section_index');
    if (!hasSerializedSelection) {
      _selectedIndex.value = _sectionIndexFromId(widget.initialSectionId);
    }
  }

  @override
  void dispose() {
    _launchRouteChannel.setMethodCallHandler(null);
    _selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WorkflowSection section = kSections[_effectiveSelectedIndex];
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Penjar Desktop')),
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _effectiveSelectedIndex,
            scrollable: true,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex.value = index;
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
                                  Chip(
                                    label: Text(
                                      'Contract Mode: ${_contracts.mode.label}',
                                    ),
                                  ),
                                  if (_contracts.mode ==
                                          DesktopContractMode.remoteStub &&
                                      (_contracts.remoteStubProfile?.isEmpty ??
                                              true) ==
                                          false)
                                    Chip(
                                      label: Text(
                                        'Remote Profile: ${_contracts.remoteStubProfile?.summaryLabel}',
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              if (section.id == 'auth')
                                AuthSessionPanel(
                                  contract: _contracts.authSession,
                                )
                              else if (section.id == 'project')
                                ProjectLifecyclePanel(
                                  contract: _contracts.projectLifecycle,
                                )
                              else if (section.id == 'canvas')
                                CanvasEditingPanel(
                                  contract: _contracts.canvasEditing,
                                )
                              else if (section.id == 'assets')
                                AssetManagementPanel(
                                  contract: _contracts.assetManagement,
                                )
                              else if (section.id == 'collaboration')
                                CollaborationContextPanel(
                                  contract: _contracts.collaborationContext,
                                )
                              else if (section.id == 'inspect')
                                InspectHandoffPanel(
                                  contract: _contracts.inspectHandoff,
                                )
                              else if (section.id == 'export')
                                ExportWorkflowPanel(
                                  contract: _contracts.exportWorkflow,
                                )
                              else if (section.id == 'diagnostics')
                                DiagnosticsRecoveryPanel(
                                  contract: _contracts.diagnosticsRecovery,
                                  contractModeLabel: _contracts.mode.label,
                                  remoteProfileLabel:
                                      _contracts.mode ==
                                          DesktopContractMode.remoteStub
                                      ? (_contracts
                                                .remoteStubProfile
                                                ?.summaryLabel ??
                                            'none')
                                      : '',
                                )
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
  const AuthSessionPanel({super.key, this.contract});

  final AuthSessionContract? contract;

  @override
  State<AuthSessionPanel> createState() => _AuthSessionPanelState();
}

class _AuthSessionPanelState extends State<AuthSessionPanel> {
  late final AuthSessionContract _contract =
      widget.contract ?? InMemoryAuthSessionContract();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

  void _signIn() {
    setState(() {
      _contract.signIn(
        AuthSignInRequest(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    });
  }

  void _restoreSession() {
    setState(() {
      _contract.restoreSession();
    });
  }

  void _refreshToken() {
    setState(() {
      _contract.refreshToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthSessionState authState = _contract.state;
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
          value: authState.rememberSession,
          contentPadding: EdgeInsets.zero,
          onChanged: (bool? value) {
            setState(() {
              _contract.setRememberSession(value ?? false);
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
          'Status: ${authState.status}',
          key: const ValueKey<String>('auth-status'),
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class ProjectLifecyclePanel extends StatefulWidget {
  const ProjectLifecyclePanel({super.key, this.contract});

  final ProjectLifecycleContract? contract;

  @override
  State<ProjectLifecyclePanel> createState() => _ProjectLifecyclePanelState();
}

class _ProjectLifecyclePanelState extends State<ProjectLifecyclePanel> {
  late final ProjectLifecycleContract _contract =
      widget.contract ?? InMemoryProjectLifecycleContract();
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _fileNameController = TextEditingController();

  @override
  void dispose() {
    _projectNameController.dispose();
    _fileNameController.dispose();
    super.dispose();
  }

  void _createProject() {
    setState(() {
      final String previousStatus = _contract.state.status;
      final ProjectLifecycleState nextState = _contract.createProject(
        _projectNameController.text,
      );
      if (nextState.status != previousStatus &&
          nextState.status.startsWith('Project created:')) {
        _projectNameController.clear();
      }
    });
  }

  void _switchProject(int index) {
    setState(() {
      _contract.switchProject(index);
    });
  }

  void _createFile() {
    setState(() {
      final String previousStatus = _contract.state.status;
      final ProjectLifecycleState nextState = _contract.createFile(
        _fileNameController.text,
      );
      if (nextState.status != previousStatus &&
          nextState.status.startsWith('File created in ')) {
        _fileNameController.clear();
      }
    });
  }

  void _deleteFirstFile() {
    setState(() {
      _contract.deleteFirstFile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProjectLifecycleState projectState = _contract.state;
    final ProjectRecord selectedProject = projectState.selectedProject;
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
          'Projects: ${projectState.projects.length} · Files in selected: ${selectedProject.files.length}',
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
          children: List<Widget>.generate(projectState.projects.length, (
            int index,
          ) {
            final ProjectRecord project = projectState.projects[index];
            final bool selected = index == projectState.selectedProjectIndex;
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
        if (selectedProject.files.isEmpty)
          Text(
            'No files in ${selectedProject.name}.',
            key: const ValueKey<String>('file-empty'),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: selectedProject.files
                .map(
                  (String file) => Text(
                    file,
                    key: ValueKey<String>(
                      'file-item-${selectedProject.id}-$file',
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        const SizedBox(height: 16),
        Text(
          'Status: ${projectState.status}',
          key: const ValueKey<String>('project-status'),
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class CanvasEditingPanel extends StatefulWidget {
  const CanvasEditingPanel({super.key, this.contract});

  final CanvasEditingContract? contract;

  @override
  State<CanvasEditingPanel> createState() => _CanvasEditingPanelState();
}

class _CanvasEditingPanelState extends State<CanvasEditingPanel> {
  late final CanvasEditingContract _contract =
      widget.contract ?? InMemoryCanvasEditingContract();

  void _createRectangle() {
    setState(() {
      _contract.createRectangle();
    });
  }

  void _moveSelected() {
    setState(() {
      _contract.moveSelected();
    });
  }

  void _resizeSelected() {
    setState(() {
      _contract.resizeSelected();
    });
  }

  void _toggleFillSelected() {
    setState(() {
      _contract.toggleFillSelected();
    });
  }

  @override
  Widget build(BuildContext context) {
    final CanvasEditingState canvasState = _contract.state;
    final CanvasShapeRecord? shape = canvasState.selectedShape;
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
          children: List<Widget>.generate(canvasState.shapes.length, (
            int index,
          ) {
            final CanvasShapeRecord item = canvasState.shapes[index];
            final bool selected = index == canvasState.selectedIndex;
            return ChoiceChip(
              key: ValueKey<String>('canvas-shape-${item.id}'),
              label: Text(item.id),
              selected: selected,
              onSelected: (_) {
                setState(() {
                  _contract.selectShape(index);
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
          'Status: ${canvasState.status}',
          key: const ValueKey<String>('canvas-status'),
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class AssetManagementPanel extends StatefulWidget {
  const AssetManagementPanel({super.key, this.contract});

  final AssetManagementContract? contract;

  @override
  State<AssetManagementPanel> createState() => _AssetManagementPanelState();
}

class _AssetManagementPanelState extends State<AssetManagementPanel> {
  late final AssetManagementContract _contract =
      widget.contract ?? InMemoryAssetManagementContract();
  final TextEditingController _assetNameController = TextEditingController();
  final List<String> _assetTypes = <String>['image', 'icon', 'vector'];
  String _selectedAssetType = 'image';

  @override
  void dispose() {
    _assetNameController.dispose();
    super.dispose();
  }

  void _importAsset() {
    setState(() {
      final String previousStatus = _contract.state.status;
      final AssetManagementState nextState = _contract.importAsset(
        _assetNameController.text,
        _selectedAssetType,
      );
      if (nextState.status != previousStatus &&
          nextState.status.startsWith('Asset imported:')) {
        _assetNameController.clear();
      }
    });
  }

  void _selectAsset(int index) {
    setState(() {
      _contract.selectAsset(index);
    });
  }

  void _useSelectedAsset() {
    setState(() {
      _contract.useSelectedAsset();
    });
  }

  void _removeSelectedAsset() {
    setState(() {
      _contract.removeSelectedAsset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AssetManagementState assetState = _contract.state;
    final AssetRecord? asset = assetState.selectedAsset;
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
          'Assets: ${assetState.assets.length}',
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
          children: List<Widget>.generate(assetState.assets.length, (
            int index,
          ) {
            final AssetRecord item = assetState.assets[index];
            final bool selected = index == assetState.selectedAssetIndex;
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
          'Status: ${assetState.status}',
          key: const ValueKey<String>('asset-status'),
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class CollaborationContextPanel extends StatefulWidget {
  const CollaborationContextPanel({super.key, this.contract});

  final CollaborationContextContract? contract;

  @override
  State<CollaborationContextPanel> createState() =>
      _CollaborationContextPanelState();
}

class _CollaborationContextPanelState extends State<CollaborationContextPanel> {
  late final CollaborationContextContract _contract =
      widget.contract ?? InMemoryCollaborationContextContract();
  final TextEditingController _threadTitleController = TextEditingController();

  @override
  void dispose() {
    _threadTitleController.dispose();
    super.dispose();
  }

  void _togglePeerPresence() {
    setState(() {
      _contract.togglePeerPresence();
    });
  }

  void _createThread() {
    setState(() {
      final String previousStatus = _contract.state.status;
      final CollaborationContextState nextState = _contract.createThread(
        _threadTitleController.text,
      );
      if (nextState.status != previousStatus &&
          nextState.status.startsWith('Thread created:')) {
        _threadTitleController.clear();
      }
    });
  }

  void _selectThread(int index) {
    setState(() {
      _contract.selectThread(index);
    });
  }

  void _resolveSelectedThread() {
    setState(() {
      _contract.resolveSelectedThread();
    });
  }

  @override
  Widget build(BuildContext context) {
    final CollaborationContextState collaborationState = _contract.state;
    final ThreadRecord? thread = collaborationState.selectedThread;
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
          'Active sessions: ${collaborationState.activeSessions} · Open threads: ${collaborationState.threads.length}',
          key: const ValueKey<String>('collaboration-summary'),
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          key: const ValueKey<String>('collaboration-toggle-peer'),
          onPressed: _togglePeerPresence,
          child: Text(
            collaborationState.peerActive ? 'Disconnect Peer' : 'Connect Peer',
          ),
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
        if (collaborationState.threads.isEmpty)
          const Text('No open threads.', key: ValueKey<String>('thread-empty'))
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List<Widget>.generate(collaborationState.threads.length, (
              int index,
            ) {
              final ThreadRecord item = collaborationState.threads[index];
              final bool selected =
                  index == collaborationState.selectedThreadIndex;
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
          'Status: ${collaborationState.status}',
          key: const ValueKey<String>('collaboration-status'),
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class InspectHandoffPanel extends StatefulWidget {
  const InspectHandoffPanel({super.key, this.contract});

  final InspectHandoffContract? contract;

  @override
  State<InspectHandoffPanel> createState() => _InspectHandoffPanelState();
}

class _InspectHandoffPanelState extends State<InspectHandoffPanel> {
  late final InspectHandoffContract _contract =
      widget.contract ?? InMemoryInspectHandoffContract();
  final TextEditingController _elementIdController = TextEditingController();
  final List<String> _targets = <String>['css', 'flutter', 'swiftui'];

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

  void _generateSnippet() {
    setState(() {
      _contract.generateSnippet(_elementIdController.text);
    });
  }

  void _copyMetadata() {
    setState(() {
      _contract.copyMetadata(_elementIdController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final InspectHandoffState inspectState = _contract.state;
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
          initialValue: inspectState.target,
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
              _contract.setTarget(value);
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
          'Inspect metadata: id=${elementId.isEmpty ? '<empty>' : elementId}, target=${inspectState.target}',
          key: const ValueKey<String>('inspect-metadata'),
        ),
        const SizedBox(height: 12),
        Text(
          inspectState.snippet,
          key: const ValueKey<String>('inspect-snippet'),
        ),
        const SizedBox(height: 12),
        Text(
          'Status: ${inspectState.status}',
          key: const ValueKey<String>('inspect-status'),
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class ExportWorkflowPanel extends StatefulWidget {
  const ExportWorkflowPanel({super.key, this.contract});

  final ExportWorkflowContract? contract;

  @override
  State<ExportWorkflowPanel> createState() => _ExportWorkflowPanelState();
}

class _ExportWorkflowPanelState extends State<ExportWorkflowPanel> {
  late final ExportWorkflowContract _contract =
      widget.contract ?? InMemoryExportWorkflowContract();
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
  const DiagnosticsRecoveryPanel({
    super.key,
    this.contract,
    this.contractModeLabel = 'in-memory',
    this.remoteProfileLabel = '',
  });

  final DiagnosticsRecoveryContract? contract;
  final String contractModeLabel;
  final String remoteProfileLabel;

  @override
  State<DiagnosticsRecoveryPanel> createState() =>
      _DiagnosticsRecoveryPanelState();
}

class _DiagnosticsRecoveryPanelState extends State<DiagnosticsRecoveryPanel> {
  late final DiagnosticsRecoveryContract _contract =
      widget.contract ?? InMemoryDiagnosticsRecoveryContract();

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
          'Contract mode: ${widget.contractModeLabel} · WebSocket: $websocketLabel · MCP: $mcpLabel · reconnect attempts: ${diagnosticsState.reconnectAttempts}',
          key: const ValueKey<String>('diagnostics-summary'),
          style: textTheme.bodyMedium,
        ),
        if (widget.remoteProfileLabel.isNotEmpty) ...<Widget>[
          const SizedBox(height: 8),
          Text(
            'Remote profile: ${widget.remoteProfileLabel}',
            key: const ValueKey<String>('diagnostics-remote-profile'),
            style: textTheme.bodyMedium,
          ),
        ],
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
