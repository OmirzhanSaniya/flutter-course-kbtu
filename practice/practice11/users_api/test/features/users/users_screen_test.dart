import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:users_api/core/api/api_client.dart';
import 'package:users_api/features/users/user_repository.dart';
import 'package:users_api/features/users/users_model.dart';
import 'package:users_api/features/users/users_screen.dart';

import 'user1_json.dart';

Future<UsersModel> pumpWith(WidgetTester tester, MockClientHandler h) async {
  final model = UsersModel(UserRepository(ApiClient(MockClient(h))));
  await model.load();
  await tester.pumpWidget(
    MaterialApp(
      home: ChangeNotifierProvider.value(
        value: model,
        child: const UsersScreen(),
      ),
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
