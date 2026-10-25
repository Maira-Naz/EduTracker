// Teacher bottom tabs: Rooms, Review, Reports.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import 'reports_tab.dart';
import 'review_tab.dart';
import 'rooms_tab.dart';

class TeacherShell extends StatelessWidget {
  const TeacherShell({super.key});
  @override
  Widget build(BuildContext context) => const AppShell(
        tabs: [RoomsTab(), ReviewTab(), ReportsTab()],
        items: [
          NavItem(Icons.videocam_outlined, Icons.videocam, 'Rooms'),
          NavItem(Icons.fact_check_outlined, Icons.fact_check, 'Review'),
          NavItem(Icons.insights_outlined, Icons.insights, 'Reports'),
        ],
      );
}
