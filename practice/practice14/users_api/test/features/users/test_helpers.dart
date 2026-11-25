import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/testing.dart';
import 'package:users_api/core/api/api_client.dart';
import 'package:users_api/core/storage/secure_store.dart';
import 'package:users_api/features/users/user_repository.dart';
import 'package:users_api/features/users/users_cache.dart';

/// A cache in a fresh temporary folder — never the real Documents.
UsersCache tempCache() {
  final dir = Directory.systemTemp.createTempSync('users_cache_test');
  return UsersCache(directory: () async => dir);
}

/// A repository over a fake network, an in-memory secure store and a
/// temporary cache.
HttpUserRepository repoWith(
  MockClientHandler handler, {
  UsersCache? cache,
  Map<String, String> secure = const {},
}) {
  FlutterSecureStorage.setMockInitialValues(Map.of(secure));
  return HttpUserRepository(
    ApiClient(MockClient(handler), const SecureStore()),
    cache ?? tempCache(),
  );
}
