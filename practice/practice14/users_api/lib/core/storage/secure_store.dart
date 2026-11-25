import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Level 3: anything that lets someone BE you goes to the Keychain
// (iOS) / Keystore (Android) — never to shared_preferences.
class SecureStore {
  const SecureStore([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;
  static const _key = 'token';

  Future<void> saveToken(String token) =>
      _storage.write(key: _key, value: token);

  Future<String?> readToken() => _storage.read(key: _key);

  Future<void> clear() => _storage.delete(key: _key);
}
