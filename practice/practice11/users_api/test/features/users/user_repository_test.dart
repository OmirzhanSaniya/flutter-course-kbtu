import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:users_api/core/api/api_client.dart';
import 'package:users_api/core/api/api_exception.dart';
import 'package:users_api/features/users/user.dart';
import 'package:users_api/features/users/user_repository.dart';

import 'user1_json.dart';

UserRepository repoWith(MockClientHandler handler) =>
    UserRepository(ApiClient(MockClient(handler)));

void main() {
  test('getAll parses a list', () async {
    final repo = repoWith((_) async => http.Response('[$user1Json]', 200));
    final users = await repo.getAll();
    expect(users.single.name, 'Leanne Graham');
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
}
