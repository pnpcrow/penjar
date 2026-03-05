import 'package:flutter_test/flutter_test.dart';
import 'package:penjar_desktop/contracts/workflow_contracts.dart';

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
}
