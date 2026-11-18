import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users_api/features/settings/settings_model.dart';
import 'package:users_api/features/users/users_model.dart';
import 'package:users_api/features/users/users_screen.dart';

import 'test_helpers.dart';
import 'user1_json.dart';

Future<UsersModel> pumpWith(WidgetTester tester, MockClientHandler h) async {
  final model = UsersModel(repoWith(h));
  await tester.runAsync(model.load); // real file I/O for the cache
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: model),
        // settings are only read by the screen; prefs are never touched
        ChangeNotifierProvider(
          create: (_) => SettingsModel(_NoPrefs(), dark: false),
        ),
      ],
      child: const MaterialApp(home: UsersScreen()),
    ),
  );
  return model;
}

void main() {
  testWidgets('shows the list', (tester) async {
    await pumpWith(tester, (_) async => http.Response('[$user1Json]', 200));
    expect(find.text('Leanne Graham'), findsOneWidget);
  });

  testWidgets('offline view with Retry', (tester) async {
    await pumpWith(tester, (_) async => throw const SocketException('down'));
    expect(find.text('No connection'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}

// A stand-in that is never called in these tests.
class _NoPrefs implements SharedPreferencesAsync {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
