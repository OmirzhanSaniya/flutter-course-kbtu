import 'package:flutter/foundation.dart';

import '../../core/storage/secure_store.dart';
import 'login_exception.dart';

// Level 3: a fake login with a real secure store.
class AuthModel extends ChangeNotifier {
  AuthModel(this._store, [this._token]);

  final SecureStore _store;
  String? _token; // read in main() before runApp

  bool get signedIn => _token != null;

  /// Only for the debug "Copy token" button. Never print it.
  String? get token => _token;

  // The fake: any password of 8+ characters, after one second.
  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (password.length < 8) {
      throw const LoginException('Password must be at least 8 characters');
    }
    final token = 'tok_${email.hashCode}';
    await _store.saveToken(token);
    _token = token;
    notifyListeners();
  }

  Future<void> logout() async {
    await _store.clear();
    _token = null;
    notifyListeners();
  }
}
