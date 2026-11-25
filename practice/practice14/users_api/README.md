# Users — a Flutter REST client

A Flutter client for jsonplaceholder.typicode.com: a list of users with an offline
cache, a fake login with the token in secure storage, settings that survive a
restart, and a profile photo with the full permission flow.

## Run it

```
flutter pub get
flutter run                                            # defaults: public host, ENV=local
flutter run --dart-define=USE_FAKES=true               # no network needed (two fake users)
flutter run --dart-define-from-file=env/local.json     # the local environment
flutter build apk --release --dart-define-from-file=env/prod.json
```

Release (arm64, obfuscated, symbols archived separately):
```
flutter build apk --release --split-per-abi --obfuscate --split-debug-info=build/symbols --dart-define-from-file=env/prod.json
```

## Architecture
- `lib/features/<name>/` — screen, ChangeNotifier, repository, per feature
- `lib/core/api/` — ApiClient: Uri.https, 10 s timeout, sealed ApiException
- repositories behind `abstract interface class`; `FakeUserRepository` for tests and demo mode
- `lib/core/env.dart` — the only file that reads `--dart-define`
- `main.dart` is the only composition root

## Pre-release checklist

> TODO: compare the wording with the lecture's fourteen boxes and adjust.

- [x] 1. applicationId is mine and reverse-domain — `kz.saniya.users`
- [x] 2. version bumped, build number went up — `1.0.1+2`
- [x] 3. versionCode / versionName come from pubspec — `flutter.versionCode`
- [x] 4. signed with my upload key — `keytool -printcert` (NOTES.md)
- [x] 5. keystore and key.properties never committed — `git log --all --diff-filter=A`
- [x] 6. INTERNET in the main manifest — `AndroidManifest.xml`
- [x] 7. release host from env/prod.json — About shows `prod`
- [x] 8. no developer switches in release — `kDebugMode`
- [x] 9. own icon, adaptive on Android — `flutter_launcher_icons`
- [x] 10. own splash, Android 12 included — `flutter_native_splash`
- [x] 11. app name "Users" — `android:label`, `CFBundleDisplayName`
- [x] 12. obfuscated, symbols archived next to the APK — `releases/1.0.1+2/`
- [x] 13. tested on a real phone from the file, over mobile data — `screenshot_about_release.png`
- [x] 14. analyze 0, format clean, tests green, layer grep empty — output below

## Quality checklist

```
$ flutter analyze
No issues found!

$ dart format lib test
Formatted 42 files (0 changed)

$ flutter test
00:01 +20: All tests passed!

$ bash tool/check_layers.sh
(nothing)
```
