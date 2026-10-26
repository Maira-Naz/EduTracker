// Admin bottom tabs. (Admin module is built after the student module.)
import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../auth/sign_out.dart';

class AdminShell extends StatelessWidget {
  const AdminShell({super.key});
  @override
  Widget build(BuildContext context) => const AppShell([TabSpec('Overview', _Soon()), TabSpec('Rooms', _Soon()), TabSpec('Students', _Soon()), TabSpec('Audit', _Soon())]);
}

class _Soon extends StatelessWidget {
  const _Soon();
  @override
  Widget build(BuildContext context) => const Screen(title: 'Admin module', below: 'Coming in a later step', trailing: SignOutButton(), children: []);
}
