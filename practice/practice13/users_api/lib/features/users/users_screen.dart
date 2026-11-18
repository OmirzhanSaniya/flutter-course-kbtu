import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../settings/settings_model.dart';
import '../settings/settings_screen.dart';
import 'new_user_screen.dart';
import 'users_model.dart';
import 'widgets/city_filter_bar.dart';
import 'widgets/empty_users_view.dart';
import 'widgets/loading_view.dart';
import 'widgets/offline_banner.dart';
import 'widgets/user_list.dart';
import 'widgets/users_error_view.dart';

// Practice 13: build() is short — every part is its own widget.
class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.watch<UsersModel>();
    final city = context.select<SettingsModel, String?>((s) => s.city);
    final shown = city == null
        ? m.items
        : m.items.where((u) => u.address.city == city).toList();
    final error = m.error;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: m.loading
          ? const LoadingView()
          : error != null
          ? UsersErrorView(error, onRetry: m.load)
          : Column(
              children: [
                if (m.fromCache) OfflineBanner(onRetry: m.load),
                if (city != null)
                  CityFilterBar(
                    city: city,
                    onClear: () => context.read<SettingsModel>().setCity(null),
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: m.load,
                    child: shown.isEmpty
                        ? const EmptyUsersView()
                        : UserList(shown),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const NewUserScreen())),
        icon: const Icon(Icons.person_add),
        label: const Text('New user'),
      ),
    );
  }
}
