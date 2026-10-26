// Change password form.
import 'package:flutter/material.dart';
import '../../core/core.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordScreen> {
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
    if (old.text != Store.demoPassword) return setState(() => error = 'Current password is incorrect.');
    if (np.text.length < 8) return setState(() => error = 'Use at least 8 characters.');
    if (np.text != cp.text) return setState(() => error = 'Passwords do not match.');
    Store.demoPassword = np.text; // demo: replace with your API call
    final m = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    m.showSnackBar(const SnackBar(content: Text('Password updated')));
  }

  @override
  Widget build(BuildContext context) => Screen(
        backLabel: 'Account',
        title: 'Change password',
        titleSize: 32,
        gap: 16,
        children: [
          AppField('Current password', old, obscure: true),
          AppField('New password', np, obscure: true),
          AppField('Confirm new password', cp, obscure: true),
          if (error != null) Text(error!, style: const TextStyle(color: kRed, fontSize: 13, fontWeight: FontWeight.w600)),
          PButton('Update password', _save),
        ],
      );
}
