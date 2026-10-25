// Teacher home: today's classes. The running class is the big card.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../auth/profile_menu.dart';
import 'room_screen.dart';

class RoomsTab extends StatelessWidget {
  const RoomsTab({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) {
          final s = Store.i;
          final mine = s.sessions.where((x) => x.course.tid == s.uid).toList();
          List<Sess> by(String st) => mine.where((x) => x.status == st).toList();
          return Screen(
            title: 'Your rooms',
            subtitle: todayLabel(),
            trailing: const ProfileMenu(),
            children: [
              for (final x in by('Live')) _LiveCard(x.course),
              if (by('Upcoming').isNotEmpty) const Section('Later today'),
              for (final x in by('Upcoming')) _SessionCard(x),
              if (by('Done').isNotEmpty) const Section('Earlier today'),
              for (final x in by('Done')) _SessionCard(x),
              if (mine.isEmpty) emptyNote('No classes scheduled today.'),
            ],
          );
        },
      );
}

class _LiveCard extends StatelessWidget {
  const _LiveCard(this.c);
  final Course c;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: kInk, borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Running now · ${c.time}', style: const TextStyle(fontSize: 13, color: Color(0xFFC9CCF5))),
              const Pill('Live', Tone.green),
            ]),
            const SizedBox(height: 10),
            Text(c.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 4),
            Text('Room ${c.room}, ${Store.i.roomOf(c.room).block}', style: const TextStyle(color: Color(0xFFC9CCF5))),
            const SizedBox(height: 16),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: kInk),
              onPressed: () => go(context, RoomScreen(c)),
              child: const Text('Open room'),
            ),
          ]),
        ),
      );
}

class _SessionCard extends StatelessWidget {
  const _SessionCard(this.x);
  final Sess x;
  @override
  Widget build(BuildContext context) => AppCard(
        onTap: () => go(context, RoomScreen(x.course)),
        child: Item(
          x.course.name,
          sub: 'Room ${x.course.room}, ${Store.i.roomOf(x.course.room).block}',
          trailing: x.status == 'Done' ? const Pill('Closed', Tone.violet) : Text(hm(x.course.start), style: kMut),
        ),
      );
}
