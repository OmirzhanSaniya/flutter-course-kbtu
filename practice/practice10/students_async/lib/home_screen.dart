import 'package:flutter/material.dart';

import 'routes.dart';

// Home: three ways in. Each button pushes its own screen (week 6).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('The data arrives later')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton(
              onPressed: () => Navigator.of(context).pushNamed(Routes.byHand),
              child: const Text('By hand'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => Navigator.of(context).pushNamed(Routes.future),
              child: const Text('FutureBuilder'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(Routes.countdown),
              child: const Text('Countdown'),
            ),
          ],
        ),
      ),
    );
  }
}
