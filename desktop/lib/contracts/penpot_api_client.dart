import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// HTTP client for communicating with the Penpot backend RPC API.
///
/// The Penpot backend exposes an RPC-style API at:
///   POST /api/main/methods/{method-name}
///
/// Authentication uses session cookies (auth-token) set after login.
/// Requests use application/json content type.
class PenpotApiClient {
  PenpotApiClient({
    required this.baseUrl,
    Duration? timeout,
  }) : timeout = timeout ?? const Duration(seconds: 10) {
    _httpClient = HttpClient()
      ..connectionTimeout = this.timeout
      ..idleTimeout = const Duration(seconds: 30);
  }

  final String baseUrl;
  final Duration timeout;
  late final HttpClient _httpClient;

  String? _authToken;
  final Map<String, String> _cookies = <String, String>{};

  String? get authToken => _authToken;
  bool get isAuthenticated => _authToken != null && _authToken!.isNotEmpty;

  void setAuthToken(String? token) {
    _authToken = token;
  }

  void dispose() {
    _httpClient.close(force: true);
  }

  /// Call a Penpot RPC method.
  ///
  /// [method] is the RPC method name (e.g., 'login-with-password').
  /// [params] is the JSON-encodable parameters map.
  Future<PenpotApiResponse> rpc(
    String method, {
    Map<String, Object?> params = const <String, Object?>{},
  }) async {
    final Uri uri = Uri.parse('$baseUrl/api/main/methods/$method');

    try {
      final HttpClientRequest request = await _httpClient
          .postUrl(uri)
          .timeout(timeout);

      request.headers.set('Content-Type', 'application/json');
      request.headers.set('Accept', 'application/json');

      if (_authToken != null && _authToken!.isNotEmpty) {
        request.headers.set('Authorization', 'Token $_authToken');
      }

      if (_cookies.isNotEmpty) {
        final String cookieHeader = _cookies.entries
            .map((MapEntry<String, String> e) => '${e.key}=${e.value}')
            .join('; ');
        request.headers.set('Cookie', cookieHeader);
      }

      request.write(jsonEncode(params));

      final HttpClientResponse response = await request.close().timeout(timeout);

      _extractCookies(response);

      final String body = await response.transform(utf8.decoder).join();
      final int statusCode = response.statusCode;

      Map<String, Object?> data = const <String, Object?>{};
      if (body.isNotEmpty) {
        try {
          final Object? decoded = jsonDecode(body);
          if (decoded is Map<String, Object?>) {
            data = decoded;
          } else if (decoded is Map) {
            data = <String, Object?>{};
            decoded.forEach((Object? k, Object? v) {
              data['$k'] = v;
            });
          }
        } on FormatException {
          // Body is not JSON
        }
      }

      return PenpotApiResponse(
        statusCode: statusCode,
        body: body,
        data: data,
        ok: statusCode >= 200 && statusCode < 300,
      );
    } on SocketException catch (e) {
      return PenpotApiResponse.error('Connection failed: ${e.message}');
    } on HttpException catch (e) {
      return PenpotApiResponse.error('HTTP error: ${e.message}');
    } on TimeoutException {
      return PenpotApiResponse.error('Request timed out');
    } on Object catch (e) {
      return PenpotApiResponse.error('Unexpected error: $e');
    }
  }

  /// Upload a file as multipart form data.
  Future<PenpotApiResponse> uploadFile(
    String method, {
    required String filePath,
    required String fieldName,
    Map<String, String> fields = const <String, String>{},
  }) async {
    final Uri uri = Uri.parse('$baseUrl/api/main/methods/$method');

    try {
      final HttpClientRequest request = await _httpClient
          .postUrl(uri)
          .timeout(timeout);

      final String boundary =
          '----PenjarDesktop${DateTime.now().millisecondsSinceEpoch}';
      request.headers.set(
        'Content-Type',
        'multipart/form-data; boundary=$boundary',
      );
      request.headers.set('Accept', 'application/json');

      if (_authToken != null && _authToken!.isNotEmpty) {
        request.headers.set('Authorization', 'Token $_authToken');
      }

      if (_cookies.isNotEmpty) {
        final String cookieHeader = _cookies.entries
            .map((MapEntry<String, String> e) => '${e.key}=${e.value}')
            .join('; ');
        request.headers.set('Cookie', cookieHeader);
      }

      final StringBuffer body = StringBuffer();

      for (final MapEntry<String, String> field in fields.entries) {
        body.write('--$boundary\r\n');
        body.write(
          'Content-Disposition: form-data; name="${field.key}"\r\n\r\n',
        );
        body.write('${field.value}\r\n');
      }

      final File file = File(filePath);
      if (await file.exists()) {
        final String fileName = file.uri.pathSegments.last;
        body.write('--$boundary\r\n');
        body.write(
          'Content-Disposition: form-data; name="$fieldName"; filename="$fileName"\r\n',
        );
        body.write('Content-Type: application/octet-stream\r\n\r\n');
        request.write(body);
        await request.addStream(file.openRead());
        request.write('\r\n--$boundary--\r\n');
      } else {
        body.write('--$boundary--\r\n');
        request.write(body);
      }

      final HttpClientResponse response = await request.close().timeout(timeout);
      _extractCookies(response);

      final String responseBody =
          await response.transform(utf8.decoder).join();

      Map<String, Object?> data = const <String, Object?>{};
      if (responseBody.isNotEmpty) {
        try {
          final Object? decoded = jsonDecode(responseBody);
          if (decoded is Map) {
            data = <String, Object?>{};
            decoded.forEach((Object? k, Object? v) {
              data['$k'] = v;
            });
          }
        } on FormatException {
          // Not JSON
        }
      }

      return PenpotApiResponse(
        statusCode: response.statusCode,
        body: responseBody,
        data: data,
        ok: response.statusCode >= 200 && response.statusCode < 300,
      );
    } on Object catch (e) {
      return PenpotApiResponse.error('Upload failed: $e');
    }
  }

  void _extractCookies(HttpClientResponse response) {
    final List<String> setCookieHeaders =
        response.headers[HttpHeaders.setCookieHeader] ?? <String>[];
    for (final String header in setCookieHeaders) {
      final Cookie cookie = Cookie.fromSetCookieValue(header);
      _cookies[cookie.name] = cookie.value;
      if (cookie.name == 'auth-token') {
        _authToken = cookie.value;
      }
    }
  }
}

class PenpotApiResponse {
  const PenpotApiResponse({
    required this.statusCode,
    required this.body,
    required this.data,
    required this.ok,
    this.errorMessage,
  });

  factory PenpotApiResponse.error(String message) {
    return PenpotApiResponse(
      statusCode: 0,
      body: '',
      data: const <String, Object?>{},
      ok: false,
      errorMessage: message,
    );
  }

  final int statusCode;
  final String body;
  final Map<String, Object?> data;
  final bool ok;
  final String? errorMessage;

  String? get id => _getString('id');
  String? get name => _getString('name');
  String? get email => _getString('email');

  String? _getString(String key) {
    final Object? value = data[key];
    return value is String ? value : null;
  }

  List<Map<String, Object?>> getList(String key) {
    final Object? value = data[key];
    if (value is List) {
      return value
          .whereType<Map>()
          .map((Map<dynamic, dynamic> m) {
            final Map<String, Object?> result = <String, Object?>{};
            m.forEach((dynamic k, dynamic v) {
              result['$k'] = v;
            });
            return result;
          })
          .toList();
    }
    return <Map<String, Object?>>[];
  }

  String get errorDetail {
    if (errorMessage != null) return errorMessage!;
    final Object? hint = data['hint'] ?? data['message'] ?? data['reason'];
    if (hint is String && hint.isNotEmpty) return hint;
    if (statusCode == 401 || statusCode == 403) return 'Authentication required';
    return 'Request failed (HTTP $statusCode)';
  }
}
