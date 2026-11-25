import 'package:flutter/foundation.dart';

import '../../core/api/api_exception.dart';
import 'user.dart';
import 'user_repository.dart';

// Level 4: no BuildContext, no mounted, no http.
class UsersModel extends ChangeNotifier {
  UsersModel(this._repo);

  final UserRepository _repo;

  List<User> items = const [];
  ApiException? error;
  bool loading = false;
  bool fromCache = false; // true -> the screen shows the stale banner

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final result = await _repo.getAll();
      items = result.items;
      fromCache = result.fromCache;
    } on ApiException catch (e) {
      error = e; // never an empty catch
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // Level 5: POST. Errors go up to the form, which shows a SnackBar.
  Future<void> create(User draft) async {
    final created = await _repo.create(draft); // the server's id
    items = [created, ...items];
    notifyListeners();
  }
}
