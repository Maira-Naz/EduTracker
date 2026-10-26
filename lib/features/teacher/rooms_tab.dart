// Teacher home: today's classes. The running class is the big card.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../auth/sign_out.dart';
import 'room_screen.dart';

class RoomsTab extends StatelessWidget {
  const RoomsTab({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) {
          final s = Store.i;
          final mine = s.sessions.where((x) => x.course.tid == s.uid).toList();
          final live = mine.where((x) => x.status == 'Live').toList();
          final later = mine.where((x) => x.status != 'Live' && x.status != 'Closed').toList();
          final done = mine.where((x) => x.status == 'Closed').toList();
          return Screen(
            above: todayLabel(),
            title: 'Your rooms',
            trailing: const SignOutButton(),
            gap: 20,
            children: [
              for (final x in live) _LiveCard(x.course),
              if (later.isNotEmpty) _Group('Later today', [for (final x in later) _SessionCard(x)]),
              if (done.isNotEmpty) _Group('Earlier today', [for (final x in done) _SessionCard(x)]),
              if (mine.isEmpty) const Panel(child: Text('No classes scheduled today.', textAlign: TextAlign.center, style: kRowSub)),
            ],
          );
        },
      );
}

class _Group extends StatelessWidget {
  const _Group(this.title, this.cards);
  final String title;
  final List<Widget> cards;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.only(left: 2, bottom: 10), child: Text(title, style: kSection)),
        for (var i = 0; i < cards.length; i++) Padding(padding: EdgeInsets.only(top: i == 0 ? 0 : 10), child: cards[i]),
      ]);
}

class _LiveCard extends StatelessWidget {
  const _LiveCard(this.c);
  final Course c;

  Widget _count(String v, String l) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: const Color(0x24FFFFFF), borderRadius: BorderRadius.circular(14)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(v, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
            Text(l, style: const TextStyle(fontSize: 12, color: kSoft)),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final s = Store.i;
    return HeroCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Running now · ${c.time}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kSoft)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
            decoration: BoxDecoration(color: kBlobB, borderRadius: BorderRadius.circular(10)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 7, height: 7, margin: const EdgeInsets.only(right: 6), decoration: const BoxDecoration(color: kInk, shape: BoxShape.circle)),
              const Text('Live', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: kInk)),
            ]),
          ),
        ]),
        const SizedBox(height: 16),
        Text(c.name, style: const TextStyle(fontSize: 27, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: Colors.white)),
        Text('${s.roomOf(c.room).name}, ${s.roomOf(c.room).block}', style: const TextStyle(fontSize: 14, color: kSoft)),
        const SizedBox(height: 16),
        Row(children: [_count('${s.count('Present')}', 'Present'), const SizedBox(width: 10), _count('${s.count('Late')}', 'Late'), const SizedBox(width: 10), _count('${s.count('Absent')}', 'Not seen')]),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => go(context, RoomScreen(c)),
          child: Container(
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
            child: const Text('Open room', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kDeep)),
          ),
        ),
      ]),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard(this.x);
  final Sess x;
  @override
  Widget build(BuildContext context) {
    final r = Store.i.roomOf(x.course.room);
    final closed = x.status == 'Closed';
    return Panel(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      onTap: () => go(context, RoomScreen(x.course)),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(x.course.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            Padding(padding: const EdgeInsets.only(top: 2), child: Text('${r.name}, ${r.block}', style: kRowSub)),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: closed ? kGreyBg : kChip, borderRadius: BorderRadius.circular(10)),
          child: Text(closed ? 'Closed' : hm(x.course.start), style: TextStyle(fontSize: closed ? 13 : 14, fontWeight: closed ? FontWeight.w700 : FontWeight.w800, color: closed ? kMuted : kDeep)),
        ),
      ]),
    );
  }
}
