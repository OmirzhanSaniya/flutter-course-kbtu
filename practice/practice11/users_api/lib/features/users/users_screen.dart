import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_exception.dart';
import 'new_user_screen.dart';
import 'users_model.dart';
import 'widgets/generic_error_view.dart';
import 'widgets/loading_view.dart';
import 'widgets/offline_view.dart';
import 'widgets/server_error_view.dart';
import 'widgets/user_list.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final m = context.watch<UsersModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: m.loading
          ? const LoadingView()
          // Exhaustive: ApiException is sealed, so no default.
          // BREAK IT (Level 4): delete the BadResponseException() arm ->
          // "The type 'ApiException?' is not exhaustively matched".
          : switch (m.error) {
              null => RefreshIndicator(
                onRefresh: m.load,
                child: UserList(m.items),
              ),
              NoConnectionException() => OfflineView(onRetry: m.load),
              NotFoundException() || UnauthorizedException() =>
                const GenericErrorView(title: 'Not available'),
              ServerException(:final status) => ServerErrorView(
                status,
                onRetry: m.load,
              ),
              BadResponseException() => const GenericErrorView(),
            },
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
