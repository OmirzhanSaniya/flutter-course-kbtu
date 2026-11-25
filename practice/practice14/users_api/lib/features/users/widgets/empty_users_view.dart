import 'package:flutter/material.dart';

// The empty state: a screen, not a spinner.
class EmptyUsersView extends StatelessWidget {
  const EmptyUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      // scrollable, so pull-to-refresh still works on an empty list
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        SizedBox(height: 120),
        Center(child: Text('No users here')),
      ],
    );
  }
}
