// lib/core/env.dart — the only file that knows the variable names.
// The values are baked in at BUILD time:
//   flutter run --dart-define=USE_FAKES=true
//   flutter run --dart-define-from-file=env/local.json
abstract final class Env {
  static const host = String.fromEnvironment(
    'API_HOST',
    defaultValue: 'jsonplaceholder.typicode.com',
  );
  static const useFakes = bool.fromEnvironment('USE_FAKES');
  static const name = String.fromEnvironment('ENV', defaultValue: 'local');
}
