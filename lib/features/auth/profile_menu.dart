// Avatar menu (teacher/admin) with sign out, plus the sign-out confirmation.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import 'login_screen.dart';

/// Asks for confirmation, then returns to the login screen.
Future<void> confirmSignOut(BuildContext c) async {
  final ok = await confirm(c, 'Sign out?', 'You will need to sign in again.', yes: 'Sign out', danger: true);
  if (ok && c.mounted) {
    Navigator.of(c).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
    Store.i.signOut();
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});
  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
        tooltip: 'Account',
        onSelected: (_) => confirmSignOut(context),
        itemBuilder: (_) => [
          PopupMenuItem(enabled: false, child: Text('${Store.i.name} · ${Store.i.uid}')),
          const PopupMenuItem(value: 'out', child: Text('Sign out')),
        ],
        child: CircleAvatar(radius: 24, backgroundColor: kInk, child: Text(Store.i.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
      );
}
