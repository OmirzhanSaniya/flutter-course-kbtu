import 'package:flutter/material.dart';

import '../../../core/api/api_exception.dart';
import 'generic_error_view.dart';
import 'offline_view.dart';
import 'server_error_view.dart';

// The error view: one widget per kind of error.
// Exhaustive: ApiException is sealed, so no default.
// BREAK IT (Practice 11, Level 4): delete the BadResponseException() arm
// -> "The type 'ApiException' is not exhaustively matched".
class UsersErrorView extends StatelessWidget {
  const UsersErrorView(this.error, {super.key, required this.onRetry});

  final ApiException error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return switch (error) {
      NoConnectionException() => OfflineView(onRetry: onRetry),
      NotFoundException() ||
      UnauthorizedException() => const GenericErrorView(title: 'Not available'),
      ServerException(:final status) => ServerErrorView(
        status,
        onRetry: onRetry,
      ),
      BadResponseException() => const GenericErrorView(),
    };
  }
}
