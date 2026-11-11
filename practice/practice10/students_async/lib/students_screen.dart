import 'package:flutter/material.dart';

import 'api/fake_api.dart';
import 'widgets/empty_view.dart';
import 'widgets/error_view.dart';
import 'widgets/loading_view.dart';
import 'widgets/student_list.dart';

// Level 2: four states by hand. Level 5: the Save button.
class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Student>? _students; // null = not loaded yet
  Object? _error; // non-null = failed
  // Level 2 test: FakeApi(empty: true) shows the EmptyView.
  final _api = FakeApi();
  //final _api = FakeApi(empty: true);
  bool _saving = false; // Level 5: true while save() is in flight

  @override
  void initState() {
    super.initState();
    // initState is synchronous: we start the load and do NOT await it.
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _students = null;
      _error = null;
    });
    try {
      final list = await _api.fetchStudents();
      // The line after await runs later: the screen may be gone.
      // BREAK IT (Level 2): delete this guard -> setState() called after dispose()
      if (!mounted) return;
      setState(() => _students = list);
    } catch (e) {
      if (!mounted) return; // BREAK IT (Level 2): and this one
      setState(() => _error = e);
    }
  }

  // Level 5, the honest version: awaited, try / on, context.mounted
  // after the await, pop only on success.
  // `context` here is the one the button's callback hands in, so we
  // check context.mounted (the State's own check would be `mounted`).
  // The AI version (BREAK IT) was:
  //   onPressed: () { _api.save(n); Navigator.pop(context); }
  Future<void> _save(BuildContext context, int n) async {
    setState(() => _saving = true);
    try {
      await _api.save(n);
      if (!context.mounted) return;
      Navigator.pop(context);
    } on StateError catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final students = _students;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students (by hand)'),
        actions: [
          // Reload: lets you reach the 3rd call (the one that fails).
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      // The order matters: error first, then loading, then empty, then data.
      body: switch ((_error, students)) {
        (Object _, _) => ErrorView(onRetry: _load),
        (null, null) => const LoadingView(),
        (null, List<Student> list) when list.isEmpty => const EmptyView(),
        (null, List<Student> list) => StudentList(list),
      },
      floatingActionButton: FloatingActionButton(
        // null onPressed = the button is disabled.
        // Disabled while saving (two fast taps -> one request) and
        // while there is nothing loaded to save.
        onPressed: (_saving || students == null)
            ? null
            : () => _save(context, students.length),
        /*: () async {
                _api.save(students.length);
                Navigator.pop(context);
              },*/
        child: _saving
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save),
      ),
    );
  }
}
