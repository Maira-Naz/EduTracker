// Low-confidence face scans waiting for the teacher, plus resolved ones.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../auth/profile_menu.dart';
import 'scan_detail_screen.dart';

class ReviewTab extends StatelessWidget {
  const ReviewTab({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) {
          final s = Store.i;
          final mine = s.scans.where((x) => s.courseNamed(x.course).tid == s.uid).toList();
          final pending = mine.where((x) => x.state == 'pending').toList();
          final done = mine.where((x) => x.state != 'pending').toList();
          return Screen(
            title: 'Needs review',
            subtitle: 'Your classes today',
            trailing: const ProfileMenu(),
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Align(alignment: Alignment.centerLeft, child: Pill('${pending.length} scan${pending.length == 1 ? '' : 's'}', Tone.violet)),
              ),
              if (pending.isEmpty) emptyNote('All caught up. Nothing needs review.'),
              for (final x in pending)
                AppCard(
                  onTap: () => go(context, ScanDetail(x)),
                  child: Item(x.name,
                      sub: '${x.id}, seen ${x.time}',
                      leading: Avatar(x.name),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [Pill('${x.conf}%', Tone.violet), const Icon(Icons.chevron_right, color: kMuted)])),
                ),
              if (done.isNotEmpty) const Section('Resolved today'),
              if (done.isNotEmpty)
                AppCard(
                  child: Column(children: [
                    for (var i = 0; i < done.length; i++) ...[
                      if (i > 0) const Hr(),
                      Item(done[i].name,
                          sub: '${done[i].conf}%, ${done[i].state == 'approved' ? 'you approved' : 'you marked absent'}',
                          leading: Avatar(done[i].name),
                          trailing: Pill(done[i].state == 'approved' ? 'Present' : 'Absent', done[i].state == 'approved' ? Tone.green : Tone.red)),
                    ],
                  ]),
                ),
            ],
          );
        },
      );
}
