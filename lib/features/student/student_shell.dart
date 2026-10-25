// Student bottom tabs: Courses, Face ID, Account.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import 'account_tab.dart';
import 'courses_tab.dart';
import 'face_id_tab.dart';

class StudentShell extends StatelessWidget {
  const StudentShell({super.key});
  @override
  Widget build(BuildContext context) => const AppShell(
        tabs: [CoursesTab(), FaceIdTab(), AccountTab()],
        items: [
          NavItem(Icons.menu_book_outlined, Icons.menu_book, 'Courses'),
          NavItem(Icons.face_outlined, Icons.face, 'Face ID'),
          NavItem(Icons.person_outline, Icons.person, 'Account'),
        ],
      );
}
