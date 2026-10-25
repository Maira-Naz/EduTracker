// Change password form.
import 'package:flutter/material.dart';
import '../../core/core.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  @override
  State<ChangePasswordScreen> createState() => _ChangePwState();
}

class _ChangePwState extends State<ChangePasswordScreen> {
  final old = TextEditingController(), np = TextEditingController(), cp = TextEditingController();
  String? error;

  @override
  void dispose() {
    old.dispose();
    np.dispose();
    cp.dispose();
    super.dispose();
  }

  void _save() {
    if (old.text != '12345678') return setState(() => error = 'Current password is incorrect.');
    if (np.text.length < 8) return setState(() => error = 'Use at least 8 characters.');
    if (np.text != cp.text) return setState(() => error = 'Passwords do not match.');
    final m = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    m.showSnackBar(const SnackBar(content: Text('Password updated')));
  }

  @override
  Widget build(BuildContext context) => Screen(
        back: true,
        backLabel: 'Account',
        title: 'Change password',
        children: [
          const FieldLabel('Current password (demo: 12345678)'),
          TextField(controller: old, obscureText: true),
          const FieldLabel('New password'),
          TextField(controller: np, obscureText: true),
          const FieldLabel('Confirm new password'),
          TextField(controller: cp, obscureText: true),
          if (error != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(error!, style: const TextStyle(color: kRed, fontSize: 13))),
          const SizedBox(height: 20),
          FilledButton(onPressed: _save, child: const Text('Update password')),
        ],
      );
}
