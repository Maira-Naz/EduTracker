// Admin (HOD) bottom tabs: Overview, Rooms, Audit.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import 'audit_tab.dart';
import 'overview_tab.dart';
import 'rooms_tab.dart';

class AdminShell extends StatelessWidget {
  const AdminShell({super.key});
  @override
  Widget build(BuildContext context) => const AppShell(
        tabs: [OverviewTab(), RoomsTabAdmin(), AuditTab()],
        items: [
          NavItem(Icons.dashboard_outlined, Icons.dashboard, 'Overview'),
          NavItem(Icons.videocam_outlined, Icons.videocam, 'Rooms'),
          NavItem(Icons.history, Icons.history, 'Audit'),
        ],
      );
}
