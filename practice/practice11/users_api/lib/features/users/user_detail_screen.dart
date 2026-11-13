import 'package:flutter/material.dart';

import 'user.dart';

// Shows everything. Phone and website are taps that do nothing yet
// (Practice 12 gives them url_launcher).
class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen(this.user, {super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    final a = user.address;
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Username'),
            subtitle: Text(user.username),
          ),
          ListTile(title: const Text('Email'), subtitle: Text(user.email)),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Phone'),
            subtitle: Text(user.phone),
            onTap: () {}, // Practice 12: tel:
          ),
          ListTile(
            leading: const Icon(Icons.public),
            title: const Text('Website'),
            subtitle: Text(user.website ?? '—'),
            onTap: () {}, // Practice 12: https://
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
        ],
      ),
    );
  }
}
