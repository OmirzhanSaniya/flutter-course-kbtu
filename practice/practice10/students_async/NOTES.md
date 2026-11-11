# Practice 10 — NOTES

> Fill the lines marked TODO from YOUR console. The "expected" lines are
> what should happen; replace them with what you actually saw.

## Level 1 — the order of events

Experiment in `main()` (before `runApp`, deleted afterwards):

```dart
print('A');
Future.delayed(const Duration(seconds: 2), () => print('B'));
print('C');
final api = FakeApi();
api.fetchStudents().then((l) => print('${l.length} students'));
```

**Predicted order:** A, C, fetchStudents #1, (first frame of the app), then
after ~2 s: B, 6 students.

**Actual order:**
I/flutter ( 6279): A;
I/flutter ( 6279): C;
I/flutter ( 6279): fetchStudents #1;
I/flutter ( 6279): B;
I/flutter ( 6279): 6 students;

Why: `main()` runs to the end without waiting. The timer and the Future
are only *registered*; the event loop draws the first frame and later
delivers the two callbacks as events. B comes before "6 students"
because its timer was registered first.

With three `fetchStudents()` calls in a row the third one prints:

```
E/flutter ( 6279): [ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: Instance of 'NoConnectionException'
```

and the app keeps running — nobody awaited that Future, so the error was
only printed (Level 5 is about this).

With `sleep(const Duration(seconds: 2))` instead of
`await Future.delayed(...)`: no first frame for two seconds — the loop
is blocked, not waiting.

## Level 2 — setState after dispose

Without the two `if (!mounted) return;` lines, Back within two seconds:

``` Unhandled Exception: setState() called after dispose(): _StudentsScreenState#9fb00(lifecycle state: defunct, not mounted)```

## Level 3 — FutureBuilder

- Future in a field: ten Switch flips -> the console shows only
  `fetchStudents #1`, no spinner.
- `future: _api.fetchStudents()` inline: a spinner on every flip,
  `#2 #3 #4 …`, every third one fails.
- `hasData` checked before `hasError` with a failing server: spinner
  forever.

## Level 4 — countdown

- **Version B without `_sub.cancel()`**, Back at 7: TODO — expected:
  `[ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: setState() called after dispose(): _VersionBState#8e6c5(lifecycle state: defunct, not mounted)` once per
  second, and `tick 6 … tick 0` keep printing with nobody on screen. That
  is the leak.
- **Version B with `cancel()`**: the console stops at `tick 7`.
- **Version A** (no `cancel` anywhere in my code), Back at 7: the console
  stops. StreamBuilder cancelled the subscription for me.

## Level 5 — the error that vanished

AI version `onPressed: () { _api.save(n); Navigator.pop(context); }`,
second Save:

```
E/flutter ( 6279): [ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: Bad state: server rejected 6
```

**The user saw a success.** The screen closed as if the save worked,
while the server said no.

Note: `unawaited_futures` only checks `async` functions. The lint flags
the line when the callback is written `() async { _api.save(n); ... }`.

## Where does the state live?

| Thing | Where |
|---|---|
| `_students`, `_error` (by hand) | State of `StudentsScreen` |
| `_future` (FutureBuilder) | State field, created once in `initState`, replaced only in `_retry` |
| `_compact` (Switch) | ephemeral, local State |
| `_sub` (countdown B) | State field, cancelled in `dispose` |
| `_saving` | ephemeral, local State |
