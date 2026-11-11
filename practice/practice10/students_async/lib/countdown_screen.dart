import 'dart:async';

import 'package:flutter/material.dart';

import 'api/countdown.dart';

enum _Version { a, b }

// Level 4: a countdown, two ways, on one screen.
class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  _Version _version = _Version.a;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Countdown')),
      body: Column(
        children: [
          const SizedBox(height: 16),
          SegmentedButton<_Version>(
            segments: const [
              ButtonSegment(value: _Version.a, label: Text('A: StreamBuilder')),
              ButtonSegment(value: _Version.b, label: Text('B: listen')),
            ],
            selected: {_version},
            onSelectionChanged: (s) => setState(() => _version = s.first),
          ),
          Expanded(
            // Switching the segment removes the other version from the
            // tree, so its dispose() runs and it starts again from 10.
            child: Center(
              child: switch (_version) {
                _Version.a => const _VersionA(),
                _Version.b => const _VersionB(),
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Version A: StreamBuilder subscribes and cancels for us.
class _VersionA extends StatefulWidget {
  const _VersionA();

  @override
  State<_VersionA> createState() => _VersionAState();
}

class _VersionAState extends State<_VersionA> {
  late final Stream<int> _stream = countdown(10); // a field, not in build

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _stream,
      builder: (context, snapshot) => Text(
        '${snapshot.data ?? 10}',
        style: Theme.of(context).textTheme.displayLarge,
      ),
    );
  }
}

// Version B: we subscribe by hand, so we must cancel by hand.
class _VersionB extends StatefulWidget {
  const _VersionB();

  @override
  State<_VersionB> createState() => _VersionBState();
}

class _VersionBState extends State<_VersionB> {
  int _left = 10;
  late StreamSubscription<int> _sub;

  @override
  void initState() {
    super.initState();
    _sub = countdown(10).listen((i) => setState(() => _left = i));
  }

  @override
  void dispose() {
    // BREAK IT (Level 4): comment this out -> ticks go on with nobody
    // on screen, and setState() called after dispose().
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('$_left', style: Theme.of(context).textTheme.displayLarge);
  }
}
