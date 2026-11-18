# Practice 13 — NOTES

## Level 1 — the tree and the layer rule

The project was feature-first from Practice 11 (`lib/core/`, `lib/features/<name>/`),
so this week's moves were: `UserTile`, `CityFilterBar`, `EmptyUsersView`,
`UsersErrorView`, `CopyTokenTile` into `widgets/`; the fake into its own file.
`tool/check_layers.sh` prints nothing.
Break it: `import 'package:http/http.dart' as http;` in users_screen.dart → it
compiles, the app runs, the script prints `lib/features/users/users_screen.dart`.
The compiler has no opinion about layers — the script does.

## Level 2 — interfaces and fakes

`grep -rn "HttpUserRepository(" lib/` → two lines: the call in `main.dart` and the
constructor declaration in `user_repository.dart` (the declaration is not a
construction; the only place that *builds* one is main.dart).

Why the old model could not be tested: when `UsersModel` built its own repository
inside, **the first line I could not write was the arrange step** — there was no
way to give the model a repository that fails, so "NoConnection sets error" needed
a real broken network.

## Level 4 — why widgets, not `_buildX()` methods

A widget can be `const` (Flutter skips rebuilding it), has its own rebuild scope
(its `build` runs alone), shows up by name in DevTools, and can be pumped in a
test by itself. A `_buildHeader()` method is just part of its parent's `build`.

## Level 5 — the trace, annotated

Planted: `'lat': 43.2567` (a number) for user 1 in `FakeUserRepository`.

```
type 'double' is not a subtype of type 'String' in type cast      <- 1. the message
#0      new Geo.fromJson (package:users_api/features/users/user.dart:14:35)   <- 2. my first frame: line 14, column 35
#1      new Address.fromJson (package:users_api/features/users/user.dart:44:14)
#2      new User.fromJson (package:users_api/features/users/user.dart:91:24)
#3      FakeUserRepository._users (package:users_api/features/users/fake_user_repository.dart:55:55)
#4      FakeUserRepository.getAll (package:users_api/features/users/fake_user_repository.dart:60:20)
<asynchronous suspension>
#5      UsersModel.load (package:users_api/features/users/users_model.dart:23:22)  <- 3. the path down to load()
<asynchronous suspension>
```

The data that went in: field `address.geo.lat` of user 1 (Aida Nurlanova) was a
number, the model expects a String.

**#0 is the right place to throw and the wrong place to fix:** `Geo.fromJson` is
where the broken contract becomes visible, but the server's mistake must not crash
the app — so the repository catches the `TypeError` and throws
`BadResponseException`, and the screen shows the generic error.
Tests: `user_test.dart` (Geo.fromJson throws TypeError) and
`user_repository_test.dart` (lat as a number → BadResponseException).
