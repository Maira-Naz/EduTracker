import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class EtTab {
  const EtTab(this.label, this.route);
  final String label;
  final String route;
}

/// Scrolling body + rounded bottom tab bar. Used by every role.
class EtTabScaffold extends StatelessWidget {
  const EtTabScaffold({
    super.key,
    required this.tabs,
    required this.index,
    required this.children,
  });

  final List<EtTab> tabs;
  final int index;
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
          EtNavBar(tabs: tabs, index: index),
        ],
      ),
    );
  }
}

class EtNavBar extends StatelessWidget {
  const EtNavBar({super.key, required this.tabs, required this.index});

  final List<EtTab> tabs;
  final int index;

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
          for (var i = 0; i < tabs.length; i++)
            Expanded(
              child: _NavItem(
                label: tabs[i].label,
                active: i == index,
                onTap: () {
                  final here = ModalRoute.of(context)?.settings.name;
                  if (here == tabs[i].route) return; // already on tab root
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(tabs[i].route, (r) => false);
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
