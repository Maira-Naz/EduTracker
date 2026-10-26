// Sign-out confirmation and the small round sign-out button used in tab headers.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import 'login_screen.dart';

Future<void> confirmSignOut(BuildContext c) async {
  final ok = await confirm(c, 'Sign out?', 'You will need to sign in again.', yes: 'Sign out', danger: true);
  if (ok && c.mounted) {
    Navigator.of(c, rootNavigator: true).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
    Store.i.signOut();
  }
}

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});
  @override
  Widget build(BuildContext context) => Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: kShadow),
        child: IconButton(tooltip: 'Sign out', icon: const Icon(Icons.logout_rounded, size: 20, color: kDeep), onPressed: () => confirmSignOut(context)),
      );
}
