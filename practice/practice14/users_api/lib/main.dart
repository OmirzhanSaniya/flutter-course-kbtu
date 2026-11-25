import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/api/api_client.dart';
import 'core/env.dart';
import 'core/storage/secure_store.dart';
import 'features/auth/auth_model.dart';
import 'features/settings/settings_model.dart';
import 'features/users/fake_user_repository.dart';
import 'features/users/user_repository.dart';
import 'features/users/users_cache.dart';
import 'features/users/users_model.dart';

// The order matters: the binding, then the disk, then runApp.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // before any plugin

  // Settings, read BEFORE the first frame: no flash of a light theme.
  // BREAK IT (Practice 12, Level 2): read darkMode later inside
  // SettingsModel -> one light frame, then dark.
  final prefs = SharedPreferencesAsync();
  final dark = await prefs.getBool('darkMode') ?? false;
  final city = await prefs.getString('cityFilter'); // String?
  final avatarPath = await prefs.getString('avatarPath'); // String?
  // Practice 14: a tester's host override — debug builds only.
  final devHost = kDebugMode ? await prefs.getString('devHost') : null;

  // The token, from the Keychain / Keystore.
  const store = SecureStore();
  final token = await store.readToken();

  // The composition root: the chain is built here, once.
  // Practice 14: the choice is a build-time constant, not an edited file.
  //   flutter run --dart-define=USE_FAKES=true  -> no network at all
  final UserRepository repo = Env.useFakes
      ? FakeUserRepository()
      : HttpUserRepository(
          ApiClient.real(store, host: devHost ?? Env.host),
          UsersCache(),
        );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsModel(
            prefs,
            dark: dark,
            city: city,
            avatarPath: avatarPath,
            devHost: devHost,
          ),
        ),
        ChangeNotifierProvider(create: (_) => AuthModel(store, token)),
        ChangeNotifierProvider(create: (_) => UsersModel(repo)..load()),
      ],
      child: const App(),
    ),
  );
}
