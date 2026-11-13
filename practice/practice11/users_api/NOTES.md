# Practice 11 — NOTES

## Level 1 — Postman first

`GET https://jsonplaceholder.typicode.com/users` → **200**,
`Content-Type: application/json; charset=utf-8`, a JSON **array of 10 users**.
`GET …/users/1` → 200, one JSON object.

### User (top level)

| field | JSON type | Dart type | nullable? |
|---|---|---|---|
| id | number (int) | int | no |
| name | string | String | no |
| username | string | String | no |
| email | string | String | no |
| address | object | Address | no |
| phone | string | String | no |
| website | string | String? | yes — the one field we treat as optional |
| company | object | ({String name, String catchPhrase}) | no |

### address (nested once) — `address.geo` is nested twice

| field | JSON type | Dart type | nullable? |
|---|---|---|---|
| street | string | String | no |
| suite | string | String | no |
| city | string | String | no |
| zipcode | string | String | no |
| geo | object | Geo | no |
| geo.lat | **string** ("-37.3159") | double (double.parse) | no |
| geo.lng | **string** ("81.1496") | double (double.parse) | no |

### company (nested once)

| field | JSON type | Dart type | nullable? |
|---|---|---|---|
| name | string | String | no |
| catchPhrase | string | String | no |
| bs | string | — (not used) | no |

### Statuses

- `GET …/users/999` → **404 Not Found**, body `{}` (an empty object).
- `POST …/users` with `Content-Type: application/json` and a JSON body →
  **201 Created**; the body is what I sent **plus `"id": 11`**.
- `GET …/users?id=3` → 200, **a list of one** `[ { … } ]`, not an object.

## Level 3 — grep

`grep -rn "package:http" lib/` → only `lib/core/api/api_client.dart`.
The repository gets decoded JSON from ApiClient, so it does not import
http at all; `http.Client()` is created by `ApiClient.real()` and called
from main.dart.

## Level 5 — two kinds of "no network"

| test | what I saw | time                |
|---|---|---------------------|
| Airplane mode, pull to refresh | Offline view | ≈ under 1 s         |
| Hotspot without internet | Offline view | ≈ 14 s, the timeout |

DevTools → Network: `screenshot_timeout.png` (no status, ~149.2 ms),
`screenshot_200.png` (200 with the body).
