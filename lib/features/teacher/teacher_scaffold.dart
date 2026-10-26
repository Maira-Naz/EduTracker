import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/widgets/tab_scaffold.dart';

enum TeacherTab { rooms, review, reports }

/// Common frame for every teacher screen: scrolling body + bottom nav.
class TeacherScaffold extends StatelessWidget {
  const TeacherScaffold({super.key, required this.tab, required this.children});

  final TeacherTab tab;
  final List<Widget> children;

  static const _tabs = [
    EtTab('Rooms', Routes.teacherRooms),
    EtTab('Review', Routes.teacherReview),
    EtTab('Reports', Routes.teacherReports),
  ];

  @override
  Widget build(BuildContext context) =>
      EtTabScaffold(tabs: _tabs, index: tab.index, children: children);
}
