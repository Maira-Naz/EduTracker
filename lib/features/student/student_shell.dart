// Student bottom tabs: Courses, Face ID, Account.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import 'account_tab.dart';
import 'courses_tab.dart';
import 'face_id_tab.dart';

class StudentShell extends StatelessWidget {
  const StudentShell({super.key});
  @override
  Widget build(BuildContext context) => const AppShell([
        TabSpec('Courses', CoursesTab()),
        TabSpec('Face ID', FaceIdTab()),
        TabSpec('Account', AccountTab()),
      ]);
}
