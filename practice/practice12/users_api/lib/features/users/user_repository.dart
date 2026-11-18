import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import 'user.dart';
import 'users_cache.dart';
import 'users_result.dart';

// Screens ask for models and get models — or an ApiException.
class UserRepository {
  UserRepository(this._api, this._cache);

  final ApiClient _api;
  final UsersCache _cache;

  Uri _uri(String path) => Uri.https(_api.host, path); // never '+'

  // Practice 12, Level 4: fresh from the network and saved, or the
  // saved copy when there is no network, or the honest error when
  // there is nothing saved.
  Future<UsersResult> getAll() async {
    try {
      final fresh = await _fetchAll();
      await _cache.save(fresh);
      return (items: fresh, fromCache: false);
    } on NoConnectionException {
      final saved = await _cache.load();
      if (saved == null) rethrow;
      return (items: saved, fromCache: true);
    }
  }

  Future<List<User>> _fetchAll() async {
    final json = await _api.getJson(_uri('/users'));
    try {
      return [
        for (final item in json as List<dynamic>)
          User.fromJson(item as Map<String, dynamic>),
      ];
    } on TypeError catch (e) {
      throw BadResponseException('users: $e');
    }
  }

  Future<User> getById(int id) async {
    final json = await _api.getJson(_uri('/users/$id'));
    try {
      return User.fromJson(json as Map<String, dynamic>);
    } on TypeError catch (e) {
      throw BadResponseException('users/$id: $e');
    }
  }

  Future<User> create(User draft) async {
    final json = await _api.postJson(_uri('/users'), draft.toJson());
    try {
      return User.fromJson(json as Map<String, dynamic>);
    } on TypeError catch (e) {
      throw BadResponseException('users (POST): $e');
    }
  }
}
