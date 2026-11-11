import 'package:flutter/material.dart';

import 'api/fake_api.dart';
import 'widgets/empty_view.dart';
import 'widgets/error_view.dart';
import 'widgets/loading_view.dart';
import 'widgets/student_list.dart';

// Level 3: the same screen with FutureBuilder, done right.
class StudentsFutureScreen extends StatefulWidget {
  const StudentsFutureScreen({super.key});

  @override
  State<StudentsFutureScreen> createState() => _StudentsFutureScreenState();
}

class _StudentsFutureScreenState extends State<StudentsFutureScreen> {
  final _api = FakeApi();

  // late but NOT final: _retry() is the one place that is allowed to
  // put a new Future here. Everywhere else the field is only read.
  late Future<List<Student>> _future;

  bool _compact = false; // the Switch in the AppBar

  @override
  void initState() {
    super.initState();
    _future = _api.fetchStudents(); // created once, stored in a field
  }

  void _retry() {
    setState(() => _future = _api.fetchStudents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students (FutureBuilder)'),
        actions: [
          Switch(
            value: _compact,
            onChanged: (v) => setState(() => _compact = v),
          ),
        ],
      ),
      body: FutureBuilder<List<Student>>(
        // The field, never a call.
        // BREAK IT (Level 3): future: _api.fetchStudents(),
        future: _future,
        builder: (context, snapshot) {
          // 1. error first (otherwise a failed Future = spinner forever)
          if (snapshot.hasError) {
            return ErrorView(onRetry: _retry);
          }
          // 2. not finished yet
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView();
          }
          // 3. finished: data, maybe empty
          final list = snapshot.data ?? const <Student>[];
          if (list.isEmpty) {
            return const EmptyView();
          }
          // 4. the list
          return StudentList(list, compact: _compact);
        },
      ),
    );
  }
}
