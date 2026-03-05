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
