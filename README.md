# Mobile Application Development with Flutter 1 — KBTU, 2026

Labs and practices for the course *Mobile Application Development with Flutter 1*.

## Main project: Users
`practice/practice14/users_api` — a Flutter app that lists users from a REST API,
works offline from a cache and keeps the login token in secure storage.

| ![list](docs/list.png) | ![offline](docs/offline.png) |
|---|---|

- provider + ChangeNotifier, repositories behind interfaces, sealed ApiException
- shared_preferences, flutter_secure_storage, file cache in Documents
- 20 unit/widget tests, signed release APK → see **Releases** (v1.0.1)

## Contents
| Folder | What |
|---|---|
| `labs/lab1_campus_events` | Lab 1 — Campus events |
| `practice/practice1` … `practice9` | Dart, widgets and layout, state, navigation, forms, state management |
| `practice/practice10` | Async: Future, FutureBuilder, Stream |
| `practice/practice11` … `practice14` | Users app: REST → storage → architecture → signed release |
