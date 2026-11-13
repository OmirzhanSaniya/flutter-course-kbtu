import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/api/api_exception.dart';
import 'user.dart';
import 'users_model.dart';

// Level 5: POST from the UI. Pop only on success.
class NewUserScreen extends StatefulWidget {
  const NewUserScreen({super.key});

  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  bool _saving = false; // Practice 10: disabled while in flight

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _email.dispose();
    super.dispose();
  }

  static String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  static String? _emailRule(String? v) {
    final text = v?.trim() ?? '';
    if (text.isEmpty) return 'Required';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text)) {
      return 'Not an email';
    }
    return null;
  }

  Future<void> _save(BuildContext context) async {
    // currentState! is the one allowed `!`: the key is attached to
    // the Form in build, so the state exists when Save is tapped.
    if (!_formKey.currentState!.validate()) return;
    final draft = User(
      id: 0, // the server assigns the real one
      name: _name.text.trim(),
      username: _username.text.trim(),
      email: _email.text.trim(),
      phone: '',
      address: const Address(
        street: '',
        suite: '',
        city: '',
        zipcode: '',
        geo: Geo(lat: 0, lng: 0),
      ),
      company: (name: '', catchPhrase: ''),
    );
    setState(() => _saving = true);
    try {
      await context.read<UsersModel>().create(draft);
      if (!context.mounted) return;
      Navigator.of(context).pop();
    } on ApiException catch (e) {
      if (!context.mounted) return;
      final text = switch (e) {
        NoConnectionException() => 'No connection',
        ServerException(:final status) => 'Server error ($status)',
        BadResponseException() => 'The server sent something we cannot read',
        NotFoundException() || UnauthorizedException() => 'Not allowed',
      };
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New user')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              textInputAction: TextInputAction.next,
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _username,
              decoration: const InputDecoration(labelText: 'Username'),
              textInputAction: TextInputAction.next,
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: _emailRule,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : () => _save(context),
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
