import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../storage/secure_store.dart';
import 'api_exception.dart';

// The only class (with the repository) that knows http exists.
// Out of here come decoded JSON or one of OUR exceptions —
// never a Response, never a status code.
class ApiClient {
  ApiClient(
    this._client,
    this._store, {
    this.host = 'jsonplaceholder.typicode.com',
  });

  // The real network client, for main.dart. Here and not in main.dart
  // so that `package:http` stays inside core/api (the grep rule).
  ApiClient.real(
    SecureStore store, {
    String host = 'jsonplaceholder.typicode.com',
  }) : this(http.Client(), store, host: host);

  final http.Client _client; // injected: tests pass a MockClient
  final SecureStore _store; // Practice 12: the token lives here
  final String host;

  // Headers in one place. The token is added HERE, so the repository
  // never sees it and the screen never sees the header.
  Future<Map<String, String>> _headers() async => {
    'Accept': 'application/json',
    if (await _store.readToken() case final t?) 'Authorization': 'Bearer $t',
  };

  /// GET → decoded JSON (a List or a Map).
  Future<dynamic> getJson(Uri uri) async {
    final headers = await _headers();
    final r = await _send(() => _client.get(uri, headers: headers));
    _check(r);
    return _decode(r);
  }

  /// POST a JSON body → decoded JSON. [expected] is the success status.
  Future<dynamic> postJson(Uri uri, Object body, {int expected = 201}) async {
    final headers = await _headers();
    final r = await _send(
      () => _client.post(
        uri,
        headers: {...headers, 'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ),
    );
    _check(r);
    if (r.statusCode != expected) {
      throw BadResponseException('expected $expected, got ${r.statusCode}');
    }
    return _decode(r);
  }

  // 1. The wire: no answer at all -> NoConnectionException.
  Future<http.Response> _send(Future<http.Response> Function() call) async {
    try {
      final r = await call().timeout(const Duration(seconds: 10));
      if (kDebugMode) {
        log(
          '${r.request?.method} ${r.request?.url.path} → ${r.statusCode}',
          name: 'api',
        );
      }
      return r;
    } on SocketException {
      throw const NoConnectionException(); // airplane mode, bad host
    } on TimeoutException {
      throw const NoConnectionException(); // Wi-Fi that leads nowhere
    } on http.ClientException {
      throw const NoConnectionException(); // http wraps socket errors
    }
  }

  // 2. The status, BEFORE the body.
  // BREAK IT (Level 3): delete the 404 line -> getById(999) decodes {}
  // and fails in fromJson: BadResponseException, but the wrong cause.
  void _check(http.Response r) {
    final s = r.statusCode;
    if (s == 401) throw const UnauthorizedException();
    if (s == 404) throw const NotFoundException();
    if (s >= 500) throw ServerException(s);
  }

  // 3. The body: text that is not JSON -> BadResponseException.
  dynamic _decode(http.Response r) {
    try {
      return jsonDecode(r.body);
    } on FormatException catch (e) {
      throw BadResponseException('not JSON: ${e.message}');
    }
  }
}
