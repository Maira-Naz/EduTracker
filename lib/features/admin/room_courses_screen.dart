// Courses of one room, plus live camera / troubleshoot entry.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import 'course_screen.dart';
import 'room_live_screen.dart';
import 'room_offline_screen.dart';

class RoomCoursesScreen extends StatelessWidget {
  const RoomCoursesScreen(this.room, {super.key});
  final Room room;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) {
          final list = Store.i.courses.where((c) => c.room == room.id).toList();
          return Screen(
            back: true,
            backLabel: 'Rooms',
            subtitle: '${room.cam}, ${room.block}',
            title: 'Room ${room.id}',
            trailing: Pill(room.online ? 'Online' : 'Offline', room.online ? Tone.green : Tone.red),
            children: [
              if (room.online)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: OutlinedButton.icon(onPressed: () => go(context, RoomLiveScreen(room)), icon: const Icon(Icons.videocam_outlined), label: const Text('Live camera view')),
                )
              else
                AppCard(
                  color: kRedBg,
                  border: const Color(0xFFF5B8B2),
                  onTap: () => go(context, RoomOfflineScreen(room)),
                  child: const Item('Camera offline', sub: 'Tap to troubleshoot', trailing: Icon(Icons.chevron_right, color: kRed)),
                ),
              const Section('Courses in this room'),
              if (list.isEmpty) emptyNote('No courses scheduled in this room.'),
              for (final c in list)
                AppCard(
                  onTap: () => go(context, AdminCourseScreen(c)),
                  child: Item(c.name, sub: '${c.teacher} · ${c.days} ${hm(c.start)}', trailing: Text('${c.avg}%', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
                ),
            ],
          );
        },
      );
}
