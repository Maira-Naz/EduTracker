// Attendance report for a course by week / month / term.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../auth/profile_menu.dart';

class ReportsTab extends StatefulWidget {
  const ReportsTab({super.key});
  @override
  State<ReportsTab> createState() => _ReportsState();
}

class _ReportsState extends State<ReportsTab> {
  int range = 0;
  Course? sel;
  static const labels = [['Mon', 'Tue', 'Wed', 'Thu', 'Fri'], ['W1', 'W2', 'W3', 'W4'], ['Aug', 'Sep', 'Oct']];
  static const vals = [[94, 91, 96, 89, 82], [92, 88, 90, 85], [92, 90, 89]];
  static const lateN = [6, 14, 31], manualN = [3, 8, 19];
  static const delta = ['+2%', '-1%', '+3%'], rname = ['this week', 'this month', 'this term'];

  @override
  Widget build(BuildContext context) {
    final mine = Store.i.courses.where((c) => c.tid == Store.i.uid).toList();
    final c = sel ?? (mine.isEmpty ? null : mine.first);
    final off = c == null ? 0 : (c.avg - 91) ~/ 2;
    final v = [for (final x in vals[range]) (x + off).clamp(0, 100).toInt()];
    final avg = (v.reduce((a, b) => a + b) / v.length).round();
    final low = Store.i.students.where((x) => x.pct < 75).toList();
    return Screen(
      title: 'Reports',
      trailing: const ProfileMenu(),
      children: [
        if (c != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: PopupMenuButton<Course>(
              onSelected: (x) => setState(() => sel = x),
              itemBuilder: (_) => [for (final m in mine) PopupMenuItem(value: m, child: Text(m.name))],
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text('${c.name}, ${rname[range]}', style: kMut),
                const Icon(Icons.expand_more, size: 18, color: kMuted),
              ]),
            ),
          ),
        Seg(const ['Week', 'Month', 'Term'], range, (i) => setState(() => range = i)),
        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Item('Average ${rname[range]}', trailing: Pill(delta[range], delta[range].startsWith('-') ? Tone.red : Tone.green)),
            Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Text('$avg%', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w700))),
            SizedBox(
              height: 150,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                for (var i = 0; i < v.length; i++)
                  Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text('${v[i]}', style: TextStyle(fontSize: 12, color: kMuted, fontWeight: i == v.length - 1 ? FontWeight.w700 : FontWeight.w400)),
                      const SizedBox(height: 4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: v[i] * 1.05,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(color: i == v.length - 1 ? kPrimary : const Color(0xFFE0E3FF), borderRadius: BorderRadius.circular(8)),
                      ),
                      const SizedBox(height: 4),
                      Text(labels[range][i], style: kMut),
                    ]),
                  ),
              ]),
            ),
          ]),
        ),
        tileRow([StatTile('${lateN[range]}', 'Late arrivals'), StatTile('${manualN[range]}', 'Manual marks')]),
        const Section('Needs attention'),
        if (low.isEmpty)
          emptyNote('Everyone is above 75%.')
        else
          AppCard(
            child: Column(children: [
              for (var i = 0; i < low.length; i++) ...[
                if (i > 0) const Hr(),
                Item(low[i].name, sub: low[i].id, trailing: Pill('${low[i].pct}% attendance', pctTone(low[i].pct))),
              ],
            ]),
          ),
      ],
    );
  }
}
