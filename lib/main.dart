import 'package:flutter/material.dart';
import 'core/core.dart';
import 'features/auth/login_screen.dart';

void main() => runApp(const PresenceApp());

class PresenceApp extends StatelessWidget {
  const PresenceApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'EduTracker',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const LoginScreen(),
      );
}
