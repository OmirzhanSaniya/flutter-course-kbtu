import 'package:flutter/material.dart';

import '../api/fake_api.dart';

class StudentList extends StatelessWidget {
  const StudentList(this.students, {super.key, this.compact = false});

  final List<Student> students;
  final bool compact; // Level 3: dense tiles on/off

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, i) {
        final s = students[i];
        return ListTile(
          dense: compact,
          title: Text(s.name),
          subtitle: Text(s.group),
          // gpa is double? : null is shown as a dash
          trailing: Text(s.gpa?.toStringAsFixed(1) ?? '—'),
        );
      },
    );
  }
}
