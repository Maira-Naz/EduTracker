// Low-confidence face scans waiting for the teacher, plus resolved ones.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../auth/sign_out.dart';
import 'review_detail_screen.dart';

class ReviewTab extends StatelessWidget {
  const ReviewTab({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) {
          final s = Store.i;
          final mine = s.scans.where((x) => s.course(x.course).tid == s.uid).toList();
          final pending = mine.where((x) => x.state == 'pending').toList();
          final done = mine.where((x) => x.state != 'pending').toList();
          final live = s.sessions.where((x) => x.status == 'Live' && x.course.tid == s.uid).toList();
          final above = live.isEmpty ? 'Your classes today' : '${live.first.course.name}, ${hm(live.first.course.start)}, ${s.roomOf(live.first.course.room).name}';
          return Screen(
            above: above,
            title: 'Needs review',
            trailing: const SignOutButton(),
            children: [
              Align(alignment: Alignment.centerLeft, child: Pill('${pending.length} scan${pending.length == 1 ? '' : 's'}', Tone.indigo)),
              if (pending.isEmpty) const Panel(child: Text('All caught up. Nothing needs review.', textAlign: TextAlign.center, style: kRowSub)),
              for (final x in pending) _ScanCard(x),
              if (done.isNotEmpty) const SectionTitle('Resolved today'),
              if (done.isNotEmpty)
                RowsPanel([
                  for (final x in done)
                    RowItem(
                      x.name,
                      sub: '${x.conf}%, ${x.state == 'approved' ? 'you approved' : 'you marked absent'}',
                      trailing: Pill(x.state == 'approved' ? 'Present' : 'Absent', x.state == 'approved' ? Tone.green : Tone.red),
                    ),
                ]),
            ],
          );
        },
      );
}

class _ScanCard extends StatelessWidget {
  const _ScanCard(this.x);
  final Scan x;

  void _resolve(BuildContext context, bool approve) {
    Store.i.resolveScan(x, approve);
    toast(context, approve ? '${x.name} marked present' : '${x.name} marked absent');
  }

  @override
  Widget build(BuildContext context) => Panel(
        child: Column(children: [
          InkWell(
            onTap: () => go(context, ReviewDetailScreen(x)),
            child: Row(children: [
              Avatar(x.name, size: 46),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(x.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                  Text('${x.id}, seen ${x.time}', style: kRowSub),
                ]),
              ),
              Pill('${x.conf}%', x.conf < 75 ? Tone.amber : Tone.green, size: 13),
            ]),
          ),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: OButton('Mark absent', () => _resolve(context, false), height: 46, size: 14)),
            const SizedBox(width: 10),
            Expanded(child: PButton('Approve', () => _resolve(context, true), height: 46, size: 14)),
          ]),
        ]),
      );
}
