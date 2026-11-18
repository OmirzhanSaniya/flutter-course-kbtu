import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Level 2: settings in shared_preferences. The first values are read
// in main() BEFORE runApp and come in through the constructor, so the
// very first frame already has the right theme.
class SettingsModel extends ChangeNotifier {
  SettingsModel(this._prefs, {required this.dark, this.city, this.avatarPath});

  final SharedPreferencesAsync _prefs;

  // Read by the screens; changed only through the setters below.
  bool dark;
  String? city; // null = all cities
  String? avatarPath;

  // notifyListeners() FIRST: the screen must not wait for the disk.
  Future<void> setDark(bool v) async {
    dark = v;
    notifyListeners();
    await _prefs.setBool('darkMode', v);
  }

  Future<void> setCity(String? c) async {
    city = c;
    notifyListeners();
    if (c == null) {
      await _prefs.remove('cityFilter');
    } else {
      await _prefs.setString('cityFilter', c);
    }
  }

  Future<void> setAvatarPath(String path) async {
    avatarPath = path;
    notifyListeners();
    await _prefs.setString('avatarPath', path);
  }
}
