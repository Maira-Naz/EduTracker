// Teacher bottom tabs: Rooms, Review, Reports.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import 'reports_tab.dart';
import 'review_tab.dart';
import 'rooms_tab.dart';

class TeacherShell extends StatelessWidget {
  const TeacherShell({super.key});
  @override
  Widget build(BuildContext context) => const AppShell([
        TabSpec('Rooms', RoomsTab()),
        TabSpec('Review', ReviewTab()),
        TabSpec('Reports', ReportsTab()),
      ]);
}
