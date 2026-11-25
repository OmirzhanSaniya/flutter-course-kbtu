# Practice 14 — NOTES

## Level 1 — identity and version

`applicationId = "kz.saniya.users"`, namespace the same (MainActivity moved to
`kotlin/kz/saniya/users/`). minSdk / targetSdk / versionCode / versionName come
from `flutter.*`, i.e. from pubspec.

`version: 1.0.0+1`:
- `1.0.0` = **versionName** — for **people** (the store page, the About screen).
  Semantic: major.minor.patch.
- `+1` = **versionCode / build number** — for the **store**. A whole number that
  **must go up on every upload**; the store refuses a build whose number it has
  already seen.

Now `1.0.1+2`. Break it: `versionCode = 1` hard-coded in Gradle + pubspec `+3` →
About still says `(1)` — the third upload would be rejected. Put back.

## Level 2 — the key

Keystore: `upload-keystore.jks`, alias `upload`, outside the project. Backup: flash drive.

`keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk`:
```
 & "D:\Android\Sdk\build-tools\36.0.0\apksigner.bat" verify --print-certs build\app\outputs\flutter-apk\app-release.apk
Signer #1 certificate DN: CN=Saniya Omirzhan, OU=KBTU, O=KBTU, L=Almaty, ST=Kazakhstan, C=kz
Signer #1 certificate SHA-256 digest: edf17261d4fdcd931158591f6421d912f77bece45bea10691d1880a4fe93c56c
Signer #1 certificate SHA-1 digest: cccee346203e36a636f3e6e66b467129fb94704f
Signer #1 certificate MD5 digest: 45da6d626990585f1313a7b33af21a64```

If I had committed the key and `key.properties`: a classmate could sign **their own
APK as my app** (same applicationId + same key = Android installs it as an update over
mine, with access to my app's data). **Play App Signing**: Google keeps the real app
signing key; mine is only the *upload* key — if it leaks, Google can reset it, so
the damage is limited.

Scrub a file from history:
1. `git filter-repo --invert-paths --path android/key.properties` (or the BFG)
2. `git push --force` — and change every password anyway: the old history may
   already be cloned.

## Level 3 — environments

Run / build commands — see README. `grep -rn fromEnvironment lib/` → only
`lib/core/env.dart`.

The developer host switch cannot be done with `fromEnvironment`: those values are
**constants compiled into the build**; a tester cannot change them without a new
build. A runtime choice must be stored (shared_preferences). It must never be
visible in a release build: a user could point the app at any server — a fake one
that collects their token. So it is behind `if (kDebugMode)`, and main() ignores the
saved value outside debug.

## Level 4

INTERNET removed on purpose → release build: the Offline view instantly and forever
(debug worked only because the debug manifest adds INTERNET). Put back.

## Level 5 — the release

| build | size |
|---|---|
| `app-arm64-v8a-release.apk` | 18.0 MB |
| `flutter build apk --debug` | 187.8 MB |
| `app-release.apk` | 53.6 MB |
| `app-release.aab` | 50.1 MB |

Without symbols a crash log from an obfuscated build shows frames like
`#0 abs 0x... virt 0x... _kDartIsolateSnapshotInstructions+0x...` — no file names,
no line numbers. Turn it back:
```
flutter symbolize -i crash.txt -d releases/1.0.1+2/symbols/app.android-arm64.symbols
```
