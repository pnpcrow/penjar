import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Manages an embedded MCP server process within the desktop app.
///
/// Phase D: Users can access MCP features from the desktop app without
/// needing to set up a separate bridge process.
///
/// The runtime:
/// - Discovers the bundled MCP server distribution
/// - Starts the Node.js MCP server as a child process
/// - Monitors health via the /health endpoint
/// - Auto-restarts on failure with exponential backoff
/// - Provides lifecycle management (start/stop/restart)
class EmbeddedMcpRuntime {
  EmbeddedMcpRuntime({
    String? mcpDistPath,
    String? nodeBinaryPath,
    this.serverPort = 4401,
    this.websocketPort = 4402,
    this.pluginPort = 4400,
    this.replPort = 4403,
    this.healthCheckInterval = const Duration(seconds: 30),
    this.maxRestartAttempts = 5,
    this.restartBaseDelay = const Duration(seconds: 2),
  })  : mcpDistPath = mcpDistPath ?? _defaultMcpDistPath(),
        nodeBinaryPath = nodeBinaryPath ?? _defaultNodeBinaryPath();

  final String mcpDistPath;
  final String nodeBinaryPath;
  final int serverPort;
  final int websocketPort;
  final int pluginPort;
  final int replPort;
  final Duration healthCheckInterval;
  final int maxRestartAttempts;
  final Duration restartBaseDelay;

  Process? _serverProcess;
  Timer? _healthCheckTimer;
  int _restartAttempts = 0;
  bool _intentionalStop = false;
  final StreamController<McpRuntimeEvent> _eventController =
      StreamController<McpRuntimeEvent>.broadcast();

  McpRuntimeStatus _status = McpRuntimeStatus.stopped;
  String _lastError = '';
  DateTime? _startedAt;

  McpRuntimeStatus get status => _status;
  String get lastError => _lastError;
  DateTime? get startedAt => _startedAt;
  bool get isRunning => _status == McpRuntimeStatus.running;
  Stream<McpRuntimeEvent> get events => _eventController.stream;

  String get healthUrl => 'http://localhost:$serverPort/health';
  String get mcpUrl => 'http://localhost:$serverPort/mcp';
  String get sseUrl => 'http://localhost:$serverPort/sse';

  /// Start the embedded MCP server.
  Future<bool> start() async {
    if (_status == McpRuntimeStatus.running) {
      return true;
    }

    _intentionalStop = false;
    _status = McpRuntimeStatus.starting;
    _emit(McpRuntimeEvent.starting());

    final String entryPoint = _resolveEntryPoint();
    if (entryPoint.isEmpty) {
      _status = McpRuntimeStatus.error;
      _lastError = 'MCP server distribution not found at: $mcpDistPath';
      _emit(McpRuntimeEvent.error(_lastError));
      return false;
    }

    try {
      _serverProcess = await Process.start(
        nodeBinaryPath,
        <String>[entryPoint],
        environment: <String, String>{
          'PENJAR_MCP_SERVER_PORT': '$serverPort',
          'PENJAR_MCP_WEBSOCKET_PORT': '$websocketPort',
          'PENJAR_MCP_PLUGIN_PORT': '$pluginPort',
          'PENJAR_MCP_REPL_PORT': '$replPort',
          'PENJAR_MCP_LOG_LEVEL': 'info',
          'NODE_ENV': 'production',
        },
        workingDirectory: mcpDistPath,
      );

      _serverProcess!.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(_onServerOutput);
      _serverProcess!.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen(_onServerError);
      _serverProcess!.exitCode.then(_onServerExit);

      // Wait for server to become healthy
      final bool healthy = await _waitForHealth(
        timeout: const Duration(seconds: 15),
      );

      if (healthy) {
        _status = McpRuntimeStatus.running;
        _startedAt = DateTime.now();
        _restartAttempts = 0;
        _startHealthCheckTimer();
        _emit(McpRuntimeEvent.started());
        return true;
      } else {
        _status = McpRuntimeStatus.error;
        _lastError = 'Server started but health check failed';
        _emit(McpRuntimeEvent.error(_lastError));
        await _killProcess();
        return false;
      }
    } on ProcessException catch (e) {
      _status = McpRuntimeStatus.error;
      _lastError = 'Failed to start Node.js: ${e.message}';
      _emit(McpRuntimeEvent.error(_lastError));
      return false;
    }
  }

  /// Stop the embedded MCP server gracefully.
  Future<void> stop() async {
    _intentionalStop = true;
    _healthCheckTimer?.cancel();
    _healthCheckTimer = null;

    if (_serverProcess != null) {
      _status = McpRuntimeStatus.stopping;
      _emit(McpRuntimeEvent.stopping());

      _serverProcess!.kill(ProcessSignal.sigterm);

      // Wait for graceful shutdown, force kill after timeout
      try {
        await _serverProcess!.exitCode.timeout(
          const Duration(seconds: 5),
        );
      } on TimeoutException {
        _serverProcess!.kill(ProcessSignal.sigkill);
      }

      _serverProcess = null;
    }

    _status = McpRuntimeStatus.stopped;
    _startedAt = null;
    _emit(McpRuntimeEvent.stopped());
  }

  /// Restart the MCP server.
  Future<bool> restart() async {
    await stop();
    _intentionalStop = false;
    return start();
  }

  /// Check if the MCP server is healthy.
  Future<McpHealthStatus> checkHealth() async {
    try {
      final HttpClient client = HttpClient()
        ..connectionTimeout = const Duration(seconds: 3);
      final HttpClientRequest request = await client
          .getUrl(Uri.parse(healthUrl))
          .timeout(const Duration(seconds: 3));
      final HttpClientResponse response =
          await request.close().timeout(const Duration(seconds: 3));

      final String body = await response.transform(utf8.decoder).join();
      client.close(force: true);

      if (response.statusCode == 200) {
        Map<String, Object?> data = const <String, Object?>{};
        try {
          final Object? decoded = jsonDecode(body);
          if (decoded is Map<String, Object?>) {
            data = decoded;
          }
        } on FormatException {
          // Not JSON
        }

        final String healthStatus =
            '${data['status'] ?? 'unknown'}';
        final bool degraded = healthStatus == 'degraded';

        return McpHealthStatus(
          reachable: true,
          status: healthStatus,
          degraded: degraded,
          pluginConnected: !degraded,
          rawData: data,
        );
      }

      return McpHealthStatus(
        reachable: true,
        status: 'unhealthy',
        degraded: true,
        pluginConnected: false,
      );
    } on Object catch (e) {
      return McpHealthStatus(
        reachable: false,
        status: 'unreachable',
        degraded: true,
        pluginConnected: false,
        error: '$e',
      );
    }
  }

  /// Get a summary of the runtime state.
  McpRuntimeState getState() {
    return McpRuntimeState(
      status: _status,
      lastError: _lastError,
      startedAt: _startedAt,
      restartAttempts: _restartAttempts,
      serverPort: serverPort,
      websocketPort: websocketPort,
      healthUrl: healthUrl,
      mcpUrl: mcpUrl,
    );
  }

  void dispose() {
    _intentionalStop = true;
    _healthCheckTimer?.cancel();
    _eventController.close();
    if (_serverProcess != null) {
      _serverProcess!.kill(ProcessSignal.sigkill);
      _serverProcess = null;
    }
  }

  // --- Internal ---

  String _resolveEntryPoint() {
    final List<String> candidates = <String>[
      '$mcpDistPath/dist/index.js',
      '$mcpDistPath/packages/server/dist/index.js',
      '$mcpDistPath/index.js',
    ];

    for (final String path in candidates) {
      if (File(path).existsSync()) {
        return path;
      }
    }
    return '';
  }

  Future<bool> _waitForHealth({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final DateTime deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      final McpHealthStatus health = await checkHealth();
      if (health.reachable) {
        return true;
      }
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    return false;
  }

  void _startHealthCheckTimer() {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = Timer.periodic(healthCheckInterval, (_) async {
      if (_status != McpRuntimeStatus.running) return;

      final McpHealthStatus health = await checkHealth();
      if (!health.reachable && !_intentionalStop) {
        _emit(McpRuntimeEvent.unhealthy(health.error ?? 'Health check failed'));
        _attemptAutoRestart();
      }
    });
  }

  Future<void> _attemptAutoRestart() async {
    if (_intentionalStop) return;
    if (_restartAttempts >= maxRestartAttempts) {
      _status = McpRuntimeStatus.error;
      _lastError =
          'Max restart attempts ($maxRestartAttempts) exceeded';
      _emit(McpRuntimeEvent.error(_lastError));
      return;
    }

    _restartAttempts++;
    final Duration delay = restartBaseDelay * (1 << (_restartAttempts - 1));
    _emit(McpRuntimeEvent.restarting(_restartAttempts, delay));

    await Future<void>.delayed(delay);

    if (_intentionalStop) return;
    await _killProcess();
    await start();
  }

  Future<void> _killProcess() async {
    if (_serverProcess != null) {
      _serverProcess!.kill(ProcessSignal.sigkill);
      _serverProcess = null;
    }
  }

  void _onServerOutput(String line) {
    _emit(McpRuntimeEvent.log(line, isError: false));
  }

  void _onServerError(String line) {
    _emit(McpRuntimeEvent.log(line, isError: true));
  }

  void _onServerExit(int exitCode) {
    if (_intentionalStop) return;

    _status = McpRuntimeStatus.error;
    _lastError = 'Server process exited with code $exitCode';
    _emit(McpRuntimeEvent.crashed(exitCode));

    _attemptAutoRestart();
  }

  void _emit(McpRuntimeEvent event) {
    if (!_eventController.isClosed) {
      _eventController.add(event);
    }
  }

  static String _defaultMcpDistPath() {
    // Look for MCP server relative to the app bundle
    final String execDir = File(Platform.resolvedExecutable).parent.path;
    final List<String> candidates = <String>[
      '$execDir/mcp',
      '$execDir/../Resources/mcp',
      '$execDir/../mcp',
      // Development fallback
      '${Directory.current.path}/../mcp',
    ];

    for (final String path in candidates) {
      if (Directory(path).existsSync()) {
        return path;
      }
    }
    return '${Directory.current.path}/../mcp';
  }

  static String _defaultNodeBinaryPath() {
    // Check common locations
    final List<String> candidates = <String>[
      '/usr/local/bin/node',
      '/usr/bin/node',
      '/opt/homebrew/bin/node',
      // Bundled Node.js
      '${File(Platform.resolvedExecutable).parent.path}/node',
    ];

    for (final String path in candidates) {
      if (File(path).existsSync()) {
        return path;
      }
    }

    // Fallback: hope it's in PATH
    return 'node';
  }
}

enum McpRuntimeStatus {
  stopped,
  starting,
  running,
  stopping,
  error;

  String get label => name;
}

class McpRuntimeState {
  const McpRuntimeState({
    required this.status,
    required this.lastError,
    required this.startedAt,
    required this.restartAttempts,
    required this.serverPort,
    required this.websocketPort,
    required this.healthUrl,
    required this.mcpUrl,
  });

  final McpRuntimeStatus status;
  final String lastError;
  final DateTime? startedAt;
  final int restartAttempts;
  final int serverPort;
  final int websocketPort;
  final String healthUrl;
  final String mcpUrl;
}

class McpHealthStatus {
  const McpHealthStatus({
    required this.reachable,
    required this.status,
    required this.degraded,
    required this.pluginConnected,
    this.error,
    this.rawData = const <String, Object?>{},
  });

  final bool reachable;
  final String status;
  final bool degraded;
  final bool pluginConnected;
  final String? error;
  final Map<String, Object?> rawData;
}

class McpRuntimeEvent {
  const McpRuntimeEvent._({
    required this.type,
    this.message = '',
    this.exitCode,
    this.restartAttempt,
    this.restartDelay,
    this.isError = false,
  });

  factory McpRuntimeEvent.starting() =>
      const McpRuntimeEvent._(type: McpRuntimeEventType.starting);
  factory McpRuntimeEvent.started() =>
      const McpRuntimeEvent._(type: McpRuntimeEventType.started);
  factory McpRuntimeEvent.stopping() =>
      const McpRuntimeEvent._(type: McpRuntimeEventType.stopping);
  factory McpRuntimeEvent.stopped() =>
      const McpRuntimeEvent._(type: McpRuntimeEventType.stopped);
  factory McpRuntimeEvent.error(String message) =>
      McpRuntimeEvent._(type: McpRuntimeEventType.error, message: message);
  factory McpRuntimeEvent.crashed(int exitCode) =>
      McpRuntimeEvent._(
        type: McpRuntimeEventType.crashed,
        exitCode: exitCode,
        message: 'Process exited with code $exitCode',
      );
  factory McpRuntimeEvent.unhealthy(String message) =>
      McpRuntimeEvent._(
        type: McpRuntimeEventType.unhealthy,
        message: message,
      );
  factory McpRuntimeEvent.restarting(int attempt, Duration delay) =>
      McpRuntimeEvent._(
        type: McpRuntimeEventType.restarting,
        restartAttempt: attempt,
        restartDelay: delay,
        message: 'Restart attempt $attempt after ${delay.inSeconds}s delay',
      );
  factory McpRuntimeEvent.log(String message, {bool isError = false}) =>
      McpRuntimeEvent._(
        type: McpRuntimeEventType.log,
        message: message,
        isError: isError,
      );

  final McpRuntimeEventType type;
  final String message;
  final int? exitCode;
  final int? restartAttempt;
  final Duration? restartDelay;
  final bool isError;
}

enum McpRuntimeEventType {
  starting,
  started,
  stopping,
  stopped,
  error,
  crashed,
  unhealthy,
  restarting,
  log,
}
