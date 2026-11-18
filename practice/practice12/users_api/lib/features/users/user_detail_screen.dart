import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../auth/auth_model.dart';
import 'user.dart';

// Shows everything. Email, phone and website open other apps.
class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen(this.user, {super.key});

  final User user;

  // launchUrl answers with a bool: false = no app can open this.
  Future<void> _open(BuildContext context, Uri uri) async {
    final ok = await launchUrl(uri);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No app can open this')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = user.address;
    final website = user.website;
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Username'),
            subtitle: Text(user.username),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email'),
            subtitle: Text(user.email),
            onTap: () =>
                _open(context, Uri(scheme: 'mailto', path: user.email)),
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone'),
            subtitle: Text(user.phone),
            onTap: () =>
                _open(context, Uri(scheme: 'tel', path: user.phoneDigits)),
          ),
          ListTile(
            leading: const Icon(Icons.public),
            title: const Text('Website'),
            subtitle: Text(website ?? '—'),
            // BREAK IT (Level 5): Uri.parse(website) without https:// ->
            // launchUrl returns false, nothing opens.
            onTap: website == null
                ? null
                : () => _open(context, Uri.parse('https://$website')),
          ),
          ListTile(
            title: const Text('Address'),
            subtitle: Text('${a.street}, ${a.suite}\n${a.city} ${a.zipcode}'),
            isThreeLine: true,
          ),
          ListTile(
            title: const Text('Geo'),
            subtitle: Text('${a.geo.lat}, ${a.geo.lng}'),
          ),
          ListTile(
            title: const Text('Company'),
            subtitle: Text('${user.company.name}\n${user.company.catchPhrase}'),
            isThreeLine: true,
          ),
          // Debug only: proves the token exists without logging it.
          if (kDebugMode)
            ListTile(
              leading: const Icon(Icons.key),
              title: const Text('Copy token to clipboard'),
              onTap: () async {
                final token = context.read<AuthModel>().token ?? '';
                await Clipboard.setData(ClipboardData(text: token));
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Token copied')));
              },
            ),
        ],
      ),
    );
  }
}
