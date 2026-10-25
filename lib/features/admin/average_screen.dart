// Average attendance by room (Today / Week / Term).
import 'package:flutter/material.dart';
import '../../core/core.dart';
import 'course_screen.dart';

class AverageScreen extends StatefulWidget {
  const AverageScreen({super.key});
  @override
  State<AverageScreen> createState() => _AverageState();
}

class _AverageState extends State<AverageScreen> {
  int r = 0;

  // Rooms added later (no sample data yet) show as "No camera data".
  int? _avgOf(int range, int room) => room < kRoomAvg[range].length ? kRoomAvg[range][room] : null;
  @override
  Widget build(BuildContext context) {
    final s = Store.i;
    final lowest = ([...s.courses]..sort((a, b) => a.avg.compareTo(b.avg))).first;
    return Screen(
      back: true,
      backLabel: 'Overview',
      title: 'Average attendance',
      children: [
        Seg(kRanges, r, (i) => setState(() => r = i)),
        AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Department average ${kRanges[r].toLowerCase() == 'today' ? 'today' : 'this ${kRanges[r].toLowerCase()}'}', style: kMut),
          Text('${avgFor(r)}%', style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w700)),
        ])),
        const Section('By room'),
        AppCard(
          child: Column(children: [
            for (var i = 0; i < s.rooms.length; i++) ...[
              if (i > 0) const Hr(),
              _avgOf(r, i) == null
                  ? Item('Room ${s.rooms[i].id}', trailing: const Pill('No camera data', Tone.red))
                  : Column(children: [Item('Room ${s.rooms[i].id}', trailing: Text('${_avgOf(r, i)}%', style: kH3)), PercentBar(_avgOf(r, i)!)]),
            ],
          ]),
        ),
        const Section('Lowest course'),
        AppCard(onTap: () => go(context, AdminCourseScreen(lowest)), child: Item(lowest.name, sub: 'Room ${lowest.room}', trailing: Text('${lowest.avg}%', style: kH3))),
      ],
    );
  }
}
