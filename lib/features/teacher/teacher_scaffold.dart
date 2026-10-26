import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';

enum TeacherTab { rooms, review, reports }

/// Common frame for every teacher screen: scrolling body + bottom nav.
class TeacherScaffold extends StatelessWidget {
  const TeacherScaffold({super.key, required this.tab, required this.children});

  final TeacherTab tab;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final top = math.max(56.0, MediaQuery.of(context).padding.top + 12);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, top, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
          TeacherNavBar(current: tab),
        ],
      ),
    );
  }
}

class TeacherNavBar extends StatelessWidget {
  const TeacherNavBar({super.key, required this.current});

  final TeacherTab current;

  static const _items = [
    (TeacherTab.rooms, 'Rooms', Routes.teacherRooms),
    (TeacherTab.review, 'Review', Routes.teacherReview),
    (TeacherTab.reports, 'Reports', Routes.teacherReports),
  ];

  @override
  Widget build(BuildContext context) {
    final bottom = math.max(24.0, MediaQuery.of(context).padding.bottom);
    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 16, bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: AppShadows.navUp,
      ),
      child: Row(
        children: [
          for (final item in _items)
            Expanded(
              child: _NavItem(
                label: item.$2,
                active: item.$1 == current,
                onTap: () {
                  final here = ModalRoute.of(context)?.settings.name;
                  if (here == item.$3) return; // already on this tab's root
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(item.$3, (r) => false);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem(
      {required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? AppColors.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 46,
          child: Center(
            child: Text(
              label,
              style: AppText.style(
                14,
                active ? FontWeight.w800 : FontWeight.w700,
                active ? Colors.white : AppColors.muted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
