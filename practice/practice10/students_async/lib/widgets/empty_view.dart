import 'package:flutter/material.dart';

// An empty list is a screen of its own, not a spinner.
class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No students yet'));
  }
}
