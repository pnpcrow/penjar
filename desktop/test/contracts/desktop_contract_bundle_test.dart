import 'package:flutter_test/flutter_test.dart';
import 'package:penjar_desktop/contracts/desktop_contract_bundle.dart';
import 'package:penjar_desktop/contracts/remote_stub_contracts.dart';
import 'package:penjar_desktop/contracts/workflow_contracts.dart';

class _BundleBackendResponseTransportClient extends RemoteStubTransportClient {
  _BundleBackendResponseTransportClient(this.responsesByOperation);

  final Map<String, Map<String, Object?>> responsesByOperation;

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    final Map<String, Object?>? response =
        responsesByOperation[request.operation];
    if (response == null || response.isEmpty) {
      return RemoteStubTransportResult.allow;
    }
    return RemoteStubTransportResult.allowedWithPayload(response);
  }
}

class _BundleCaptureTransportClient extends RemoteStubTransportClient {
  final List<RemoteStubTransportRequest> executed =
      <RemoteStubTransportRequest>[];

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    executed.add(request);
    return RemoteStubTransportResult.allow;
  }
}

void main() {
  test('in-memory bundle exposes reusable workflow contracts', () {
    final DesktopContractBundle bundle = DesktopContractBundle.inMemory();

    expect(bundle.mode, DesktopContractMode.inMemory);
    expect(bundle.authSession.state.status, 'Idle');
    bundle.authSession.signIn(
      const AuthSignInRequest(
        email: 'designer@penjar.app',
        password: 'desktop-pass',
      ),
    );
    expect(bundle.authSession.state.status, 'Signed in (simulated).');

    expect(bundle.projectLifecycle.state.projects, hasLength(1));
    expect(bundle.canvasEditing.state.shapes, isEmpty);
    expect(bundle.assetManagement.state.assets, isEmpty);
    expect(bundle.collaborationContext.state.threads, isEmpty);
    expect(bundle.inspectHandoff.state.status, 'Idle');
    expect(bundle.exportWorkflow.state.status, 'Idle');
    expect(bundle.diagnosticsRecovery.state.status, 'Idle');
    expect(bundle.remoteStubProfile, isNull);
  });

  test('contract mode parser supports remote-stub aliases', () {
    expect(
      DesktopContractMode.fromEnv('remote-stub'),
      DesktopContractMode.remoteStub,
    );
    expect(
      DesktopContractMode.fromEnv('remote_stub'),
      DesktopContractMode.remoteStub,
    );
    expect(
      DesktopContractMode.fromEnv('remote'),
      DesktopContractMode.remoteStub,
    );
    expect(
      DesktopContractMode.fromEnv('in-memory'),
      DesktopContractMode.inMemory,
    );
    expect(DesktopContractMode.fromEnv(null), DesktopContractMode.inMemory);
  });

  test(
    'secure storage rollout mode parser defaults on and supports explicit opt-out',
    () {
      expect(
        RemoteStubSecureStorageRolloutMode.fromEnvRaw(''),
        RemoteStubSecureStorageRolloutMode.defaultOn,
      );
      expect(
        RemoteStubSecureStorageRolloutMode.fromEnvRaw('true'),
        RemoteStubSecureStorageRolloutMode.explicitOn,
      );
      expect(
        RemoteStubSecureStorageRolloutMode.fromEnvRaw('1'),
        RemoteStubSecureStorageRolloutMode.explicitOn,
      );
      expect(
        RemoteStubSecureStorageRolloutMode.fromEnvRaw('false'),
        RemoteStubSecureStorageRolloutMode.explicitOff,
      );
      expect(
        RemoteStubSecureStorageRolloutMode.fromEnvRaw('off'),
        RemoteStubSecureStorageRolloutMode.explicitOff,
      );
      expect(
        RemoteStubSecureStorageRolloutMode.defaultOn.secureStorageEnabled,
        isTrue,
      );
      expect(
        RemoteStubSecureStorageRolloutMode.explicitOn.secureStorageEnabled,
        isTrue,
      );
      expect(
        RemoteStubSecureStorageRolloutMode.explicitOff.secureStorageEnabled,
        isFalse,
      );
    },
  );

  test('remote-stub bundle uses dedicated adapters with prefixed statuses', () {
    final DesktopContractBundle bundle = DesktopContractBundle.remoteStub();

    expect(bundle.mode, DesktopContractMode.remoteStub);
    expect(bundle.authSession, isA<RemoteStubAuthSessionContract>());
    expect(bundle.projectLifecycle, isA<RemoteStubProjectLifecycleContract>());
    expect(bundle.canvasEditing, isA<RemoteStubCanvasEditingContract>());
    expect(bundle.assetManagement, isA<RemoteStubAssetManagementContract>());
    expect(
      bundle.collaborationContext,
      isA<RemoteStubCollaborationContextContract>(),
    );
    expect(bundle.inspectHandoff, isA<RemoteStubInspectHandoffContract>());
    expect(bundle.exportWorkflow, isA<RemoteStubExportWorkflowContract>());
    expect(
      bundle.diagnosticsRecovery,
      isA<RemoteStubDiagnosticsRecoveryContract>(),
    );
    expect(bundle.remoteStubProfile, isNotNull);
    expect(bundle.remoteStubProfile?.isEmpty, isTrue);
    expect(bundle.authSession.state.status, '[remote-stub] Idle');

    bundle.authSession.signIn(
      const AuthSignInRequest(
        email: 'designer@penjar.app',
        password: 'desktop-pass',
      ),
    );
    expect(
      bundle.authSession.state.status,
      '[remote-stub] Signed in (simulated).',
    );
  });

  test('fromMode routes mode to matching bundle factory', () {
    final DesktopContractBundle inMemoryBundle = DesktopContractBundle.fromMode(
      DesktopContractMode.inMemory,
    );
    final DesktopContractBundle remoteStubBundle =
        DesktopContractBundle.fromMode(DesktopContractMode.remoteStub);
    final DesktopContractBundle blockedRemoteStubBundle =
        DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubFaultProfile: const RemoteStubFaultProfile(
            unavailable: true,
          ),
        );

    expect(inMemoryBundle.mode, DesktopContractMode.inMemory);
    expect(inMemoryBundle.remoteStubProfile, isNull);
    expect(remoteStubBundle.mode, DesktopContractMode.remoteStub);
    expect(remoteStubBundle.remoteStubProfile, isNotNull);
    expect(remoteStubBundle.authSession.state.status, '[remote-stub] Idle');

    blockedRemoteStubBundle.authSession.signIn(
      const AuthSignInRequest(
        email: 'designer@penjar.app',
        password: 'desktop-pass',
      ),
    );
    expect(
      blockedRemoteStubBundle.authSession.state.status,
      '[remote-stub] Remote bridge unavailable: sign-in.',
    );
    expect(blockedRemoteStubBundle.remoteStubProfile?.unavailable, isTrue);
  });

  test('fromMode forwards remote-stub auth initial state snapshot', () {
    final DesktopContractBundle remoteStubBundle =
        DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubAuthInitialState: const AuthSessionState(
            rememberSession: true,
            signedIn: true,
            status: 'Restored from bundle seed.',
          ),
        );

    expect(remoteStubBundle.mode, DesktopContractMode.remoteStub);
    expect(remoteStubBundle.authSession.state.rememberSession, isTrue);
    expect(remoteStubBundle.authSession.state.signedIn, isTrue);
    expect(
      remoteStubBundle.authSession.state.status,
      '[remote-stub] Restored from bundle seed.',
    );
  });

  test('fromMode forwards strict backend auth schema mode', () {
    final _BundleBackendResponseTransportClient transportClient =
        _BundleBackendResponseTransportClient(<String, Map<String, Object?>>{
          RemoteStubOperationIds.signIn: <String, Object?>{
            'unexpected': <String, Object?>{'shape': true},
          },
        });
    final DesktopContractBundle nonStrictBundle =
        DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient: transportClient,
        );
    final DesktopContractBundle strictBundle = DesktopContractBundle.fromMode(
      DesktopContractMode.remoteStub,
      remoteStubTransportClient: transportClient,
      remoteStubAuthStrictBackendSchema: true,
    );

    nonStrictBundle.authSession.signIn(
      const AuthSignInRequest(
        email: 'designer@penjar.app',
        password: 'desktop-pass',
      ),
    );
    expect(nonStrictBundle.authSession.state.signedIn, isTrue);
    expect(
      nonStrictBundle.authSession.state.status,
      '[remote-stub] Signed in (simulated).',
    );

    strictBundle.authSession.signIn(
      const AuthSignInRequest(
        email: 'designer@penjar.app',
        password: 'desktop-pass',
      ),
    );
    expect(strictBundle.authSession.state.signedIn, isFalse);
    expect(
      strictBundle.authSession.state.status,
      '[remote-stub] Backend auth schema validation failed.',
    );
  });

  test('fromMode forwards required backend auth state mode', () {
    final DesktopContractBundle requiredBundle = DesktopContractBundle.fromMode(
      DesktopContractMode.remoteStub,
      remoteStubAuthRequireBackendState: true,
    );

    requiredBundle.authSession.signIn(
      const AuthSignInRequest(
        email: 'designer@penjar.app',
        password: 'desktop-pass',
      ),
    );

    expect(requiredBundle.authSession.state.signedIn, isFalse);
    expect(
      requiredBundle.authSession.state.status,
      '[remote-stub] Backend auth state payload required.',
    );
  });

  test(
    'fromMode auto-enables required backend auth state mode for backend execution transport',
    () {
      final RemoteStubHttpTransportClient backendTransportClient =
          RemoteStubHttpTransportClient(
            backendBaseUrl: 'https://api.penjar.app',
            executionProbe: (_) =>
                const RemoteStubHttpBackendExecutionResult.allowed(),
          );
      final DesktopContractBundle autoRequiredBundle =
          DesktopContractBundle.fromMode(
            DesktopContractMode.remoteStub,
            remoteStubTransportClient: backendTransportClient,
          );

      autoRequiredBundle.authSession.signIn(
        const AuthSignInRequest(
          email: 'designer@penjar.app',
          password: 'desktop-pass',
        ),
      );

      expect(autoRequiredBundle.authSession.state.signedIn, isFalse);
      expect(
        autoRequiredBundle.authSession.state.status,
        '[remote-stub] Backend auth state payload required.',
      );
      expect(
        autoRequiredBundle.remoteStubProfile?.authBackendStateLabel,
        'required',
      );
      expect(
        autoRequiredBundle.remoteStubProfile?.authBackendFallbackLabel,
        'require-state',
      );
      expect(
        autoRequiredBundle.remoteStubProfile?.summaryLabel,
        contains('auth-backend-state: required'),
      );
      expect(
        autoRequiredBundle.remoteStubProfile?.summaryLabel,
        contains('auth-backend-fallback: require-state'),
      );
    },
  );

  test(
    'fromMode allows explicit opt-out from auto required backend auth state mode',
    () {
      final RemoteStubHttpTransportClient backendTransportClient =
          RemoteStubHttpTransportClient(
            backendBaseUrl: 'https://api.penjar.app',
            executionProbe: (_) =>
                const RemoteStubHttpBackendExecutionResult.allowed(),
          );
      final DesktopContractBundle optOutBundle = DesktopContractBundle.fromMode(
        DesktopContractMode.remoteStub,
        remoteStubTransportClient: backendTransportClient,
        remoteStubAuthRequireBackendState: false,
      );

      optOutBundle.authSession.signIn(
        const AuthSignInRequest(
          email: 'designer@penjar.app',
          password: 'desktop-pass',
        ),
      );

      expect(optOutBundle.authSession.state.signedIn, isTrue);
      expect(
        optOutBundle.authSession.state.status,
        '[remote-stub] Signed in (simulated).',
      );
      expect(optOutBundle.remoteStubProfile?.authBackendStateLabel, isEmpty);
      expect(
        optOutBundle.remoteStubProfile?.summaryLabel,
        isNot(contains('auth-backend-state: required')),
      );
      expect(
        optOutBundle.remoteStubProfile?.authBackendFallbackLabel,
        'delegate-enabled',
      );
      expect(
        optOutBundle.remoteStubProfile?.summaryLabel,
        contains('auth-backend-fallback: delegate-enabled'),
      );
    },
  );

  test('fromMode forwards auth sign-in credential payload mode', () {
    final _BundleCaptureTransportClient sanitizedTransportClient =
        _BundleCaptureTransportClient();
    final DesktopContractBundle sanitizedBundle =
        DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient: sanitizedTransportClient,
        );
    sanitizedBundle.authSession.signIn(
      const AuthSignInRequest(
        email: 'designer@penjar.app',
        password: 'desktop-pass',
      ),
    );

    expect(sanitizedTransportClient.executed, hasLength(1));
    final RemoteStubTransportRequest sanitizedRequest =
        sanitizedTransportClient.executed.single;
    expect(sanitizedRequest.operation, RemoteStubOperationIds.signIn);
    expect(sanitizedRequest.payload['passwordLength'], 12);
    expect(sanitizedRequest.payload.containsKey('password'), isFalse);

    final _BundleCaptureTransportClient forwardedTransportClient =
        _BundleCaptureTransportClient();
    final DesktopContractBundle forwardedBundle =
        DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient: forwardedTransportClient,
          remoteStubAuthForwardSignInCredentials: true,
        );
    forwardedBundle.authSession.signIn(
      const AuthSignInRequest(
        email: 'designer@penjar.app',
        password: 'desktop-pass',
      ),
    );

    expect(forwardedTransportClient.executed, hasLength(1));
    final RemoteStubTransportRequest forwardedRequest =
        forwardedTransportClient.executed.single;
    expect(forwardedRequest.operation, RemoteStubOperationIds.signIn);
    expect(forwardedRequest.payload['passwordLength'], 12);
    expect(forwardedRequest.payload['password'], 'desktop-pass');
  });

  test('remote-stub profile exposes strict backend auth schema label', () {
    final DesktopContractBundle bundle = DesktopContractBundle.fromMode(
      DesktopContractMode.remoteStub,
      remoteStubAuthStrictBackendSchema: true,
    );

    expect(bundle.remoteStubProfile?.isEmpty, isFalse);
    expect(bundle.remoteStubProfile?.authBackendSchemaLabel, 'strict');
    expect(
      bundle.remoteStubProfile?.summaryLabel,
      contains('auth-backend-schema: strict'),
    );
  });

  test('remote-stub profile exposes required auth backend state label', () {
    final DesktopContractBundle bundle = DesktopContractBundle.fromMode(
      DesktopContractMode.remoteStub,
      remoteStubAuthRequireBackendState: true,
    );

    expect(bundle.remoteStubProfile?.isEmpty, isFalse);
    expect(bundle.remoteStubProfile?.authBackendStateLabel, 'required');
    expect(
      bundle.remoteStubProfile?.summaryLabel,
      contains('auth-backend-state: required'),
    );
  });

  test('remote-stub profile exposes forwarded auth sign-in payload label', () {
    final DesktopContractBundle bundle = DesktopContractBundle.fromMode(
      DesktopContractMode.remoteStub,
      remoteStubAuthForwardSignInCredentials: true,
    );

    expect(bundle.remoteStubProfile?.isEmpty, isFalse);
    expect(bundle.remoteStubProfile?.authSignInPayloadLabel, 'forwarded');
    expect(
      bundle.remoteStubProfile?.summaryLabel,
      contains('auth-sign-in-payload: forwarded'),
    );
  });

  test(
    'remote-stub profile exposes strict-schema fallback label for backend execution transport',
    () {
      final DesktopContractBundle bundle = DesktopContractBundle.fromMode(
        DesktopContractMode.remoteStub,
        remoteStubTransportClient: RemoteStubHttpTransportClient(
          backendBaseUrl: 'https://api.penjar.app/v1',
          executionProbe: (_) =>
              const RemoteStubHttpBackendExecutionResult.allowed(),
        ),
        remoteStubAuthStrictBackendSchema: true,
        remoteStubAuthRequireBackendState: false,
      );

      expect(bundle.remoteStubProfile?.isEmpty, isFalse);
      expect(bundle.remoteStubProfile?.authBackendStateLabel, isEmpty);
      expect(bundle.remoteStubProfile?.authBackendSchemaLabel, 'strict');
      expect(
        bundle.remoteStubProfile?.authBackendFallbackLabel,
        'strict-schema',
      );
      expect(
        bundle.remoteStubProfile?.summaryLabel,
        contains('auth-backend-fallback: strict-schema'),
      );
    },
  );

  test('remote-stub bundle forwards auth state store persistence seam', () {
    final RemoteStubMemoryAuthStateStore authStateStore =
        RemoteStubMemoryAuthStateStore();
    final DesktopContractBundle remoteStubBundle =
        DesktopContractBundle.remoteStub(authStateStore: authStateStore);

    remoteStubBundle.authSession.signIn(
      const AuthSignInRequest(
        email: 'designer@penjar.app',
        password: 'desktop-pass',
      ),
    );

    final AuthSessionState? persistedState = authStateStore.load();
    expect(persistedState, isNotNull);
    expect(persistedState?.signedIn, isTrue);
    expect(persistedState?.status, 'Signed in (simulated).');
  });

  test('remote-stub bundle supports command auth state store seam', () {
    final List<RemoteStubCommandExecutionRequest> executedRequests =
        <RemoteStubCommandExecutionRequest>[];
    final RemoteStubCommandAuthStateStore
    authStateStore = RemoteStubCommandAuthStateStore(
      loadCommand: 'load-auth-snapshot',
      saveCommand: 'save-auth-snapshot',
      commandRunner: (RemoteStubCommandExecutionRequest request) {
        executedRequests.add(request);
        if (request.command == 'load-auth-snapshot') {
          return const RemoteStubCommandExecutionResult(
            exitCode: 0,
            stdout:
                '{"rememberSession":true,"signedIn":true,"status":"Loaded from command."}',
          );
        }
        return const RemoteStubCommandExecutionResult(exitCode: 0);
      },
    );
    final DesktopContractBundle remoteStubBundle =
        DesktopContractBundle.remoteStub(authStateStore: authStateStore);

    expect(remoteStubBundle.authSession.state.rememberSession, isTrue);
    expect(remoteStubBundle.authSession.state.signedIn, isTrue);
    expect(
      remoteStubBundle.authSession.state.status,
      '[remote-stub] Loaded from command.',
    );

    remoteStubBundle.authSession.refreshToken();
    expect(
      executedRequests.map(
        (RemoteStubCommandExecutionRequest item) => item.command,
      ),
      containsAll(<String>['load-auth-snapshot', 'save-auth-snapshot']),
    );
  });

  test('remote-stub bundle supports secure auth state store seam', () async {
    final List<String> persistedSnapshots = <String>[];
    final RemoteStubSecureSnapshotAuthStateStore authStateStore =
        RemoteStubSecureSnapshotAuthStateStore(
          initialSnapshot: const AuthSessionState(
            rememberSession: true,
            signedIn: true,
            status: 'Loaded from secure store.',
          ),
          snapshotWriter: (String snapshotJson) async {
            persistedSnapshots.add(snapshotJson);
          },
        );
    final DesktopContractBundle remoteStubBundle =
        DesktopContractBundle.remoteStub(authStateStore: authStateStore);

    expect(remoteStubBundle.authSession.state.rememberSession, isTrue);
    expect(remoteStubBundle.authSession.state.signedIn, isTrue);
    expect(
      remoteStubBundle.authSession.state.status,
      '[remote-stub] Loaded from secure store.',
    );

    remoteStubBundle.authSession.signIn(
      const AuthSignInRequest(
        email: 'designer@penjar.app',
        password: 'desktop-pass',
      ),
    );
    await Future<void>.delayed(Duration.zero);
    expect(persistedSnapshots, isNotEmpty);
    expect(persistedSnapshots.last, contains('"signedIn":true'));
    expect(
      persistedSnapshots.last,
      contains('"status":"Signed in (simulated)."'),
    );
  });

  test('remote-stub profile exposes auth store label for secure store', () {
    final DesktopContractBundle bundle = DesktopContractBundle.remoteStub(
      authStateStore: RemoteStubSecureSnapshotAuthStateStore(
        snapshotWriter: (_) async {},
      ),
    );

    expect(bundle.remoteStubProfile?.authStoreLabel, 'secure-storage');
    expect(
      bundle.remoteStubProfile?.summaryLabel,
      contains('auth-store: secure-storage'),
    );
  });

  test('remote-stub profile exposes auth store mirror label', () {
    final DesktopContractBundle bundle = DesktopContractBundle.remoteStub(
      authStateStore: RemoteStubCompositeAuthStateStore(
        primary: RemoteStubSecureSnapshotAuthStateStore(
          snapshotWriter: (_) async {},
        ),
        secondary: RemoteStubMemoryAuthStateStore(),
      ),
    );

    expect(
      bundle.remoteStubProfile?.authStoreLabel,
      'secure-storage+legacy-mirror',
    );
    expect(
      bundle.remoteStubProfile?.summaryLabel,
      contains('auth-store: secure-storage+legacy-mirror'),
    );
  });

  test('remote-stub unavailable profile blocks mutating operations', () {
    final DesktopContractBundle bundle = DesktopContractBundle.remoteStub(
      faultProfile: const RemoteStubFaultProfile(unavailable: true),
    );

    bundle.authSession.signIn(
      const AuthSignInRequest(
        email: 'designer@penjar.app',
        password: 'desktop-pass',
      ),
    );
    expect(bundle.authSession.state.signedIn, isFalse);
    expect(
      bundle.authSession.state.status,
      '[remote-stub] Remote bridge unavailable: sign-in.',
    );

    bundle.projectLifecycle.createProject('Remote Fail');
    expect(bundle.projectLifecycle.state.projects, hasLength(1));
    expect(
      bundle.projectLifecycle.state.status,
      '[remote-stub] Remote bridge unavailable: create-project.',
    );

    bundle.exportWorkflow.runExport(
      const ExportRequest(
        fileName: 'landing',
        format: 'png',
        scale: '2x',
        includeBackground: true,
      ),
    );
    expect(bundle.exportWorkflow.state.artifacts, isEmpty);
    expect(
      bundle.exportWorkflow.state.status,
      '[remote-stub] Remote bridge unavailable: run-export.',
    );
  });

  test('remote-stub blocked operations profile blocks selected operations', () {
    final DesktopContractBundle bundle = DesktopContractBundle.fromMode(
      DesktopContractMode.remoteStub,
      remoteStubFaultProfile: const RemoteStubFaultProfile(
        blockedOperations: <String>{'sign-in'},
      ),
    );

    bundle.authSession.signIn(
      const AuthSignInRequest(
        email: 'designer@penjar.app',
        password: 'desktop-pass',
      ),
    );
    expect(bundle.authSession.state.signedIn, isFalse);
    expect(
      bundle.authSession.state.status,
      '[remote-stub] Remote bridge unavailable: sign-in.',
    );
    expect(
      bundle.remoteStubProfile?.blockedOperations,
      contains(RemoteStubOperationIds.signIn),
    );

    bundle.projectLifecycle.createProject('Allowed Project');
    expect(bundle.projectLifecycle.state.projects, hasLength(2));
    expect(
      bundle.projectLifecycle.state.status,
      '[remote-stub] Project created: Allowed Project.',
    );
  });

  test(
    'remote-stub transport client blocks selected operations independently',
    () {
      final DesktopContractBundle bundle = DesktopContractBundle.fromMode(
        DesktopContractMode.remoteStub,
        remoteStubTransportClient: const RemoteStubScriptedTransportClient(
          blockedOperations: <String>{'create-project'},
          blockedReason: 'Remote transport unavailable',
        ),
      );

      bundle.authSession.signIn(
        const AuthSignInRequest(
          email: 'designer@penjar.app',
          password: 'desktop-pass',
        ),
      );
      expect(bundle.authSession.state.signedIn, isTrue);
      expect(
        bundle.authSession.state.status,
        '[remote-stub] Signed in (simulated).',
      );

      bundle.projectLifecycle.createProject('Transport Blocked');
      expect(bundle.projectLifecycle.state.projects, hasLength(1));
      expect(
        bundle.projectLifecycle.state.status,
        '[remote-stub] Remote transport unavailable: create-project.',
      );
      expect(
        bundle.remoteStubProfile?.transportBlockedOperations,
        contains(RemoteStubOperationIds.createProject),
      );
    },
  );

  test('remote-stub profile exposes http transport label', () {
    final DesktopContractBundle bundle = DesktopContractBundle.fromMode(
      DesktopContractMode.remoteStub,
      remoteStubTransportClient: RemoteStubHttpTransportClient(
        healthUrl: 'https://api.penjar.app/desktop/health?token=secret',
        probe: (_) => const RemoteStubHttpTransportProbeResult.allowed(),
      ),
    );

    expect(bundle.remoteStubProfile?.isEmpty, isFalse);
    expect(
      bundle.remoteStubProfile?.transportLabel,
      'http-health:https://api.penjar.app/desktop/health',
    );
    expect(
      bundle.remoteStubProfile?.summaryLabel,
      contains('transport: http-health:https://api.penjar.app/desktop/health'),
    );
  });

  test('remote-stub profile exposes backend execution transport label', () {
    final DesktopContractBundle bundle = DesktopContractBundle.fromMode(
      DesktopContractMode.remoteStub,
      remoteStubTransportClient: RemoteStubHttpTransportClient(
        backendBaseUrl: 'https://api.penjar.app/v1',
        executionProbe: (_) =>
            const RemoteStubHttpBackendExecutionResult.allowed(),
      ),
    );

    expect(bundle.remoteStubProfile?.isEmpty, isFalse);
    expect(
      bundle.remoteStubProfile?.transportLabel,
      'http-backend:https://api.penjar.app/v1',
    );
    expect(
      bundle.remoteStubProfile?.summaryLabel,
      contains('transport: http-backend:https://api.penjar.app/v1'),
    );
  });

  test('remote-stub profile exposes backend endpoint override label', () {
    final DesktopContractBundle bundle = DesktopContractBundle.fromMode(
      DesktopContractMode.remoteStub,
      remoteStubTransportClient: RemoteStubHttpTransportClient(
        backendBaseUrl: 'https://api.penjar.app/v1',
        backendEndpointOverrides: <String, String>{
          RemoteStubOperationIds.signIn: '/v2/auth/custom-sign-in',
        },
        executionProbe: (_) =>
            const RemoteStubHttpBackendExecutionResult.allowed(),
      ),
    );

    expect(bundle.remoteStubProfile?.isEmpty, isFalse);
    expect(
      bundle.remoteStubProfile?.transportLabel,
      'http-backend:https://api.penjar.app/v1 · http-backend-overrides:1',
    );
    expect(
      bundle.remoteStubProfile?.summaryLabel,
      contains(
        'transport: http-backend:https://api.penjar.app/v1 · http-backend-overrides:1',
      ),
    );
  });
}
