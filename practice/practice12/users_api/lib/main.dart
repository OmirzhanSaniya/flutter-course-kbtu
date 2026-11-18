import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/api/api_client.dart';
import 'core/storage/secure_store.dart';
import 'features/auth/auth_model.dart';
import 'features/settings/settings_model.dart';
import 'features/users/user_repository.dart';
import 'features/users/users_cache.dart';
import 'features/users/users_model.dart';

// The order matters: the binding, then the disk, then runApp.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // before any plugin

  // Settings, read BEFORE the first frame: no flash of a light theme.
  // BREAK IT (Level 2): read darkMode later inside SettingsModel ->
  // one light frame, then dark.
  final prefs = SharedPreferencesAsync();
  final dark = await prefs.getBool('darkMode') ?? false;
  final city = await prefs.getString('cityFilter'); // String?
  final avatarPath = await prefs.getString('avatarPath'); // String?

  // The token, from the Keychain / Keystore.
  const store = SecureStore();
  final token = await store.readToken();

  // The composition root: the chain is built here, once.
  final api = ApiClient.real(store);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsModel(
            prefs,
            dark: dark,
            city: city,
            avatarPath: avatarPath,
          ),
        ),
        ChangeNotifierProvider(create: (_) => AuthModel(store, token)),
        ChangeNotifierProvider(
          create: (_) => UsersModel(UserRepository(api, UsersCache()))..load(),
        ),
      ],
      child: const App(),
    ),
  );
}
