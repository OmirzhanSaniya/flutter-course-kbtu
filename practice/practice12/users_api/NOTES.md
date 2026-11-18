# Practice 12 — NOTES

## Level 1 — six package verdicts (pub.dev, checked November 2026)

Order: publisher · last release · platforms · pub points · issues vs. commits · dependencies · licence.

- **shared_preferences** — verified publisher flutter.dev, 2.5.6 released October 2026, all six platforms, 160/160 points, lives in the flutter/packages monorepo with commits every week, depends only on its own platform implementations, BSD-3-Clause.
- **flutter_secure_storage** — verified publisher steenbakker.dev (a community maintainer, not Google), 11.2.0 released September 2026, all six platforms, 160/160, its own repo (mogol/flutter_secure_storage) with many open issues but active releases, depends on its platform packages and `meta`, BSD-3-Clause.
- **path_provider** — verified publisher flutter.dev, 2.1.6 released June 2026, five platforms (no web — there is no file system there), 160/160, flutter/packages monorepo, only its platform implementations, BSD-3-Clause.
- **image_picker** — verified publisher flutter.dev, 1.2.4 released October 2026, all six platforms, 160/160, flutter/packages monorepo, only its platform implementations, Apache-2.0 + BSD-3-Clause.
- **permission_handler** — verified publisher baseflow.com (a company), 13.0.2 released September 2026, Android, iOS, Windows and web, 160/160, its own repo with many open issues and regular releases, depends on its platform packages and `meta`, MIT.
- **url_launcher** — verified publisher flutter.dev, 6.3.3 released October 2026, all six platforms, 160/160, flutter/packages monorepo, only its platform implementations, BSD-3-Clause.

## Carets and the lock file

- `flutter pub add` wrote carets, e.g. `http: ^1.6.0`. `pubspec.lock` pins the exact
  version pub resolved for http: **1.6.0** 
- `^1.2.0` means `>=1.2.0 <2.0.0`: it accepts 1.2.1, 1.3.0, 1.9.9 and refuses
  1.1.x (too old) and 2.0.0 (a major version may break the API).
- `pubspec.lock` is committed for an **app**: every machine (mine, a classmate's, CI)
  builds with exactly the same versions. A package (a library) does not commit it.
- `flutter pub outdated`: `cupertino_icons` 1.0.9 → 2.0.0 is "resolvable" but not
  upgraded, because `^1.0.8` refuses a new major version. 
- Break it: `http: 1.2.0` (no caret) + `flutter pub get` → the lock pins exactly 1.2.0
  and `pub outdated` shows every newer version as unavailable. Caret put back.

## Level 3 — where a token must not go

`prefs.setString('token', …)` would put the token into a plain file in the app's folder:
an XML file on Android (`shared_prefs/…xml`), a plist on iOS. Who can read it: a device
backup, anyone with root, a cable + adb on a debuggable build.

Platform surprises:
- **iOS:** Keychain items can survive an uninstall — reinstall the app and the old
  token may still be there.
- **Android:** the Keystore key can be invalidated when the lock screen is removed or
  changed — the saved value can no longer be decrypted, reads fail / return nothing.

Proof the header exists: DevTools → Network → the request to /users → Request headers →
`Authorization: Bearer tok_…`. 

## Level 5 — permissions

Android emulator: Take photo → Don't allow → Take photo → Don't allow → the third tap:
no system dialog, my own dialog at once, "Open settings" opens the app's permission page.
(Android 11+: two No's = permanently denied.)

iOS: **one** No and the system never asks again (`permanentlyDenied` after the first
denial; only Settings can change it). The fourth Photos state is **limited** — the user
allowed only some selected photos.

Break it: `launchUrl(Uri.parse('kbtu.edu.kz'))` without a scheme → `false`, nothing
opens; `https://kbtu.edu.kz` → the browser opens.

Screenshots: `screenshot_offline_banner.png`, `screenshot_permission_dialog.png`.

