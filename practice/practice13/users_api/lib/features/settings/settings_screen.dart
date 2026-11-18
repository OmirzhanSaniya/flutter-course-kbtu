import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth_model.dart';
import '../profile/profile_screen.dart';
import '../users/users_model.dart';
import 'settings_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsModel>();
    // Cities from the loaded users, sorted, without blanks.
    final cities = {
      for (final u in context.watch<UsersModel>().items)
        if (u.address.city.isNotEmpty) u.address.city,
    }.toList()..sort();
    // A saved city that is not in the list (yet) must not crash the
    // dropdown, so it shows "All cities" until the users are loaded.
    final current = cities.contains(settings.city) ? settings.city : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark mode'),
            value: settings.dark,
            onChanged: (v) => context.read<SettingsModel>().setDark(v),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String?>(
              key: ValueKey(current), // rebuild when the value changes
              initialValue: current,
              decoration: const InputDecoration(labelText: 'City filter'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All cities')),
                for (final c in cities)
                  DropdownMenuItem(value: c, child: Text(c)),
              ],
              onChanged: (c) => context.read<SettingsModel>().setCity(c),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Profile photo'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign out'),
            onTap: () async {
              await context.read<AuthModel>().logout();
              if (!context.mounted) return;
              // back to the first route, which is now the login screen
              Navigator.of(context).popUntil((r) => r.isFirst);
            },
          ),
        ],
      ),
    );
  }
}
