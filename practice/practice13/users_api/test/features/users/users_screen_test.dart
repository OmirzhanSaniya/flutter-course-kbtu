import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users_api/features/settings/settings_model.dart';
import 'package:users_api/features/users/users_model.dart';
import 'package:users_api/features/users/users_screen.dart';

import '../../fakes/fake_user_repository.dart';

Future<void> pumpScreen(WidgetTester tester, UsersModel model) {
  return tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: model),
        // UsersScreen also reads the city filter from SettingsModel.
        ChangeNotifierProvider(
          create: (_) => SettingsModel(_NoPrefs(), dark: false),
        ),
      ],
      child: const MaterialApp(home: UsersScreen()),
    ),
  );
}

void main() {
  testWidgets('shows the list', (tester) async {
    final model = UsersModel(FakeUserRepository());
    // the fake awaits a (zero) timer: run it on the real clock
    await tester.runAsync(model.load);
    await pumpScreen(tester, model);
    expect(find.text('Aida Nurlanova'), findsOneWidget);
    expect(find.text('Dias Seitkali'), findsOneWidget);
  });

  testWidgets('shows the offline view and Retry', (tester) async {
    final model = UsersModel(
      FakeUserRepository(fail: true, delay: const Duration(seconds: 1)),
    );
    await tester.runAsync(model.load); // arrange: a real 1 s wait
    await pumpScreen(tester, model);
    expect(find.text('No connection'), findsOneWidget);

    await tester.tap(find.text('Retry')); // act
    await tester.pump();

    // BREAK IT (Level 4): rename Retry to "Try again" in MessageView ->
    // Expected: exactly one matching candidate, Actual: zero.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(seconds: 1)); // let the fake finish
  });
}

// A stand-in that is never called in these tests.
class _NoPrefs implements SharedPreferencesAsync {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
