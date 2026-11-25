import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'user.dart';

// Level 4: the last good list, in a file in Documents.
// Documents = kept until the app is deleted. Temporary = the OS may
// clear it any time ("Clear cache").
class UsersCache {
  UsersCache({Future<Directory> Function()? directory})
    // BREAK IT (Level 4): getTemporaryDirectory -> "Clear cache"
    // in Android settings wipes the saved list.
    : _directory = directory ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _directory; // tests pass a temp dir

  Future<File> _file() async {
    final dir = await _directory();
    return File('${dir.path}${Platform.pathSeparator}users.json');
  }

  Future<void> save(List<User> list) async {
    final file = await _file();
    await file.writeAsString(jsonEncode([for (final u in list) u.toJson()]));
  }

  /// null = nothing saved yet (first launch, or the app was reinstalled).
  Future<List<User>?> load() async {
    final file = await _file();
    if (!await file.exists()) return null;
    try {
      final json = jsonDecode(await file.readAsString()) as List<dynamic>;
      return [
        for (final item in json) User.fromJson(item as Map<String, dynamic>),
      ];
    } on FormatException catch (e) {
      log('cache is broken: $e', name: 'cache'); // treat as "no cache"
      return null;
    } on TypeError catch (e) {
      log('cache has an old shape: $e', name: 'cache');
      return null;
    }
  }
}
