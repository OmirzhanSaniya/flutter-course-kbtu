import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_model.dart';

// Debug only (the caller wraps it in `if (kDebugMode)`): copies the
// token so you can prove the header exists — without printing it.
class CopyTokenTile extends StatelessWidget {
  const CopyTokenTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.key),
      title: const Text('Copy token to clipboard'),
      onTap: () async {
        final token = context.read<AuthModel>().token ?? '';
        await Clipboard.setData(ClipboardData(text: token));
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Token copied')));
      },
    );
  }
}
