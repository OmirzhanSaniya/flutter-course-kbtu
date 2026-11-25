import 'package:flutter/material.dart';

import '../user.dart';
import '../user_detail_screen.dart';

class UserTile extends StatelessWidget {
  const UserTile(this.user, {super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text('${user.email} · ${user.address.city}'),
      onTap: () => Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => UserDetailScreen(user))),
    );
  }
}
