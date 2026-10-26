import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import 'cameras_screen.dart';
import 'requests_screen.dart';
import 'schedule_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});
  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _tab = 0;
  final _keys = List.generate(3, (_) => GlobalKey<NavigatorState>());
  static const _labels = ['Cameras', 'Requests', 'Schedule'];

  Widget _root(int i) => [
        const CamerasScreen(),
        const RequestsScreen(),
        const ScheduleScreen(),
      ][i];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final nav = _keys[_tab].currentState!;
        if (nav.canPop()) nav.pop();
      },
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: IndexedStack(index: _tab, children: [
          for (var i = 0; i < 3; i++)
            Navigator(
              key: _keys[i],
              onGenerateRoute: (_) =>
                  MaterialPageRoute(builder: (_) => _root(i)),
            ),
        ]),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: AppShadows.navUp,
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Row(children: [
                for (var i = 0; i < 3; i++)
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (i == _tab) {
                          _keys[i].currentState!.popUntil((r) => r.isFirst);
                        }
                        setState(() => _tab = i);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: i == _tab
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(_labels[i],
                            style: AppText.style(
                                12,
                                FontWeight.w800,
                                i == _tab ? Colors.white : AppColors.deep)),
                      ),
                    ),
                  ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
