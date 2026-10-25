// Admin home: 4 tappable stat tiles and "Needs attention".
import 'package:flutter/material.dart';
import '../../core/core.dart';
import 'course_screen.dart';
import 'average_screen.dart';
import 'cameras_online_screen.dart';
import '../auth/profile_menu.dart';
import 'room_offline_screen.dart';
import 'scans_screen.dart';
import 'sessions_screen.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) {
          final s = Store.i;
          final offline = s.rooms.where((r) => !r.online).toList();
          final lowCourses = s.courses.where((c) => c.avg < 80).toList();
          return Screen(
            title: 'Computer Science',
            subtitle: 'Admin · HOD',
            trailing: const ProfileMenu(),
            children: [
              tileRow([
                StatTile('${s.onlineCams} / ${s.rooms.length}', 'Cameras online', bg: kAmberBg, fg: kAmber, onTap: () => go(context, const CamerasOnlineScreen())),
                StatTile('${s.sessions.length}', "Today's sessions", bg: kVioletBg, fg: kViolet, onTap: () => go(context, const SessionsScreen())),
              ]),
              tileRow([
                StatTile('${avgFor(0)}%', 'Average attendance', bg: kGreenBg, fg: kGreen, onTap: () => go(context, const AverageScreen())),
                StatTile('${s.pendingScans}', 'Scans to review', bg: const Color(0xFFEDE7FF), fg: const Color(0xFF5A2FC2), onTap: () => go(context, const ScansScreen())),
              ]),
              const Section('Needs attention'),
              if (offline.isEmpty && lowCourses.isEmpty) emptyNote('Everything is running normally.'),
              for (final r in offline)
                AppCard(
                  onTap: () => go(context, RoomOfflineScreen(r)),
                  child: Item('Room ${r.id} camera offline', sub: 'Since ${r.since ?? 'earlier'} today', trailing: const Pill('Offline', Tone.red)),
                ),
              for (final c in lowCourses)
                AppCard(
                  onTap: () => go(context, AdminCourseScreen(c)),
                  child: Item('${c.name} is at ${c.avg}%', sub: 'Room ${c.room} · ${c.teacher}', trailing: Pill('${c.avg}%', pctTone(c.avg))),
                ),
            ],
          );
        },
      );
}
