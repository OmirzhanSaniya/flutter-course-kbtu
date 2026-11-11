import 'package:flutter/material.dart';

import 'countdown_screen.dart';
import 'home_screen.dart';
import 'routes.dart';
import 'students_future_screen.dart';
import 'students_screen.dart';

//import 'api/fake_api.dart';

void main() {
  runApp(const MyApp());
}
/*void main() {
  print('A');
  Future.delayed(const Duration(seconds: 2), () => print('B'));
  print('C');
  final api = FakeApi();
  api.fetchStudents().then((l) => print('${l.length} students'));
  api.fetchStudents().then((l) => print('${l.length} students'));
  api.fetchStudents().then((l) => print('${l.length} students'));
  runApp(const MyApp());
}*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Students async',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      initialRoute: Routes.home,
      routes: {
        Routes.home: (_) => const HomeScreen(),
        Routes.byHand: (_) => const StudentsScreen(),
        Routes.future: (_) => const StudentsFutureScreen(),
        Routes.countdown: (_) => const CountdownScreen(),
      },
    );
  }
}
