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

class _AuthBackendCodeOnlySignedInOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendCodeOnlySignedInOverrideParityTransportClient();

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
          'state': <String, Object?>{
            'signedIn': true,
            'rememberSession': true,
            'sessionToken': 'override-session-token',
          },
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

class _AuthBackendStatusCodeSignedInOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendStatusCodeSignedInOverrideParityTransportClient();

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
          'state': <String, Object?>{
            'signedIn': true,
            'rememberSession': true,
            'sessionToken': 'override-session-token',
          },
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

class _AuthBackendStatusCodeSnakeCaseSignedInOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendStatusCodeSnakeCaseSignedInOverrideParityTransportClient();

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
          'state': <String, Object?>{
            'signedIn': true,
            'rememberSession': true,
            'sessionToken': 'override-session-token',
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendFailureFlagSuccessParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendFailureFlagSuccessParityTransportClient();

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
          'success': false,
          'state': <String, Object?>{'sessionToken': 'expired-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendFailureFlagSuccessSignedInOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendFailureFlagSuccessSignedInOverrideParityTransportClient();

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
          'success': false,
          'state': <String, Object?>{
            'signedIn': true,
            'rememberSession': true,
            'sessionToken': 'override-session-token',
          },
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

class _AuthBackendFailureFlagSnakeCaseSignedInOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendFailureFlagSnakeCaseSignedInOverrideParityTransportClient();

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
          'state': <String, Object?>{
            'signedIn': true,
            'rememberSession': true,
            'sessionToken': 'override-session-token',
          },
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

class _AuthBackendFailureFlagOkSignedInOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendFailureFlagOkSignedInOverrideParityTransportClient();

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
          'state': <String, Object?>{
            'signedIn': true,
            'rememberSession': true,
            'sessionToken': 'override-session-token',
          },
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

class _AuthBackendFailureFlagIsSuccessSignedInOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendFailureFlagIsSuccessSignedInOverrideParityTransportClient();

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
          'state': <String, Object?>{
            'signedIn': true,
            'rememberSession': true,
            'sessionToken': 'override-session-token',
          },
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

class _AuthBackendFailureFlagIsOkSnakeCaseSignedInOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendFailureFlagIsOkSnakeCaseSignedInOverrideParityTransportClient();

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
          'state': <String, Object?>{
            'signedIn': true,
            'rememberSession': true,
            'sessionToken': 'override-session-token',
          },
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

class _AuthBackendFailureFlagIsOkSignedInOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendFailureFlagIsOkSignedInOverrideParityTransportClient();

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
          'state': <String, Object?>{
            'signedIn': true,
            'rememberSession': true,
            'sessionToken': 'override-session-token',
          },
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

class _AuthBackendFailureFlagNestedSignedInOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendFailureFlagNestedSignedInOverrideParityTransportClient();

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
          'state': <String, Object?>{
            'signedIn': true,
            'rememberSession': true,
            'sessionToken': 'override-session-token',
          },
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

class _AuthBackendIsSignedInStateAliasParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendIsSignedInStateAliasParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend is_signed_in sign-in snapshot applied.',
          'state': <String, Object?>{
            'is_signed_in': true,
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

class _AuthBackendSignedOutAliasSignedInOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendSignedOutAliasSignedInOverrideParityTransportClient({
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
        'signedIn': true,
        signedOutAlias: true,
        'remember_session': true,
        'sessionToken': 'override-session-token',
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

class _AuthBackendTokenExpiredParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendTokenExpiredParityTransportClient();

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
          'errorCode': 'TOKEN_EXPIRED',
          'state': <String, Object?>{'sessionToken': 'token-expired-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendHttpStatusSessionExpiredParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendHttpStatusSessionExpiredParityTransportClient();

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
          'state': <String, Object?>{
            'httpStatus': '440',
            'sessionToken': 'http-status-expired-session',
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendHttpStatusSnakeCaseSessionExpiredParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendHttpStatusSnakeCaseSessionExpiredParityTransportClient();

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
          'state': <String, Object?>{
            'http_status': 419,
            'sessionToken': 'http-status-snake-expired-session',
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendSignedOutErrorCodeSignedInOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendSignedOutErrorCodeSignedInOverrideParityTransportClient();

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
          'code': 'AUTH_REQUIRED',
          'state': <String, Object?>{
            'signedIn': true,
            'rememberSession': true,
            'sessionToken': 'override-session-token',
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendSessionTimeoutSignedInOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendSessionTimeoutSignedInOverrideParityTransportClient();

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
          'state': <String, Object?>{
            'signedIn': true,
            'rememberSession': true,
            'sessionToken': 'override-session-token',
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendTokenExpiredSignedInOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendTokenExpiredSignedInOverrideParityTransportClient();

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
          'errorCode': 'TOKEN_EXPIRED',
          'state': <String, Object?>{
            'signedIn': true,
            'rememberSession': true,
            'sessionToken': 'override-session-token',
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendHttpStatusSignedInOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendHttpStatusSignedInOverrideParityTransportClient();

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
          'httpStatus': '440',
          'state': <String, Object?>{
            'signedIn': true,
            'rememberSession': true,
            'sessionToken': 'override-session-token',
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendHttpStatusSnakeCaseSignedInOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendHttpStatusSnakeCaseSignedInOverrideParityTransportClient();

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
          'http_status': 419,
          'state': <String, Object?>{
            'signedIn': true,
            'rememberSession': true,
            'sessionToken': 'override-session-token',
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendExpiredTokenSignedInOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendExpiredTokenSignedInOverrideParityTransportClient();

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
          'code': 'EXPIRED_TOKEN',
          'state': <String, Object?>{
            'signedIn': true,
            'rememberSession': true,
            'sessionToken': 'override-session-token',
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendExpiredTokenParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendExpiredTokenParityTransportClient();

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
          'code': 'EXPIRED_TOKEN',
          'state': <String, Object?>{'sessionToken': 'expired-token-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendRefreshTokenExpiredParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendRefreshTokenExpiredParityTransportClient();

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
          'code': 'REFRESH_TOKEN_EXPIRED',
          'state': <String, Object?>{
            'sessionToken': 'refresh-token-expired-session',
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendDelimitedRefreshTokenExpiredParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendDelimitedRefreshTokenExpiredParityTransportClient();

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
          'code': '  REFRESH-TOKEN::EXPIRED  ',
          'state': <String, Object?>{
            'sessionToken': 'delimited-refresh-token-expired-session',
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendCompactRefreshTokenExpiredParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendCompactRefreshTokenExpiredParityTransportClient();

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
          'code': 'refreshtokenexpired',
          'state': <String, Object?>{
            'sessionToken': 'compact-refresh-token-expired-session',
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendRefreshTokenExpiredSignedInOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendRefreshTokenExpiredSignedInOverrideParityTransportClient();

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
          'code': 'REFRESH_TOKEN_EXPIRED',
          'state': <String, Object?>{
            'signedIn': true,
            'rememberSession': true,
            'sessionToken': 'override-session-token',
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendJwtExpiredParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendJwtExpiredParityTransportClient();

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
          'code': 'JWT_EXPIRED',
          'state': <String, Object?>{'sessionToken': 'jwt-expired-session'},
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendJwtExpiredSignedInOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendJwtExpiredSignedInOverrideParityTransportClient();

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
          'code': 'JWT_EXPIRED',
          'state': <String, Object?>{
            'signedIn': true,
            'rememberSession': true,
            'sessionToken': 'override-session-token',
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendSignedInAliasCodeOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendSignedInAliasCodeOverrideParityTransportClient({
    required this.signedInStatePayload,
  });

  final Map<String, Object?> signedInStatePayload;

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
        'sessionToken': 'override-session-token',
      };
      statePayload.addAll(signedInStatePayload);
      return RemoteStubTransportResult.allowedWithPayload(<String, Object?>{
        'code': 'AUTH_REQUIRED',
        'state': statePayload,
      });
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

class _AuthBackendAuthStateEnvelopeFixtureParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendAuthStateEnvelopeFixtureParityTransportClient({
    required this.signInPayload,
    this.restoreSessionPayload,
    this.refreshTokenPayload,
  });

  final Map<String, Object?> signInPayload;
  final Map<String, Object?>? restoreSessionPayload;
  final Map<String, Object?>? refreshTokenPayload;

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(signInPayload);
    }
    if (request.operation == RemoteStubOperationIds.restoreSession &&
        restoreSessionPayload != null) {
      return RemoteStubTransportResult.allowedWithPayload(
        restoreSessionPayload!,
      );
    }
    if (request.operation == RemoteStubOperationIds.refreshToken &&
        refreshTokenPayload != null) {
      return RemoteStubTransportResult.allowedWithPayload(refreshTokenPayload!);
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendNestedErrorListSignedInAliasOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendNestedErrorListSignedInAliasOverrideParityTransportClient();

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
    if (request.operation == RemoteStubOperationIds.restoreSession) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'state': <String, Object?>{
            'authentication': <String, Object?>{
              'errors': <Map<String, Object?>>[
                <String, Object?>{'reasonCode': 'TOKEN_EXPIRED'},
              ],
              'authenticated': true,
              'rememberSession': true,
            },
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendNestedErrorCodeSignedInAliasOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendNestedErrorCodeSignedInAliasOverrideParityTransportClient();

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
    if (request.operation == RemoteStubOperationIds.restoreSession) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'state': <String, Object?>{
            'authentication': <String, Object?>{
              'errorCode': 'AUTH_REQUIRED',
              'authenticated': true,
              'remember': true,
            },
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendNestedErrorListDetailParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendNestedErrorListDetailParityTransportClient();

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
    if (request.operation == RemoteStubOperationIds.restoreSession) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'state': <String, Object?>{
            'authentication': <String, Object?>{
              'errors': <Map<String, Object?>>[
                <String, Object?>{
                  'detail': 'Nested auth detail from error list.',
                },
              ],
            },
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendTopLevelMessagePrecedenceParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendTopLevelMessagePrecedenceParityTransportClient();

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
    if (request.operation == RemoteStubOperationIds.restoreSession) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'message': 'Top-level backend auth message.',
          'state': <String, Object?>{
            'authentication': <String, Object?>{
              'errors': <Map<String, Object?>>[
                <String, Object?>{
                  'detail': 'Nested detail should not override top-level.',
                },
              ],
            },
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendNestedSignedOutErrorCodeParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendNestedSignedOutErrorCodeParityTransportClient();

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
          'message': 'Nested backend session expired.',
          'state': <String, Object?>{
            'authentication': <String, Object?>{'errorCode': 'SESSION_EXPIRED'},
            'tokens': <String, Object?>{
              'accessToken': 'nested-stale-access-token',
            },
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendTokenSessionAliasParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendTokenSessionAliasParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'detail': 'Backend auth alias payload applied.',
          'state': <String, Object?>{
            'remember': true,
            'accessToken': 'access-token-from-backend',
            'sessionId': 'session-from-backend',
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendExplicitSignedOutTokenAliasParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendExplicitSignedOutTokenAliasParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.signIn) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
          'status': 'Backend auth alias payload applied.',
          'state': <String, Object?>{
            'signedIn': false,
            'accessToken': 'ignored-for-explicit-sign-out',
            'sessionId': 'ignored-for-explicit-sign-out',
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendNestedAuthTokenAliasParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendNestedAuthTokenAliasParityTransportClient();

  @override
  RemoteStubTransportResult execute(RemoteStubTransportRequest request) {
    if (request.operation == RemoteStubOperationIds.restoreSession) {
      return RemoteStubTransportResult.allowedWithPayload(
        const <String, Object?>{
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
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendNestedSignedOutAliasTokenOverrideParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendNestedSignedOutAliasTokenOverrideParityTransportClient();

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
          'status': 'Backend nested auth payload applied.',
          'state': <String, Object?>{
            'authentication': <String, Object?>{'authenticated': false},
            'tokens': <String, Object?>{
              'accessToken': 'access-token-that-should-not-force-sign-in',
            },
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendErrorObjectCodeParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendErrorObjectCodeParityTransportClient();

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
          'error': <String, Object?>{'code': 'UNAUTHENTICATED'},
          'message': 'Backend rejected stale credentials.',
          'state': <String, Object?>{
            'sessionToken': 'stale-session-token',
            'user': <String, Object?>{'id': 'stale-user'},
          },
        },
      );
    }
    return RemoteStubTransportResult.allow;
  }
}

class _AuthBackendExplicitMessageCodePrecedenceParityTransportClient
    extends RemoteStubTransportClient {
  const _AuthBackendExplicitMessageCodePrecedenceParityTransportClient();

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
          'message': 'Backend explicit unauthorized message.',
          'state': <String, Object?>{'sessionToken': 'stale-session-token'},
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
    'auth/session parity infers signed-in from token/session aliases',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendTokenSessionAliasParityTransportClient(),
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
          'Status: [remote-stub] Backend auth alias payload applied.',
        ),
        findsOneWidget,
      );
      final CheckboxListTile rememberSessionTile = tester.widget(
        find.byKey(const ValueKey<String>('auth-remember')),
      );
      expect(rememberSessionTile.value, isTrue);
      expect(
        find.textContaining('Status: [remote-stub] Authentication required.'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'auth/session parity keeps explicit signed-out precedence over token/session aliases',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendExplicitSignedOutTokenAliasParityTransportClient(),
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
          'Status: [remote-stub] Backend auth alias payload applied.',
        ),
        findsOneWidget,
      );
      final CheckboxListTile rememberSessionTile = tester.widget(
        find.byKey(const ValueKey<String>('auth-remember')),
      );
      expect(rememberSessionTile.value, isFalse);
    },
  );

  testWidgets(
    'auth/session parity normalizes nested auth/session/token payload aliases',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendNestedAuthTokenAliasParityTransportClient(),
        ),
      );
      await openWorkflowSection(tester, 'auth');

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('auth-restore-session')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-restore-session')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend nested auth payload applied.',
        ),
        findsOneWidget,
      );
      final CheckboxListTile rememberSessionTile = tester.widget(
        find.byKey(const ValueKey<String>('auth-remember')),
      );
      expect(rememberSessionTile.value, isTrue);
      expect(
        find.textContaining('Status: [remote-stub] Authentication required.'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'auth/session parity maps nested explicit signed-out aliases over token inference',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendNestedSignedOutAliasTokenOverrideParityTransportClient(),
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
          'Status: [remote-stub] Backend nested auth payload applied.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity maps error-object code over token inference',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendErrorObjectCodeParityTransportClient(),
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
          'Status: [remote-stub] Backend rejected stale credentials.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Token refreshed (simulated).'), findsNothing);
    },
  );

  testWidgets(
    'auth/session parity keeps explicit message precedence over code fallback mapping',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendExplicitMessageCodePrecedenceParityTransportClient(),
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
          'Status: [remote-stub] Backend explicit unauthorized message.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Status: [remote-stub] Authentication required.'),
        findsNothing,
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
    'auth/session parity keeps signed-in state when code-only backend failure has explicit signed-in override',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendCodeOnlySignedInOverrideParityTransportClient(),
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
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Status: [remote-stub] Authentication required.'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'auth/session parity keeps signed-in state when signed-out error code has explicit signed-in override',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendSignedOutErrorCodeSignedInOverrideParityTransportClient(),
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
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Status: [remote-stub] Authentication required.'),
        findsNothing,
      );
    },
  );

  for (final MapEntry<String, Map<String, Object?>> aliasFixture
      in <MapEntry<String, Map<String, Object?>>>[
        const MapEntry<String, Map<String, Object?>>(
          'signed_in',
          <String, Object?>{'signed_in': true, 'remember_session': true},
        ),
        const MapEntry<String, Map<String, Object?>>(
          'is_signed_in',
          <String, Object?>{'is_signed_in': true, 'remember_session': true},
        ),
        const MapEntry<String, Map<String, Object?>>(
          'is_logged_in',
          <String, Object?>{'is_logged_in': true, 'persist_session': true},
        ),
        const MapEntry<String, Map<String, Object?>>(
          'isLoggedIn',
          <String, Object?>{'isLoggedIn': true, 'persistSession': true},
        ),
      ]) {
    testWidgets(
      'auth/session parity keeps signed-in state when ${aliasFixture.key} alias overrides unauthorized code inference',
      (WidgetTester tester) async {
        await pumpDesktopApp(
          tester,
          contracts: DesktopContractBundle.fromMode(
            DesktopContractMode.remoteStub,
            remoteStubTransportClient:
                _AuthBackendSignedInAliasCodeOverrideParityTransportClient(
                  signedInStatePayload: aliasFixture.value,
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
          find.textContaining(
            'Status: [remote-stub] Backend sign-in snapshot applied.',
          ),
          findsOneWidget,
        );
        expect(
          find.textContaining('Status: [remote-stub] Authentication required.'),
          findsNothing,
        );
      },
    );
  }

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
    'auth/session parity keeps signed-in state when statusCode backend failure has explicit signed-in override',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendStatusCodeSignedInOverrideParityTransportClient(),
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
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Status: [remote-stub] Authentication required.'),
        findsNothing,
      );
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
    'auth/session parity keeps signed-in state when status_code backend failure has explicit signed-in override',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendStatusCodeSnakeCaseSignedInOverrideParityTransportClient(),
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
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Status: [remote-stub] Authentication required.'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'auth/session parity maps success failure flag to deterministic auth-failed status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendFailureFlagSuccessParityTransportClient(),
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
    'auth/session parity keeps signed-in state when success failure flag has explicit signed-in override',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendFailureFlagSuccessSignedInOverrideParityTransportClient(),
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
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend auth request failed.',
        ),
        findsNothing,
      );
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
    'auth/session parity keeps signed-in state when snake-case failure flag has explicit signed-in override',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendFailureFlagSnakeCaseSignedInOverrideParityTransportClient(),
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
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend auth request failed.',
        ),
        findsNothing,
      );
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
    'auth/session parity keeps signed-in state when ok failure flag has explicit signed-in override',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendFailureFlagOkSignedInOverrideParityTransportClient(),
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
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend auth request failed.',
        ),
        findsNothing,
      );
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
    'auth/session parity keeps signed-in state when isSuccess failure flag has explicit signed-in override',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendFailureFlagIsSuccessSignedInOverrideParityTransportClient(),
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
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend auth request failed.',
        ),
        findsNothing,
      );
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
    'auth/session parity keeps signed-in state when is_ok failure flag has explicit signed-in override',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendFailureFlagIsOkSnakeCaseSignedInOverrideParityTransportClient(),
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
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend auth request failed.',
        ),
        findsNothing,
      );
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
    'auth/session parity keeps signed-in state when isOk failure flag has explicit signed-in override',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendFailureFlagIsOkSignedInOverrideParityTransportClient(),
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
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend auth request failed.',
        ),
        findsNothing,
      );
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
    'auth/session parity keeps signed-in state when nested failure flag has explicit signed-in override',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendFailureFlagNestedSignedInOverrideParityTransportClient(),
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
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend auth request failed.',
        ),
        findsNothing,
      );
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

  testWidgets('auth/session parity normalizes is_signed_in state aliases', (
    WidgetTester tester,
  ) async {
    await pumpDesktopApp(
      tester,
      contracts: DesktopContractBundle.fromMode(
        DesktopContractMode.remoteStub,
        remoteStubTransportClient:
            const _AuthBackendIsSignedInStateAliasParityTransportClient(),
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
        'Status: [remote-stub] Backend is_signed_in sign-in snapshot applied.',
      ),
      findsOneWidget,
    );
    final CheckboxListTile rememberSessionTile = tester.widget(
      find.byKey(const ValueKey<String>('auth-remember')),
    );
    expect(rememberSessionTile.value, isTrue);

    expect(find.textContaining('Signed in (simulated).'), findsNothing);
  });

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
      'auth/session parity keeps signed-in state when $signedOutAlias alias collides with explicit signedIn',
      (WidgetTester tester) async {
        await pumpDesktopApp(
          tester,
          contracts: DesktopContractBundle.fromMode(
            DesktopContractMode.remoteStub,
            remoteStubTransportClient:
                _AuthBackendSignedOutAliasSignedInOverrideParityTransportClient(
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
          find.textContaining(
            'Status: [remote-stub] Backend sign-in snapshot applied.',
          ),
          findsOneWidget,
        );
        expect(
          find.textContaining('Status: [remote-stub] Authentication required.'),
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
    'auth/session parity maps token-expired backend failure to deterministic session-expired status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendTokenExpiredParityTransportClient(),
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
    'auth/session parity maps httpStatus backend failure to deterministic session-expired status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendHttpStatusSessionExpiredParityTransportClient(),
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
    'auth/session parity maps http_status backend failure to deterministic session-expired status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendHttpStatusSnakeCaseSessionExpiredParityTransportClient(),
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
    'auth/session parity maps expired-token backend failure to deterministic session-expired status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendExpiredTokenParityTransportClient(),
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
    'auth/session parity maps refresh-token-expired backend failure to deterministic session-expired status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendRefreshTokenExpiredParityTransportClient(),
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
    'auth/session parity maps delimited refresh-token-expired backend failure to deterministic session-expired status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendDelimitedRefreshTokenExpiredParityTransportClient(),
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
    'auth/session parity maps compact refresh-token-expired backend failure to deterministic session-expired status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendCompactRefreshTokenExpiredParityTransportClient(),
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
    'auth/session parity maps jwt-expired backend failure to deterministic session-expired status',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendJwtExpiredParityTransportClient(),
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
    'auth/session parity keeps signed-in state when session-timeout backend failure has explicit signed-in override',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendSessionTimeoutSignedInOverrideParityTransportClient(),
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
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Status: [remote-stub] Backend session expired.'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'auth/session parity keeps signed-in state when token-expired backend failure has explicit signed-in override',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendTokenExpiredSignedInOverrideParityTransportClient(),
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
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Status: [remote-stub] Backend session expired.'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'auth/session parity keeps signed-in state when httpStatus backend failure has explicit signed-in override',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendHttpStatusSignedInOverrideParityTransportClient(),
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
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Status: [remote-stub] Backend session expired.'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'auth/session parity keeps signed-in state when http_status backend failure has explicit signed-in override',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendHttpStatusSnakeCaseSignedInOverrideParityTransportClient(),
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
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Status: [remote-stub] Backend session expired.'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'auth/session parity keeps signed-in state when expired-token backend failure has explicit signed-in override',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendExpiredTokenSignedInOverrideParityTransportClient(),
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
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Status: [remote-stub] Backend session expired.'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'auth/session parity keeps signed-in state when refresh-token-expired backend failure has explicit signed-in override',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendRefreshTokenExpiredSignedInOverrideParityTransportClient(),
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
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Status: [remote-stub] Backend session expired.'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'auth/session parity keeps signed-in state when jwt-expired backend failure has explicit signed-in override',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendJwtExpiredSignedInOverrideParityTransportClient(),
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
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Status: [remote-stub] Backend session expired.'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'auth/session parity keeps signed-in state when nested error-list code collides with authenticated alias',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendNestedErrorListSignedInAliasOverrideParityTransportClient(),
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
        find.byKey(const ValueKey<String>('auth-restore-session')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-restore-session')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      final CheckboxListTile rememberSessionTile = tester.widget(
        find.byKey(const ValueKey<String>('auth-remember')),
      );
      expect(rememberSessionTile.value, isTrue);
      expect(
        find.textContaining('Status: [remote-stub] Authentication required.'),
        findsNothing,
      );
      expect(
        find.textContaining('Status: [remote-stub] Backend session expired.'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'auth/session parity keeps signed-in state when nested error-code collides with authenticated alias',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendNestedErrorCodeSignedInAliasOverrideParityTransportClient(),
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
        find.byKey(const ValueKey<String>('auth-restore-session')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-restore-session')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Backend sign-in snapshot applied.',
        ),
        findsOneWidget,
      );
      final CheckboxListTile rememberSessionTile = tester.widget(
        find.byKey(const ValueKey<String>('auth-remember')),
      );
      expect(rememberSessionTile.value, isTrue);
      expect(
        find.textContaining('Status: [remote-stub] Authentication required.'),
        findsNothing,
      );
      expect(
        find.textContaining('Status: [remote-stub] Backend session expired.'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'auth/session parity maps nested error-list detail when top-level status is absent',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendNestedErrorListDetailParityTransportClient(),
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
        find.byKey(const ValueKey<String>('auth-restore-session')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-restore-session')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Nested auth detail from error list.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Status: [remote-stub] Authentication required.'),
        findsNothing,
      );
      expect(
        find.textContaining('Session restored (simulated).'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'auth/session parity keeps top-level status precedence over nested error detail',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendTopLevelMessagePrecedenceParityTransportClient(),
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
        find.byKey(const ValueKey<String>('auth-restore-session')),
      );
      await tester.tap(
        find.byKey(const ValueKey<String>('auth-restore-session')),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          'Status: [remote-stub] Top-level backend auth message.',
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Nested detail should not override'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'auth/session parity maps nested signed-out error code during refresh flow',
    (WidgetTester tester) async {
      await pumpDesktopApp(
        tester,
        contracts: DesktopContractBundle.fromMode(
          DesktopContractMode.remoteStub,
          remoteStubTransportClient:
              const _AuthBackendNestedSignedOutErrorCodeParityTransportClient(),
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
          'Status: [remote-stub] Nested backend session expired.',
        ),
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

  final List<String> authStateWrapperKeys = <String>['result', 'data'];
  final List<String> authStateSignedOutAliases = <String>[
    'signedOut',
    'signed_out',
    'isSignedOut',
    'loggedOut',
    'logged_out',
    'isLoggedOut',
    'is_signed_out',
    'is_logged_out',
  ];
  final List<String> authStateSignedInAliases = <String>[
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

  String authStateMatrixEntryKey({
    required String wrapperKey,
    required String alias,
    required Object? value,
  }) {
    return '$wrapperKey::$alias::$value';
  }

  Set<String> buildAuthStateMatrixEntrySet(
    Iterable<Map<String, Object?>> payloads,
  ) {
    final Set<String> matrixEntries = <String>{};

    for (final Map<String, Object?> payload in payloads) {
      for (final String wrapperKey in authStateWrapperKeys) {
        final Object? wrapperPayload = payload[wrapperKey];
        if (wrapperPayload is! Map) {
          continue;
        }
        final Object? authStatePayload = wrapperPayload['authState'];
        if (authStatePayload is! Map) {
          continue;
        }
        authStatePayload.forEach((Object? aliasKey, Object? aliasValue) {
          if (aliasKey is! String) {
            return;
          }
          matrixEntries.add(
            authStateMatrixEntryKey(
              wrapperKey: wrapperKey,
              alias: aliasKey,
              value: aliasValue,
            ),
          );
        });
      }
    }

    return matrixEntries;
  }

  void appendMissingAuthStateMatrixEntries({
    required List<String> missingEntries,
    required String operationLabel,
    required Iterable<Map<String, Object?>> payloads,
    required Iterable<String> aliases,
    required bool expectedValue,
  }) {
    final Set<String> matrixEntries = buildAuthStateMatrixEntrySet(payloads);

    for (final String wrapperKey in authStateWrapperKeys) {
      for (final String alias in aliases) {
        if (!matrixEntries.contains(
          authStateMatrixEntryKey(
            wrapperKey: wrapperKey,
            alias: alias,
            value: expectedValue,
          ),
        )) {
          missingEntries.add(
            '$operationLabel $wrapperKey authState.$alias=$expectedValue',
          );
        }
      }
    }
  }

  void expectOperationAuthStateMatrixSymmetric({
    required String operationLabel,
    required Iterable<Map<String, Object?>> payloads,
    required Iterable<String> aliases,
    required bool expectedValue,
  }) {
    final List<String> missingEntries = <String>[];

    appendMissingAuthStateMatrixEntries(
      missingEntries: missingEntries,
      operationLabel: operationLabel,
      payloads: payloads,
      aliases: aliases,
      expectedValue: expectedValue,
    );

    expect(
      missingEntries,
      isEmpty,
      reason: 'Missing parity matrix entries:\n${missingEntries.join('\n')}',
    );
  }

  final List<
    ({
      String description,
      Map<String, Object?> signInPayload,
      String expectedStatus,
    })
  >
  authStateSignedInEnvelopeCases =
      <
        ({
          String description,
          Map<String, Object?> signInPayload,
          String expectedStatus,
        })
      >[
        (
          description: 'result envelope authState isAuthenticated alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'message': 'Backend authState result envelope applied.',
              'authState': <String, Object?>{
                'isAuthenticated': true,
                'remember': true,
              },
            },
          },
          expectedStatus: 'Backend authState result envelope applied.',
        ),
        (
          description: 'data envelope authState isAuthenticated alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail':
                  'Backend authState data envelope isAuthenticated applied.',
              'authState': <String, Object?>{
                'isAuthenticated': true,
                'remember': true,
              },
            },
          },
          expectedStatus:
              'Backend authState data envelope isAuthenticated applied.',
        ),
        (
          description: 'data envelope authState loggedIn alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend authState data envelope loggedIn applied.',
              'authState': <String, Object?>{
                'loggedIn': true,
                'persistSession': true,
              },
            },
          },
          expectedStatus: 'Backend authState data envelope loggedIn applied.',
        ),
        (
          description: 'result envelope authState loggedIn alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail': 'Backend authState result envelope loggedIn applied.',
              'authState': <String, Object?>{
                'loggedIn': true,
                'persistSession': true,
              },
            },
          },
          expectedStatus: 'Backend authState result envelope loggedIn applied.',
        ),
        (
          description: 'result envelope authState isLoggedIn alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail': 'Backend authState result envelope isLoggedIn applied.',
              'authState': <String, Object?>{
                'isLoggedIn': true,
                'persistSession': true,
              },
            },
          },
          expectedStatus:
              'Backend authState result envelope isLoggedIn applied.',
        ),
        (
          description: 'data envelope authState isLoggedIn alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend authState data envelope isLoggedIn applied.',
              'authState': <String, Object?>{
                'isLoggedIn': true,
                'persistSession': true,
              },
            },
          },
          expectedStatus: 'Backend authState data envelope isLoggedIn applied.',
        ),
        (
          description: 'data envelope authState is_authenticated alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail':
                  'Backend authState data envelope is_authenticated applied.',
              'authState': <String, Object?>{
                'is_authenticated': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus:
              'Backend authState data envelope is_authenticated applied.',
        ),
        (
          description: 'result envelope authState is_authenticated alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail':
                  'Backend authState result envelope is_authenticated applied.',
              'authState': <String, Object?>{
                'is_authenticated': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus:
              'Backend authState result envelope is_authenticated applied.',
        ),
        (
          description: 'result envelope authState signedIn alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail': 'Backend authState result envelope signedIn applied.',
              'authState': <String, Object?>{
                'signedIn': true,
                'persistSession': true,
              },
            },
          },
          expectedStatus: 'Backend authState result envelope signedIn applied.',
        ),
        (
          description: 'data envelope authState signedIn alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend authState data envelope signedIn applied.',
              'authState': <String, Object?>{
                'signedIn': true,
                'persistSession': true,
              },
            },
          },
          expectedStatus: 'Backend authState data envelope signedIn applied.',
        ),
        (
          description: 'data envelope authState authenticated alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail':
                  'Backend authState data envelope authenticated applied.',
              'authState': <String, Object?>{
                'authenticated': true,
                'remember': true,
              },
            },
          },
          expectedStatus:
              'Backend authState data envelope authenticated applied.',
        ),
        (
          description: 'result envelope authState authenticated alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail':
                  'Backend authState result envelope authenticated applied.',
              'authState': <String, Object?>{
                'authenticated': true,
                'remember': true,
              },
            },
          },
          expectedStatus:
              'Backend authState result envelope authenticated applied.',
        ),
        (
          description: 'data envelope authState logged_in alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend authState data envelope logged_in applied.',
              'authState': <String, Object?>{
                'logged_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus: 'Backend authState data envelope logged_in applied.',
        ),
        (
          description: 'result envelope authState logged_in alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail': 'Backend authState result envelope logged_in applied.',
              'authState': <String, Object?>{
                'logged_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus:
              'Backend authState result envelope logged_in applied.',
        ),
        (
          description: 'data envelope authState is_logged_in alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend authState data envelope is_logged_in applied.',
              'authState': <String, Object?>{
                'is_logged_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus:
              'Backend authState data envelope is_logged_in applied.',
        ),
        (
          description: 'result envelope authState is_logged_in alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail':
                  'Backend authState result envelope is_logged_in applied.',
              'authState': <String, Object?>{
                'is_logged_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus:
              'Backend authState result envelope is_logged_in applied.',
        ),
        (
          description: 'data envelope authState is_signed_in alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend authState data envelope is_signed_in applied.',
              'authState': <String, Object?>{
                'is_signed_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus:
              'Backend authState data envelope is_signed_in applied.',
        ),
        (
          description: 'result envelope authState is_signed_in alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail':
                  'Backend authState result envelope is_signed_in applied.',
              'authState': <String, Object?>{
                'is_signed_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus:
              'Backend authState result envelope is_signed_in applied.',
        ),
        (
          description: 'data envelope authState signed_in alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend authState data envelope signed_in applied.',
              'authState': <String, Object?>{
                'signed_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus: 'Backend authState data envelope signed_in applied.',
        ),
        (
          description: 'result envelope authState signed_in alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail': 'Backend authState result envelope signed_in applied.',
              'authState': <String, Object?>{
                'signed_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus:
              'Backend authState result envelope signed_in applied.',
        ),
      ];

  void expectSignInAuthStateMatrixSymmetric({
    required Iterable<Map<String, Object?>> payloads,
    required Iterable<String> aliases,
    required bool expectedValue,
  }) {
    expectOperationAuthStateMatrixSymmetric(
      operationLabel: 'sign-in',
      payloads: payloads,
      aliases: aliases,
      expectedValue: expectedValue,
    );
  }

  test(
    'auth/session parity sign-in signed-in authState matrix is symmetric',
    () {
      final Iterable<Map<String, Object?>> payloads =
          authStateSignedInEnvelopeCases.map(
            (caseData) => caseData.signInPayload,
          );
      expectSignInAuthStateMatrixSymmetric(
        payloads: payloads,
        aliases: authStateSignedInAliases,
        expectedValue: true,
      );
    },
  );

  for (final ({
        String description,
        Map<String, Object?> signInPayload,
        String expectedStatus,
      })
      caseData
      in authStateSignedInEnvelopeCases) {
    testWidgets(
      'auth/session parity normalizes ${caseData.description} sign-in snapshot',
      (WidgetTester tester) async {
        await pumpDesktopApp(
          tester,
          contracts: DesktopContractBundle.fromMode(
            DesktopContractMode.remoteStub,
            remoteStubTransportClient:
                _AuthBackendAuthStateEnvelopeFixtureParityTransportClient(
                  signInPayload: caseData.signInPayload,
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
            'Status: [remote-stub] ${caseData.expectedStatus}',
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
  }

  final List<({String description, Map<String, Object?> signInPayload})>
  authStateSignedInFalseEnvelopeCases =
      <({String description, Map<String, Object?> signInPayload})>[
        (
          description: 'result envelope authState isAuthenticated false alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'isAuthenticated': false,
                'sessionToken': 'sign-in-result-is-authenticated-false-token',
              },
            },
          },
        ),
        (
          description: 'data envelope authState isAuthenticated false alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'isAuthenticated': false,
                'sessionToken': 'sign-in-data-is-authenticated-false-token',
              },
            },
          },
        ),
        (
          description: 'data envelope authState loggedIn false alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'loggedIn': false,
                'sessionToken': 'sign-in-data-logged-in-false-token',
              },
            },
          },
        ),
        (
          description: 'result envelope authState loggedIn false alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'loggedIn': false,
                'sessionToken': 'sign-in-result-logged-in-false-token',
              },
            },
          },
        ),
        (
          description: 'result envelope authState isLoggedIn false alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'isLoggedIn': false,
                'sessionToken': 'sign-in-result-is-logged-in-false-token',
              },
            },
          },
        ),
        (
          description: 'data envelope authState isLoggedIn false alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'isLoggedIn': false,
                'sessionToken': 'sign-in-data-is-logged-in-false-token',
              },
            },
          },
        ),
        (
          description: 'data envelope authState is_authenticated false alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'is_authenticated': false,
                'sessionToken':
                    'sign-in-data-is-authenticated-snake-false-token',
              },
            },
          },
        ),
        (
          description: 'result envelope authState is_authenticated false alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'is_authenticated': false,
                'sessionToken':
                    'sign-in-result-is-authenticated-snake-false-token',
              },
            },
          },
        ),
        (
          description: 'result envelope authState signedIn false alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'signedIn': false,
                'sessionToken': 'sign-in-result-signed-in-false-token',
              },
            },
          },
        ),
        (
          description: 'data envelope authState signedIn false alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'signedIn': false,
                'sessionToken': 'sign-in-data-signed-in-false-token',
              },
            },
          },
        ),
        (
          description: 'data envelope authState authenticated false alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'authenticated': false,
                'sessionToken': 'sign-in-data-authenticated-false-token',
              },
            },
          },
        ),
        (
          description: 'result envelope authState authenticated false alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'authenticated': false,
                'sessionToken': 'sign-in-result-authenticated-false-token',
              },
            },
          },
        ),
        (
          description: 'result envelope authState signed_in false alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'signed_in': false,
                'sessionToken': 'sign-in-result-signed-in-snake-false-token',
              },
            },
          },
        ),
        (
          description: 'data envelope authState signed_in false alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'signed_in': false,
                'sessionToken': 'sign-in-data-signed-in-snake-false-token',
              },
            },
          },
        ),
        (
          description: 'result envelope authState is_signed_in false alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'is_signed_in': false,
                'sessionToken': 'sign-in-result-is-signed-in-false-token',
              },
            },
          },
        ),
        (
          description: 'data envelope authState is_signed_in false alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'is_signed_in': false,
                'sessionToken': 'sign-in-data-is-signed-in-false-token',
              },
            },
          },
        ),
        (
          description: 'result envelope authState logged_in false alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'logged_in': false,
                'sessionToken': 'sign-in-result-logged-in-snake-false-token',
              },
            },
          },
        ),
        (
          description: 'data envelope authState logged_in false alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'logged_in': false,
                'sessionToken': 'sign-in-data-logged-in-snake-false-token',
              },
            },
          },
        ),
        (
          description: 'data envelope authState is_logged_in false alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'is_logged_in': false,
                'sessionToken': 'sign-in-data-is-logged-in-snake-false-token',
              },
            },
          },
        ),
        (
          description: 'result envelope authState is_logged_in false alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'is_logged_in': false,
                'sessionToken': 'sign-in-result-is-logged-in-snake-false-token',
              },
            },
          },
        ),
      ];

  test(
    'auth/session parity sign-in signed-in-false authState matrix is symmetric',
    () {
      final Iterable<Map<String, Object?>> payloads =
          authStateSignedInFalseEnvelopeCases.map(
            (caseData) => caseData.signInPayload,
          );
      expectSignInAuthStateMatrixSymmetric(
        payloads: payloads,
        aliases: authStateSignedInAliases,
        expectedValue: false,
      );
    },
  );

  for (final ({String description, Map<String, Object?> signInPayload}) caseData
      in authStateSignedInFalseEnvelopeCases) {
    testWidgets(
      'auth/session parity maps sign-in ${caseData.description} to deterministic signed-out fallback',
      (WidgetTester tester) async {
        await pumpDesktopApp(
          tester,
          contracts: DesktopContractBundle.fromMode(
            DesktopContractMode.remoteStub,
            remoteStubTransportClient:
                _AuthBackendAuthStateEnvelopeFixtureParityTransportClient(
                  signInPayload: caseData.signInPayload,
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
          find.textContaining('Status: [remote-stub] Authentication required.'),
          findsOneWidget,
        );
        final CheckboxListTile rememberSessionTile = tester.widget(
          find.byKey(const ValueKey<String>('auth-remember')),
        );
        expect(rememberSessionTile.value, isFalse);
        expect(find.textContaining('Signed in (simulated).'), findsNothing);
      },
    );
  }

  final List<({String description, Map<String, Object?> signInPayload})>
  authStateSignedOutSignInEnvelopeCases =
      <({String description, Map<String, Object?> signInPayload})>[
        (
          description: 'result envelope authState signedOut alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'signedOut': true,
                'sessionToken': 'sign-in-result-signed-out-camel-token',
              },
            },
          },
        ),
        (
          description: 'data envelope authState signedOut alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'signedOut': true,
                'sessionToken': 'sign-in-data-signed-out-camel-token',
              },
            },
          },
        ),
        (
          description: 'result envelope authState signed_out alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'signed_out': true,
                'sessionToken': 'sign-in-result-signed-out-snake-token',
              },
            },
          },
        ),
        (
          description: 'data envelope authState signed_out alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'signed_out': true,
                'sessionToken': 'sign-in-data-signed-out-snake-token',
              },
            },
          },
        ),
        (
          description: 'result envelope authState isSignedOut alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'isSignedOut': true,
                'sessionToken': 'sign-in-result-is-signed-out-camel-token',
              },
            },
          },
        ),
        (
          description: 'data envelope authState isSignedOut alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'isSignedOut': true,
                'sessionToken': 'sign-in-data-is-signed-out-camel-token',
              },
            },
          },
        ),
        (
          description: 'result envelope authState loggedOut alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'loggedOut': true,
                'sessionToken': 'sign-in-result-logged-out-camel-token',
              },
            },
          },
        ),
        (
          description: 'data envelope authState loggedOut alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'loggedOut': true,
                'sessionToken': 'sign-in-data-logged-out-camel-token',
              },
            },
          },
        ),
        (
          description: 'result envelope authState logged_out alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'logged_out': true,
                'sessionToken': 'sign-in-result-logged-out-snake-token',
              },
            },
          },
        ),
        (
          description: 'data envelope authState logged_out alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'logged_out': true,
                'sessionToken': 'sign-in-data-logged-out-snake-token',
              },
            },
          },
        ),
        (
          description: 'result envelope authState isLoggedOut alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'isLoggedOut': true,
                'sessionToken': 'sign-in-result-is-logged-out-camel-token',
              },
            },
          },
        ),
        (
          description: 'data envelope authState isLoggedOut alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'isLoggedOut': true,
                'sessionToken': 'sign-in-data-is-logged-out-camel-token',
              },
            },
          },
        ),
        (
          description: 'result envelope authState is_signed_out alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'is_signed_out': true,
                'sessionToken': 'sign-in-result-is-signed-out-snake-token',
              },
            },
          },
        ),
        (
          description: 'data envelope authState is_signed_out alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'is_signed_out': true,
                'sessionToken': 'sign-in-data-is-signed-out-snake-token',
              },
            },
          },
        ),
        (
          description: 'result envelope authState is_logged_out alias',
          signInPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'is_logged_out': true,
                'sessionToken': 'sign-in-result-is-logged-out-snake-token',
              },
            },
          },
        ),
        (
          description: 'data envelope authState is_logged_out alias',
          signInPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'is_logged_out': true,
                'sessionToken': 'sign-in-data-is-logged-out-snake-token',
              },
            },
          },
        ),
      ];

  test(
    'auth/session parity sign-in signed-out authState matrix is symmetric',
    () {
      final Iterable<Map<String, Object?>> payloads =
          authStateSignedOutSignInEnvelopeCases.map(
            (caseData) => caseData.signInPayload,
          );
      expectSignInAuthStateMatrixSymmetric(
        payloads: payloads,
        aliases: authStateSignedOutAliases,
        expectedValue: true,
      );
    },
  );

  for (final ({String description, Map<String, Object?> signInPayload}) caseData
      in authStateSignedOutSignInEnvelopeCases) {
    testWidgets(
      'auth/session parity maps sign-in ${caseData.description} to deterministic signed-out fallback',
      (WidgetTester tester) async {
        await pumpDesktopApp(
          tester,
          contracts: DesktopContractBundle.fromMode(
            DesktopContractMode.remoteStub,
            remoteStubTransportClient:
                _AuthBackendAuthStateEnvelopeFixtureParityTransportClient(
                  signInPayload: caseData.signInPayload,
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
          find.textContaining('Status: [remote-stub] Authentication required.'),
          findsOneWidget,
        );
        final CheckboxListTile rememberSessionTile = tester.widget(
          find.byKey(const ValueKey<String>('auth-remember')),
        );
        expect(rememberSessionTile.value, isFalse);
        expect(find.textContaining('Signed in (simulated).'), findsNothing);
      },
    );
  }

  final List<
    ({
      String description,
      Map<String, Object?> refreshTokenPayload,
      String expectedStatus,
    })
  >
  authStateSignedInRefreshEnvelopeCases =
      <
        ({
          String description,
          Map<String, Object?> refreshTokenPayload,
          String expectedStatus,
        })
      >[
        (
          description: 'result envelope authState isAuthenticated alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail':
                  'Backend refresh result envelope isAuthenticated applied.',
              'authState': <String, Object?>{
                'isAuthenticated': true,
                'remember': true,
              },
            },
          },
          expectedStatus:
              'Backend refresh result envelope isAuthenticated applied.',
        ),
        (
          description: 'data envelope authState isAuthenticated alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail':
                  'Backend refresh data envelope isAuthenticated applied.',
              'authState': <String, Object?>{
                'isAuthenticated': true,
                'remember': true,
              },
            },
          },
          expectedStatus:
              'Backend refresh data envelope isAuthenticated applied.',
        ),
        (
          description: 'data envelope authState loggedIn alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend refresh data envelope loggedIn applied.',
              'authState': <String, Object?>{
                'loggedIn': true,
                'persistSession': true,
              },
            },
          },
          expectedStatus: 'Backend refresh data envelope loggedIn applied.',
        ),
        (
          description: 'result envelope authState loggedIn alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail': 'Backend refresh result envelope loggedIn applied.',
              'authState': <String, Object?>{
                'loggedIn': true,
                'persistSession': true,
              },
            },
          },
          expectedStatus: 'Backend refresh result envelope loggedIn applied.',
        ),
        (
          description: 'result envelope authState isLoggedIn alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail': 'Backend refresh result envelope isLoggedIn applied.',
              'authState': <String, Object?>{
                'isLoggedIn': true,
                'persistSession': true,
              },
            },
          },
          expectedStatus: 'Backend refresh result envelope isLoggedIn applied.',
        ),
        (
          description: 'data envelope authState isLoggedIn alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend refresh data envelope isLoggedIn applied.',
              'authState': <String, Object?>{
                'isLoggedIn': true,
                'persistSession': true,
              },
            },
          },
          expectedStatus: 'Backend refresh data envelope isLoggedIn applied.',
        ),
        (
          description: 'data envelope authState is_authenticated alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail':
                  'Backend refresh data envelope is_authenticated applied.',
              'authState': <String, Object?>{
                'is_authenticated': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus:
              'Backend refresh data envelope is_authenticated applied.',
        ),
        (
          description: 'result envelope authState is_authenticated alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail':
                  'Backend refresh result envelope is_authenticated applied.',
              'authState': <String, Object?>{
                'is_authenticated': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus:
              'Backend refresh result envelope is_authenticated applied.',
        ),
        (
          description: 'result envelope authState signedIn alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail': 'Backend refresh result envelope signedIn applied.',
              'authState': <String, Object?>{
                'signedIn': true,
                'persistSession': true,
              },
            },
          },
          expectedStatus: 'Backend refresh result envelope signedIn applied.',
        ),
        (
          description: 'data envelope authState signedIn alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend refresh data envelope signedIn applied.',
              'authState': <String, Object?>{
                'signedIn': true,
                'persistSession': true,
              },
            },
          },
          expectedStatus: 'Backend refresh data envelope signedIn applied.',
        ),
        (
          description: 'data envelope authState authenticated alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend refresh data envelope authenticated applied.',
              'authState': <String, Object?>{
                'authenticated': true,
                'remember': true,
              },
            },
          },
          expectedStatus:
              'Backend refresh data envelope authenticated applied.',
        ),
        (
          description: 'result envelope authState authenticated alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail':
                  'Backend refresh result envelope authenticated applied.',
              'authState': <String, Object?>{
                'authenticated': true,
                'remember': true,
              },
            },
          },
          expectedStatus:
              'Backend refresh result envelope authenticated applied.',
        ),
        (
          description: 'result envelope authState signed_in alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail': 'Backend refresh result envelope signed_in applied.',
              'authState': <String, Object?>{
                'signed_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus: 'Backend refresh result envelope signed_in applied.',
        ),
        (
          description: 'data envelope authState signed_in alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend refresh data envelope signed_in applied.',
              'authState': <String, Object?>{
                'signed_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus: 'Backend refresh data envelope signed_in applied.',
        ),
        (
          description: 'result envelope authState is_signed_in alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail': 'Backend refresh result envelope is_signed_in applied.',
              'authState': <String, Object?>{
                'is_signed_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus:
              'Backend refresh result envelope is_signed_in applied.',
        ),
        (
          description: 'data envelope authState is_signed_in alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend refresh data envelope is_signed_in applied.',
              'authState': <String, Object?>{
                'is_signed_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus: 'Backend refresh data envelope is_signed_in applied.',
        ),
        (
          description: 'result envelope authState logged_in alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail': 'Backend refresh result envelope logged_in applied.',
              'authState': <String, Object?>{
                'logged_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus: 'Backend refresh result envelope logged_in applied.',
        ),
        (
          description: 'data envelope authState logged_in alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend refresh data envelope logged_in applied.',
              'authState': <String, Object?>{
                'logged_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus: 'Backend refresh data envelope logged_in applied.',
        ),
        (
          description: 'data envelope authState is_logged_in alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend refresh data envelope is_logged_in applied.',
              'authState': <String, Object?>{
                'is_logged_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus: 'Backend refresh data envelope is_logged_in applied.',
        ),
        (
          description: 'result envelope authState is_logged_in alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail': 'Backend refresh result envelope is_logged_in applied.',
              'authState': <String, Object?>{
                'is_logged_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus:
              'Backend refresh result envelope is_logged_in applied.',
        ),
      ];

  test(
    'auth/session parity refresh-token signed-in authState matrix is symmetric',
    () {
      final Iterable<Map<String, Object?>> payloads =
          authStateSignedInRefreshEnvelopeCases.map(
            (caseData) => caseData.refreshTokenPayload,
          );
      expectOperationAuthStateMatrixSymmetric(
        operationLabel: 'refresh-token',
        payloads: payloads,
        aliases: authStateSignedInAliases,
        expectedValue: true,
      );
    },
  );

  for (final ({
        String description,
        Map<String, Object?> refreshTokenPayload,
        String expectedStatus,
      })
      caseData
      in authStateSignedInRefreshEnvelopeCases) {
    testWidgets(
      'auth/session parity normalizes refresh-token ${caseData.description} sign-in snapshot',
      (WidgetTester tester) async {
        await pumpDesktopApp(
          tester,
          contracts: DesktopContractBundle.fromMode(
            DesktopContractMode.remoteStub,
            remoteStubTransportClient:
                _AuthBackendAuthStateEnvelopeFixtureParityTransportClient(
                  signInPayload: const <String, Object?>{
                    'status': 'Backend sign-in baseline snapshot applied.',
                    'state': <String, Object?>{
                      'signedIn': true,
                      'rememberSession': true,
                    },
                  },
                  refreshTokenPayload: caseData.refreshTokenPayload,
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
            'Status: [remote-stub] Backend sign-in baseline snapshot applied.',
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
            'Status: [remote-stub] ${caseData.expectedStatus}',
          ),
          findsOneWidget,
        );
        expect(
          find.textContaining('Status: [remote-stub] Authentication required.'),
          findsNothing,
        );
        expect(
          find.textContaining('Token refreshed (simulated).'),
          findsNothing,
        );
        final CheckboxListTile rememberSessionTile = tester.widget(
          find.byKey(const ValueKey<String>('auth-remember')),
        );
        expect(rememberSessionTile.value, isTrue);
      },
    );
  }

  final List<
    ({
      String description,
      Map<String, Object?> restoreSessionPayload,
      String expectedStatus,
    })
  >
  authStateSignedInRestoreEnvelopeCases =
      <
        ({
          String description,
          Map<String, Object?> restoreSessionPayload,
          String expectedStatus,
        })
      >[
        (
          description: 'result envelope authState isAuthenticated alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail':
                  'Backend restore result envelope isAuthenticated applied.',
              'authState': <String, Object?>{
                'isAuthenticated': true,
                'remember': true,
              },
            },
          },
          expectedStatus:
              'Backend restore result envelope isAuthenticated applied.',
        ),
        (
          description: 'data envelope authState isAuthenticated alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail':
                  'Backend restore data envelope isAuthenticated applied.',
              'authState': <String, Object?>{
                'isAuthenticated': true,
                'remember': true,
              },
            },
          },
          expectedStatus:
              'Backend restore data envelope isAuthenticated applied.',
        ),
        (
          description: 'data envelope authState loggedIn alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend restore data envelope loggedIn applied.',
              'authState': <String, Object?>{
                'loggedIn': true,
                'persistSession': true,
              },
            },
          },
          expectedStatus: 'Backend restore data envelope loggedIn applied.',
        ),
        (
          description: 'result envelope authState loggedIn alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail': 'Backend restore result envelope loggedIn applied.',
              'authState': <String, Object?>{
                'loggedIn': true,
                'persistSession': true,
              },
            },
          },
          expectedStatus: 'Backend restore result envelope loggedIn applied.',
        ),
        (
          description: 'result envelope authState isLoggedIn alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail': 'Backend restore result envelope isLoggedIn applied.',
              'authState': <String, Object?>{
                'isLoggedIn': true,
                'persistSession': true,
              },
            },
          },
          expectedStatus: 'Backend restore result envelope isLoggedIn applied.',
        ),
        (
          description: 'data envelope authState isLoggedIn alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend restore data envelope isLoggedIn applied.',
              'authState': <String, Object?>{
                'isLoggedIn': true,
                'persistSession': true,
              },
            },
          },
          expectedStatus: 'Backend restore data envelope isLoggedIn applied.',
        ),
        (
          description: 'data envelope authState is_authenticated alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail':
                  'Backend restore data envelope is_authenticated applied.',
              'authState': <String, Object?>{
                'is_authenticated': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus:
              'Backend restore data envelope is_authenticated applied.',
        ),
        (
          description: 'result envelope authState is_authenticated alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail':
                  'Backend restore result envelope is_authenticated applied.',
              'authState': <String, Object?>{
                'is_authenticated': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus:
              'Backend restore result envelope is_authenticated applied.',
        ),
        (
          description: 'result envelope authState signedIn alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail': 'Backend restore result envelope signedIn applied.',
              'authState': <String, Object?>{
                'signedIn': true,
                'persistSession': true,
              },
            },
          },
          expectedStatus: 'Backend restore result envelope signedIn applied.',
        ),
        (
          description: 'data envelope authState signedIn alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend restore data envelope signedIn applied.',
              'authState': <String, Object?>{
                'signedIn': true,
                'persistSession': true,
              },
            },
          },
          expectedStatus: 'Backend restore data envelope signedIn applied.',
        ),
        (
          description: 'data envelope authState authenticated alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend restore data envelope authenticated applied.',
              'authState': <String, Object?>{
                'authenticated': true,
                'remember': true,
              },
            },
          },
          expectedStatus:
              'Backend restore data envelope authenticated applied.',
        ),
        (
          description: 'result envelope authState authenticated alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail':
                  'Backend restore result envelope authenticated applied.',
              'authState': <String, Object?>{
                'authenticated': true,
                'remember': true,
              },
            },
          },
          expectedStatus:
              'Backend restore result envelope authenticated applied.',
        ),
        (
          description: 'result envelope authState signed_in alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail': 'Backend restore result envelope signed_in applied.',
              'authState': <String, Object?>{
                'signed_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus: 'Backend restore result envelope signed_in applied.',
        ),
        (
          description: 'data envelope authState signed_in alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend restore data envelope signed_in applied.',
              'authState': <String, Object?>{
                'signed_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus: 'Backend restore data envelope signed_in applied.',
        ),
        (
          description: 'result envelope authState is_signed_in alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail': 'Backend restore result envelope is_signed_in applied.',
              'authState': <String, Object?>{
                'is_signed_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus:
              'Backend restore result envelope is_signed_in applied.',
        ),
        (
          description: 'data envelope authState is_signed_in alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend restore data envelope is_signed_in applied.',
              'authState': <String, Object?>{
                'is_signed_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus: 'Backend restore data envelope is_signed_in applied.',
        ),
        (
          description: 'result envelope authState logged_in alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail': 'Backend restore result envelope logged_in applied.',
              'authState': <String, Object?>{
                'logged_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus: 'Backend restore result envelope logged_in applied.',
        ),
        (
          description: 'data envelope authState logged_in alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend restore data envelope logged_in applied.',
              'authState': <String, Object?>{
                'logged_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus: 'Backend restore data envelope logged_in applied.',
        ),
        (
          description: 'data envelope authState is_logged_in alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'detail': 'Backend restore data envelope is_logged_in applied.',
              'authState': <String, Object?>{
                'is_logged_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus: 'Backend restore data envelope is_logged_in applied.',
        ),
        (
          description: 'result envelope authState is_logged_in alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'detail': 'Backend restore result envelope is_logged_in applied.',
              'authState': <String, Object?>{
                'is_logged_in': true,
                'remember_session': true,
              },
            },
          },
          expectedStatus:
              'Backend restore result envelope is_logged_in applied.',
        ),
      ];

  test(
    'auth/session parity restore-session signed-in authState matrix is symmetric',
    () {
      final Iterable<Map<String, Object?>> payloads =
          authStateSignedInRestoreEnvelopeCases.map(
            (caseData) => caseData.restoreSessionPayload,
          );
      expectOperationAuthStateMatrixSymmetric(
        operationLabel: 'restore-session',
        payloads: payloads,
        aliases: authStateSignedInAliases,
        expectedValue: true,
      );
    },
  );

  for (final ({
        String description,
        Map<String, Object?> restoreSessionPayload,
        String expectedStatus,
      })
      caseData
      in authStateSignedInRestoreEnvelopeCases) {
    testWidgets(
      'auth/session parity normalizes restore-session ${caseData.description} sign-in snapshot',
      (WidgetTester tester) async {
        await pumpDesktopApp(
          tester,
          contracts: DesktopContractBundle.fromMode(
            DesktopContractMode.remoteStub,
            remoteStubTransportClient:
                _AuthBackendAuthStateEnvelopeFixtureParityTransportClient(
                  signInPayload: const <String, Object?>{
                    'status': 'Backend sign-in baseline snapshot applied.',
                    'state': <String, Object?>{
                      'signedIn': true,
                      'rememberSession': true,
                    },
                  },
                  restoreSessionPayload: caseData.restoreSessionPayload,
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
            'Status: [remote-stub] Backend sign-in baseline snapshot applied.',
          ),
          findsOneWidget,
        );

        await tester.ensureVisible(
          find.byKey(const ValueKey<String>('auth-restore-session')),
        );
        await tester.tap(
          find.byKey(const ValueKey<String>('auth-restore-session')),
        );
        await tester.pumpAndSettle();
        expect(
          find.textContaining(
            'Status: [remote-stub] ${caseData.expectedStatus}',
          ),
          findsOneWidget,
        );
        expect(
          find.textContaining('Status: [remote-stub] Authentication required.'),
          findsNothing,
        );
        expect(
          find.textContaining('Session restored (simulated).'),
          findsNothing,
        );
        final CheckboxListTile rememberSessionTile = tester.widget(
          find.byKey(const ValueKey<String>('auth-remember')),
        );
        expect(rememberSessionTile.value, isTrue);
      },
    );
  }

  final List<
    ({
      String description,
      Map<String, Object?>? restoreSessionPayload,
      Map<String, Object?>? refreshTokenPayload,
      ValueKey<String> actionKey,
      String expectedStatus,
      String absentSuccessText,
    })
  >
  authStateSignedOutEnvelopeCases =
      <
        ({
          String description,
          Map<String, Object?>? restoreSessionPayload,
          Map<String, Object?>? refreshTokenPayload,
          ValueKey<String> actionKey,
          String expectedStatus,
          String absentSuccessText,
        })
      >[
        (
          description: 'result envelope authState signedOut alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'signedOut': true,
                'sessionToken': 'auth-state-signed-out-result-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description: 'refresh-token data envelope authState signedOut alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'signedOut': true,
                'sessionToken':
                    'auth-state-signed-out-refresh-data-camel-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token result envelope authState signed_out alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'signed_out': true,
                'sessionToken':
                    'auth-state-signed-out-refresh-result-snake-direct-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description: 'refresh-token data envelope authState signed_out alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'signed_out': true,
                'sessionToken':
                    'auth-state-signed-out-refresh-data-snake-direct-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description: 'result envelope authState signed_out alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'signed_out': true,
                'sessionToken':
                    'auth-state-signed-out-result-snake-direct-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'data envelope authState signed_out alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'signed_out': true,
                'sessionToken': 'auth-state-signed-out-data-snake-direct-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'result envelope authState signedOut alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'signedOut': true,
                'sessionToken': 'auth-state-signed-out-result-camel-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'data envelope authState signedOut alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'signedOut': true,
                'sessionToken': 'auth-state-signed-out-data-camel-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description:
              'refresh-token result envelope authState isSignedOut alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'isSignedOut': true,
                'sessionToken':
                    'auth-state-is-signed-out-refresh-result-camel-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token data envelope authState isSignedOut alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'isSignedOut': true,
                'sessionToken':
                    'auth-state-is-signed-out-refresh-data-camel-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description: 'result envelope authState isSignedOut alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'isSignedOut': true,
                'sessionToken': 'auth-state-is-signed-out-result-camel-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'data envelope authState isSignedOut alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'isSignedOut': true,
                'sessionToken': 'auth-state-is-signed-out-data-camel-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'result envelope authState loggedOut alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'loggedOut': true,
                'sessionToken': 'auth-state-logged-out-result-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description: 'refresh-token data envelope authState loggedOut alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'loggedOut': true,
                'sessionToken':
                    'auth-state-logged-out-refresh-data-camel-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token result envelope authState logged_out alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'logged_out': true,
                'sessionToken':
                    'auth-state-logged-out-refresh-result-snake-direct-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description: 'refresh-token data envelope authState logged_out alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'logged_out': true,
                'sessionToken':
                    'auth-state-logged-out-refresh-data-snake-direct-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description: 'result envelope authState logged_out alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'logged_out': true,
                'sessionToken':
                    'auth-state-logged-out-result-snake-direct-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'data envelope authState logged_out alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'logged_out': true,
                'sessionToken': 'auth-state-logged-out-data-snake-direct-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'result envelope authState loggedOut alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'loggedOut': true,
                'sessionToken': 'auth-state-logged-out-result-camel-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'data envelope authState loggedOut alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'loggedOut': true,
                'sessionToken': 'auth-state-logged-out-data-camel-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description:
              'refresh-token data envelope authState is_signed_out alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'is_signed_out': true,
                'sessionToken':
                    'auth-state-signed-out-refresh-data-snake-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token result envelope authState is_signed_out alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'is_signed_out': true,
                'sessionToken':
                    'auth-state-signed-out-refresh-result-snake-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description: 'data envelope authState is_signed_out alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'is_signed_out': true,
                'sessionToken': 'auth-state-signed-out-data-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'result envelope authState is_signed_out alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'is_signed_out': true,
                'sessionToken': 'auth-state-signed-out-result-snake-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description:
              'refresh-token data envelope authState is_logged_out alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'is_logged_out': true,
                'sessionToken':
                    'auth-state-logged-out-refresh-data-snake-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token result envelope authState is_logged_out alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'is_logged_out': true,
                'sessionToken':
                    'auth-state-logged-out-refresh-result-snake-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description: 'data envelope authState is_logged_out alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'is_logged_out': true,
                'sessionToken': 'auth-state-logged-out-data-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'result envelope authState is_logged_out alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'is_logged_out': true,
                'sessionToken': 'auth-state-logged-out-result-snake-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description:
              'refresh-token result envelope authState isLoggedOut alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'isLoggedOut': true,
                'sessionToken': 'auth-state-is-logged-out-refresh-result-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token data envelope authState isLoggedOut alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'isLoggedOut': true,
                'sessionToken': 'auth-state-is-logged-out-refresh-data-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description: 'result envelope authState isLoggedOut alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'isLoggedOut': true,
                'sessionToken': 'auth-state-is-logged-out-result-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'data envelope authState isLoggedOut alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'isLoggedOut': true,
                'sessionToken': 'auth-state-is-logged-out-data-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description:
              'refresh-token result envelope authState isAuthenticated false alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'isAuthenticated': false,
                'sessionToken':
                    'auth-state-is-authenticated-false-refresh-result-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token data envelope authState isAuthenticated false alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'isAuthenticated': false,
                'sessionToken':
                    'auth-state-is-authenticated-false-refresh-data-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token data envelope authState loggedIn false alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'loggedIn': false,
                'sessionToken': 'auth-state-logged-in-false-refresh-data-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token result envelope authState loggedIn false alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'loggedIn': false,
                'sessionToken':
                    'auth-state-logged-in-false-refresh-result-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token result envelope authState isLoggedIn false alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'isLoggedIn': false,
                'sessionToken':
                    'auth-state-is-logged-in-false-refresh-result-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token data envelope authState isLoggedIn false alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'isLoggedIn': false,
                'sessionToken':
                    'auth-state-is-logged-in-false-refresh-data-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token data envelope authState is_authenticated false alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'is_authenticated': false,
                'sessionToken':
                    'auth-state-is-authenticated-false-refresh-data-snake-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token result envelope authState is_authenticated false alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'is_authenticated': false,
                'sessionToken':
                    'auth-state-is-authenticated-false-refresh-result-snake-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token result envelope authState signedIn false alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'signedIn': false,
                'sessionToken':
                    'auth-state-signed-in-camel-false-refresh-result-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token data envelope authState signedIn false alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'signedIn': false,
                'sessionToken':
                    'auth-state-signed-in-camel-false-refresh-data-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token data envelope authState authenticated false alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'authenticated': false,
                'sessionToken':
                    'auth-state-authenticated-false-refresh-data-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token result envelope authState authenticated false alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'authenticated': false,
                'sessionToken':
                    'auth-state-authenticated-false-refresh-result-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token result envelope authState signed_in false alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'signed_in': false,
                'sessionToken':
                    'auth-state-signed-in-false-refresh-result-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token data envelope authState signed_in false alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'signed_in': false,
                'sessionToken': 'auth-state-signed-in-false-refresh-data-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token result envelope authState is_signed_in false alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'is_signed_in': false,
                'sessionToken':
                    'auth-state-is-signed-in-false-refresh-result-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token data envelope authState is_signed_in false alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'is_signed_in': false,
                'sessionToken':
                    'auth-state-is-signed-in-false-refresh-data-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token result envelope authState logged_in false alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'logged_in': false,
                'sessionToken':
                    'auth-state-logged-in-snake-false-refresh-result-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token data envelope authState logged_in false alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'logged_in': false,
                'sessionToken':
                    'auth-state-logged-in-snake-false-refresh-data-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token data envelope authState is_logged_in false alias',
          refreshTokenPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'is_logged_in': false,
                'sessionToken':
                    'auth-state-is-logged-in-snake-false-refresh-data-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description:
              'refresh-token result envelope authState is_logged_in false alias',
          refreshTokenPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'is_logged_in': false,
                'sessionToken':
                    'auth-state-is-logged-in-snake-false-refresh-result-token',
              },
            },
          },
          restoreSessionPayload: null,
          actionKey: const ValueKey<String>('auth-refresh-token'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Token refreshed (simulated).',
        ),
        (
          description: 'result envelope authState isAuthenticated false alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'isAuthenticated': false,
                'sessionToken':
                    'auth-state-is-authenticated-false-result-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'data envelope authState isAuthenticated false alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'isAuthenticated': false,
                'sessionToken': 'auth-state-is-authenticated-false-data-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'data envelope authState loggedIn false alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'loggedIn': false,
                'sessionToken': 'auth-state-logged-in-false-data-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'result envelope authState loggedIn false alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'loggedIn': false,
                'sessionToken': 'auth-state-logged-in-false-result-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'result envelope authState isLoggedIn false alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'isLoggedIn': false,
                'sessionToken': 'auth-state-is-logged-in-false-result-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'data envelope authState isLoggedIn false alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'isLoggedIn': false,
                'sessionToken': 'auth-state-is-logged-in-false-data-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'data envelope authState is_authenticated false alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'is_authenticated': false,
                'sessionToken': 'auth-state-is-authenticated-false-data-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'result envelope authState is_authenticated false alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'is_authenticated': false,
                'sessionToken':
                    'auth-state-is-authenticated-false-result-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'result envelope authState signedIn false alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'signedIn': false,
                'sessionToken': 'auth-state-signed-in-camel-false-result-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'data envelope authState signedIn false alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'signedIn': false,
                'sessionToken': 'auth-state-signed-in-camel-false-data-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'data envelope authState authenticated false alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'authenticated': false,
                'sessionToken': 'auth-state-authenticated-false-data-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'result envelope authState authenticated false alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'authenticated': false,
                'sessionToken': 'auth-state-authenticated-false-result-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'result envelope authState signed_in false alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'signed_in': false,
                'sessionToken': 'auth-state-signed-in-false-result-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'data envelope authState signed_in false alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'signed_in': false,
                'sessionToken': 'auth-state-signed-in-false-data-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'result envelope authState is_signed_in false alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'is_signed_in': false,
                'sessionToken': 'auth-state-is-signed-in-false-result-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'data envelope authState is_signed_in false alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'is_signed_in': false,
                'sessionToken': 'auth-state-is-signed-in-false-data-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'result envelope authState logged_in false alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'logged_in': false,
                'sessionToken': 'auth-state-logged-in-snake-false-result-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'data envelope authState logged_in false alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'logged_in': false,
                'sessionToken': 'auth-state-logged-in-snake-false-data-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'data envelope authState is_logged_in false alias',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'is_logged_in': false,
                'sessionToken':
                    'auth-state-is-logged-in-snake-false-data-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description: 'result envelope authState is_logged_in false alias',
          restoreSessionPayload: <String, Object?>{
            'result': <String, Object?>{
              'authState': <String, Object?>{
                'is_logged_in': false,
                'sessionToken':
                    'auth-state-is-logged-in-snake-false-result-token',
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
        (
          description:
              'data envelope authState explicit signed-out authentication over token',
          restoreSessionPayload: <String, Object?>{
            'data': <String, Object?>{
              'authState': <String, Object?>{
                'authentication': <String, Object?>{'authenticated': false},
                'tokens': <String, Object?>{
                  'accessToken': 'auth-state-ignored-token',
                },
              },
            },
          },
          refreshTokenPayload: null,
          actionKey: const ValueKey<String>('auth-restore-session'),
          expectedStatus: 'Authentication required.',
          absentSuccessText: 'Session restored (simulated).',
        ),
      ];

  final Iterable<Map<String, Object?>> restoreAuthStateEnvelopePayloads =
      authStateSignedOutEnvelopeCases
          .where(
            (caseData) =>
                caseData.actionKey.value == 'auth-restore-session' &&
                caseData.restoreSessionPayload != null,
          )
          .map((caseData) => caseData.restoreSessionPayload!);
  final Iterable<Map<String, Object?>> refreshAuthStateEnvelopePayloads =
      authStateSignedOutEnvelopeCases
          .where(
            (caseData) =>
                caseData.actionKey.value == 'auth-refresh-token' &&
                caseData.refreshTokenPayload != null,
          )
          .map((caseData) => caseData.refreshTokenPayload!);

  void expectRestoreRefreshAuthStateMatrixSymmetric({
    required Iterable<String> aliases,
    required bool expectedValue,
  }) {
    final List<String> missingEntries = <String>[];

    appendMissingAuthStateMatrixEntries(
      missingEntries: missingEntries,
      operationLabel: 'refresh-token',
      payloads: refreshAuthStateEnvelopePayloads,
      aliases: aliases,
      expectedValue: expectedValue,
    );
    appendMissingAuthStateMatrixEntries(
      missingEntries: missingEntries,
      operationLabel: 'restore-session',
      payloads: restoreAuthStateEnvelopePayloads,
      aliases: aliases,
      expectedValue: expectedValue,
    );

    expect(
      missingEntries,
      isEmpty,
      reason: 'Missing parity matrix entries:\n${missingEntries.join('\n')}',
    );
  }

  test(
    'auth/session parity restore/refresh signed-out authState matrix is symmetric',
    () {
      expectRestoreRefreshAuthStateMatrixSymmetric(
        aliases: authStateSignedOutAliases,
        expectedValue: true,
      );
    },
  );

  test(
    'auth/session parity restore/refresh signed-in-false authState matrix is symmetric',
    () {
      expectRestoreRefreshAuthStateMatrixSymmetric(
        aliases: authStateSignedInAliases,
        expectedValue: false,
      );
    },
  );

  for (final ({
        String description,
        Map<String, Object?>? restoreSessionPayload,
        Map<String, Object?>? refreshTokenPayload,
        ValueKey<String> actionKey,
        String expectedStatus,
        String absentSuccessText,
      })
      caseData
      in authStateSignedOutEnvelopeCases) {
    testWidgets(
      'auth/session parity maps ${caseData.description} to deterministic signed-out fallback',
      (WidgetTester tester) async {
        await pumpDesktopApp(
          tester,
          contracts: DesktopContractBundle.fromMode(
            DesktopContractMode.remoteStub,
            remoteStubTransportClient:
                _AuthBackendAuthStateEnvelopeFixtureParityTransportClient(
                  signInPayload: const <String, Object?>{
                    'status': 'Backend sign-in snapshot applied.',
                    'state': <String, Object?>{
                      'signedIn': true,
                      'rememberSession': true,
                    },
                  },
                  restoreSessionPayload: caseData.restoreSessionPayload,
                  refreshTokenPayload: caseData.refreshTokenPayload,
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

        await tester.ensureVisible(find.byKey(caseData.actionKey));
        await tester.tap(find.byKey(caseData.actionKey));
        await tester.pumpAndSettle();
        expect(
          find.textContaining(
            'Status: [remote-stub] ${caseData.expectedStatus}',
          ),
          findsOneWidget,
        );
        expect(find.textContaining(caseData.absentSuccessText), findsNothing);
      },
    );
  }

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
