import 'package:flutter/material.dart';

import 'message_view.dart';

// NoConnectionException: airplane mode, a bad host, a timeout.
class OfflineView extends StatelessWidget {
  const OfflineView({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MessageView(
      icon: Icons.wifi_off,
      title: 'No connection',
      detail: 'Check the internet and try again.',
      onRetry: onRetry,
    );
  }
}
