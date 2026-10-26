import 'package:flutter/material.dart';
import 'core/core.dart';
import 'features/auth/login_screen.dart';

void main() => runApp(const EduTrackerApp());

class EduTrackerApp extends StatelessWidget {
  const EduTrackerApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'EduTracker',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const LoginScreen(),
      );
}
