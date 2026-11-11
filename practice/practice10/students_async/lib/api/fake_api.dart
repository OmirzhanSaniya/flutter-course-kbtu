import 'package:flutter/foundation.dart';

class Student {
  const Student({required this.name, required this.group, this.gpa});

  final String name;
  final String group;
  final double? gpa;
}

class NoConnectionException implements Exception {}

const _seed = [
  Student(name: 'Aida Nurlanova', group: 'IT-2301', gpa: 3.7),
  Student(name: 'Dias Seitkali', group: 'IT-2301', gpa: 3.1),
  Student(name: 'Aruzhan Bek', group: 'IT-2302'),
  Student(name: 'Timur Alibekov', group: 'IT-2302', gpa: 2.9),
  Student(name: 'Dana Omarova', group: 'IT-2303', gpa: 3.9),
  Student(name: 'Alikhan Kairatuly', group: 'IT-2303', gpa: 3.4),
];

// Level 1: the API that does not exist yet. It must feel like a
// network: slow, and sometimes down.
class FakeApi {
  FakeApi({this.empty = false});

  final bool empty; // true -> the server has no students
  int calls = 0; // how many times fetchStudents() ran

  // The save counter is static: it lives on the "server", not in one
  // screen. So the second save fails even after the screen was
  // closed and opened again (a new State gets a new FakeApi).
  static int _saves = 0;

  Future<List<Student>> fetchStudents() async {
    calls++;
    debugPrint('fetchStudents #$calls'); // the console counts requests
    // BREAK IT (Level 1): sleep(const Duration(seconds: 2)) from
    // dart:io here blocks the loop: no first frame for two seconds.
    await Future.delayed(const Duration(seconds: 2));
    if (calls % 3 == 0) {
      throw NoConnectionException();
    }
    return empty ? const [] : _seed;
  }

  // Level 5: waits one second, fails on every second call.
  Future<void> save(int value) async {
    _saves++;
    await Future.delayed(const Duration(seconds: 1));
    if (_saves % 2 == 0) {
      throw StateError('server rejected $value');
    }
  }
}
