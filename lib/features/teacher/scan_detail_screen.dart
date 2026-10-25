// One scan: enrolled face vs scan, Approve or Mark absent.
import 'package:flutter/material.dart';
import '../../core/core.dart';

class ScanDetail extends StatelessWidget {
  const ScanDetail(this.x, {super.key});
  final Scan x;

  void _resolve(BuildContext context, bool approve) {
    final m = ScaffoldMessenger.of(context);
    Store.i.resolveScan(x, approve);
    Navigator.pop(context);
    m.showSnackBar(SnackBar(content: Text(approve ? '${x.name} marked present' : '${x.name} marked absent')));
  }

  Widget _photo(String label) => Column(children: [
        Container(
          height: 150,
          decoration: BoxDecoration(color: kGrey, borderRadius: BorderRadius.circular(14)),
          child: const Center(child: Icon(Icons.person, size: 64, color: kMuted)),
        ),
        const SizedBox(height: 6),
        Text(label, style: kMut),
      ]);

  @override
  Widget build(BuildContext context) {
    final course = Store.i.courseNamed(x.course);
    return Screen(
      back: true,
      backLabel: 'Needs review',
      subtitle: '${x.id} · seen ${x.time} · Room ${course.room}',
      title: x.name,
      children: [
        AppCard(child: Row(children: [Expanded(child: _photo('Enrolled face')), const SizedBox(width: 12), Expanded(child: _photo('This scan'))])),
        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Item('Match', trailing: Pill('${x.conf}%', pctTone(x.conf))),
            PercentBar(x.conf),
            const SizedBox(height: 8),
            const Text('Below the automatic-mark level, so it needs your decision.', style: kMut),
          ]),
        ),
        const SizedBox(height: 16),
        if (x.state == 'pending')
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: () => _resolve(context, false), child: const Text('Mark absent'))),
            const SizedBox(width: 12),
            Expanded(child: FilledButton(onPressed: () => _resolve(context, true), child: const Text('Approve'))),
          ])
        else
          Center(child: Pill(x.state == 'approved' ? 'Approved as present' : 'Marked absent', x.state == 'approved' ? Tone.green : Tone.red)),
      ],
    );
  }
}
