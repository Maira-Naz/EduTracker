// One scan: camera scan vs registered face, match confidence, approve or reject.
import 'package:flutter/material.dart';
import '../../core/core.dart';

class ReviewDetailScreen extends StatelessWidget {
  const ReviewDetailScreen(this.x, {super.key});
  final Scan x;

  void _resolve(BuildContext context, bool approve) {
    final m = ScaffoldMessenger.of(context);
    Store.i.resolveScan(x, approve);
    Navigator.pop(context);
    m.showSnackBar(SnackBar(content: Text(approve ? '${x.name} marked present' : '${x.name} marked absent')));
  }

  Widget _photo(String label, Color bg) => Expanded(
        child: Panel(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Container(height: 150, width: double.infinity, decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)), child: const Icon(Icons.person_outline, size: 64, color: kDeep)),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final s = Store.i;
    final c = s.course(x.course);
    final low = x.conf < 75;
    return Screen(
      backLabel: 'Needs review',
      title: x.name,
      titleSize: 32,
      below: '${x.id} · seen ${x.time} · ${s.roomOf(c.room).name}',
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [_photo('Camera scan', kBlobB), const SizedBox(width: 12), _photo('Registered face', kBlobA)]),
        Panel(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
              const Text('Match confidence', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              Text('${x.conf}%', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: low ? kAmber : kGreen)),
            ]),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, box) => Stack(clipBehavior: Clip.none, children: [
                Container(height: 10, decoration: BoxDecoration(color: kChip, borderRadius: BorderRadius.circular(6))),
                Container(height: 10, width: box.maxWidth * x.conf / 100, decoration: BoxDecoration(color: low ? kAmberBar : kDotGreen, borderRadius: BorderRadius.circular(6))),
                Positioned(left: box.maxWidth * 0.75, top: -4, child: Container(width: 3, height: 18, color: kInk)),
              ]),
            ),
            const SizedBox(height: 10),
            Text(low ? 'Auto-approve starts at 75%. This scan is just below it.' : 'This scan is above the 75% auto-approve line.', style: kNote),
          ]),
        ),
        if (x.state == 'pending')
          Row(children: [
            Expanded(child: OButton('Not her, mark absent', () => _resolve(context, false))),
            const SizedBox(width: 10),
            Expanded(child: PButton('Yes, approve', () => _resolve(context, true), height: 54, size: 15)),
          ])
        else
          Center(child: Pill(x.state == 'approved' ? 'Approved as present' : 'Marked absent', x.state == 'approved' ? Tone.green : Tone.red)),
      ],
    );
  }
}
