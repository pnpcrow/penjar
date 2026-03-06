import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:penjar_desktop/contracts/remote_stub_contracts.dart';
import 'package:penjar_desktop/contracts/workflow_contracts.dart';

class _CaptureTransportClient extends RemoteStubTransportClient {
  final List<RemoteStubTransportRequest> executed =
      <RemoteStubTransportRequest>[];

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    executed.add(request);
    return RemoteStubTransportResult.allow;
  }
}

class _BackendResponseTransportClient extends RemoteStubTransportClient {
  _BackendResponseTransportClient(this.responsesByOperation);

  final Map<String, Map<String, Object?>> responsesByOperation;
  final List<String> executedOperations = <String>[];

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    executedOperations.add(request.operation);
    final Map<String, Object?>? response =
        responsesByOperation[request.operation];
    if (response == null || response.isEmpty) {
      return RemoteStubTransportResult.allow;
    }
    return RemoteStubTransportResult.allowedWithPayload(response);
  }
}

class _TrackingAuthSessionContract implements AuthSessionContract {
  int signInCallCount = 0;
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
    signInCallCount += 1;
    _signedIn = true;
    _status = 'Delegate sign-in called.';
    return state;
  }

  @override
  AuthSessionState restoreSession() {
    _status = 'Delegate restore called.';
    return state;
  }

  @override
  AuthSessionState refreshToken() {
    _status = 'Delegate refresh called.';
    return state;
  }
}

class _AuthBackendFixtureCase {
  const _AuthBackendFixtureCase({
    required this.name,
    required this.operationId,
    required this.responsePayload,
    required this.expectedSignedIn,
    this.expectedRememberSession,
    this.expectedStatus,
  });

  final String name;
  final String operationId;
  final Map<String, Object?> responsePayload;
  final bool expectedSignedIn;
  final bool? expectedRememberSession;
  final String? expectedStatus;
}

void _invokeAuthBackendFixtureOperation(
  RemoteStubAuthSessionContract authContract,
  String operationId,
) {
  switch (operationId) {
    case RemoteStubOperationIds.restoreSession:
      authContract.restoreSession();
      return;
    case RemoteStubOperationIds.refreshToken:
      authContract.refreshToken();
      return;
    case RemoteStubOperationIds.signIn:
      authContract.signIn(
        const AuthSignInRequest(
          email: 'fixture@penjar.app',
          password: 'fixture-password',
        ),
      );
      return;
  }
  fail('Unsupported auth fixture operation: $operationId');
}

String _authBackendFixtureMatrixEntryKey({
  required String operationId,
  required String wrapperKey,
  required String alias,
  required Object? expectedValue,
}) => '$operationId|$wrapperKey|$alias|$expectedValue';

Set<String> _buildAuthBackendFixtureMatrixEntrySet({
  required Iterable<_AuthBackendFixtureCase> fixtures,
  required Iterable<String> wrapperKeys,
}) {
  final Set<String> entries = <String>{};
  for (final _AuthBackendFixtureCase fixture in fixtures) {
    for (final String wrapperKey in wrapperKeys) {
      final Object? wrapper = fixture.responsePayload[wrapperKey];
      if (wrapper is! Map<Object?, Object?>) {
        continue;
      }
      final Object? authState = wrapper['authState'];
      if (authState is! Map<Object?, Object?>) {
        continue;
      }
      for (final MapEntry<Object?, Object?> authStateEntry
          in authState.entries) {
        final Object? alias = authStateEntry.key;
        if (alias is! String) {
          continue;
        }
        entries.add(
          _authBackendFixtureMatrixEntryKey(
            operationId: fixture.operationId,
            wrapperKey: wrapperKey,
            alias: alias,
            expectedValue: authStateEntry.value,
          ),
        );
      }
    }
  }
  return entries;
}

void _appendMissingAuthBackendFixtureMatrixEntries({
  required List<String> missingEntries,
  required Set<String> matrixEntries,
  required String operationId,
  required String wrapperKey,
  required Iterable<String> aliases,
  required Object? expectedValue,
}) {
  for (final String alias in aliases) {
    if (matrixEntries.contains(
      _authBackendFixtureMatrixEntryKey(
        operationId: operationId,
        wrapperKey: wrapperKey,
        alias: alias,
        expectedValue: expectedValue,
      ),
    )) {
      continue;
    }
    missingEntries.add(
      '$operationId $wrapperKey authState.$alias=$expectedValue',
    );
  }
}

void main() {
  group('InMemoryAuthSessionContract', () {
    test('requires email and password to sign in', () {
      final InMemoryAuthSessionContract contract =
          InMemoryAuthSessionContract();

      contract.signIn(const AuthSignInRequest(email: '', password: 'secret'));
      expect(
        contract.state.status,
        'Validation failed: email and password are required.',
      );
      expect(contract.state.signedIn, isFalse);
    });

    test('supports remember/restore and refresh token lifecycle', () {
      final InMemoryAuthSessionContract contract =
          InMemoryAuthSessionContract();

      contract.restoreSession();
      expect(
        contract.state.status,
        'Session restore blocked: enable Remember Session first.',
      );

      contract.setRememberSession(true);
      contract.restoreSession();
      expect(contract.state.status, 'Session restored (simulated).');

      contract.refreshToken();
      expect(contract.state.status, 'Token refresh blocked: sign in first.');

      contract.signIn(
        const AuthSignInRequest(
          email: 'designer@penjar.app',
          password: 'desktop-pass',
        ),
      );
      expect(contract.state.status, 'Signed in (simulated).');
      expect(contract.state.signedIn, isTrue);

      contract.refreshToken();
      expect(contract.state.status, 'Token refreshed (simulated).');
    });
  });

  group('InMemoryProjectLifecycleContract', () {
    test('supports project/file lifecycle transitions', () {
      final InMemoryProjectLifecycleContract contract =
          InMemoryProjectLifecycleContract();

      expect(contract.state.projects, hasLength(1));
      expect(contract.state.selectedProject.name, 'Core Product');
      expect(contract.state.selectedProject.files, <String>['landing.penjar']);

      contract.createProject('');
      expect(
        contract.state.status,
        'Project create failed: project name is required.',
      );

      contract.createProject('Mobile Revamp');
      expect(contract.state.status, 'Project created: Mobile Revamp.');
      expect(contract.state.projects, hasLength(2));
      expect(contract.state.selectedProject.name, 'Mobile Revamp');

      contract.createFile('');
      expect(
        contract.state.status,
        'File create failed: file name is required.',
      );

      contract.createFile('spec.penjar');
      expect(
        contract.state.status,
        'File created in Mobile Revamp: spec.penjar.',
      );
      expect(contract.state.selectedProject.files, <String>['spec.penjar']);

      contract.switchProject(0);
      expect(contract.state.status, 'Project selected: Core Product.');

      contract.deleteFirstFile();
      expect(
        contract.state.status,
        'File deleted from Core Product: landing.penjar.',
      );
      expect(contract.state.selectedProject.files, isEmpty);

      contract.deleteFirstFile();
      expect(contract.state.status, 'File delete skipped: no file exists.');
    });

    test('handles invalid project switch index', () {
      final InMemoryProjectLifecycleContract contract =
          InMemoryProjectLifecycleContract();

      contract.switchProject(3);
      expect(
        contract.state.status,
        'Project switch failed: invalid project index.',
      );
      expect(contract.state.selectedProject.name, 'Core Product');
    });
  });

  group('InMemoryCanvasEditingContract', () {
    test('supports create/select/move/resize/fill lifecycle', () {
      final InMemoryCanvasEditingContract contract =
          InMemoryCanvasEditingContract();

      expect(contract.state.shapes, isEmpty);
      expect(contract.state.selectedShape, isNull);
      expect(contract.state.status, 'Idle');

      contract.moveSelected();
      expect(contract.state.status, 'Move skipped: no shape selected.');

      contract.createRectangle();
      expect(contract.state.status, 'Rectangle created: rect-1.');
      expect(contract.state.shapes, hasLength(1));
      expect(contract.state.selectedShape?.id, 'rect-1');

      contract.moveSelected();
      expect(contract.state.status, 'Moved rect-1 to (20, 15).');

      contract.resizeSelected();
      expect(contract.state.status, 'Resized rect-1 to 140x100.');

      contract.toggleFillSelected();
      expect(contract.state.status, 'Fill updated for rect-1: #FF8A00.');
      expect(contract.state.selectedShape?.fillHex, '#FF8A00');
    });

    test('guards invalid shape selection', () {
      final InMemoryCanvasEditingContract contract =
          InMemoryCanvasEditingContract();

      contract.selectShape(2);
      expect(contract.state.status, 'Shape select failed: invalid index.');
    });
  });

  group('InMemoryAssetManagementContract', () {
    test('supports import/select/use/remove lifecycle', () {
      final InMemoryAssetManagementContract contract =
          InMemoryAssetManagementContract();

      contract.importAsset('', 'image');
      expect(
        contract.state.status,
        'Asset import failed: asset name is required.',
      );

      contract.importAsset('hero.png', 'image');
      expect(contract.state.status, 'Asset imported: hero.png (image).');
      expect(contract.state.assets, hasLength(1));
      expect(contract.state.selectedAsset?.name, 'hero.png');

      contract.importAsset('hero.png', 'image');
      expect(
        contract.state.status,
        'Asset import failed: duplicate asset name.',
      );

      contract.useSelectedAsset();
      expect(contract.state.status, 'Asset used: hero.png (count 1).');
      expect(contract.state.selectedAsset?.usedCount, 1);

      contract.removeSelectedAsset();
      expect(contract.state.status, 'Asset removed: hero.png.');
      expect(contract.state.assets, isEmpty);
      expect(contract.state.selectedAsset, isNull);

      contract.useSelectedAsset();
      expect(contract.state.status, 'Asset use skipped: no asset selected.');
    });

    test('guards invalid asset selection index', () {
      final InMemoryAssetManagementContract contract =
          InMemoryAssetManagementContract();

      contract.selectAsset(1);
      expect(contract.state.status, 'Asset select failed: invalid index.');
    });
  });

  group('InMemoryCollaborationContextContract', () {
    test('supports presence and thread lifecycle transitions', () {
      final InMemoryCollaborationContextContract contract =
          InMemoryCollaborationContextContract();

      expect(contract.state.peerActive, isFalse);
      expect(contract.state.activeSessions, 1);
      expect(contract.state.threads, isEmpty);
      expect(contract.state.status, 'Idle');

      contract.togglePeerPresence();
      expect(contract.state.peerActive, isTrue);
      expect(contract.state.status, 'Peer connected: reviewer@penjar.app.');
      expect(contract.state.activeSessions, 2);

      contract.createThread('');
      expect(contract.state.status, 'Thread create failed: title is required.');

      contract.createThread('Review button spacing');
      expect(contract.state.status, 'Thread created: Review button spacing.');
      expect(contract.state.threads, hasLength(1));
      expect(contract.state.selectedThread?.title, 'Review button spacing');

      contract.resolveSelectedThread();
      expect(contract.state.status, 'Thread resolved: Review button spacing.');
      expect(contract.state.threads, isEmpty);
      expect(contract.state.selectedThread, isNull);
    });

    test('guards invalid thread selection index', () {
      final InMemoryCollaborationContextContract contract =
          InMemoryCollaborationContextContract();

      contract.selectThread(2);
      expect(contract.state.status, 'Thread select failed: invalid index.');
    });
  });

  group('InMemoryInspectHandoffContract', () {
    test('supports snippet generation and metadata copy lifecycle', () {
      final InMemoryInspectHandoffContract contract =
          InMemoryInspectHandoffContract();

      expect(contract.state.target, 'flutter');
      expect(contract.state.snippet, 'No snippet generated.');
      expect(contract.state.status, 'Idle');

      contract.generateSnippet('');
      expect(
        contract.state.status,
        'Snippet generation failed: element id is required.',
      );

      contract.setTarget('css');
      contract.generateSnippet('button/primary');
      expect(
        contract.state.status,
        'Snippet generated for button/primary (css).',
      );
      expect(contract.state.snippet, contains('.button-primary'));

      contract.copyMetadata('');
      expect(
        contract.state.status,
        'Metadata copy failed: element id is required.',
      );

      contract.copyMetadata('button/primary');
      expect(
        contract.state.status,
        'Metadata copied (simulated) for button/primary.',
      );
    });
  });

  group('InMemoryExportWorkflowContract', () {
    test('returns validation failure for empty file name', () {
      final InMemoryExportWorkflowContract contract =
          InMemoryExportWorkflowContract();

      contract.runExport(
        const ExportRequest(
          fileName: '',
          format: 'png',
          scale: '2x',
          includeBackground: true,
        ),
      );

      expect(contract.state.status, 'Export failed: file name is required.');
      expect(contract.state.artifacts, isEmpty);
    });

    test('supports run/save/clear lifecycle', () {
      final InMemoryExportWorkflowContract contract =
          InMemoryExportWorkflowContract();

      contract.runExport(
        const ExportRequest(
          fileName: 'landing',
          format: 'png',
          scale: '2x',
          includeBackground: true,
        ),
      );

      expect(contract.state.status, 'Export completed: /exports/landing.png.');
      expect(contract.state.artifacts, hasLength(1));
      expect(contract.state.latestArtifact?.outputPath, '/exports/landing.png');

      contract.saveLatest();
      expect(
        contract.state.status,
        'Export saved (simulated): /exports/landing.png.',
      );

      contract.clearArtifacts();
      expect(contract.state.status, 'Export artifacts cleared.');
      expect(contract.state.artifacts, isEmpty);
    });
  });

  group('InMemoryDiagnosticsRecoveryContract', () {
    test('supports health, disconnect, reconnect and remediation actions', () {
      final InMemoryDiagnosticsRecoveryContract contract =
          InMemoryDiagnosticsRecoveryContract();

      expect(contract.state.websocketHealthy, isTrue);
      expect(contract.state.mcpHealthy, isTrue);
      expect(contract.state.reconnectAttempts, 0);
      expect(contract.state.status, 'Idle');

      contract.runHealthCheck();
      expect(
        contract.state.status,
        'Health check passed: websocket and MCP are connected.',
      );

      contract.simulateDisconnect();
      expect(contract.state.websocketHealthy, isFalse);
      expect(contract.state.mcpHealthy, isFalse);
      expect(
        contract.state.status,
        'WebSocket disconnected; MCP stream unavailable.',
      );

      contract.attemptReconnect();
      expect(contract.state.websocketHealthy, isTrue);
      expect(contract.state.mcpHealthy, isTrue);
      expect(contract.state.reconnectAttempts, 1);
      expect(contract.state.status, 'Reconnect successful on attempt 1.');

      contract.openRecoveryGuide();
      expect(contract.state.status, 'Recovery guide opened (simulated).');

      contract.attemptReconnect();
      expect(
        contract.state.status,
        'Reconnect skipped: session is already healthy.',
      );
    });
  });

  group('RemoteStubContracts', () {
    test('preserve payloads while prefixing status text', () {
      final RemoteStubAuthSessionContract authContract =
          RemoteStubAuthSessionContract();
      final RemoteStubProjectLifecycleContract projectContract =
          RemoteStubProjectLifecycleContract();
      final RemoteStubCanvasEditingContract canvasContract =
          RemoteStubCanvasEditingContract();
      final RemoteStubAssetManagementContract assetContract =
          RemoteStubAssetManagementContract();
      final RemoteStubCollaborationContextContract collaborationContract =
          RemoteStubCollaborationContextContract();
      final RemoteStubInspectHandoffContract inspectContract =
          RemoteStubInspectHandoffContract();
      final RemoteStubExportWorkflowContract exportContract =
          RemoteStubExportWorkflowContract();
      final RemoteStubDiagnosticsRecoveryContract diagnosticsContract =
          RemoteStubDiagnosticsRecoveryContract();

      expect(authContract.state.status, '[remote-stub] Idle');
      authContract.signIn(
        const AuthSignInRequest(
          email: 'designer@penjar.app',
          password: 'desktop-pass',
        ),
      );
      expect(authContract.state.signedIn, isTrue);
      expect(authContract.state.status, '[remote-stub] Signed in (simulated).');

      projectContract.createProject('Remote Workspace');
      expect(projectContract.state.selectedProject.name, 'Remote Workspace');
      expect(
        projectContract.state.status,
        '[remote-stub] Project created: Remote Workspace.',
      );

      canvasContract.createRectangle();
      expect(canvasContract.state.selectedShape?.id, 'rect-1');
      expect(
        canvasContract.state.status,
        '[remote-stub] Rectangle created: rect-1.',
      );

      assetContract.importAsset('hero.png', 'image');
      expect(assetContract.state.selectedAsset?.name, 'hero.png');
      expect(
        assetContract.state.status,
        '[remote-stub] Asset imported: hero.png (image).',
      );

      collaborationContract.createThread('Remote review');
      expect(
        collaborationContract.state.selectedThread?.title,
        'Remote review',
      );
      expect(
        collaborationContract.state.status,
        '[remote-stub] Thread created: Remote review.',
      );

      inspectContract.generateSnippet('button/primary');
      expect(inspectContract.state.snippet, isNotEmpty);
      expect(
        inspectContract.state.status,
        '[remote-stub] Snippet generated for button/primary (flutter).',
      );

      exportContract.runExport(
        const ExportRequest(
          fileName: 'landing',
          format: 'png',
          scale: '2x',
          includeBackground: true,
        ),
      );
      expect(
        exportContract.state.latestArtifact?.outputPath,
        '/exports/landing.png',
      );
      expect(
        exportContract.state.status,
        '[remote-stub] Export completed: /exports/landing.png.',
      );

      diagnosticsContract.simulateDisconnect();
      expect(diagnosticsContract.state.websocketHealthy, isFalse);
      expect(
        diagnosticsContract.state.status,
        '[remote-stub] WebSocket disconnected; MCP stream unavailable.',
      );
    });

    test(
      'block mutating operations when remote stub fault profile is unavailable',
      () {
        const RemoteStubFaultProfile faultProfile = RemoteStubFaultProfile(
          unavailable: true,
        );
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(faultProfile: faultProfile);
        final RemoteStubProjectLifecycleContract projectContract =
            RemoteStubProjectLifecycleContract(faultProfile: faultProfile);
        final RemoteStubCanvasEditingContract canvasContract =
            RemoteStubCanvasEditingContract(faultProfile: faultProfile);
        final RemoteStubAssetManagementContract assetContract =
            RemoteStubAssetManagementContract(faultProfile: faultProfile);
        final RemoteStubCollaborationContextContract collaborationContract =
            RemoteStubCollaborationContextContract(faultProfile: faultProfile);
        final RemoteStubInspectHandoffContract inspectContract =
            RemoteStubInspectHandoffContract(faultProfile: faultProfile);
        final RemoteStubExportWorkflowContract exportContract =
            RemoteStubExportWorkflowContract(faultProfile: faultProfile);
        final RemoteStubDiagnosticsRecoveryContract diagnosticsContract =
            RemoteStubDiagnosticsRecoveryContract(faultProfile: faultProfile);

        authContract.signIn(
          const AuthSignInRequest(
            email: 'designer@penjar.app',
            password: 'desktop-pass',
          ),
        );
        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Remote bridge unavailable: sign-in.',
        );

        projectContract.createProject('Blocked Project');
        expect(projectContract.state.projects, hasLength(1));
        expect(
          projectContract.state.status,
          '[remote-stub] Remote bridge unavailable: create-project.',
        );

        canvasContract.createRectangle();
        expect(canvasContract.state.shapes, isEmpty);
        expect(
          canvasContract.state.status,
          '[remote-stub] Remote bridge unavailable: create-rectangle.',
        );

        assetContract.importAsset('hero.png', 'image');
        expect(assetContract.state.assets, isEmpty);
        expect(
          assetContract.state.status,
          '[remote-stub] Remote bridge unavailable: import-asset.',
        );

        collaborationContract.createThread('Blocked Thread');
        expect(collaborationContract.state.threads, isEmpty);
        expect(
          collaborationContract.state.status,
          '[remote-stub] Remote bridge unavailable: create-thread.',
        );

        inspectContract.generateSnippet('button/primary');
        expect(inspectContract.state.snippet, 'No snippet generated.');
        expect(
          inspectContract.state.status,
          '[remote-stub] Remote bridge unavailable: generate-snippet.',
        );

        exportContract.runExport(
          const ExportRequest(
            fileName: 'landing',
            format: 'png',
            scale: '2x',
            includeBackground: true,
          ),
        );
        expect(exportContract.state.artifacts, isEmpty);
        expect(
          exportContract.state.status,
          '[remote-stub] Remote bridge unavailable: run-export.',
        );

        diagnosticsContract.simulateDisconnect();
        expect(diagnosticsContract.state.websocketHealthy, isTrue);
        expect(
          diagnosticsContract.state.status,
          '[remote-stub] Remote bridge unavailable: simulate-disconnect.',
        );
      },
    );

    test('block only configured operations when blockedOperations is set', () {
      const RemoteStubFaultProfile faultProfile = RemoteStubFaultProfile(
        blockedOperations: <String>{'create-project', 'run-export'},
      );
      final RemoteStubAuthSessionContract authContract =
          RemoteStubAuthSessionContract(faultProfile: faultProfile);
      final RemoteStubProjectLifecycleContract projectContract =
          RemoteStubProjectLifecycleContract(faultProfile: faultProfile);
      final RemoteStubExportWorkflowContract exportContract =
          RemoteStubExportWorkflowContract(faultProfile: faultProfile);

      authContract.signIn(
        const AuthSignInRequest(
          email: 'designer@penjar.app',
          password: 'desktop-pass',
        ),
      );
      expect(authContract.state.signedIn, isTrue);
      expect(authContract.state.status, '[remote-stub] Signed in (simulated).');

      projectContract.createProject('Blocked Project');
      expect(projectContract.state.projects, hasLength(1));
      expect(
        projectContract.state.status,
        '[remote-stub] Remote bridge unavailable: create-project.',
      );

      exportContract.runExport(
        const ExportRequest(
          fileName: 'landing',
          format: 'png',
          scale: '2x',
          includeBackground: true,
        ),
      );
      expect(exportContract.state.artifacts, isEmpty);
      expect(
        exportContract.state.status,
        '[remote-stub] Remote bridge unavailable: run-export.',
      );
    });

    test('transport client blocks configured operations', () {
      const RemoteStubScriptedTransportClient transportClient =
          RemoteStubScriptedTransportClient(
            blockedOperations: <String>{'SIGN-IN'},
            blockedReason: 'Transport bridge unavailable',
          );
      expect(
        transportClient.profile.blockedOperations,
        contains(RemoteStubOperationIds.signIn),
      );
      expect(
        transportClient.profile.blockedReason,
        'Transport bridge unavailable',
      );
      final RemoteStubAuthSessionContract authContract =
          RemoteStubAuthSessionContract(transportClient: transportClient);
      final RemoteStubProjectLifecycleContract projectContract =
          RemoteStubProjectLifecycleContract(transportClient: transportClient);

      authContract.signIn(
        const AuthSignInRequest(
          email: 'designer@penjar.app',
          password: 'desktop-pass',
        ),
      );
      expect(authContract.state.signedIn, isFalse);
      expect(
        authContract.state.status,
        '[remote-stub] Transport bridge unavailable: sign-in.',
      );

      projectContract.createProject('Allowed Project');
      expect(projectContract.state.projects, hasLength(2));
      expect(
        projectContract.state.status,
        '[remote-stub] Project created: Allowed Project.',
      );
    });

    test('maps all operations to backend request metadata', () {
      final _CaptureTransportClient transportClient = _CaptureTransportClient();
      final RemoteStubAuthSessionContract authContract =
          RemoteStubAuthSessionContract(transportClient: transportClient);
      final RemoteStubProjectLifecycleContract projectContract =
          RemoteStubProjectLifecycleContract(transportClient: transportClient);
      final RemoteStubCanvasEditingContract canvasContract =
          RemoteStubCanvasEditingContract(transportClient: transportClient);
      final RemoteStubAssetManagementContract assetContract =
          RemoteStubAssetManagementContract(transportClient: transportClient);
      final RemoteStubCollaborationContextContract collaborationContract =
          RemoteStubCollaborationContextContract(
            transportClient: transportClient,
          );
      final RemoteStubInspectHandoffContract inspectContract =
          RemoteStubInspectHandoffContract(transportClient: transportClient);
      final RemoteStubExportWorkflowContract exportContract =
          RemoteStubExportWorkflowContract(transportClient: transportClient);
      final RemoteStubDiagnosticsRecoveryContract diagnosticsContract =
          RemoteStubDiagnosticsRecoveryContract(
            transportClient: transportClient,
          );

      authContract.setRememberSession(true);
      authContract.signIn(
        const AuthSignInRequest(
          email: 'designer@penjar.app',
          password: 'desktop-pass',
        ),
      );
      authContract.restoreSession();
      authContract.refreshToken();

      projectContract.createProject('Route Catalog');
      projectContract.switchProject(0);
      projectContract.createFile('routes.penjar');
      projectContract.deleteFirstFile();

      canvasContract.createRectangle();
      canvasContract.selectShape(0);
      canvasContract.moveSelected();
      canvasContract.resizeSelected();
      canvasContract.toggleFillSelected();

      assetContract.importAsset('hero.png', 'image');
      assetContract.selectAsset(0);
      assetContract.useSelectedAsset();
      assetContract.removeSelectedAsset();

      collaborationContract.togglePeerPresence();
      collaborationContract.createThread('Route metadata');
      collaborationContract.selectThread(0);
      collaborationContract.resolveSelectedThread();

      inspectContract.setTarget('css');
      inspectContract.generateSnippet('button/primary');
      inspectContract.copyMetadata('button/primary');

      exportContract.runExport(
        const ExportRequest(
          fileName: 'landing',
          format: 'png',
          scale: '2x',
          includeBackground: true,
        ),
      );
      exportContract.saveLatest();
      exportContract.clearArtifacts();

      diagnosticsContract.runHealthCheck();
      diagnosticsContract.simulateDisconnect();
      diagnosticsContract.attemptReconnect();
      diagnosticsContract.openRecoveryGuide();

      expect(
        transportClient.executed,
        hasLength(RemoteStubOperationIds.all.length),
      );
      expect(
        transportClient.executed
            .map((RemoteStubTransportRequest item) => item.operation)
            .toSet(),
        RemoteStubOperationIds.all,
      );
      expect(
        transportClient.executed
            .where(
              (RemoteStubTransportRequest item) =>
                  item.endpoint == '/api/desktop/contracts/operation',
            )
            .toList(growable: false),
        isEmpty,
      );

      final RemoteStubTransportRequest signInRequest = transportClient.executed
          .firstWhere(
            (RemoteStubTransportRequest item) =>
                item.operation == RemoteStubOperationIds.signIn,
          );
      expect(signInRequest.workflow, 'auth');
      expect(signInRequest.method, 'POST');
      expect(signInRequest.endpoint, '/api/desktop/auth/sign-in');
      expect(signInRequest.payload['email'], 'designer@penjar.app');
      expect(signInRequest.payload['passwordLength'], 12);
      expect(signInRequest.payload.containsKey('password'), isFalse);

      final RemoteStubTransportRequest createProjectRequest = transportClient
          .executed
          .firstWhere(
            (RemoteStubTransportRequest item) =>
                item.operation == RemoteStubOperationIds.createProject,
          );
      expect(createProjectRequest.workflow, 'projects');
      expect(createProjectRequest.endpoint, '/api/desktop/projects');
      expect(createProjectRequest.payload['projectName'], 'Route Catalog');

      final RemoteStubTransportRequest deleteFileRequest = transportClient
          .executed
          .firstWhere(
            (RemoteStubTransportRequest item) =>
                item.operation == RemoteStubOperationIds.deleteFile,
          );
      expect(deleteFileRequest.method, 'DELETE');
      expect(deleteFileRequest.endpoint, '/api/desktop/projects/files/first');

      final RemoteStubTransportRequest clearArtifactsRequest = transportClient
          .executed
          .firstWhere(
            (RemoteStubTransportRequest item) =>
                item.operation == RemoteStubOperationIds.clearExportArtifacts,
          );
      expect(clearArtifactsRequest.method, 'DELETE');
      expect(clearArtifactsRequest.endpoint, '/api/desktop/export/artifacts');
    });

    test('auth sign-in payload forwards password only when enabled', () {
      final _CaptureTransportClient sanitizedTransportClient =
          _CaptureTransportClient();
      final RemoteStubAuthSessionContract sanitizedContract =
          RemoteStubAuthSessionContract(
            transportClient: sanitizedTransportClient,
          );
      sanitizedContract.signIn(
        const AuthSignInRequest(
          email: 'designer@penjar.app',
          password: 'desktop-pass',
        ),
      );

      expect(sanitizedTransportClient.executed, hasLength(1));
      final RemoteStubTransportRequest sanitizedRequest =
          sanitizedTransportClient.executed.single;
      expect(sanitizedRequest.payload['email'], 'designer@penjar.app');
      expect(sanitizedRequest.payload['passwordLength'], 12);
      expect(sanitizedRequest.payload.containsKey('password'), isFalse);

      final _CaptureTransportClient forwardedTransportClient =
          _CaptureTransportClient();
      final RemoteStubAuthSessionContract forwardedContract =
          RemoteStubAuthSessionContract(
            transportClient: forwardedTransportClient,
            forwardSignInCredentials: true,
          );
      forwardedContract.signIn(
        const AuthSignInRequest(
          email: 'designer@penjar.app',
          password: 'desktop-pass',
        ),
      );

      expect(forwardedTransportClient.executed, hasLength(1));
      final RemoteStubTransportRequest forwardedRequest =
          forwardedTransportClient.executed.single;
      expect(forwardedRequest.payload['email'], 'designer@penjar.app');
      expect(forwardedRequest.payload['passwordLength'], 12);
      expect(forwardedRequest.payload['password'], 'desktop-pass');
    });

    test('http transport client blocks operations when probe fails', () {
      final List<String> probedOperations = <String>[];
      final RemoteStubHttpTransportClient transportClient =
          RemoteStubHttpTransportClient(
            healthUrl: 'https://api.penjar.app/desktop/health?token=secret',
            blockedReason: 'Remote HTTP transport unavailable',
            probe: (RemoteStubHttpTransportProbeRequest request) {
              probedOperations.add(request.operation);
              expect(request.healthUrl, contains('/desktop/health'));
              expect(request.allowedStatusCodes, contains(200));
              expect(request.workflow, 'auth');
              expect(request.method, 'POST');
              expect(request.endpoint, '/api/desktop/auth/sign-in');
              expect(request.payload['email'], 'designer@penjar.app');
              expect(request.payload['passwordLength'], 12);
              return const RemoteStubHttpTransportProbeResult.blocked();
            },
          );
      expect(
        transportClient.profile.transportLabel,
        'http-health:https://api.penjar.app/desktop/health',
      );

      final RemoteStubAuthSessionContract authContract =
          RemoteStubAuthSessionContract(transportClient: transportClient);
      authContract.signIn(
        const AuthSignInRequest(
          email: 'designer@penjar.app',
          password: 'desktop-pass',
        ),
      );

      expect(probedOperations, <String>[RemoteStubOperationIds.signIn]);
      expect(authContract.state.signedIn, isFalse);
      expect(
        authContract.state.status,
        '[remote-stub] Remote HTTP transport unavailable: sign-in.',
      );
    });

    test('http transport client allows operations when probe succeeds', () {
      final RemoteStubHttpTransportClient transportClient =
          RemoteStubHttpTransportClient(
            healthUrl: 'http://127.0.0.1:28080/health',
            allowedStatusCodes: const <int>{200, 204},
            probe: (RemoteStubHttpTransportProbeRequest request) {
              expect(request.allowedStatusCodes, contains(204));
              expect(request.workflow, 'projects');
              expect(request.method, 'POST');
              expect(request.endpoint, '/api/desktop/projects');
              expect(request.payload['projectName'], 'HTTP Transport Ready');
              return const RemoteStubHttpTransportProbeResult.allowed();
            },
          );

      final RemoteStubProjectLifecycleContract projectContract =
          RemoteStubProjectLifecycleContract(transportClient: transportClient);
      projectContract.createProject('HTTP Transport Ready');

      expect(projectContract.state.projects, hasLength(2));
      expect(
        projectContract.state.status,
        '[remote-stub] Project created: HTTP Transport Ready.',
      );
    });

    test('http transport client blocks operation on backend execution error', () {
      final List<RemoteStubHttpBackendExecutionRequest> executedRequests =
          <RemoteStubHttpBackendExecutionRequest>[];
      final RemoteStubHttpTransportClient transportClient =
          RemoteStubHttpTransportClient(
            healthUrl: 'http://127.0.0.1:28080/health',
            backendBaseUrl: 'https://api.penjar.app',
            backendBlockedReason: 'Remote backend execution failed',
            probe: (_) => const RemoteStubHttpTransportProbeResult.allowed(),
            executionProbe: (RemoteStubHttpBackendExecutionRequest request) {
              executedRequests.add(request);
              expect(
                request.endpointUrl,
                'https://api.penjar.app/api/desktop/auth/sign-in',
              );
              expect(request.transportRequest.payload['passwordLength'], 12);
              return const RemoteStubHttpBackendExecutionResult.blocked(
                'Remote backend execution failed: sign-in. upstream timeout',
              );
            },
          );

      final RemoteStubAuthSessionContract authContract =
          RemoteStubAuthSessionContract(transportClient: transportClient);
      authContract.signIn(
        const AuthSignInRequest(
          email: 'designer@penjar.app',
          password: 'desktop-pass',
        ),
      );

      expect(executedRequests, hasLength(1));
      expect(authContract.state.signedIn, isFalse);
      expect(
        authContract.state.status,
        '[remote-stub] Remote backend execution failed: sign-in. upstream timeout',
      );
    });

    test(
      'http transport client applies auth backend error payload snapshots from execution probe',
      () {
        final RemoteStubHttpTransportClient transportClient =
            RemoteStubHttpTransportClient(
              backendBaseUrl: 'https://api.penjar.app',
              executionProbe: (RemoteStubHttpBackendExecutionRequest request) {
                expect(
                  request.endpointUrl,
                  'https://api.penjar.app/api/desktop/auth/token/refresh',
                );
                return RemoteStubHttpBackendExecutionResult.allowedWithPayload(
                  <String, Object?>{
                    'code': 401,
                    'message': 'Backend session expired.',
                    'state': <String, Object?>{
                      'sessionToken': 'stale-backend-session',
                    },
                  },
                );
              },
            );
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(
              transportClient: transportClient,
              initialState: const AuthSessionState(
                rememberSession: true,
                signedIn: true,
                status: 'Previously signed in.',
              ),
            );

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend session expired.',
        );
      },
    );

    test(
      'http transport client applies backend endpoint overrides for auth operations',
      () {
        final List<RemoteStubHttpBackendExecutionRequest> executedRequests =
            <RemoteStubHttpBackendExecutionRequest>[];
        final RemoteStubHttpTransportClient
        transportClient = RemoteStubHttpTransportClient(
          backendBaseUrl: 'https://api.penjar.app',
          backendEndpointOverrides: <String, String>{
            RemoteStubOperationIds.signIn: '/v2/auth/custom-sign-in',
          },
          executionProbe: (RemoteStubHttpBackendExecutionRequest request) {
            executedRequests.add(request);
            expect(
              request.transportRequest.endpoint,
              '/v2/auth/custom-sign-in',
            );
            expect(
              request.endpointUrl,
              'https://api.penjar.app/v2/auth/custom-sign-in',
            );
            return const RemoteStubHttpBackendExecutionResult.blocked(
              'Remote backend execution failed: sign-in. overridden endpoint unreachable',
            );
          },
        );
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.signIn(
          const AuthSignInRequest(
            email: 'designer@penjar.app',
            password: 'desktop-pass',
          ),
        );

        expect(executedRequests, hasLength(1));
        expect(
          authContract.state.status,
          '[remote-stub] Remote backend execution failed: sign-in. overridden endpoint unreachable',
        );
      },
    );

    test(
      'http transport client executes backend request and allows operation on success',
      () {
        final List<RemoteStubHttpBackendExecutionRequest> executedRequests =
            <RemoteStubHttpBackendExecutionRequest>[];
        final RemoteStubHttpTransportClient transportClient =
            RemoteStubHttpTransportClient(
              backendBaseUrl: 'https://api.penjar.app/v1',
              executionProbe: (RemoteStubHttpBackendExecutionRequest request) {
                executedRequests.add(request);
                expect(request.transportRequest.workflow, 'projects');
                expect(
                  request.endpointUrl,
                  'https://api.penjar.app/v1/api/desktop/projects',
                );
                return RemoteStubHttpBackendExecutionResult.allowedWithPayload(
                  <String, Object?>{
                    'status': 'Backend project snapshot applied.',
                    'state': <String, Object?>{
                      'projects': <Map<String, Object?>>[
                        <String, Object?>{
                          'id': 'project-backend',
                          'name': 'Backend Execution Workspace',
                          'files': <String>['backend-file.penjar'],
                        },
                      ],
                      'selectedProjectIndex': 0,
                    },
                  },
                );
              },
            );

        final RemoteStubProjectLifecycleContract projectContract =
            RemoteStubProjectLifecycleContract(
              transportClient: transportClient,
            );
        projectContract.createProject('Backend Execution Ready');

        expect(executedRequests, hasLength(1));
        expect(projectContract.state.projects, hasLength(1));
        expect(
          projectContract.state.selectedProject.name,
          'Backend Execution Workspace',
        );
        expect(projectContract.state.selectedProject.files, <String>[
          'backend-file.penjar',
        ]);
        expect(
          projectContract.state.status,
          '[remote-stub] Backend project snapshot applied.',
        );
      },
    );

    test(
      'applies backend response payload snapshots across all workflow adapters',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.signIn: <String, Object?>{
                'status': 'Backend auth snapshot applied.',
                'state': <String, Object?>{
                  'rememberSession': true,
                  'signedIn': false,
                },
              },
              RemoteStubOperationIds.createProject: <String, Object?>{
                'status': 'Backend project snapshot applied.',
                'state': <String, Object?>{
                  'projects': <Map<String, Object?>>[
                    <String, Object?>{
                      'id': 'project-remote',
                      'name': 'Remote Project',
                      'files': <String>['remote.penjar'],
                    },
                  ],
                  'selectedProjectIndex': 0,
                },
              },
              RemoteStubOperationIds.createRectangle: <String, Object?>{
                'status': 'Backend canvas snapshot applied.',
                'state': <String, Object?>{
                  'shapes': <Map<String, Object?>>[
                    <String, Object?>{
                      'id': 'rect-remote',
                      'x': 41.0,
                      'y': 22.0,
                      'width': 180.0,
                      'height': 90.0,
                      'fillHex': '#112233',
                    },
                  ],
                  'selectedIndex': 0,
                },
              },
              RemoteStubOperationIds.importAsset: <String, Object?>{
                'status': 'Backend asset snapshot applied.',
                'state': <String, Object?>{
                  'assets': <Map<String, Object?>>[
                    <String, Object?>{
                      'id': 'asset-remote',
                      'name': 'hero-remote.png',
                      'type': 'image',
                      'usedCount': 9,
                    },
                  ],
                  'selectedAssetIndex': 0,
                },
              },
              RemoteStubOperationIds.createThread: <String, Object?>{
                'status': 'Backend collaboration snapshot applied.',
                'state': <String, Object?>{
                  'peerActive': true,
                  'threads': <Map<String, Object?>>[
                    <String, Object?>{
                      'id': 'thread-remote',
                      'title': 'Backend Review',
                    },
                  ],
                  'selectedThreadIndex': 0,
                },
              },
              RemoteStubOperationIds.generateSnippet: <String, Object?>{
                'status': 'Backend inspect snapshot applied.',
                'state': <String, Object?>{
                  'target': 'swiftui',
                  'snippet': 'Text("Remote")',
                },
              },
              RemoteStubOperationIds.runExport: <String, Object?>{
                'status': 'Backend export snapshot applied.',
                'state': <String, Object?>{
                  'artifacts': <Map<String, Object?>>[
                    <String, Object?>{
                      'id': 'export-remote',
                      'fileName': 'remote-landing',
                      'format': 'svg',
                      'scale': '3x',
                      'includeBackground': false,
                    },
                  ],
                },
              },
              RemoteStubOperationIds.runHealthCheck: <String, Object?>{
                'status': 'Backend diagnostics snapshot applied.',
                'state': <String, Object?>{
                  'websocketHealthy': false,
                  'mcpHealthy': true,
                  'reconnectAttempts': 7,
                },
              },
            });

        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);
        final RemoteStubProjectLifecycleContract projectContract =
            RemoteStubProjectLifecycleContract(
              transportClient: transportClient,
            );
        final RemoteStubCanvasEditingContract canvasContract =
            RemoteStubCanvasEditingContract(transportClient: transportClient);
        final RemoteStubAssetManagementContract assetContract =
            RemoteStubAssetManagementContract(transportClient: transportClient);
        final RemoteStubCollaborationContextContract collaborationContract =
            RemoteStubCollaborationContextContract(
              transportClient: transportClient,
            );
        final RemoteStubInspectHandoffContract inspectContract =
            RemoteStubInspectHandoffContract(transportClient: transportClient);
        final RemoteStubExportWorkflowContract exportContract =
            RemoteStubExportWorkflowContract(transportClient: transportClient);
        final RemoteStubDiagnosticsRecoveryContract diagnosticsContract =
            RemoteStubDiagnosticsRecoveryContract(
              transportClient: transportClient,
            );

        authContract.signIn(
          const AuthSignInRequest(
            email: 'designer@penjar.app',
            password: 'desktop-pass',
          ),
        );
        expect(authContract.state.rememberSession, isTrue);
        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend auth snapshot applied.',
        );

        projectContract.createProject('Ignored Name');
        expect(projectContract.state.projects, hasLength(1));
        expect(projectContract.state.selectedProject.name, 'Remote Project');
        expect(projectContract.state.selectedProject.files, <String>[
          'remote.penjar',
        ]);
        expect(
          projectContract.state.status,
          '[remote-stub] Backend project snapshot applied.',
        );

        canvasContract.createRectangle();
        expect(canvasContract.state.shapes, hasLength(1));
        expect(canvasContract.state.selectedShape?.id, 'rect-remote');
        expect(canvasContract.state.selectedShape?.fillHex, '#112233');
        expect(
          canvasContract.state.status,
          '[remote-stub] Backend canvas snapshot applied.',
        );

        assetContract.importAsset('ignored.png', 'image');
        expect(assetContract.state.assets, hasLength(1));
        expect(assetContract.state.selectedAsset?.name, 'hero-remote.png');
        expect(assetContract.state.selectedAsset?.usedCount, 9);
        expect(
          assetContract.state.status,
          '[remote-stub] Backend asset snapshot applied.',
        );

        collaborationContract.createThread('Ignored Thread');
        expect(collaborationContract.state.peerActive, isTrue);
        expect(collaborationContract.state.threads, hasLength(1));
        expect(
          collaborationContract.state.selectedThread?.title,
          'Backend Review',
        );
        expect(
          collaborationContract.state.status,
          '[remote-stub] Backend collaboration snapshot applied.',
        );

        inspectContract.generateSnippet('button/primary');
        expect(inspectContract.state.target, 'swiftui');
        expect(inspectContract.state.snippet, 'Text("Remote")');
        expect(
          inspectContract.state.status,
          '[remote-stub] Backend inspect snapshot applied.',
        );

        exportContract.runExport(
          const ExportRequest(
            fileName: 'ignored',
            format: 'png',
            scale: '1x',
            includeBackground: true,
          ),
        );
        expect(exportContract.state.artifacts, hasLength(1));
        expect(exportContract.state.latestArtifact?.fileName, 'remote-landing');
        expect(exportContract.state.latestArtifact?.format, 'svg');
        expect(exportContract.state.latestArtifact?.scale, '3x');
        expect(exportContract.state.latestArtifact?.includeBackground, isFalse);
        expect(
          exportContract.state.status,
          '[remote-stub] Backend export snapshot applied.',
        );

        diagnosticsContract.runHealthCheck();
        expect(diagnosticsContract.state.websocketHealthy, isFalse);
        expect(diagnosticsContract.state.mcpHealthy, isTrue);
        expect(diagnosticsContract.state.reconnectAttempts, 7);
        expect(
          diagnosticsContract.state.status,
          '[remote-stub] Backend diagnostics snapshot applied.',
        );
      },
    );

    test('supports nested backend response envelopes and message aliases', () {
      final _BackendResponseTransportClient transportClient =
          _BackendResponseTransportClient(<String, Map<String, Object?>>{
            RemoteStubOperationIds.signIn: <String, Object?>{
              'payload': <String, Object?>{
                'detail': 'Backend auth payload envelope applied.',
                'authState': <String, Object?>{
                  'rememberSession': true,
                  'signedIn': true,
                },
              },
            },
            RemoteStubOperationIds.createProject: <String, Object?>{
              'result': <String, Object?>{
                'payload': <String, Object?>{
                  'message': 'Backend project nested payload envelope applied.',
                  'workflowState': <String, Object?>{
                    'projects': <Map<String, Object?>>[
                      <String, Object?>{
                        'id': 'project-envelope',
                        'name': 'Envelope Project',
                        'files': <String>['envelope.penjar'],
                      },
                    ],
                    'selectedProjectIndex': 0,
                  },
                },
              },
            },
          });
      final RemoteStubAuthSessionContract authContract =
          RemoteStubAuthSessionContract(transportClient: transportClient);
      final RemoteStubProjectLifecycleContract projectContract =
          RemoteStubProjectLifecycleContract(transportClient: transportClient);

      authContract.signIn(
        const AuthSignInRequest(
          email: 'designer@penjar.app',
          password: 'desktop-pass',
        ),
      );
      expect(authContract.state.rememberSession, isTrue);
      expect(authContract.state.signedIn, isTrue);
      expect(
        authContract.state.status,
        '[remote-stub] Backend auth payload envelope applied.',
      );

      projectContract.createProject('ignored');
      expect(projectContract.state.projects, hasLength(1));
      expect(projectContract.state.selectedProject.name, 'Envelope Project');
      expect(projectContract.state.selectedProject.files, <String>[
        'envelope.penjar',
      ]);
      expect(
        projectContract.state.status,
        '[remote-stub] Backend project nested payload envelope applied.',
      );
    });

    test(
      'project backend sibling data envelope is used when result envelope lacks workflow state',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.createProject: <String, Object?>{
                'result': <String, Object?>{
                  'meta': <String, Object?>{'requestId': 'req-project-1'},
                },
                'data': <String, Object?>{
                  'detail': 'Backend sibling data project snapshot applied.',
                  'workflowState': <String, Object?>{
                    'projects': <Map<String, Object?>>[
                      <String, Object?>{
                        'id': 'project-sibling-envelope',
                        'name': 'Sibling Envelope Project',
                        'files': <String>['sibling-envelope.penjar'],
                      },
                    ],
                    'selectedProjectIndex': 0,
                  },
                },
              },
            });
        final RemoteStubProjectLifecycleContract projectContract =
            RemoteStubProjectLifecycleContract(
              transportClient: transportClient,
            );

        projectContract.createProject('ignored');

        expect(projectContract.state.projects, hasLength(1));
        expect(
          projectContract.state.selectedProject.name,
          'Sibling Envelope Project',
        );
        expect(projectContract.state.selectedProject.files, <String>[
          'sibling-envelope.penjar',
        ]);
        expect(
          projectContract.state.status,
          '[remote-stub] Backend sibling data project snapshot applied.',
        );
      },
    );

    test(
      'file backend sibling data envelope is used when result envelope lacks workflow state',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.createFile: <String, Object?>{
                'result': <String, Object?>{
                  'meta': <String, Object?>{'requestId': 'req-file-1'},
                },
                'data': <String, Object?>{
                  'detail': 'Backend sibling data file snapshot applied.',
                  'workflowState': <String, Object?>{
                    'projects': <Map<String, Object?>>[
                      <String, Object?>{
                        'id': 'project-core',
                        'name': 'Core Product',
                        'files': <String>['landing.penjar', 'spec.penjar'],
                      },
                    ],
                    'selectedProjectIndex': 0,
                  },
                },
              },
            });
        final RemoteStubProjectLifecycleContract projectContract =
            RemoteStubProjectLifecycleContract(
              transportClient: transportClient,
            );

        projectContract.createFile('ignored');

        expect(projectContract.state.selectedProject.files, <String>[
          'landing.penjar',
          'spec.penjar',
        ]);
        expect(
          projectContract.state.status,
          '[remote-stub] Backend sibling data file snapshot applied.',
        );
      },
    );

    test(
      'canvas backend sibling data envelope is used when result envelope lacks canvas state',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.createRectangle: <String, Object?>{
                'result': <String, Object?>{
                  'meta': <String, Object?>{'requestId': 'req-canvas-1'},
                },
                'data': <String, Object?>{
                  'detail': 'Backend sibling data canvas snapshot applied.',
                  'canvasState': <String, Object?>{
                    'shapes': <Map<String, Object?>>[
                      <String, Object?>{
                        'id': 'rect-sibling',
                        'x': 32.0,
                        'y': 18.0,
                        'width': 144.0,
                        'height': 96.0,
                        'fillHex': '#FF8A00',
                      },
                    ],
                    'selectedIndex': 0,
                  },
                },
              },
            });
        final RemoteStubCanvasEditingContract canvasContract =
            RemoteStubCanvasEditingContract(transportClient: transportClient);

        canvasContract.createRectangle();

        expect(canvasContract.state.shapes, hasLength(1));
        expect(canvasContract.state.selectedShape?.id, 'rect-sibling');
        expect(canvasContract.state.selectedShape?.fillHex, '#FF8A00');
        expect(
          canvasContract.state.status,
          '[remote-stub] Backend sibling data canvas snapshot applied.',
        );
      },
    );

    test(
      'asset backend sibling data envelope is used when result envelope lacks asset state',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.importAsset: <String, Object?>{
                'result': <String, Object?>{
                  'meta': <String, Object?>{'requestId': 'req-asset-1'},
                },
                'data': <String, Object?>{
                  'detail': 'Backend sibling data asset snapshot applied.',
                  'assetState': <String, Object?>{
                    'assets': <Map<String, Object?>>[
                      <String, Object?>{
                        'id': 'asset-sibling',
                        'name': 'brand-kit.png',
                        'type': 'image',
                        'usedCount': 2,
                      },
                    ],
                    'selectedAssetIndex': 0,
                  },
                },
              },
            });
        final RemoteStubAssetManagementContract assetContract =
            RemoteStubAssetManagementContract(transportClient: transportClient);

        assetContract.importAsset('ignored', 'image');

        expect(assetContract.state.assets, hasLength(1));
        expect(assetContract.state.selectedAsset?.id, 'asset-sibling');
        expect(assetContract.state.selectedAsset?.name, 'brand-kit.png');
        expect(assetContract.state.selectedAsset?.usedCount, 2);
        expect(
          assetContract.state.status,
          '[remote-stub] Backend sibling data asset snapshot applied.',
        );
      },
    );

    test(
      'collaboration backend sibling data envelope is used when result envelope lacks collaboration state',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.createThread: <String, Object?>{
                'result': <String, Object?>{
                  'meta': <String, Object?>{'requestId': 'req-collaboration-1'},
                },
                'data': <String, Object?>{
                  'detail':
                      'Backend sibling data collaboration snapshot applied.',
                  'collaborationState': <String, Object?>{
                    'peerActive': true,
                    'threads': <Map<String, Object?>>[
                      <String, Object?>{
                        'id': 'thread-sibling',
                        'title': 'Backend Review',
                      },
                    ],
                    'selectedThreadIndex': 0,
                  },
                },
              },
            });
        final RemoteStubCollaborationContextContract collaborationContract =
            RemoteStubCollaborationContextContract(
              transportClient: transportClient,
            );

        collaborationContract.createThread('ignored');

        expect(collaborationContract.state.peerActive, isTrue);
        expect(collaborationContract.state.threads, hasLength(1));
        expect(
          collaborationContract.state.selectedThread?.id,
          'thread-sibling',
        );
        expect(
          collaborationContract.state.selectedThread?.title,
          'Backend Review',
        );
        expect(
          collaborationContract.state.status,
          '[remote-stub] Backend sibling data collaboration snapshot applied.',
        );
      },
    );

    test(
      'inspect backend sibling data envelope is used when result envelope lacks inspect state',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.generateSnippet: <String, Object?>{
                'result': <String, Object?>{
                  'meta': <String, Object?>{'requestId': 'req-inspect-1'},
                },
                'data': <String, Object?>{
                  'detail': 'Backend sibling data inspect snapshot applied.',
                  'inspectState': <String, Object?>{
                    'target': 'swiftui',
                    'snippet': 'Text("Remote")',
                  },
                },
              },
            });
        final RemoteStubInspectHandoffContract inspectContract =
            RemoteStubInspectHandoffContract(transportClient: transportClient);

        inspectContract.generateSnippet('ignored');

        expect(inspectContract.state.target, 'swiftui');
        expect(inspectContract.state.snippet, 'Text("Remote")');
        expect(
          inspectContract.state.status,
          '[remote-stub] Backend sibling data inspect snapshot applied.',
        );
      },
    );

    test(
      'export backend sibling data envelope is used when result envelope lacks export state',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.runExport: <String, Object?>{
                'result': <String, Object?>{
                  'meta': <String, Object?>{'requestId': 'req-export-1'},
                },
                'data': <String, Object?>{
                  'detail': 'Backend sibling data export snapshot applied.',
                  'exportState': <String, Object?>{
                    'artifacts': <Map<String, Object?>>[
                      <String, Object?>{
                        'id': 'export-sibling',
                        'fileName': 'remote-landing',
                        'format': 'svg',
                        'scale': '3x',
                        'includeBackground': false,
                      },
                    ],
                  },
                },
              },
            });
        final RemoteStubExportWorkflowContract exportContract =
            RemoteStubExportWorkflowContract(transportClient: transportClient);

        exportContract.runExport(
          const ExportRequest(
            fileName: 'ignored',
            format: 'png',
            scale: '2x',
            includeBackground: true,
          ),
        );

        expect(exportContract.state.artifacts, hasLength(1));
        expect(exportContract.state.latestArtifact?.id, 'export-sibling');
        expect(
          exportContract.state.latestArtifact?.outputPath,
          '/exports/remote-landing.svg',
        );
        expect(
          exportContract.state.status,
          '[remote-stub] Backend sibling data export snapshot applied.',
        );
      },
    );

    test(
      'diagnostics backend sibling data envelope is used when result envelope lacks diagnostics state',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.runHealthCheck: <String, Object?>{
                'result': <String, Object?>{
                  'meta': <String, Object?>{'requestId': 'req-diagnostics-1'},
                },
                'data': <String, Object?>{
                  'detail':
                      'Backend sibling data diagnostics snapshot applied.',
                  'diagnosticsState': <String, Object?>{
                    'websocketHealthy': false,
                    'mcpHealthy': true,
                    'reconnectAttempts': 7,
                  },
                },
              },
            });
        final RemoteStubDiagnosticsRecoveryContract diagnosticsContract =
            RemoteStubDiagnosticsRecoveryContract(
              transportClient: transportClient,
            );

        diagnosticsContract.runHealthCheck();

        expect(diagnosticsContract.state.websocketHealthy, isFalse);
        expect(diagnosticsContract.state.mcpHealthy, isTrue);
        expect(diagnosticsContract.state.reconnectAttempts, 7);
        expect(
          diagnosticsContract.state.status,
          '[remote-stub] Backend sibling data diagnostics snapshot applied.',
        );
      },
    );

    test(
      'supports deep backend response envelope chains beyond four levels',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.signIn: <String, Object?>{
                'result': <String, Object?>{
                  'data': <String, Object?>{
                    'payload': <String, Object?>{
                      'result': <String, Object?>{
                        'data': <String, Object?>{
                          'detail':
                              'Backend deep envelope auth snapshot applied.',
                          'authState': <String, Object?>{
                            'isAuthenticated': true,
                            'remember_session': true,
                          },
                        },
                      },
                    },
                  },
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.signIn(
          const AuthSignInRequest(
            email: 'designer@penjar.app',
            password: 'desktop-pass',
          ),
        );

        expect(authContract.state.rememberSession, isTrue);
        expect(authContract.state.signedIn, isTrue);
        expect(
          authContract.state.status,
          '[remote-stub] Backend deep envelope auth snapshot applied.',
        );
      },
    );

    test(
      'auth backend cyclic envelope references do not loop indefinitely',
      () {
        final Map<String, Object?> cyclicEnvelopePayload = <String, Object?>{
          'detail': 'Backend cyclic envelope auth snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        };
        cyclicEnvelopePayload['result'] = cyclicEnvelopePayload;

        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.signIn: cyclicEnvelopePayload,
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.signIn(
          const AuthSignInRequest(
            email: 'designer@penjar.app',
            password: 'desktop-pass',
          ),
        );

        expect(authContract.state.rememberSession, isTrue);
        expect(authContract.state.signedIn, isTrue);
        expect(
          authContract.state.status,
          '[remote-stub] Backend cyclic envelope auth snapshot applied.',
        );
      },
    );

    test(
      'auth backend envelope traversal skips cyclic wrapper keys when alternates exist',
      () {
        final Map<String, Object?> responsePayload = <String, Object?>{
          'data': <String, Object?>{
            'detail': 'Backend alternate envelope auth snapshot applied.',
            'authState': <String, Object?>{
              'signedIn': true,
              'rememberSession': true,
            },
          },
        };
        responsePayload['result'] = responsePayload;

        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.signIn: responsePayload,
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.signIn(
          const AuthSignInRequest(
            email: 'designer@penjar.app',
            password: 'desktop-pass',
          ),
        );

        expect(authContract.state.rememberSession, isTrue);
        expect(authContract.state.signedIn, isTrue);
        expect(
          authContract.state.status,
          '[remote-stub] Backend alternate envelope auth snapshot applied.',
        );
      },
    );

    test(
      'auth backend sibling data envelope is used when result envelope lacks state',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.signIn: <String, Object?>{
                'result': <String, Object?>{
                  'meta': <String, Object?>{'requestId': 'req-1'},
                },
                'data': <String, Object?>{
                  'detail': 'Backend sibling data auth snapshot applied.',
                  'authState': <String, Object?>{
                    'signedIn': true,
                    'rememberSession': true,
                  },
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.signIn(
          const AuthSignInRequest(
            email: 'designer@penjar.app',
            password: 'desktop-pass',
          ),
        );

        expect(authContract.state.rememberSession, isTrue);
        expect(authContract.state.signedIn, isTrue);
        expect(
          authContract.state.status,
          '[remote-stub] Backend sibling data auth snapshot applied.',
        );
      },
    );

    test(
      'auth backend payload infers signed-in from token/session aliases',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.signIn: <String, Object?>{
                'detail': 'Backend auth alias payload applied.',
                'state': <String, Object?>{
                  'remember': true,
                  'accessToken': 'access-token-from-backend',
                  'sessionId': 'session-from-backend',
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.signIn(
          const AuthSignInRequest(
            email: 'designer@penjar.app',
            password: 'desktop-pass',
          ),
        );

        expect(authContract.state.rememberSession, isTrue);
        expect(authContract.state.signedIn, isTrue);
        expect(
          authContract.state.status,
          '[remote-stub] Backend auth alias payload applied.',
        );
      },
    );

    test(
      'auth backend explicit signed-out state overrides token/session aliases',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.signIn: <String, Object?>{
                'status': 'Backend auth alias payload applied.',
                'state': <String, Object?>{
                  'signedIn': false,
                  'accessToken': 'ignored-for-explicit-sign-out',
                  'sessionId': 'ignored-for-explicit-sign-out',
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.signIn(
          const AuthSignInRequest(
            email: 'designer@penjar.app',
            password: 'desktop-pass',
          ),
        );

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend auth alias payload applied.',
        );
      },
    );

    test(
      'auth backend nested auth/session/token payload aliases are normalized',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'detail': 'Backend nested auth payload applied.',
                'state': <String, Object?>{
                  'authentication': <String, Object?>{
                    'persistSession': true,
                    'authenticated': true,
                    'user': <String, Object?>{'id': 'user-1'},
                  },
                  'session': <String, Object?>{
                    'sessionId': 'session-from-nested-payload',
                  },
                  'tokens': <String, Object?>{
                    'accessToken': 'access-token-from-nested-payload',
                    'refreshToken': 'refresh-token-from-nested-payload',
                  },
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.rememberSession, isTrue);
        expect(authContract.state.signedIn, isTrue);
        expect(
          authContract.state.status,
          '[remote-stub] Backend nested auth payload applied.',
        );
      },
    );

    test(
      'auth backend snake_case signed_in and remember_session aliases are normalized',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'detail': 'Backend snake-case auth payload applied.',
                'state': <String, Object?>{
                  'signed_in': true,
                  'remember_session': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.rememberSession, isTrue);
        expect(authContract.state.signedIn, isTrue);
        expect(
          authContract.state.status,
          '[remote-stub] Backend snake-case auth payload applied.',
        );
      },
    );

    test(
      'auth backend snake_case is_signed_in and remember_session aliases are normalized',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'detail':
                    'Backend snake-case is_signed_in auth payload applied.',
                'state': <String, Object?>{
                  'is_signed_in': true,
                  'remember_session': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.rememberSession, isTrue);
        expect(authContract.state.signedIn, isTrue);
        expect(
          authContract.state.status,
          '[remote-stub] Backend snake-case is_signed_in auth payload applied.',
        );
      },
    );

    test(
      'auth backend logged_in and persist_session aliases are normalized',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'detail': 'Backend logged-in auth payload applied.',
                'state': <String, Object?>{
                  'logged_in': true,
                  'persist_session': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.rememberSession, isTrue);
        expect(authContract.state.signedIn, isTrue);
        expect(
          authContract.state.status,
          '[remote-stub] Backend logged-in auth payload applied.',
        );
      },
    );

    test('auth backend loggedIn and persistSession aliases are normalized', () {
      final _BackendResponseTransportClient transportClient =
          _BackendResponseTransportClient(<String, Map<String, Object?>>{
            RemoteStubOperationIds.restoreSession: <String, Object?>{
              'detail': 'Backend loggedIn auth payload applied.',
              'state': <String, Object?>{
                'loggedIn': true,
                'persistSession': true,
              },
            },
          });
      final RemoteStubAuthSessionContract authContract =
          RemoteStubAuthSessionContract(transportClient: transportClient);

      authContract.restoreSession();

      expect(authContract.state.rememberSession, isTrue);
      expect(authContract.state.signedIn, isTrue);
      expect(
        authContract.state.status,
        '[remote-stub] Backend loggedIn auth payload applied.',
      );
    });

    test(
      'auth backend snake_case signed_in alias overrides unauthorized code inference',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'code': 'AUTH_REQUIRED',
                'state': <String, Object?>{
                  'signed_in': true,
                  'remember_session': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend is_signed_in alias overrides unauthorized code inference',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'code': 'AUTH_REQUIRED',
                'state': <String, Object?>{
                  'is_signed_in': true,
                  'remember_session': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend is_logged_in alias overrides unauthorized code inference',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'code': 'AUTH_REQUIRED',
                'state': <String, Object?>{
                  'is_logged_in': true,
                  'persist_session': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend isLoggedIn alias overrides unauthorized code inference',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'code': 'AUTH_REQUIRED',
                'state': <String, Object?>{
                  'isLoggedIn': true,
                  'persistSession': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    for (final String signedOutAlias in const <String>[
      'signedOut',
      'isSignedOut',
      'loggedOut',
      'isLoggedOut',
      'signed_out',
      'is_signed_out',
      'logged_out',
      'is_logged_out',
    ]) {
      test(
        'auth backend $signedOutAlias alias without explicit status maps authentication-required fallback status',
        () {
          final Map<String, Object?> statePayload = <String, Object?>{
            signedOutAlias: true,
            'sessionToken': 'stale-session-token',
          };
          final _BackendResponseTransportClient transportClient =
              _BackendResponseTransportClient(<String, Map<String, Object?>>{
                RemoteStubOperationIds.refreshToken: <String, Object?>{
                  'state': statePayload,
                },
              });
          final RemoteStubAuthSessionContract authContract =
              RemoteStubAuthSessionContract(transportClient: transportClient);

          authContract.refreshToken();

          expect(authContract.state.signedIn, isFalse);
          expect(
            authContract.state.status,
            '[remote-stub] Authentication required.',
          );
        },
      );

      test(
        'auth backend explicit signedIn alias overrides $signedOutAlias alias',
        () {
          final Map<String, Object?> statePayload = <String, Object?>{
            'signedIn': true,
            signedOutAlias: true,
            'remember_session': true,
          };
          final _BackendResponseTransportClient transportClient =
              _BackendResponseTransportClient(<String, Map<String, Object?>>{
                RemoteStubOperationIds.restoreSession: <String, Object?>{
                  'state': statePayload,
                },
              });
          final RemoteStubAuthSessionContract authContract =
              RemoteStubAuthSessionContract(transportClient: transportClient);

          authContract.restoreSession();

          expect(authContract.state.signedIn, isTrue);
          expect(authContract.state.rememberSession, isTrue);
        },
      );
    }

    test(
      'auth backend nested explicit signed-out aliases override token inference',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'status': 'Backend nested auth payload applied.',
                'state': <String, Object?>{
                  'authentication': <String, Object?>{'authenticated': false},
                  'tokens': <String, Object?>{
                    'accessToken': 'access-token-that-should-not-force-sign-in',
                  },
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend nested auth payload applied.',
        );
      },
    );

    test(
      'auth backend cyclic error containers do not recurse indefinitely',
      () {
        final Map<String, Object?> cyclicError = <String, Object?>{};
        final List<Object?> cyclicFailures = <Object?>[];
        cyclicError['error'] = cyclicError;
        cyclicError['failures'] = cyclicFailures;
        cyclicFailures.add(cyclicError);
        cyclicFailures.add(cyclicFailures);

        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'message': 'Backend cyclic payload handled.',
                'error': cyclicError,
                'failures': cyclicFailures,
                'state': <String, Object?>{
                  'signedIn': true,
                  'rememberSession': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
        expect(
          authContract.state.status,
          '[remote-stub] Backend cyclic payload handled.',
        );
      },
    );

    final List<_AuthBackendFixtureCase>
    authBackendContractFixtures = <_AuthBackendFixtureCase>[
      const _AuthBackendFixtureCase(
        name: 'nested auth/session alias normalization',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'state': <String, Object?>{
            'authentication': <String, Object?>{
              'persistSession': true,
              'authenticated': true,
            },
            'tokens': <String, Object?>{'accessToken': 'fixture-access-token'},
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
      ),
      const _AuthBackendFixtureCase(
        name: 'sign-in result envelope with authState alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'message': 'Fixture sign-in result envelope applied.',
            'authState': <String, Object?>{
              'isAuthenticated': true,
              'remember': true,
              'tokens': <String, Object?>{
                'accessToken': 'fixture-result-envelope-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in result envelope applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope with authState isAuthenticated alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail':
                'Fixture sign-in data envelope isAuthenticated alias applied.',
            'authState': <String, Object?>{
              'isAuthenticated': true,
              'remember': true,
              'tokens': <String, Object?>{
                'accessToken': 'fixture-data-envelope-isauthenticated-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in data envelope isAuthenticated alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'sign-in payload envelope with authState alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'payload': <String, Object?>{
            'detail': 'Fixture sign-in payload envelope applied.',
            'authState': <String, Object?>{
              'signed_in': true,
              'remember_session': true,
              'tokens': <String, Object?>{
                'accessToken': 'fixture-payload-envelope-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in payload envelope applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'sign-in data envelope with authState loggedIn alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail': 'Fixture sign-in data envelope loggedIn applied.',
            'authState': <String, Object?>{
              'loggedIn': true,
              'persistSession': true,
              'tokens': <String, Object?>{
                'accessToken': 'fixture-data-envelope-loggedin-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in data envelope loggedIn applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'sign-in result envelope with authState loggedIn alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail': 'Fixture sign-in result envelope loggedIn applied.',
            'authState': <String, Object?>{
              'loggedIn': true,
              'persistSession': true,
              'tokens': <String, Object?>{
                'accessToken': 'fixture-result-envelope-loggedin-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in result envelope loggedIn applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'sign-in result envelope with authState isLoggedIn alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail': 'Fixture sign-in result envelope isLoggedIn applied.',
            'authState': <String, Object?>{
              'isLoggedIn': true,
              'persistSession': true,
              'tokens': <String, Object?>{
                'accessToken': 'fixture-result-envelope-isloggedin-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in result envelope isLoggedIn applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'sign-in data envelope with authState isLoggedIn alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail': 'Fixture sign-in data envelope isLoggedIn applied.',
            'authState': <String, Object?>{
              'isLoggedIn': true,
              'persistSession': true,
              'tokens': <String, Object?>{
                'accessToken': 'fixture-data-envelope-isloggedin-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in data envelope isLoggedIn applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope with authState is_authenticated alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail':
                'Fixture sign-in data envelope is_authenticated alias applied.',
            'authState': <String, Object?>{
              'is_authenticated': true,
              'remember_session': true,
              'tokens': <String, Object?>{
                'accessToken': 'fixture-data-envelope-is-authenticated-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in data envelope is_authenticated alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope with authState is_authenticated alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture sign-in result envelope is_authenticated alias applied.',
            'authState': <String, Object?>{
              'is_authenticated': true,
              'remember_session': true,
              'tokens': <String, Object?>{
                'accessToken': 'fixture-result-envelope-is-authenticated-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in result envelope is_authenticated alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'sign-in result envelope with authState signedIn alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail': 'Fixture sign-in result envelope signedIn alias applied.',
            'authState': <String, Object?>{
              'signedIn': true,
              'persistSession': true,
              'tokens': <String, Object?>{
                'accessToken': 'fixture-result-envelope-signedin-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in result envelope signedIn alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'sign-in data envelope with authState signedIn alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail': 'Fixture sign-in data envelope signedIn alias applied.',
            'authState': <String, Object?>{
              'signedIn': true,
              'persistSession': true,
              'tokens': <String, Object?>{
                'accessToken': 'fixture-data-envelope-signedin-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in data envelope signedIn alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope with authState authenticated alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail':
                'Fixture sign-in data envelope authenticated alias applied.',
            'authState': <String, Object?>{
              'authenticated': true,
              'remember': true,
              'tokens': <String, Object?>{
                'accessToken': 'fixture-data-envelope-authenticated-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in data envelope authenticated alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope with authState authenticated alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture sign-in result envelope authenticated alias applied.',
            'authState': <String, Object?>{
              'authenticated': true,
              'remember': true,
              'tokens': <String, Object?>{
                'accessToken': 'fixture-result-envelope-authenticated-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in result envelope authenticated alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'sign-in data envelope with authState logged_in alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail': 'Fixture sign-in data envelope logged_in alias applied.',
            'authState': <String, Object?>{
              'logged_in': true,
              'remember_session': true,
              'tokens': <String, Object?>{
                'accessToken': 'fixture-data-envelope-logged-underscore-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in data envelope logged_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'sign-in result envelope with authState logged_in alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture sign-in result envelope logged_in alias applied.',
            'authState': <String, Object?>{
              'logged_in': true,
              'remember_session': true,
              'tokens': <String, Object?>{
                'accessToken':
                    'fixture-result-envelope-logged-underscore-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in result envelope logged_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'sign-in data envelope with authState is_logged_in alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail':
                'Fixture sign-in data envelope is_logged_in alias applied.',
            'authState': <String, Object?>{
              'is_logged_in': true,
              'remember_session': true,
              'tokens': <String, Object?>{
                'accessToken':
                    'fixture-data-envelope-is-logged-underscore-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in data envelope is_logged_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope with authState is_logged_in alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture sign-in result envelope is_logged_in alias applied.',
            'authState': <String, Object?>{
              'is_logged_in': true,
              'remember_session': true,
              'tokens': <String, Object?>{
                'accessToken':
                    'fixture-result-envelope-is-logged-underscore-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in result envelope is_logged_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'sign-in data envelope with authState is_signed_in alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail':
                'Fixture sign-in data envelope is_signed_in alias applied.',
            'authState': <String, Object?>{
              'is_signed_in': true,
              'remember_session': true,
              'tokens': <String, Object?>{
                'accessToken': 'fixture-data-envelope-is-signed-in-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in data envelope is_signed_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope with authState is_signed_in alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture sign-in result envelope is_signed_in alias applied.',
            'authState': <String, Object?>{
              'is_signed_in': true,
              'remember_session': true,
              'tokens': <String, Object?>{
                'accessToken': 'fixture-result-envelope-is-signed-in-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in result envelope is_signed_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'sign-in data envelope with authState signed_in alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail': 'Fixture sign-in data envelope signed_in alias applied.',
            'authState': <String, Object?>{
              'signed_in': true,
              'remember_session': true,
              'tokens': <String, Object?>{
                'accessToken': 'fixture-data-envelope-signed-in-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in data envelope signed_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'sign-in result envelope with authState signed_in alias success',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture sign-in result envelope signed_in alias applied.',
            'authState': <String, Object?>{
              'signed_in': true,
              'remember_session': true,
              'tokens': <String, Object?>{
                'accessToken': 'fixture-result-envelope-signed-in-token',
              },
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture sign-in result envelope signed_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState isAuthenticated alias success',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture refresh result envelope isAuthenticated alias applied.',
            'authState': <String, Object?>{
              'isAuthenticated': true,
              'remember': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture refresh result envelope isAuthenticated alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState isAuthenticated alias success',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail':
                'Fixture refresh data envelope isAuthenticated alias applied.',
            'authState': <String, Object?>{
              'isAuthenticated': true,
              'remember': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture refresh data envelope isAuthenticated alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'refresh-token data envelope authState loggedIn alias success',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail': 'Fixture refresh data envelope loggedIn alias applied.',
            'authState': <String, Object?>{
              'loggedIn': true,
              'persistSession': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture refresh data envelope loggedIn alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'refresh-token result envelope authState loggedIn alias success',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail': 'Fixture refresh result envelope loggedIn alias applied.',
            'authState': <String, Object?>{
              'loggedIn': true,
              'persistSession': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture refresh result envelope loggedIn alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState isLoggedIn alias success',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture refresh result envelope isLoggedIn alias applied.',
            'authState': <String, Object?>{
              'isLoggedIn': true,
              'persistSession': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture refresh result envelope isLoggedIn alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'refresh-token data envelope authState isLoggedIn alias success',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail': 'Fixture refresh data envelope isLoggedIn alias applied.',
            'authState': <String, Object?>{
              'isLoggedIn': true,
              'persistSession': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture refresh data envelope isLoggedIn alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState is_authenticated alias success',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail':
                'Fixture refresh data envelope is_authenticated alias applied.',
            'authState': <String, Object?>{
              'is_authenticated': true,
              'remember_session': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture refresh data envelope is_authenticated alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState is_authenticated alias success',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture refresh result envelope is_authenticated alias applied.',
            'authState': <String, Object?>{
              'is_authenticated': true,
              'remember_session': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture refresh result envelope is_authenticated alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'refresh-token result envelope authState signedIn alias success',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail': 'Fixture refresh result envelope signedIn alias applied.',
            'authState': <String, Object?>{
              'signedIn': true,
              'persistSession': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture refresh result envelope signedIn alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'refresh-token data envelope authState signedIn alias success',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail': 'Fixture refresh data envelope signedIn alias applied.',
            'authState': <String, Object?>{
              'signedIn': true,
              'persistSession': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture refresh data envelope signedIn alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState authenticated alias success',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail':
                'Fixture refresh data envelope authenticated alias applied.',
            'authState': <String, Object?>{
              'authenticated': true,
              'remember': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture refresh data envelope authenticated alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState authenticated alias success',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture refresh result envelope authenticated alias applied.',
            'authState': <String, Object?>{
              'authenticated': true,
              'remember': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture refresh result envelope authenticated alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'refresh-token result envelope authState signed_in alias success',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture refresh result envelope signed_in alias applied.',
            'authState': <String, Object?>{
              'signed_in': true,
              'remember_session': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture refresh result envelope signed_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'refresh-token data envelope authState signed_in alias success',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail': 'Fixture refresh data envelope signed_in alias applied.',
            'authState': <String, Object?>{
              'signed_in': true,
              'remember_session': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture refresh data envelope signed_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState is_signed_in alias success',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture refresh result envelope is_signed_in alias applied.',
            'authState': <String, Object?>{
              'is_signed_in': true,
              'remember_session': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture refresh result envelope is_signed_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState is_signed_in alias success',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail':
                'Fixture refresh data envelope is_signed_in alias applied.',
            'authState': <String, Object?>{
              'is_signed_in': true,
              'remember_session': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture refresh data envelope is_signed_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'refresh-token result envelope authState logged_in alias success',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture refresh result envelope logged_in alias applied.',
            'authState': <String, Object?>{
              'logged_in': true,
              'remember_session': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture refresh result envelope logged_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'refresh-token data envelope authState logged_in alias success',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail': 'Fixture refresh data envelope logged_in alias applied.',
            'authState': <String, Object?>{
              'logged_in': true,
              'remember_session': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture refresh data envelope logged_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState is_logged_in alias success',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail':
                'Fixture refresh data envelope is_logged_in alias applied.',
            'authState': <String, Object?>{
              'is_logged_in': true,
              'remember_session': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture refresh data envelope is_logged_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState is_logged_in alias success',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture refresh result envelope is_logged_in alias applied.',
            'authState': <String, Object?>{
              'is_logged_in': true,
              'remember_session': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture refresh result envelope is_logged_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState isAuthenticated alias success',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture restore result envelope isAuthenticated alias applied.',
            'authState': <String, Object?>{
              'isAuthenticated': true,
              'remember': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture restore result envelope isAuthenticated alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState isAuthenticated alias success',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail':
                'Fixture restore data envelope isAuthenticated alias applied.',
            'authState': <String, Object?>{
              'isAuthenticated': true,
              'remember': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture restore data envelope isAuthenticated alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'restore-session data envelope authState loggedIn alias success',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail': 'Fixture restore data envelope loggedIn alias applied.',
            'authState': <String, Object?>{
              'loggedIn': true,
              'persistSession': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture restore data envelope loggedIn alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState loggedIn alias success',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail': 'Fixture restore result envelope loggedIn alias applied.',
            'authState': <String, Object?>{
              'loggedIn': true,
              'persistSession': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture restore result envelope loggedIn alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState isLoggedIn alias success',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture restore result envelope isLoggedIn alias applied.',
            'authState': <String, Object?>{
              'isLoggedIn': true,
              'persistSession': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture restore result envelope isLoggedIn alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState isLoggedIn alias success',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail': 'Fixture restore data envelope isLoggedIn alias applied.',
            'authState': <String, Object?>{
              'isLoggedIn': true,
              'persistSession': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture restore data envelope isLoggedIn alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState is_authenticated alias success',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail':
                'Fixture restore data envelope is_authenticated alias applied.',
            'authState': <String, Object?>{
              'is_authenticated': true,
              'remember_session': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture restore data envelope is_authenticated alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState is_authenticated alias success',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture restore result envelope is_authenticated alias applied.',
            'authState': <String, Object?>{
              'is_authenticated': true,
              'remember_session': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture restore result envelope is_authenticated alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState signedIn alias success',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail': 'Fixture restore result envelope signedIn alias applied.',
            'authState': <String, Object?>{
              'signedIn': true,
              'persistSession': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture restore result envelope signedIn alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'restore-session data envelope authState signedIn alias success',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail': 'Fixture restore data envelope signedIn alias applied.',
            'authState': <String, Object?>{
              'signedIn': true,
              'persistSession': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture restore data envelope signedIn alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState authenticated alias success',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail':
                'Fixture restore data envelope authenticated alias applied.',
            'authState': <String, Object?>{
              'authenticated': true,
              'remember': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture restore data envelope authenticated alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState authenticated alias success',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture restore result envelope authenticated alias applied.',
            'authState': <String, Object?>{
              'authenticated': true,
              'remember': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture restore result envelope authenticated alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState signed_in alias success',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture restore result envelope signed_in alias applied.',
            'authState': <String, Object?>{
              'signed_in': true,
              'remember_session': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture restore result envelope signed_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'restore-session data envelope authState signed_in alias success',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail': 'Fixture restore data envelope signed_in alias applied.',
            'authState': <String, Object?>{
              'signed_in': true,
              'remember_session': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture restore data envelope signed_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState is_signed_in alias success',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture restore result envelope is_signed_in alias applied.',
            'authState': <String, Object?>{
              'is_signed_in': true,
              'remember_session': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture restore result envelope is_signed_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState is_signed_in alias success',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail':
                'Fixture restore data envelope is_signed_in alias applied.',
            'authState': <String, Object?>{
              'is_signed_in': true,
              'remember_session': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture restore data envelope is_signed_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState logged_in alias success',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture restore result envelope logged_in alias applied.',
            'authState': <String, Object?>{
              'logged_in': true,
              'remember_session': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture restore result envelope logged_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name: 'restore-session data envelope authState logged_in alias success',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail': 'Fixture restore data envelope logged_in alias applied.',
            'authState': <String, Object?>{
              'logged_in': true,
              'remember_session': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture restore data envelope logged_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState is_logged_in alias success',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'detail':
                'Fixture restore data envelope is_logged_in alias applied.',
            'authState': <String, Object?>{
              'is_logged_in': true,
              'remember_session': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture restore data envelope is_logged_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState is_logged_in alias success',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'detail':
                'Fixture restore result envelope is_logged_in alias applied.',
            'authState': <String, Object?>{
              'is_logged_in': true,
              'remember_session': true,
            },
          },
        },
        expectedSignedIn: true,
        expectedRememberSession: true,
        expectedStatus:
            '[remote-stub] Fixture restore result envelope is_logged_in alias applied.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result payload envelope authState signed_out alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'payload': <String, Object?>{
              'authState': <String, Object?>{
                'signed_out': true,
                'sessionToken': 'fixture-signed-out-result-payload-token',
              },
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState signed_out alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'signed_out': true,
              'sessionToken':
                  'fixture-signed-out-refresh-result-snake-direct-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState signed_out alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'signed_out': true,
              'sessionToken':
                  'fixture-signed-out-refresh-data-snake-direct-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState signed_out alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'signed_out': true,
              'sessionToken': 'fixture-signed-out-result-snake-direct-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState signed_out alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'signed_out': true,
              'sessionToken': 'fixture-signed-out-data-snake-direct-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState signedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'signedOut': true,
              'sessionToken': 'fixture-signed-out-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState signedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'signedOut': true,
              'sessionToken': 'fixture-signed-out-refresh-data-camel-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState signedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'signedOut': true,
              'sessionToken': 'fixture-signed-out-data-camel-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState signedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'signedOut': true,
              'sessionToken': 'fixture-signed-out-result-camel-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState isSignedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'isSignedOut': true,
              'sessionToken':
                  'fixture-is-signed-out-refresh-result-camel-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState isSignedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'isSignedOut': true,
              'sessionToken': 'fixture-is-signed-out-refresh-data-camel-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState isSignedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'isSignedOut': true,
              'sessionToken': 'fixture-is-signed-out-result-camel-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState isSignedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'isSignedOut': true,
              'sessionToken': 'fixture-is-signed-out-data-camel-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState loggedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'loggedOut': true,
              'sessionToken': 'fixture-logged-out-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState loggedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'loggedOut': true,
              'sessionToken': 'fixture-logged-out-refresh-data-camel-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState logged_out alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'logged_out': true,
              'sessionToken':
                  'fixture-logged-out-refresh-result-snake-direct-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState logged_out alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'logged_out': true,
              'sessionToken':
                  'fixture-logged-out-refresh-data-snake-direct-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState loggedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'loggedOut': true,
              'sessionToken': 'fixture-logged-out-data-camel-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState loggedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'loggedOut': true,
              'sessionToken': 'fixture-logged-out-result-camel-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState logged_out alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'logged_out': true,
              'sessionToken': 'fixture-logged-out-result-snake-direct-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState logged_out alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'logged_out': true,
              'sessionToken': 'fixture-logged-out-data-snake-direct-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState is_signed_out alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'is_signed_out': true,
              'sessionToken': 'fixture-signed-out-refresh-data-snake-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState is_signed_out alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'is_signed_out': true,
              'sessionToken': 'fixture-signed-out-refresh-result-snake-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState is_signed_out alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'is_signed_out': true,
              'sessionToken': 'fixture-signed-out-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState is_signed_out alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'is_signed_out': true,
              'sessionToken': 'fixture-signed-out-result-snake-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState is_logged_out alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'is_logged_out': true,
              'sessionToken': 'fixture-logged-out-refresh-data-snake-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState is_logged_out alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'is_logged_out': true,
              'sessionToken': 'fixture-logged-out-refresh-result-snake-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState is_logged_out alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'is_logged_out': true,
              'sessionToken': 'fixture-logged-out-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState is_logged_out alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'is_logged_out': true,
              'sessionToken': 'fixture-logged-out-result-snake-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState isLoggedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'isLoggedOut': true,
              'sessionToken': 'fixture-is-logged-out-refresh-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState isLoggedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'isLoggedOut': true,
              'sessionToken': 'fixture-is-logged-out-refresh-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState isLoggedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'isLoggedOut': true,
              'sessionToken': 'fixture-is-logged-out-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState isLoggedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'isLoggedOut': true,
              'sessionToken': 'fixture-is-logged-out-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState isAuthenticated false alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'isAuthenticated': false,
              'sessionToken':
                  'fixture-is-authenticated-false-refresh-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState isAuthenticated false alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'isAuthenticated': false,
              'sessionToken':
                  'fixture-is-authenticated-false-refresh-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState loggedIn false alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'loggedIn': false,
              'sessionToken': 'fixture-logged-in-false-refresh-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState loggedIn false alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'loggedIn': false,
              'sessionToken': 'fixture-logged-in-false-refresh-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState isLoggedIn false alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'isLoggedIn': false,
              'sessionToken': 'fixture-is-logged-in-false-refresh-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState isLoggedIn false alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'isLoggedIn': false,
              'sessionToken': 'fixture-is-logged-in-false-refresh-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState is_authenticated false alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'is_authenticated': false,
              'sessionToken':
                  'fixture-is-authenticated-false-refresh-data-snake-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState is_authenticated false alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'is_authenticated': false,
              'sessionToken':
                  'fixture-is-authenticated-false-refresh-result-snake-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState signedIn false alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'signedIn': false,
              'sessionToken':
                  'fixture-signed-in-camel-false-refresh-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState signedIn false alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'signedIn': false,
              'sessionToken':
                  'fixture-signed-in-camel-false-refresh-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState authenticated false alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'authenticated': false,
              'sessionToken': 'fixture-authenticated-false-refresh-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState authenticated false alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'authenticated': false,
              'sessionToken':
                  'fixture-authenticated-false-refresh-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState signed_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'signed_in': false,
              'sessionToken': 'fixture-signed-in-false-refresh-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState signed_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'signed_in': false,
              'sessionToken': 'fixture-signed-in-false-refresh-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState is_signed_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'is_signed_in': false,
              'sessionToken': 'fixture-is-signed-in-false-refresh-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState is_signed_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'is_signed_in': false,
              'sessionToken': 'fixture-is-signed-in-false-refresh-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState logged_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'logged_in': false,
              'sessionToken':
                  'fixture-logged-in-snake-false-refresh-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState logged_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'logged_in': false,
              'sessionToken':
                  'fixture-logged-in-snake-false-refresh-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token data envelope authState is_logged_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'is_logged_in': false,
              'sessionToken':
                  'fixture-is-logged-in-snake-false-refresh-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'refresh-token result envelope authState is_logged_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'is_logged_in': false,
              'sessionToken':
                  'fixture-is-logged-in-snake-false-refresh-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope authState signedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'signedOut': true,
              'sessionToken': 'fixture-signed-out-sign-in-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope authState signedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'signedOut': true,
              'sessionToken': 'fixture-signed-out-sign-in-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope authState signed_out alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'signed_out': true,
              'sessionToken': 'fixture-signed-out-snake-sign-in-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope authState signed_out alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'signed_out': true,
              'sessionToken': 'fixture-signed-out-snake-sign-in-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope authState isSignedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'isSignedOut': true,
              'sessionToken': 'fixture-is-signed-out-sign-in-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope authState isSignedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'isSignedOut': true,
              'sessionToken': 'fixture-is-signed-out-sign-in-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope authState loggedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'loggedOut': true,
              'sessionToken': 'fixture-logged-out-sign-in-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope authState loggedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'loggedOut': true,
              'sessionToken': 'fixture-logged-out-sign-in-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope authState logged_out alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'logged_out': true,
              'sessionToken': 'fixture-logged-out-snake-sign-in-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope authState logged_out alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'logged_out': true,
              'sessionToken': 'fixture-logged-out-snake-sign-in-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope authState isLoggedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'isLoggedOut': true,
              'sessionToken': 'fixture-is-logged-out-sign-in-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope authState isLoggedOut alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'isLoggedOut': true,
              'sessionToken': 'fixture-is-logged-out-sign-in-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope authState is_signed_out alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'is_signed_out': true,
              'sessionToken':
                  'fixture-is-signed-out-snake-sign-in-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope authState is_signed_out alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'is_signed_out': true,
              'sessionToken': 'fixture-is-signed-out-snake-sign-in-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope authState is_logged_out alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'is_logged_out': true,
              'sessionToken':
                  'fixture-is-logged-out-snake-sign-in-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope authState is_logged_out alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'is_logged_out': true,
              'sessionToken': 'fixture-is-logged-out-snake-sign-in-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope authState isAuthenticated false alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'isAuthenticated': false,
              'sessionToken':
                  'fixture-is-authenticated-false-sign-in-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope authState isAuthenticated false alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'isAuthenticated': false,
              'sessionToken':
                  'fixture-is-authenticated-false-sign-in-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope authState loggedIn false alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'loggedIn': false,
              'sessionToken': 'fixture-logged-in-false-sign-in-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope authState loggedIn false alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'loggedIn': false,
              'sessionToken': 'fixture-logged-in-false-sign-in-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope authState isLoggedIn false alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'isLoggedIn': false,
              'sessionToken': 'fixture-is-logged-in-false-sign-in-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope authState isLoggedIn false alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'isLoggedIn': false,
              'sessionToken': 'fixture-is-logged-in-false-sign-in-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope authState is_authenticated false alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'is_authenticated': false,
              'sessionToken':
                  'fixture-is-authenticated-snake-false-sign-in-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope authState is_authenticated false alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'is_authenticated': false,
              'sessionToken':
                  'fixture-is-authenticated-snake-false-sign-in-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope authState signedIn false alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'signedIn': false,
              'sessionToken': 'fixture-signed-in-false-sign-in-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope authState signedIn false alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'signedIn': false,
              'sessionToken': 'fixture-signed-in-false-sign-in-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope authState authenticated false alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'authenticated': false,
              'sessionToken': 'fixture-authenticated-false-sign-in-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope authState authenticated false alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'authenticated': false,
              'sessionToken':
                  'fixture-authenticated-false-sign-in-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope authState signed_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'signed_in': false,
              'sessionToken':
                  'fixture-signed-in-snake-false-sign-in-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope authState signed_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'signed_in': false,
              'sessionToken':
                  'fixture-signed-in-snake-false-sign-in-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope authState is_signed_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'is_signed_in': false,
              'sessionToken': 'fixture-is-signed-in-false-sign-in-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope authState is_signed_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'is_signed_in': false,
              'sessionToken': 'fixture-is-signed-in-false-sign-in-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope authState logged_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'logged_in': false,
              'sessionToken':
                  'fixture-logged-in-snake-false-sign-in-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope authState logged_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'logged_in': false,
              'sessionToken':
                  'fixture-logged-in-snake-false-sign-in-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in data envelope authState is_logged_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'is_logged_in': false,
              'sessionToken':
                  'fixture-is-logged-in-snake-false-sign-in-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'sign-in result envelope authState is_logged_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.signIn,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'is_logged_in': false,
              'sessionToken':
                  'fixture-is-logged-in-snake-false-sign-in-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState isAuthenticated false alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'isAuthenticated': false,
              'sessionToken': 'fixture-is-authenticated-false-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState isAuthenticated false alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'isAuthenticated': false,
              'sessionToken': 'fixture-is-authenticated-false-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState loggedIn false alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'loggedIn': false,
              'sessionToken': 'fixture-logged-in-false-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState loggedIn false alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'loggedIn': false,
              'sessionToken': 'fixture-logged-in-false-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState isLoggedIn false alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'isLoggedIn': false,
              'sessionToken': 'fixture-is-logged-in-false-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState isLoggedIn false alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'isLoggedIn': false,
              'sessionToken': 'fixture-is-logged-in-false-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState is_authenticated false alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'is_authenticated': false,
              'sessionToken': 'fixture-is-authenticated-false-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState is_authenticated false alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'is_authenticated': false,
              'sessionToken': 'fixture-is-authenticated-false-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState signedIn false alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'signedIn': false,
              'sessionToken': 'fixture-signed-in-camel-false-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState signedIn false alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'signedIn': false,
              'sessionToken': 'fixture-signed-in-camel-false-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState authenticated false alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'authenticated': false,
              'sessionToken': 'fixture-authenticated-false-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState authenticated false alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'authenticated': false,
              'sessionToken': 'fixture-authenticated-false-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState signed_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'signed_in': false,
              'sessionToken': 'fixture-signed-in-false-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState signed_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'signed_in': false,
              'sessionToken': 'fixture-signed-in-false-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState is_signed_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'is_signed_in': false,
              'sessionToken': 'fixture-is-signed-in-false-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState is_signed_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'is_signed_in': false,
              'sessionToken': 'fixture-is-signed-in-false-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState logged_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'logged_in': false,
              'sessionToken': 'fixture-logged-in-snake-false-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState logged_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'logged_in': false,
              'sessionToken': 'fixture-logged-in-snake-false-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope authState is_logged_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'is_logged_in': false,
              'sessionToken': 'fixture-is-logged-in-snake-false-data-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session result envelope authState is_logged_in false alias maps fallback status',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'result': <String, Object?>{
            'authState': <String, Object?>{
              'is_logged_in': false,
              'sessionToken': 'fixture-is-logged-in-snake-false-result-token',
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name:
            'restore-session data envelope explicit signed-out overrides token',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'authState': <String, Object?>{
              'authentication': <String, Object?>{'authenticated': false},
              'tokens': <String, Object?>{
                'accessToken': 'fixture-ignored-token',
              },
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Authentication required.',
      ),
      const _AuthBackendFixtureCase(
        name: 'numeric unauthorized code overrides token inference',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'code': 401,
          'state': <String, Object?>{
            'sessionToken': 'fixture-session-token',
            'user': <String, Object?>{'id': 'fixture-user'},
          },
        },
        expectedSignedIn: false,
      ),
      const _AuthBackendFixtureCase(
        name: 'refresh-token data envelope nested error detail and code',
        operationId: RemoteStubOperationIds.refreshToken,
        responsePayload: <String, Object?>{
          'data': <String, Object?>{
            'state': <String, Object?>{
              'authentication': <String, Object?>{
                'error': <String, Object?>{
                  'code': 'TOKEN_EXPIRED',
                  'detail': 'Fixture data-envelope refresh expired.',
                },
              },
              'tokens': <String, Object?>{'accessToken': 'fixture-stale-token'},
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Fixture data-envelope refresh expired.',
      ),
      const _AuthBackendFixtureCase(
        name: 'error container code override respects explicit signed-in',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'state': <String, Object?>{
            'authentication': <String, Object?>{
              'errors': <Object?>[
                <String, Object?>{'reasonCode': 'TOKEN_EXPIRED'},
              ],
              'authenticated': true,
            },
          },
        },
        expectedSignedIn: true,
      ),
      const _AuthBackendFixtureCase(
        name: 'nested error detail status fallback',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'state': <String, Object?>{
            'authentication': <String, Object?>{
              'errors': <Object?>[
                <String, Object?>{'detail': 'Fixture nested auth detail.'},
              ],
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Fixture nested auth detail.',
      ),
      const _AuthBackendFixtureCase(
        name: 'top-level status precedence over nested detail',
        operationId: RemoteStubOperationIds.restoreSession,
        responsePayload: <String, Object?>{
          'message': 'Fixture top-level auth message.',
          'state': <String, Object?>{
            'authentication': <String, Object?>{
              'errors': <Object?>[
                <String, Object?>{
                  'detail': 'Fixture nested detail ignored by precedence.',
                },
              ],
            },
          },
        },
        expectedSignedIn: false,
        expectedStatus: '[remote-stub] Fixture top-level auth message.',
      ),
    ];

    test(
      'auth backend contract fixture matrix keeps authState alias symmetry',
      () {
        final List<String> operationIds = <String>[
          RemoteStubOperationIds.signIn,
          RemoteStubOperationIds.refreshToken,
          RemoteStubOperationIds.restoreSession,
        ];
        final List<String> wrapperKeys = <String>['result', 'data'];
        final List<String> signedOutAliases = <String>[
          'signedOut',
          'signed_out',
          'isSignedOut',
          'loggedOut',
          'logged_out',
          'isLoggedOut',
          'is_signed_out',
          'is_logged_out',
        ];
        final List<String> signedInAliases = <String>[
          'isAuthenticated',
          'loggedIn',
          'isLoggedIn',
          'is_authenticated',
          'signedIn',
          'authenticated',
          'signed_in',
          'is_signed_in',
          'logged_in',
          'is_logged_in',
        ];

        final List<String> missingEntries = <String>[];
        final Set<String> matrixEntries =
            _buildAuthBackendFixtureMatrixEntrySet(
              fixtures: authBackendContractFixtures,
              wrapperKeys: wrapperKeys,
            );

        for (final String operationId in operationIds) {
          for (final String wrapperKey in wrapperKeys) {
            _appendMissingAuthBackendFixtureMatrixEntries(
              missingEntries: missingEntries,
              matrixEntries: matrixEntries,
              operationId: operationId,
              wrapperKey: wrapperKey,
              aliases: signedOutAliases,
              expectedValue: true,
            );
            _appendMissingAuthBackendFixtureMatrixEntries(
              missingEntries: missingEntries,
              matrixEntries: matrixEntries,
              operationId: operationId,
              wrapperKey: wrapperKey,
              aliases: signedInAliases,
              expectedValue: true,
            );
            _appendMissingAuthBackendFixtureMatrixEntries(
              missingEntries: missingEntries,
              matrixEntries: matrixEntries,
              operationId: operationId,
              wrapperKey: wrapperKey,
              aliases: signedInAliases,
              expectedValue: false,
            );
          }
        }

        expect(
          missingEntries,
          isEmpty,
          reason:
              'Missing auth backend fixture matrix entries:\n${missingEntries.join('\n')}',
        );
      },
    );

    for (final _AuthBackendFixtureCase fixture in authBackendContractFixtures) {
      test('auth backend contract fixture: ${fixture.name}', () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              fixture.operationId: fixture.responsePayload,
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        _invokeAuthBackendFixtureOperation(authContract, fixture.operationId);

        expect(authContract.state.signedIn, fixture.expectedSignedIn);
        if (fixture.expectedRememberSession != null) {
          expect(
            authContract.state.rememberSession,
            fixture.expectedRememberSession,
          );
        }
        if (fixture.expectedStatus != null) {
          expect(authContract.state.status, fixture.expectedStatus);
        }
      });
    }

    test(
      'auth backend signed-out error codes override token/session inference',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'errorCode': 'TOKEN_EXPIRED',
                'message': 'Session expired in backend.',
                'state': <String, Object?>{
                  'sessionToken': 'stale-session-token',
                  'user': <String, Object?>{'id': 'stale-user'},
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Session expired in backend.',
        );
      },
    );

    test(
      'auth backend signed-out error codes force signed-out from signed-in snapshot',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'errorCode': 'TOKEN_EXPIRED',
                'message': 'Session expired in backend.',
                'state': <String, Object?>{
                  'sessionToken': 'stale-session-token',
                  'user': <String, Object?>{'id': 'stale-user'},
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(
              transportClient: transportClient,
              initialState: const AuthSessionState(
                rememberSession: true,
                signedIn: true,
                status: 'Previously signed in.',
              ),
            );

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(authContract.state.rememberSession, isTrue);
        expect(
          authContract.state.status,
          '[remote-stub] Session expired in backend.',
        );
      },
    );

    test(
      'auth backend numeric unauthorized code overrides token/session inference',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'code': 401,
                'message': 'Backend unauthorized response.',
                'state': <String, Object?>{
                  'sessionToken': 'numeric-code-session-token',
                  'user': <String, Object?>{'id': 'numeric-user'},
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend unauthorized response.',
        );
      },
    );

    test(
      'auth backend code-only unauthorized payload maps authentication-required fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'code': 401,
                'state': <String, Object?>{
                  'sessionToken': 'code-only-unauthorized-token',
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(
              transportClient: transportClient,
              initialState: const AuthSessionState(
                rememberSession: true,
                signedIn: true,
                status: 'Previously signed in.',
              ),
            );

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(authContract.state.rememberSession, isTrue);
        expect(
          authContract.state.status,
          '[remote-stub] Authentication required.',
        );
      },
    );

    test(
      'auth backend code-only compact unauthorized payload maps authentication-required fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'code': 'unauthorized',
                'state': <String, Object?>{
                  'sessionToken': 'code-only-compact-unauthorized-token',
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(
              transportClient: transportClient,
              initialState: const AuthSessionState(
                rememberSession: true,
                signedIn: true,
                status: 'Previously signed in.',
              ),
            );

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(authContract.state.rememberSession, isTrue);
        expect(
          authContract.state.status,
          '[remote-stub] Authentication required.',
        );
      },
    );

    test(
      'auth backend code-only mixed unauthorized-refresh-token-expired payload maps session-expired fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'code': 'UNAUTHORIZED_REFRESH_TOKEN_EXPIRED',
                'state': <String, Object?>{
                  'sessionToken':
                      'code-only-mixed-unauthorized-refresh-token-expired',
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(
              transportClient: transportClient,
              initialState: const AuthSessionState(
                rememberSession: true,
                signedIn: true,
                status: 'Previously signed in.',
              ),
            );

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(authContract.state.rememberSession, isTrue);
        expect(
          authContract.state.status,
          '[remote-stub] Backend session expired.',
        );
      },
    );

    test(
      'auth backend statusCode unauthorized payload maps authentication-required fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'statusCode': 401,
                'state': <String, Object?>{
                  'sessionToken': 'status-code-unauthorized-token',
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(
              transportClient: transportClient,
              initialState: const AuthSessionState(
                rememberSession: true,
                signedIn: true,
                status: 'Previously signed in.',
              ),
            );

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(authContract.state.rememberSession, isTrue);
        expect(
          authContract.state.status,
          '[remote-stub] Authentication required.',
        );
      },
    );

    test(
      'auth backend status_code unauthorized payload maps authentication-required fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'status_code': 403,
                'state': <String, Object?>{
                  'sessionToken': 'status-code-snake-unauthorized-token',
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Authentication required.',
        );
      },
    );

    test(
      'auth backend code-only token-expired payload maps session-expired fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'errorCode': 'TOKEN_EXPIRED',
                'state': <String, Object?>{
                  'sessionToken': 'code-only-expired-token',
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend session expired.',
        );
      },
    );

    test(
      'auth backend httpStatus session-expired payload maps session-expired fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'httpStatus': '440',
                'state': <String, Object?>{
                  'sessionToken': 'http-status-expired-token',
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend session expired.',
        );
      },
    );

    test(
      'auth backend http_status session-expired payload maps session-expired fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'http_status': 419,
                'state': <String, Object?>{
                  'sessionToken': 'http-status-snake-expired-token',
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend session expired.',
        );
      },
    );

    test(
      'auth backend code-only session-timeout payload maps session-expired fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'code': 'SESSION_TIMEOUT',
                'state': <String, Object?>{
                  'sessionToken': 'code-only-timeout-token',
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend session expired.',
        );
      },
    );

    test(
      'auth backend code-only expired-token payload maps session-expired fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'code': 'EXPIRED_TOKEN',
                'state': <String, Object?>{
                  'sessionToken': 'code-only-expired-token-variant',
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend session expired.',
        );
      },
    );

    test(
      'auth backend code-only jwt-expired payload maps session-expired fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'code': 'JWT_EXPIRED',
                'state': <String, Object?>{
                  'sessionToken': 'code-only-jwt-expired-token',
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend session expired.',
        );
      },
    );

    test(
      'auth backend code-only access-token-expired payload maps session-expired fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'code': 'ACCESS_TOKEN_EXPIRED',
                'state': <String, Object?>{
                  'sessionToken': 'code-only-access-token-expired',
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend session expired.',
        );
      },
    );

    test(
      'auth backend code-only refresh-token-expired payload maps session-expired fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'code': 'REFRESH_TOKEN_EXPIRED',
                'state': <String, Object?>{
                  'sessionToken': 'code-only-refresh-token-expired',
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend session expired.',
        );
      },
    );

    test(
      'auth backend code-only delimited refresh-token-expired payload maps session-expired fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'code': '  REFRESH-TOKEN::EXPIRED  ',
                'state': <String, Object?>{
                  'sessionToken': 'code-only-delimited-refresh-token-expired',
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend session expired.',
        );
      },
    );

    test(
      'auth backend code-only compact refresh-token-expired payload maps session-expired fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'code': 'refreshtokenexpired',
                'state': <String, Object?>{
                  'sessionToken': 'code-only-compact-refresh-token-expired',
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend session expired.',
        );
      },
    );

    test(
      'auth backend explicit message keeps precedence over code-based fallback mapping',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'code': 401,
                'detail': 'Backend code-only detail takes precedence.',
                'state': <String, Object?>{
                  'sessionToken': 'code-only-detail-token',
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend code-only detail takes precedence.',
        );
      },
    );

    test(
      'auth backend explicit failure flag overrides token/session inference',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'success': false,
                'message': 'Backend auth failure flag signaled.',
                'state': <String, Object?>{
                  'sessionToken': 'failure-flag-session-token',
                  'user': <String, Object?>{'id': 'failure-flag-user'},
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend auth failure flag signaled.',
        );
      },
    );

    test(
      'auth backend failure flag without status maps auth-request-failed fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'success': false,
                'state': <String, Object?>{
                  'sessionToken': 'failure-only-session-token',
                  'user': <String, Object?>{'id': 'failure-only-user'},
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend auth request failed.',
        );
      },
    );

    test(
      'auth backend ok failure flag without status maps auth-request-failed fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'ok': false,
                'state': <String, Object?>{
                  'sessionToken': 'ok-failure-session-token',
                  'user': <String, Object?>{'id': 'ok-failure-user'},
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend auth request failed.',
        );
      },
    );

    test(
      'auth backend isSuccess failure flag without status maps auth-request-failed fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'isSuccess': false,
                'state': <String, Object?>{
                  'sessionToken': 'is-success-failure-session-token',
                  'user': <String, Object?>{'id': 'is-success-failure-user'},
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend auth request failed.',
        );
      },
    );

    test(
      'auth backend snake-case failure flag without status maps auth-request-failed fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'is_success': false,
                'state': <String, Object?>{
                  'sessionToken': 'snake-failure-session-token',
                  'user': <String, Object?>{'id': 'snake-failure-user'},
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend auth request failed.',
        );
      },
    );

    test(
      'auth backend is_ok failure flag without status maps auth-request-failed fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'is_ok': false,
                'state': <String, Object?>{
                  'sessionToken': 'is-ok-snake-failure-session-token',
                  'user': <String, Object?>{'id': 'is-ok-snake-failure-user'},
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend auth request failed.',
        );
      },
    );

    test(
      'auth backend isOk failure flag without status maps auth-request-failed fallback status',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'isOk': false,
                'state': <String, Object?>{
                  'sessionToken': 'is-ok-failure-session-token',
                  'user': <String, Object?>{'id': 'is-ok-failure-user'},
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend auth request failed.',
        );
      },
    );

    test(
      'auth backend mixed failure-flag aliases prioritize explicit false values',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'success': true,
                'is_success': false,
                'state': <String, Object?>{
                  'sessionToken': 'mixed-failure-flag-session-token',
                  'user': <String, Object?>{'id': 'mixed-failure-flag-user'},
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend auth request failed.',
        );
      },
    );

    test(
      'auth backend nested mixed failure-flag aliases prioritize explicit false values',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'success': true,
                'errors': <Map<String, Object?>>[
                  <String, Object?>{'is_success': false},
                ],
                'state': <String, Object?>{
                  'sessionToken': 'nested-mixed-failure-flag-session-token',
                  'user': <String, Object?>{
                    'id': 'nested-mixed-failure-flag-user',
                  },
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend auth request failed.',
        );
      },
    );

    test(
      'auth backend explicit failure flag forces signed-out from signed-in snapshot',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'success': false,
                'message': 'Backend auth failure flag signaled.',
                'state': <String, Object?>{
                  'sessionToken': 'failure-flag-session-token',
                  'user': <String, Object?>{'id': 'failure-flag-user'},
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(
              transportClient: transportClient,
              initialState: const AuthSessionState(
                rememberSession: true,
                signedIn: true,
                status: 'Previously signed in.',
              ),
            );

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(authContract.state.rememberSession, isTrue);
        expect(
          authContract.state.status,
          '[remote-stub] Backend auth failure flag signaled.',
        );
      },
    );

    test(
      'auth backend nested failure flag overrides token/session inference',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'message': 'Backend nested failure flag signaled.',
                'state': <String, Object?>{
                  'authentication': <String, Object?>{
                    'error': <String, Object?>{'success': false},
                  },
                  'tokens': <String, Object?>{
                    'accessToken': 'nested-failure-token',
                  },
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend nested failure flag signaled.',
        );
      },
    );

    test(
      'auth backend explicit signed-in state overrides signed-out error code',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'code': 'AUTH_REQUIRED',
                'state': <String, Object?>{
                  'signedIn': true,
                  'rememberSession': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend explicit signed-in state overrides success failure flag',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'success': false,
                'state': <String, Object?>{
                  'signedIn': true,
                  'rememberSession': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test('auth backend explicit signed-in state overrides ok failure flag', () {
      final _BackendResponseTransportClient transportClient =
          _BackendResponseTransportClient(<String, Map<String, Object?>>{
            RemoteStubOperationIds.restoreSession: <String, Object?>{
              'ok': false,
              'state': <String, Object?>{
                'signedIn': true,
                'rememberSession': true,
              },
            },
          });
      final RemoteStubAuthSessionContract authContract =
          RemoteStubAuthSessionContract(transportClient: transportClient);

      authContract.restoreSession();

      expect(authContract.state.signedIn, isTrue);
      expect(authContract.state.rememberSession, isTrue);
    });

    test(
      'auth backend explicit signed-in state overrides isSuccess failure flag',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'isSuccess': false,
                'state': <String, Object?>{
                  'signedIn': true,
                  'rememberSession': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend explicit signed-in state overrides snake-case failure flag',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'is_success': false,
                'state': <String, Object?>{
                  'signedIn': true,
                  'rememberSession': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend explicit signed-in state overrides is_ok failure flag',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'is_ok': false,
                'state': <String, Object?>{
                  'signedIn': true,
                  'rememberSession': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend explicit signed-in state overrides isOk failure flag',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'isOk': false,
                'state': <String, Object?>{
                  'signedIn': true,
                  'rememberSession': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend explicit signed-in state overrides nested failure flag',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'state': <String, Object?>{
                  'authentication': <String, Object?>{
                    'error': <String, Object?>{'ok': false},
                    'authenticated': true,
                    'remember': true,
                  },
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend explicit signed-in state overrides numeric unauthorized code',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'code': 401,
                'state': <String, Object?>{
                  'signedIn': true,
                  'rememberSession': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend explicit signed-in state overrides statusCode unauthorized variant',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'statusCode': 401,
                'state': <String, Object?>{
                  'signedIn': true,
                  'rememberSession': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend explicit signed-in state overrides status_code unauthorized variant',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'status_code': 401,
                'state': <String, Object?>{
                  'signedIn': true,
                  'rememberSession': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend explicit signed-in state overrides token-expired errorCode variant',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'errorCode': 'TOKEN_EXPIRED',
                'state': <String, Object?>{
                  'signedIn': true,
                  'rememberSession': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend explicit signed-in state overrides httpStatus session-expired variant',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'httpStatus': '440',
                'state': <String, Object?>{
                  'signedIn': true,
                  'rememberSession': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend explicit signed-in state overrides http_status session-expired variant',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'http_status': 419,
                'state': <String, Object?>{
                  'signedIn': true,
                  'rememberSession': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend explicit signed-in state overrides session-timeout code variant',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'code': 'SESSION_TIMEOUT',
                'state': <String, Object?>{
                  'signedIn': true,
                  'rememberSession': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend explicit signed-in state overrides expired-token code variant',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'code': 'EXPIRED_TOKEN',
                'state': <String, Object?>{
                  'signedIn': true,
                  'rememberSession': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend explicit signed-in state overrides jwt-expired code variant',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'code': 'JWT_EXPIRED',
                'state': <String, Object?>{
                  'signedIn': true,
                  'rememberSession': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend explicit signed-in state overrides refresh-token-expired code variant',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'code': 'REFRESH_TOKEN_EXPIRED',
                'state': <String, Object?>{
                  'signedIn': true,
                  'rememberSession': true,
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend error object code overrides token/session inference',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'error': <String, Object?>{'code': 'UNAUTHENTICATED'},
                'message': 'Backend rejected stale credentials.',
                'state': <String, Object?>{
                  'sessionToken': 'stale-session-token',
                  'user': <String, Object?>{'id': 'stale-user'},
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend rejected stale credentials.',
        );
      },
    );

    test(
      'auth backend nested error list code respects explicit signed-in alias',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'state': <String, Object?>{
                  'authentication': <String, Object?>{
                    'errors': <Object?>[
                      <String, Object?>{'reasonCode': 'TOKEN_EXPIRED'},
                    ],
                    'authenticated': true,
                    'rememberSession': true,
                  },
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend nested error list detail updates status when top-level status is absent',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'state': <String, Object?>{
                  'authentication': <String, Object?>{
                    'errors': <Object?>[
                      <String, Object?>{
                        'detail': 'Nested auth detail from error list.',
                      },
                    ],
                  },
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Nested auth detail from error list.',
        );
      },
    );

    test(
      'auth backend top-level message keeps precedence over nested error detail',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'message': 'Top-level backend auth message.',
                'state': <String, Object?>{
                  'authentication': <String, Object?>{
                    'errors': <Object?>[
                      <String, Object?>{
                        'detail':
                            'Nested detail should not override top-level.',
                      },
                    ],
                  },
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(
          authContract.state.status,
          '[remote-stub] Top-level backend auth message.',
        );
      },
    );

    test(
      'auth backend nested signed-out error code overrides token inference',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'message': 'Nested backend session expired.',
                'state': <String, Object?>{
                  'authentication': <String, Object?>{
                    'errorCode': 'SESSION_EXPIRED',
                  },
                  'tokens': <String, Object?>{
                    'accessToken': 'nested-stale-access-token',
                  },
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.refreshToken();

        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Nested backend session expired.',
        );
      },
    );

    test(
      'auth backend nested explicit signed-in alias overrides nested error code',
      () {
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.restoreSession: <String, Object?>{
                'state': <String, Object?>{
                  'authentication': <String, Object?>{
                    'errorCode': 'AUTH_REQUIRED',
                    'authenticated': true,
                    'remember': true,
                  },
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(transportClient: transportClient);

        authContract.restoreSession();

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
      },
    );

    test(
      'auth backend malformed payload falls back to delegate by default',
      () {
        final _TrackingAuthSessionContract trackingDelegate =
            _TrackingAuthSessionContract();
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.signIn: <String, Object?>{
                'unexpected': <String, Object?>{'shape': true},
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(
              delegate: trackingDelegate,
              transportClient: transportClient,
            );

        authContract.signIn(
          const AuthSignInRequest(
            email: 'designer@penjar.app',
            password: 'desktop-pass',
          ),
        );

        expect(trackingDelegate.signInCallCount, 1);
        expect(authContract.state.signedIn, isTrue);
        expect(
          authContract.state.status,
          '[remote-stub] Delegate sign-in called.',
        );
      },
    );

    test(
      'auth backend malformed payload blocks delegate fallback in strict schema mode',
      () {
        final _TrackingAuthSessionContract trackingDelegate =
            _TrackingAuthSessionContract();
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.signIn: <String, Object?>{
                'unexpected': <String, Object?>{'shape': true},
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(
              delegate: trackingDelegate,
              transportClient: transportClient,
              strictBackendSchema: true,
            );

        authContract.signIn(
          const AuthSignInRequest(
            email: 'designer@penjar.app',
            password: 'desktop-pass',
          ),
        );

        expect(trackingDelegate.signInCallCount, 0);
        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend auth schema validation failed.',
        );
      },
    );

    test(
      'auth backend required-state mode blocks delegate fallback on empty payload',
      () {
        final _TrackingAuthSessionContract trackingDelegate =
            _TrackingAuthSessionContract();
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(
              delegate: trackingDelegate,
              requireBackendState: true,
            );

        authContract.signIn(
          const AuthSignInRequest(
            email: 'designer@penjar.app',
            password: 'desktop-pass',
          ),
        );

        expect(trackingDelegate.signInCallCount, 0);
        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend auth state payload required.',
        );
      },
    );

    test(
      'auth backend required-state mode blocks delegate fallback on malformed payload',
      () {
        final _TrackingAuthSessionContract trackingDelegate =
            _TrackingAuthSessionContract();
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.signIn: <String, Object?>{
                'unexpected': <String, Object?>{'shape': true},
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(
              delegate: trackingDelegate,
              transportClient: transportClient,
              requireBackendState: true,
            );

        authContract.signIn(
          const AuthSignInRequest(
            email: 'designer@penjar.app',
            password: 'desktop-pass',
          ),
        );

        expect(trackingDelegate.signInCallCount, 0);
        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend auth state payload required.',
        );
      },
    );

    test(
      'skips auth delegate mutation when backend response snapshot is present',
      () {
        final _TrackingAuthSessionContract trackingDelegate =
            _TrackingAuthSessionContract();
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.signIn: <String, Object?>{
                'status': 'Backend auth snapshot applied.',
                'state': <String, Object?>{'signedIn': false},
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(
              delegate: trackingDelegate,
              transportClient: transportClient,
            );

        authContract.signIn(
          const AuthSignInRequest(
            email: 'designer@penjar.app',
            password: 'desktop-pass',
          ),
        );

        expect(trackingDelegate.signInCallCount, 0);
        expect(authContract.state.signedIn, isFalse);
        expect(
          authContract.state.status,
          '[remote-stub] Backend auth snapshot applied.',
        );
      },
    );

    test('restores and persists auth snapshot through auth state store', () {
      final RemoteStubMemoryAuthStateStore authStateStore =
          RemoteStubMemoryAuthStateStore(
            const AuthSessionState(
              rememberSession: true,
              signedIn: true,
              status: 'Restored auth snapshot.',
            ),
          );
      final _BackendResponseTransportClient transportClient =
          _BackendResponseTransportClient(<String, Map<String, Object?>>{
            RemoteStubOperationIds.signIn: <String, Object?>{
              'status': 'Backend auth persisted.',
              'state': <String, Object?>{
                'rememberSession': false,
                'signedIn': false,
              },
            },
          });
      final RemoteStubAuthSessionContract authContract =
          RemoteStubAuthSessionContract(
            authStateStore: authStateStore,
            transportClient: transportClient,
          );

      expect(authContract.state.rememberSession, isTrue);
      expect(authContract.state.signedIn, isTrue);
      expect(
        authContract.state.status,
        '[remote-stub] Restored auth snapshot.',
      );

      authContract.signIn(
        const AuthSignInRequest(
          email: 'designer@penjar.app',
          password: 'desktop-pass',
        ),
      );

      final AuthSessionState? persistedState = authStateStore.load();
      expect(persistedState, isNotNull);
      expect(persistedState?.rememberSession, isFalse);
      expect(persistedState?.signedIn, isFalse);
      expect(persistedState?.status, 'Backend auth persisted.');
      expect(
        authContract.state.status,
        '[remote-stub] Backend auth persisted.',
      );
    });

    test(
      'secure auth state store persists backend signed-out refresh fallback snapshot',
      () async {
        final List<String> persistedSnapshots = <String>[];
        final RemoteStubSecureSnapshotAuthStateStore authStateStore =
            RemoteStubSecureSnapshotAuthStateStore(
              initialSnapshot: const AuthSessionState(
                rememberSession: true,
                signedIn: true,
                status: 'Loaded from secure snapshot.',
              ),
              snapshotWriter: (String snapshotJson) async {
                persistedSnapshots.add(snapshotJson);
              },
            );
        final _BackendResponseTransportClient transportClient =
            _BackendResponseTransportClient(<String, Map<String, Object?>>{
              RemoteStubOperationIds.refreshToken: <String, Object?>{
                'code': 401,
                'state': <String, Object?>{
                  'sessionToken': 'secure-store-expired-session',
                },
              },
            });
        final RemoteStubAuthSessionContract authContract =
            RemoteStubAuthSessionContract(
              authStateStore: authStateStore,
              transportClient: transportClient,
            );

        expect(authContract.state.signedIn, isTrue);
        expect(authContract.state.rememberSession, isTrue);
        expect(
          authContract.state.status,
          '[remote-stub] Loaded from secure snapshot.',
        );

        authContract.refreshToken();
        await Future<void>.delayed(Duration.zero);

        expect(authContract.state.signedIn, isFalse);
        expect(authContract.state.rememberSession, isTrue);
        expect(
          authContract.state.status,
          '[remote-stub] Authentication required.',
        );
        final AuthSessionState? persistedState = authStateStore.load();
        expect(persistedState, isNotNull);
        expect(persistedState?.rememberSession, isTrue);
        expect(persistedState?.signedIn, isFalse);
        expect(persistedState?.status, 'Authentication required.');
        expect(persistedSnapshots, hasLength(1));
        expect(persistedSnapshots.single, contains('"rememberSession":true'));
        expect(persistedSnapshots.single, contains('"signedIn":false'));
      },
    );

    test('file auth state store loads and saves snapshots', () {
      final Directory tempDir = Directory.systemTemp.createTempSync(
        'penjar-auth-store-',
      );
      addTearDown(() {
        if (tempDir.existsSync()) {
          tempDir.deleteSync(recursive: true);
        }
      });

      final String snapshotPath = '${tempDir.path}/remote_stub_auth_state.json';
      final RemoteStubFileAuthStateStore store = RemoteStubFileAuthStateStore(
        snapshotPath,
      );

      expect(store.load(), isNull);
      store.save(
        const AuthSessionState(
          rememberSession: true,
          signedIn: false,
          status: 'Saved snapshot.',
        ),
      );
      final AuthSessionState? loaded = store.load();
      expect(loaded, isNotNull);
      expect(loaded?.rememberSession, isTrue);
      expect(loaded?.signedIn, isFalse);
      expect(loaded?.status, 'Saved snapshot.');

      final _BackendResponseTransportClient transportClient =
          _BackendResponseTransportClient(<String, Map<String, Object?>>{
            RemoteStubOperationIds.signIn: <String, Object?>{
              'status': 'Backend file snapshot persisted.',
              'state': <String, Object?>{
                'rememberSession': false,
                'signedIn': true,
              },
            },
          });
      final RemoteStubAuthSessionContract authContract =
          RemoteStubAuthSessionContract(
            authStateStore: store,
            transportClient: transportClient,
          );

      authContract.signIn(
        const AuthSignInRequest(
          email: 'designer@penjar.app',
          password: 'desktop-pass',
        ),
      );

      final AuthSessionState? persisted = RemoteStubFileAuthStateStore(
        snapshotPath,
      ).load();
      expect(persisted, isNotNull);
      expect(persisted?.rememberSession, isFalse);
      expect(persisted?.signedIn, isTrue);
      expect(persisted?.status, 'Backend file snapshot persisted.');
    });

    test('command auth state store loads and saves via command runner', () {
      final List<RemoteStubCommandExecutionRequest> executedRequests =
          <RemoteStubCommandExecutionRequest>[];
      final RemoteStubCommandAuthStateStore
      store = RemoteStubCommandAuthStateStore(
        loadCommand: 'load-auth-snapshot',
        saveCommand: 'save-auth-snapshot',
        commandRunner: (RemoteStubCommandExecutionRequest request) {
          executedRequests.add(request);
          if (request.command == 'load-auth-snapshot') {
            return const RemoteStubCommandExecutionResult(
              exitCode: 0,
              stdout:
                  '{"rememberSession":true,"signedIn":false,"status":"Loaded from command."}',
            );
          }
          return const RemoteStubCommandExecutionResult(exitCode: 0);
        },
      );

      final AuthSessionState? loaded = store.load();
      expect(loaded, isNotNull);
      expect(loaded?.rememberSession, isTrue);
      expect(loaded?.signedIn, isFalse);
      expect(loaded?.status, 'Loaded from command.');

      store.save(
        const AuthSessionState(
          rememberSession: false,
          signedIn: true,
          status: 'Saved from command.',
        ),
      );

      expect(executedRequests, hasLength(2));
      expect(executedRequests.first.command, 'load-auth-snapshot');
      expect(executedRequests.last.command, 'save-auth-snapshot');
      final String? savedJson = executedRequests
          .last
          .environment['PENJAR_DESKTOP_REMOTE_STUB_AUTH_STATE_JSON'];
      expect(savedJson, isNotNull);
      expect(savedJson, contains('"signedIn":true'));
      expect(savedJson, contains('"status":"Saved from command."'));
    });

    test('command auth state store returns null on failed load command', () {
      final RemoteStubCommandAuthStateStore store =
          RemoteStubCommandAuthStateStore(
            loadCommand: 'load-auth-snapshot',
            commandRunner: (_) =>
                const RemoteStubCommandExecutionResult(exitCode: 1),
          );

      expect(store.load(), isNull);
    });

    test(
      'secure snapshot auth state store caches state and writes asynchronously',
      () async {
        final List<String> persistedSnapshots = <String>[];
        final RemoteStubSecureSnapshotAuthStateStore store =
            RemoteStubSecureSnapshotAuthStateStore(
              initialSnapshot: const AuthSessionState(
                rememberSession: true,
                signedIn: false,
                status: 'Loaded from secure store.',
              ),
              snapshotWriter: (String snapshotJson) async {
                persistedSnapshots.add(snapshotJson);
              },
            );

        expect(store.load(), isNotNull);
        expect(store.load()?.rememberSession, isTrue);
        expect(store.load()?.signedIn, isFalse);
        expect(store.load()?.status, 'Loaded from secure store.');

        store.save(
          const AuthSessionState(
            rememberSession: false,
            signedIn: true,
            status: 'Saved to secure store.',
          ),
        );
        await Future<void>.delayed(Duration.zero);

        expect(store.load()?.rememberSession, isFalse);
        expect(store.load()?.signedIn, isTrue);
        expect(store.load()?.status, 'Saved to secure store.');
        expect(persistedSnapshots, hasLength(1));
        expect(persistedSnapshots.single, contains('"signedIn":true'));
      },
    );

    test('secure snapshot auth state store ignores writer failures', () async {
      final RemoteStubSecureSnapshotAuthStateStore store =
          RemoteStubSecureSnapshotAuthStateStore(
            snapshotWriter: (_) async {
              throw Exception('write failed');
            },
          );

      store.save(
        const AuthSessionState(
          rememberSession: false,
          signedIn: true,
          status: 'Failure fallback.',
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(store.load()?.signedIn, isTrue);
      expect(store.load()?.status, 'Failure fallback.');
    });

    test(
      'composite auth state store falls back to secondary load and mirrors save',
      () {
        final RemoteStubMemoryAuthStateStore primaryStore =
            RemoteStubMemoryAuthStateStore();
        final RemoteStubMemoryAuthStateStore secondaryStore =
            RemoteStubMemoryAuthStateStore(
              const AuthSessionState(
                rememberSession: true,
                signedIn: false,
                status: 'Legacy snapshot.',
              ),
            );
        final RemoteStubCompositeAuthStateStore store =
            RemoteStubCompositeAuthStateStore(
              primary: primaryStore,
              secondary: secondaryStore,
            );

        final AuthSessionState? loaded = store.load();
        expect(loaded, isNotNull);
        expect(loaded?.status, 'Legacy snapshot.');

        store.save(
          const AuthSessionState(
            rememberSession: false,
            signedIn: true,
            status: 'Mirrored snapshot.',
          ),
        );
        expect(primaryStore.load()?.status, 'Mirrored snapshot.');
        expect(secondaryStore.load()?.status, 'Mirrored snapshot.');
      },
    );
  });
}
