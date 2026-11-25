import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import 'user.dart';
import 'users_cache.dart';
import 'users_result.dart';

// Practice 13: the contract. UsersModel only knows this interface;
// main.dart decides which implementation it gets.
abstract interface class UserRepository {
  Future<UsersResult> getAll();
  Future<User> getById(int id);
  Future<User> create(User draft);
}

// The real one: the network + the file cache.
// Screens ask for models and get models — or an ApiException.
class HttpUserRepository implements UserRepository {
  HttpUserRepository(this._api, this._cache);

  final ApiClient _api;
  final UsersCache _cache;

  Uri _uri(String path) => Uri.https(_api.host, path); // never '+'

  // Practice 12, Level 4: fresh from the network and saved, or the
  // saved copy when there is no network, or the honest error when
  // there is nothing saved.
  @override
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
      // Practice 13, Level 5: the server broke the contract (e.g. lat is
      // a number, not a String). #0 of the trace is Geo.fromJson — the
      // right place to THROW, the wrong place to FIX: we map it here, so
      // the screen shows the generic error instead of crashing.
      throw BadResponseException('users: $e');
    }
  }

  @override
  Future<User> getById(int id) async {
    final json = await _api.getJson(_uri('/users/$id'));
    try {
      return User.fromJson(json as Map<String, dynamic>);
    } on TypeError catch (e) {
      throw BadResponseException('users/$id: $e');
    }
  }

  @override
  Future<User> create(User draft) async {
    final json = await _api.postJson(_uri('/users'), draft.toJson());
    try {
      return User.fromJson(json as Map<String, dynamic>);
    } on TypeError catch (e) {
      throw BadResponseException('users (POST): $e');
    }
  }
}
