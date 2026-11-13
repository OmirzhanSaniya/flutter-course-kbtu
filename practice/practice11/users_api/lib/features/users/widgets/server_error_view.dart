import 'package:flutter/material.dart';

import 'message_view.dart';

// ServerException: 5xx — their problem, Retry may help.
class ServerErrorView extends StatelessWidget {
  const ServerErrorView(this.status, {super.key, required this.onRetry});

  final int status;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MessageView(
      icon: Icons.dns,
      title: 'Server error ($status)',
      detail: 'The server is having trouble. Try again later.',
      onRetry: onRetry,
    );
  }
}
