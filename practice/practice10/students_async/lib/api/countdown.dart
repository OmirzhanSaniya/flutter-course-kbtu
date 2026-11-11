import 'package:flutter/foundation.dart';

// Level 4: a stream that counts down once per second.
// async* = a function that returns values one by one (a Stream).
// yield = "give out the next value".
Stream<int> countdown(int from) async* {
  for (var i = from; i >= 0; i--) {
    await Future.delayed(const Duration(seconds: 1));
    yield i;
    debugPrint('tick $i'); // the console shows whether anyone still listens
  }
}
