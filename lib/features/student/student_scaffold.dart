import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/widgets/tab_scaffold.dart';

enum StudentTab { courses, faceId, account }

class StudentScaffold extends StatelessWidget {
  const StudentScaffold({super.key, required this.tab, required this.children});

  final StudentTab tab;
  final List<Widget> children;

  static const _tabs = [
    EtTab('Courses', Routes.studentCourses),
    EtTab('Face ID', Routes.studentFaceId),
    EtTab('Account', Routes.studentAccount),
  ];

  @override
  Widget build(BuildContext context) =>
      EtTabScaffold(tabs: _tabs, index: tab.index, children: children);
}
