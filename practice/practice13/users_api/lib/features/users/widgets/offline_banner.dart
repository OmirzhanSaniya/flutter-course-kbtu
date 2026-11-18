import 'package:flutter/material.dart';

// Shown above the list only when the list came from the cache.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: colors.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: [
            Icon(Icons.cloud_off, color: colors.onTertiaryContainer),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Saved data · no connection',
                style: TextStyle(color: colors.onTertiaryContainer),
              ),
            ),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
