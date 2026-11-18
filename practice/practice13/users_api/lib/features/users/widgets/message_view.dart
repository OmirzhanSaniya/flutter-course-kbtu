import 'package:flutter/material.dart';

// One layout for every "something went wrong" screen:
// an icon, a title, an optional line, an optional Retry.
class MessageView extends StatelessWidget {
  const MessageView({
    super.key,
    required this.icon,
    required this.title,
    this.detail,
    this.onRetry,
  });

  final IconData icon;
  final String title;
  final String? detail;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final detail = this.detail;
    final onRetry = this.onRetry;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text(title, style: theme.textTheme.titleMedium),
            if (detail != null) ...[
              const SizedBox(height: 8),
              Text(detail, textAlign: TextAlign.center),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
