import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import 'user.dart';

// Screens ask for models and get models — or an ApiException.
class UserRepository {
  UserRepository(this._api);

  final ApiClient _api;

  Uri _uri(String path) => Uri.https(_api.host, path); // never '+'

  Future<List<User>> getAll() async {
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
