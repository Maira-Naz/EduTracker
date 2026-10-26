// Attendance report per course: average, students below 75%, export.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../auth/sign_out.dart';

class ReportsTab extends StatefulWidget {
  const ReportsTab({super.key});
  @override
  State<ReportsTab> createState() => _ReportsState();
}

class _ReportsState extends State<ReportsTab> {
  int idx = 0;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) {
          final s = Store.i;
          final mine = s.myTeaching;
          if (mine.isEmpty) return const Screen(title: 'Reports', above: 'Current semester', children: [Panel(child: Text('No courses assigned.', textAlign: TextAlign.center, style: kRowSub))]);
          final c = mine[idx.clamp(0, mine.length - 1)];
          final low = s.lowest(c);
          return Screen(
            above: 'Current semester',
            title: 'Reports',
            trailing: const SignOutButton(),
            children: [
              Seg([for (final m in mine) m.name], idx, (i) => setState(() => idx = i), size: 12),
              HeroCard(
                radius: 24,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                child: Row(children: [
                  Text('${c.avg}%', style: const TextStyle(fontSize: 46, height: 1, fontWeight: FontWeight.w800, letterSpacing: -2, color: Colors.white)),
                  const SizedBox(width: 18),
                  const Expanded(child: Text('Average attendance across 14 sessions this semester.', style: TextStyle(fontSize: 14, height: 1.45, color: kSoft))),
                ]),
              ),
              const SectionTitle('Students below 75%'),
              RowsPanel(
                empty: 'Everyone is above 75%.',
                [for (final x in low) RowItem(x.name, sub: x.id, trailing: pctBadge(s.pctFor(x, c)))],
              ),
              OButton('Export report', () => copyToClipboard(context, s.csvFor(c), 'Report copied as CSV. Paste it into Excel or Sheets.'), height: 52, border: kBlobB, color: kDeep),
            ],
          );
        },
      );
}
