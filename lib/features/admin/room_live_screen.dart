// Live camera preview and recognition switches.
import 'package:flutter/material.dart';
import '../../core/core.dart';

class RoomLiveScreen extends StatefulWidget {
  const RoomLiveScreen(this.room, {super.key});
  final Room room;
  @override
  State<RoomLiveScreen> createState() => _LiveState();
}

class _LiveState extends State<RoomLiveScreen> {
  bool line = true, whole = false;

  Widget _box(double l, double t, String label, Color c) => Positioned(
        left: l,
        top: t,
        child: Stack(clipBehavior: Clip.none, children: [
          Container(width: 44, height: 58, decoration: BoxDecoration(border: Border.all(color: c, width: 2), borderRadius: BorderRadius.circular(8))),
          Positioned(
            top: -20,
            left: -2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(5)),
              child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final r = widget.room;
    const green = Color(0xFF1F9D6B), amber = Color(0xFFC77700);
    return Screen(
      back: true,
      backLabel: 'Back',
      subtitle: '${r.cam}, ${r.block}',
      title: 'Room ${r.id}',
      trailing: const Pill('Online', Tone.green),
      children: [
        Container(
          height: 190,
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(color: const Color(0xFF141735), borderRadius: BorderRadius.circular(18)),
          clipBehavior: Clip.antiAlias,
          child: Stack(children: [
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFD92D20), borderRadius: BorderRadius.circular(99)),
                child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ),
            _box(30, 100, 'Sara 98%', green),
            _box(100, 90, 'Bilal 96%', green),
            _box(170, 85, 'Nida 71%', amber),
            _box(240, 100, 'Zainab 98%', green),
          ]),
        ),
        const Padding(padding: EdgeInsets.only(top: 8), child: Text('Preview only. The real stream connects at integration.', style: kMut)),
        tileRow(const [StatTile('21', 'Faces now'), StatTile('24', 'FPS'), StatTile('1080p', 'Quality')]),
        const Section('Recognition'),
        AppCard(
          child: Column(children: [
            Item('Entry and exit line', sub: 'Counts a student at the door', trailing: Switch(value: line, onChanged: (v) => setState(() => line = v))),
            const Hr(),
            Item('Also scan whole room', trailing: Switch(value: whole, onChanged: (v) => setState(() => whole = v))),
          ]),
        ),
      ],
    );
  }
}
