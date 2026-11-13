import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/api/api_client.dart';
import 'features/users/user_repository.dart';
import 'features/users/users_model.dart';

import 'package:flutter/foundation.dart';
import 'core/api/api_exception.dart';

/*Future<void> main() async {
  final repo = UserRepository(ApiClient.real());
  final all = await repo.getAll();
  debugPrint(all.map((u) => u.name).join(', ')); // 10 имён
  try {
    await repo.getById(999);
  } on NotFoundException {
    debugPrint('not found');
  }
  final created = await repo.create(all.first);
  debugPrint('created id ${created.id}'); // 11
}*/

/*import 'dart:convert';
import 'features/users/user.dart';

void main() {
  const raw = r'''
  { 
  "id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz",
  "address": {
    "street": "Kulas Light",
    "suite": "Apt. 556",
    "city": "Gwenborough",
    "zipcode": "92998-3874",
    "geo": {
      "lat": "-37.3159",
      "lng": "81.1496"
    }
  },
  "phone": "1-770-736-8031 x56442",
  "website": "hildegard.org",
  "company": {
    "name": "Romaguera-Crona",
    "catchPhrase": "Multi-layered client-server neural-net",
    "bs": "harness real-time e-markets"
  }
}''';
  final user = User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  debugPrint('$user'); // User(#1 Leanne Graham, Gwenborough)
}*/

// The composition root: the one place where the chain is built:
// ApiClient (the wire) -> UserRepository -> UsersModel -> screens.
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UsersModel(UserRepository(ApiClient.real()))..load(),
      child: const App(),
    ),
  );
}
