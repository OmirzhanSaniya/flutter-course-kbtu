import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/auth/auth_model.dart';
import 'features/auth/login_screen.dart';
import 'features/settings/settings_model.dart';
import 'features/users/users_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = context.select<SettingsModel, bool>((s) => s.dark);
    final signedIn = context.select<AuthModel, bool>((a) => a.signedIn);
    return MaterialApp(
      title: 'Users',
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      // No token -> the login screen. Sign in / sign out swaps it.
      home: signedIn ? const UsersScreen() : const LoginScreen(),
    );
  }
}
