# users_api

A Flutter client for jsonplaceholder.typicode.com (Practices 11–13): a repository
behind an interface with a 10-second timeout and a sealed `ApiException`, an
offline cache, settings in shared_preferences, a token in secure storage, a
profile photo with the full permission flow.

## Architecture
- `lib/features/<name>/` — screen, ChangeNotifier, repository, per feature
- `lib/core/api/` — ApiClient: Uri.https, 10 s timeout, sealed ApiException
- repositories behind `abstract interface class`; `FakeUserRepository` for tests and demo mode
- dependencies point down: screens → models → repositories → the world
- `main.dart` is the only composition root

## Quality checklist

```
$ flutter analyze
Analyzing users_api...
No issues found!

$ dart format lib test
Formatted 39 files (0 changed)

$ flutter test
00:02 +20: All tests passed!

$ bash tool/check_layers.sh
(nothing)
```
