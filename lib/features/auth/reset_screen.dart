// Reset password: enter ID, then code + new password.
import 'package:flutter/material.dart';
import '../../core/core.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({super.key});
  @override
  State<ResetScreen> createState() => _ResetState();
}

class _ResetState extends State<ResetScreen> {
  final id = TextEditingController(text: 'T-1042'), code = TextEditingController(), np = TextEditingController(), cp = TextEditingController();
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
    if (code.text.replaceAll(' ', '') != '123456') return setState(() => error = 'That code is not right. (Demo code: 123456)');
    if (np.text.length < 8) return setState(() => error = 'Use at least 8 characters.');
    if (np.text != cp.text) return setState(() => error = 'Passwords do not match.');
    Store.demoPassword = np.text; // demo: new password works on the next sign in
    final m = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    m.showSnackBar(const SnackBar(content: Text('Password updated. Please sign in.')));
  }

  @override
  Widget build(BuildContext context) => Screen(
        backLabel: 'Back to sign in',
        title: 'Reset your password',
        titleSize: 32,
        gap: 16,
        children: [
          Text(step == 0 ? 'Enter your ID. We will send a 6-digit code to your registered phone.' : 'Enter the code we sent and choose a new password.', style: const TextStyle(fontSize: 15, height: 1.5, color: kMuted)),
          if (step == 0)
            AppField('Staff or student ID', id)
          else ...[
            AppField('6-digit code', code, keyboard: TextInputType.number, maxLength: 7, spacing: 3),
            AppField('New password', np, obscure: true),
            AppField('Confirm new password', cp, obscure: true),
          ],
          if (error != null) Text(error!, style: const TextStyle(color: kRed, fontSize: 13, fontWeight: FontWeight.w600)),
          PButton(step == 0 ? 'Send code' : 'Update password', step == 0 ? _send : _reset),
          const Text('The code expires in 10 minutes. Your face data is not affected by a password reset.', textAlign: TextAlign.center, style: kNote),
        ],
      );
}
