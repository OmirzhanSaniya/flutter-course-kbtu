import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/env.dart';
import '../settings_model.dart';

// Developer-only (the caller wraps it in `if (kDebugMode)`): pick an API
// host at runtime. Env (dart-define) cannot do this — it is baked in at
// build time — and a release user must never see it.
class DevHostTile extends StatelessWidget {
  const DevHostTile({super.key});

  Future<void> _edit(BuildContext context) async {
    final settings = context.read<SettingsModel>();
    final controller = TextEditingController(
      text: settings.devHost ?? Env.host,
    );
    final host = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('API host'),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(''),
            child: const Text('Reset'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (host == null) return; // Cancel / tapped outside
    await settings.setDevHost(host.isEmpty ? null : host);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Restart the app to use the new host')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final devHost = context.select<SettingsModel, String?>((s) => s.devHost);
    return ListTile(
      leading: const Icon(Icons.developer_mode),
      title: const Text('Developer: API host'),
      subtitle: Text(devHost ?? '${Env.host} (default)'),
      onTap: () => _edit(context),
    );
  }
}
