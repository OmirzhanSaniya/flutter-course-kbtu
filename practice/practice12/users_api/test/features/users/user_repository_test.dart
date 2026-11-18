import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:users_api/core/api/api_exception.dart';
import 'package:users_api/features/users/user.dart';

import 'test_helpers.dart';
import 'user1_json.dart';

void main() {
  test('getAll parses a list', () async {
    final repo = repoWith((_) async => http.Response('[$user1Json]', 200));
    final result = await repo.getAll();
    expect(result.items.single.name, 'Leanne Graham');
    expect(result.fromCache, isFalse);
  });

  test('404 -> NotFoundException', () async {
    final repo = repoWith((_) async => http.Response('{}', 404));
    expect(repo.getById(999), throwsA(isA<NotFoundException>()));
  });

  test('500 -> ServerException(500)', () async {
    final repo = repoWith((_) async => http.Response('oops', 500));
    expect(
      repo.getAll(),
      throwsA(isA<ServerException>().having((e) => e.status, 'status', 500)),
    );
  });

  test('SocketException -> NoConnectionException', () async {
    final repo = repoWith((_) async => throw const SocketException('down'));
    expect(repo.getAll(), throwsA(isA<NoConnectionException>()));
  });

  test('not JSON -> BadResponseException', () async {
    final repo = repoWith((_) async => http.Response('<html>', 200));
    expect(repo.getAll(), throwsA(isA<BadResponseException>()));
  });

  test('a broken field -> BadResponseException', () async {
    final bad = user1Json.replaceFirst('"id": 1', '"id": "1"');
    final repo = repoWith((_) async => http.Response(bad, 200));
    expect(repo.getById(1), throwsA(isA<BadResponseException>()));
  });

  test('create POSTs JSON and returns the server id', () async {
    late http.Request sent;
    final repo = repoWith((req) async {
      sent = req;
      final body = jsonDecode(req.body) as Map<String, dynamic>;
      return http.Response(jsonEncode({...body, 'id': 11}), 201);
    });
    final draft = User.fromJson(jsonDecode(user1Json) as Map<String, dynamic>);
    final created = await repo.create(draft);
    expect(created.id, 11);
    expect(sent.method, 'POST');
    expect(sent.headers['Content-Type'], startsWith('application/json'));
    expect(sent.url.toString(), 'https://jsonplaceholder.typicode.com/users');
  });

  test('no network + a saved list -> the saved list, fromCache', () async {
    final cache = tempCache();
    final online = repoWith(
      (_) async => http.Response('[$user1Json]', 200),
      cache: cache,
    );
    await online.getAll(); // saves to the cache
    final offline = repoWith(
      (_) async => throw const SocketException('down'),
      cache: cache,
    );
    final result = await offline.getAll();
    expect(result.fromCache, isTrue);
    expect(result.items.single.name, 'Leanne Graham');
  });

  test('no network + nothing saved -> NoConnectionException', () async {
    final repo = repoWith((_) async => throw const SocketException('down'));
    expect(repo.getAll(), throwsA(isA<NoConnectionException>()));
  });

  test('a saved token becomes the Authorization header', () async {
    late http.BaseRequest sent;
    final repo = repoWith((req) async {
      sent = req;
      return http.Response('[]', 200);
    }, secure: {'token': 'tok_42'});
    await repo.getAll();
    expect(sent.headers['Authorization'], 'Bearer tok_42');
  });

  test('no token -> no Authorization header', () async {
    late http.BaseRequest sent;
    final repo = repoWith((req) async {
      sent = req;
      return http.Response('[]', 200);
    });
    await repo.getAll();
    expect(sent.headers.containsKey('Authorization'), isFalse);
  });
}
