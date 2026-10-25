// Pending scans grouped by course.
import 'package:flutter/material.dart';
import '../../core/core.dart';

class ScansScreen extends StatelessWidget {
  const ScansScreen({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) {
          final s = Store.i;
          final groups = <String, int>{};
          for (final x in s.scans.where((x) => x.state == 'pending')) {
            groups[x.course] = (groups[x.course] ?? 0) + 1;
          }
          return Screen(
            back: true,
            backLabel: 'Overview',
            title: 'Scans to review',
            subtitle: '${s.pendingScans} low-confidence scans. Teachers approve them for their own classes.',
            children: [
              if (groups.isEmpty) emptyNote('All caught up.'),
              for (final e in groups.entries)
                AppCard(
                  child: Item(e.key, sub: '${s.courseNamed(e.key).teacher} · Room ${s.courseNamed(e.key).room}', trailing: Pill('${e.value} waiting', Tone.violet)),
                ),
              const SizedBox(height: 14),
              const Text('Approved scans are recorded in the audit trail.', style: kMut),
            ],
          );
        },
      );
}
