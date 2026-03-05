import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:penjar_desktop/contracts/desktop_contract_bundle.dart';
import 'package:penjar_desktop/contracts/remote_stub_contracts.dart';

import 'parity_test_utils.dart';

class _AuthBackendParityTransportClient extends RemoteStubTransportClient {
  const _AuthBackendParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'code': 401,
          'message': 'Backend token expired.',
          'state': <String, Object?>{'sessionToken': 'expired-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendCodeOnlyParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendCodeOnlyParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'code': 401,
          'state': <String, Object?>{'sessionToken': 'expired-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendStatusCodeParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendStatusCodeParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'statusCode': 401,
          'state': <String, Object?>{'sessionToken': 'expired-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendStatusCodeSnakeCaseParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendStatusCodeSnakeCaseParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status_code': 403,
          'state': <String, Object?>{'sessionToken': 'expired-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendFailureFlagSnakeCaseParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendFailureFlagSnakeCaseParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'is_success': false,
          'state': <String, Object?>{'sessionToken': 'expired-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendFailureFlagOkParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendFailureFlagOkParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'ok': false,
          'state': <String, Object?>{'sessionToken': 'expired-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendFailureFlagIsSuccessParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendFailureFlagIsSuccessParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'isSuccess': false,
          'state': <String, Object?>{'sessionToken': 'expired-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendFailureFlagIsOkSnakeCaseParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendFailureFlagIsOkSnakeCaseParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'is_ok': false,
          'state': <String, Object?>{'sessionToken': 'expired-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendFailureFlagIsOkParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendFailureFlagIsOkParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'isOk': false,
          'state': <String, Object?>{'sessionToken': 'expired-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendFailureFlagMixedAliasParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendFailureFlagMixedAliasParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'success': true,
          'is_success': false,
          'state': <String, Object?>{'sessionToken': 'expired-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendFailureFlagNestedMixedAliasParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendFailureFlagNestedMixedAliasParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'success': true,
          'errors': <Map<String, Object?>>[
            <String, Object?>{'is_success': false},
          ],
          'state': <String, Object?>{'sessionToken': 'expired-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendSnakeCaseStateAliasParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendSnakeCaseStateAliasParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend snake-case sign-in snapshot applied.',
          'state': <String, Object?>{
            'signed_in': true,
            'remember_session': true,
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendLoggedInStateAliasParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendLoggedInStateAliasParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend logged-in sign-in snapshot applied.',
          'state': <String, Object?>{
            'logged_in': true,
            'persist_session': true,
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendIsLoggedInStateAliasParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendIsLoggedInStateAliasParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend is_logged_in sign-in snapshot applied.',
          'state': <String, Object?>{
            'is_logged_in': true,
            'persist_session': true,
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendLoggedInCamelCaseStateAliasParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendLoggedInCamelCaseStateAliasParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend loggedIn sign-in snapshot applied.',
          'state': <String, Object?>{'loggedIn': true, 'persistSession': true},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendIsLoggedInCamelCaseStateAliasParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendIsLoggedInCamelCaseStateAliasParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend isLoggedIn sign-in snapshot applied.',
          'state': <String, Object?>{
            'isLoggedIn': true,
            'persistSession': true,
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendSignedOutAliasParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendSignedOutAliasParityTransportClient({
    required this.signedOutAlias,
  });

  final String signedOutAlias;

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      final Map<String, Object?> statePayload = <String, Object?>{
        signedOutAlias: true,
        'sessionToken': 'expired-session',
      };
      return RemoteStubTransportResult.allowedWithPayload(<String, Object?>{
        'state': statePayload,
      });
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendSessionTimeoutParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendSessionTimeoutParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend sign-in snapshot applied.',
          'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'code': 'SESSION_TIMEOUT',
          'state': <String, Object?>{'sessionToken': 'timed-out-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendCyclicErrorContainerParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendCyclicErrorContainerParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      final Map<String, Object?> cyclicError = <String, Object?>{};
      final List<Object?> cyclicFailures = <Object?>[];
      cyclicError['error'] = cyclicError;
      cyclicError['failures'] = cyclicFailures;
      cyclicFailures.add(cyclicError);
      cyclicFailures.add(cyclicFailures);

      return RemoteStubTransportResult.allowedWithPayload(<String, Object?>{
        'message': 'Backend cyclic payload handled.',
        'error': cyclicError,
        'failures': cyclicFailures,
        'state': <String, Object?>{'signedIn': true, 'rememberSession': true},
      });
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendDeepEnvelopeParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendDeepEnvelopeParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'result': <String, Object?>{
            'data': <String, Object?>{
              'payload': <String, Object?>{
                'result': <String, Object?>{
                  'data': <String, Object?>{
                    'detail': 'Backend deep envelope payload handled.',
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
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendAlternateEnvelopeAfterCycleParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendAlternateEnvelopeAfterCycleParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      final Map<String, Object?> responsePayload = <String, Object?>{
        'data': <String, Object?>{
          'detail': 'Backend alternate envelope payload handled.',
          'authState': <String, Object?>{
            'isAuthenticated': true,
            'remember_session': true,
          },
        },
      };
      responsePayload['result'] = responsePayload;
      return RemoteStubTransportResult.allowedWithPayload(responsePayload);
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendSiblingDataEnvelopeParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendSiblingDataEnvelopeParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'result': <String, Object?>{
            'meta': <String, Object?>{'requestId': 'req-1'},
          },
          'data': <String, Object?>{
            'detail': 'Backend sibling data envelope payload handled.',
            'authState': <String, Object?>{
              'isAuthenticated': true,
              'remember_session': true,
            },
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendPayloadEnvelopeParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendPayloadEnvelopeParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'payload': <String, Object?>{
            'detail': 'Backend payload sign-in snapshot applied.',
            'authState': <String, Object?>{
              'signed_in': true,
              'remember_session': true,
            },
          },
        },
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'result': <String, Object?>{
            'payload': <String, Object?>{
              'authState': <String, Object?>{
                'signed_out': true,
                'sessionToken': 'payload-envelope-expired-session',
              },
            },
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

void main() {
  testWidgets('auth/session parity scaffold interactions work', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(tester);
    await openWorkflowSection(tester, 'auth');

    expect(
      find.byKey(const ValueKey<String>('auth-session-panel')),
      findsOneWidget,
    );
    expect(find.textContaining('Status: Idle'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('auth-sign-in')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining(
        'Validation failed: email and password are required.',
      ),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey<String>('auth-email')),
      'designer@penjar.app',
    );
    await tester.enterText(
      find.byKey(const ValueKey<String>('auth-password')),
      'desktop-pass',
    );

    await tester.tap(find.byKey(const ValueKey<String>('auth-remember')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('auth-sign-in')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Signed in (simulated).'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('auth-refresh-token')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('auth-refresh-token')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Token refreshed (simulated).'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('auth-restore-session')),
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('auth-restore-session')),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Session restored (simulated).'),
      findsOneWidget,
    );
  });

  testWidgets(
    'auth/session parity applies backend auth snapshots and signed-out transitions',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient: const _AuthBackendParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Status: [remote-stub] Backend token expired.'),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity maps code-only backend failure to deterministic auth-required status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendCodeOnlyParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Status: [remote-stub] Authentication required.'),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity maps statusCode backend failure to deterministic auth-required status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendStatusCodeParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Status: [remote-stub] Authentication required.'),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity maps status_code backend failure to deterministic auth-required status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendStatusCodeSnakeCaseParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Status: [remote-stub] Authentication required.'),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity maps snake-case failure flag to deterministic auth-failed status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendFailureFlagSnakeCaseParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend auth request failed.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity maps ok failure flag to deterministic auth-failed status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendFailureFlagOkParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend auth request failed.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity maps isSuccess failure flag to deterministic auth-failed status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendFailureFlagIsSuccessParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend auth request failed.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity maps is_ok failure flag to deterministic auth-failed status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendFailureFlagIsOkSnakeCaseParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend auth request failed.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity maps isOk failure flag to deterministic auth-failed status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendFailureFlagIsOkParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend auth request failed.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity prioritizes explicit false in mixed failure-flag aliases',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendFailureFlagMixedAliasParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend auth request failed.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity prioritizes explicit false in nested mixed failure-flag aliases',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendFailureFlagNestedMixedAliasParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend auth request failed.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity normalizes snake_case signed-in state aliases',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendSnakeCaseStateAliasParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'Status: [remote-stub] Backend snake-case sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      final CheckboxListTile rememberSessionTile = tester.widget(
        find.byKey(const ValueKey<String>('auth-remember')),
      );
      expect(rememberSessionTile.value, isTrue);

      expect(find.textContaining('Signed in (simulated).'), findsNothing);
    },
  );

  testWidgets('auth/session parity normalizes logged_in state aliases', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(
      tester,
      contracts: DesktopContractBundle.fromMode(
        DesktopContractMode.remoteStub,
        remoteStubTransportClient:
            const _AuthBackendLoggedInStateAliasParityTransportClient(),
      ),
    );
    await openWorkflowSection(tester, 'auth');

    await tester.enterText(
      find.byKey(const ValueKey<String>('auth-password')),
      'desktop-pass',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('auth-sign-in')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
    await tester.pumpAndSettle();

    expect(
      find.textContaining(
        'Status: [remote-stub] Backend logged-in sign-in snapshot applied.',
      ),
      findsOneWidget,
    );
    final CheckboxListTile rememberSessionTile = tester.widget(
      find.byKey(const ValueKey<String>('auth-remember')),
    );
    expect(rememberSessionTile.value, isTrue);

    expect(find.textContaining('Signed in (simulated).'), findsNothing);
  });

  testWidgets('auth/session parity normalizes loggedIn state aliases', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(
      tester,
      contracts: DesktopContractBundle.fromMode(
        DesktopContractMode.remoteStub,
        remoteStubTransportClient:
            const _AuthBackendLoggedInCamelCaseStateAliasParityTransportClient(),
      ),
    );
    await openWorkflowSection(tester, 'auth');

    await tester.enterText(
      find.byKey(const ValueKey<String>('auth-password')),
      'desktop-pass',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('auth-sign-in')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
    await tester.pumpAndSettle();

    expect(
      find.textContaining(
        'Status: [remote-stub] Backend loggedIn sign-in snapshot applied.',
      ),
      findsOneWidget,
    );
    final CheckboxListTile rememberSessionTile = tester.widget(
      find.byKey(const ValueKey<String>('auth-remember')),
    );
    expect(rememberSessionTile.value, isTrue);

    expect(find.textContaining('Signed in (simulated).'), findsNothing);
  });

  testWidgets('auth/session parity normalizes is_logged_in state aliases', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(
      tester,
      contracts: DesktopContractBundle.fromMode(
        DesktopContractMode.remoteStub,
        remoteStubTransportClient:
            const _AuthBackendIsLoggedInStateAliasParityTransportClient(),
      ),
    );
    await openWorkflowSection(tester, 'auth');

    await tester.enterText(
      find.byKey(const ValueKey<String>('auth-password')),
      'desktop-pass',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('auth-sign-in')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
    await tester.pumpAndSettle();

    expect(
      find.textContaining(
        'Status: [remote-stub] Backend is_logged_in sign-in snapshot applied.',
      ),
      findsOneWidget,
    );
    final CheckboxListTile rememberSessionTile = tester.widget(
      find.byKey(const ValueKey<String>('auth-remember')),
    );
    expect(rememberSessionTile.value, isTrue);

    expect(find.textContaining('Signed in (simulated).'), findsNothing);
  });

  testWidgets('auth/session parity normalizes isLoggedIn state aliases', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(
      tester,
      contracts: DesktopContractBundle.fromMode(
        DesktopContractMode.remoteStub,
        remoteStubTransportClient:
            const _AuthBackendIsLoggedInCamelCaseStateAliasParityTransportClient(),
      ),
    );
    await openWorkflowSection(tester, 'auth');

    await tester.enterText(
      find.byKey(const ValueKey<String>('auth-password')),
      'desktop-pass',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('auth-sign-in')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
    await tester.pumpAndSettle();

    expect(
      find.textContaining(
        'Status: [remote-stub] Backend isLoggedIn sign-in snapshot applied.',
      ),
      findsOneWidget,
    );
    final CheckboxListTile rememberSessionTile = tester.widget(
      find.byKey(const ValueKey<String>('auth-remember')),
    );
    expect(rememberSessionTile.value, isTrue);

    expect(find.textContaining('Signed in (simulated).'), findsNothing);
  });

  testWidgets('auth/session parity tolerates cyclic error containers', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(
      tester,
      contracts: DesktopContractBundle.fromMode(
        DesktopContractMode.remoteStub,
        remoteStubTransportClient:
            const _AuthBackendCyclicErrorContainerParityTransportClient(),
      ),
    );
    await openWorkflowSection(tester, 'auth');

    await tester.enterText(
      find.byKey(const ValueKey<String>('auth-password')),
      'desktop-pass',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('auth-sign-in')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
    await tester.pumpAndSettle();

    expect(
      find.textContaining(
        'Status: [remote-stub] Backend cyclic payload handled.',
      ),
      findsOneWidget,
    );
    final CheckboxListTile rememberSessionTile = tester.widget(
      find.byKey(const ValueKey<String>('auth-remember')),
    );
    expect(rememberSessionTile.value, isTrue);

    expect(find.textContaining('Signed in (simulated).'), findsNothing);
  });

  testWidgets('auth/session parity supports deep backend envelope chains', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(
      tester,
      contracts: DesktopContractBundle.fromMode(
        DesktopContractMode.remoteStub,
        remoteStubTransportClient:
            const _AuthBackendDeepEnvelopeParityTransportClient(),
      ),
    );
    await openWorkflowSection(tester, 'auth');

    await tester.enterText(
      find.byKey(const ValueKey<String>('auth-password')),
      'desktop-pass',
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey<String>('auth-sign-in')),
    );
    await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
    await tester.pumpAndSettle();

    expect(
      find.textContaining(
        'Status: [remote-stub] Backend deep envelope payload handled.',
      ),
      findsOneWidget,
    );
    final CheckboxListTile rememberSessionTile = tester.widget(
      find.byKey(const ValueKey<String>('auth-remember')),
    );
    expect(rememberSessionTile.value, isTrue);

    expect(find.textContaining('Signed in (simulated).'), findsNothing);
  });

  testWidgets(
    'auth/session parity skips cyclic primary envelope when data envelope is available',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendAlternateEnvelopeAfterCycleParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'Status: [remote-stub] Backend alternate envelope payload handled.',
        ),
        findsOneWidget,
      );
      final CheckboxListTile rememberSessionTile = tester.widget(
        find.byKey(const ValueKey<String>('auth-remember')),
      );
      expect(rememberSessionTile.value, isTrue);

      expect(find.textContaining('Signed in (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity uses sibling data envelope when result envelope lacks state',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendSiblingDataEnvelopeParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sibling data envelope payload handled.',
        ),
        findsOneWidget,
      );
      final CheckboxListTile rememberSessionTile = tester.widget(
        find.byKey(const ValueKey<String>('auth-remember')),
      );
      expect(rememberSessionTile.value, isTrue);

      expect(find.textContaining('Signed in (simulated).'), findsNothing);
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
    testWidgets(
      'auth/session parity maps $signedOutAlias alias to deterministic auth-required status',
      (WidgetTester tester) async {
        await pumpDesktopApp(
          tester,
          contracts: DesktopContractBundle.fromMode(
            DesktopContractMode.remoteStub,
            remoteStubTransportClient:
                _AuthBackendSignedOutAliasParityTransportClient(
                  signedOutAlias: signedOutAlias,
                ),
          ),
        );
        await openWorkflowSection(tester, 'auth');

        await tester.enterText(
          find.byKey(const ValueKey<String>('auth-password')),
          'desktop-pass',
        );
        await tester.ensureVisible(
          find.byKey(const ValueKey<String>('auth-sign-in')),
        );
        await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
        await tester.pumpAndSettle();
        expect(
          find.textContaining(
            'Status: [remote-stub] Backend sign-in snapshot applied.',
          ),
          findsOneWidget,
        );

        await tester.ensureVisible(
          find.byKey(const ValueKey<String>('auth-refresh-token')),
        );
        await tester.tap(
          find.byKey(const ValueKey<String>('auth-refresh-token')),
        );
        await tester.pumpAndSettle();
        expect(
          find.textContaining('Status: [remote-stub] Authentication required.'),
          findsOneWidget,
        );
        expect(
          find.textContaining('Token refreshed (simulated).'),
          findsNothing,
        );
      },
    );
  }

  testWidgets(
    'auth/session parity maps session-timeout backend failure to deterministic session-expired status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendSessionTimeoutParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Status: [remote-stub] Backend session expired.'),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity applies payload envelope backend snapshots and nested signed-out fallback',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendPayloadEnvelopeParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend payload sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      final CheckboxListTile rememberSessionTile = tester.widget(
        find.byKey(const ValueKey<String>('auth-remember')),
      );
      expect(rememberSessionTile.value, isTrue);

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-refresh-token')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Status: [remote-stub] Authentication required.'),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity required-state mode blocks empty backend payload fallback',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubAuthRequireBackendState: true,
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.enterText(
        find.byKey(const ValueKey<String>('auth-password')),
        'desktop-pass',
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-sign-in')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('auth-sign-in')));
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          'Status: [remote-stub] Backend auth state payload required.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Signed in (simulated).'), findsNothing);
    },
  );
}
