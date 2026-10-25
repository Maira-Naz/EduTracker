// Forgot password: enter ID, then code + new password.
import 'package:flutter/material.dart';
import '../../core/core.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});
  @override
  State<ForgotScreen> createState() => _ForgotState();
}

class _ForgotState extends State<ForgotScreen> {
  final id = TextEditingController(), code = TextEditingController(), np = TextEditingController(), cp = TextEditingController();
  int step = 0;
  String? error;

  @override
  void dispose() {
    for (final c in [id, code, np, cp]) {
      c.dispose();
    }
    super.dispose();
  }

  void _send() {
    if (id.text.trim().isEmpty) return setState(() => error = 'Enter your ID first.');
    setState(() {
      step = 1;
      error = null;
    });
  }

  void _reset() {
    if (code.text != '123456') return setState(() => error = 'That code is not right.');
    if (np.text.length < 8) return setState(() => error = 'Use at least 8 characters.');
    if (np.text != cp.text) return setState(() => error = 'Passwords do not match.');
    final m = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    m.showSnackBar(const SnackBar(content: Text('Password updated. Please sign in.')));
  }

  @override
  Widget build(BuildContext context) => Screen(
        back: true,
        backLabel: 'Sign in',
        title: 'Reset your password',
        children: [
          const SizedBox(height: 8),
          Text(step == 0 ? 'Enter your ID. We will send a 6-digit code to the phone registered with your account.' : 'Enter the code we sent and choose a new password.', style: kMut),
          if (step == 0) ...[
            const FieldLabel('Student, staff or admin ID'),
            TextField(controller: id),
          ] else ...[
            const FieldLabel('6-digit code (demo: 123456)'),
            TextField(controller: code, keyboardType: TextInputType.number, maxLength: 6, decoration: const InputDecoration(counterText: '')),
            const FieldLabel('New password'),
            TextField(controller: np, obscureText: true),
            const FieldLabel('Confirm new password'),
            TextField(controller: cp, obscureText: true),
          ],
          if (error != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(error!, style: const TextStyle(color: kRed, fontSize: 13))),
          const SizedBox(height: 20),
          FilledButton(onPressed: step == 0 ? _send : _reset, child: Text(step == 0 ? 'Send reset code' : 'Update password')),
          if (step == 0) AppCard(child: const Text('Code not arriving? Contact your department office to update your registered phone number.', style: kMut)),
        ],
      );
}
