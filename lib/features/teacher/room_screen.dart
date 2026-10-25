// Open room: live counts + edit late time and closing time.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import 'class_list_screen.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen(this.course, {super.key});
  final Course course;
  @override
  State<RoomScreen> createState() => _RoomState();
}

class _RoomState extends State<RoomScreen> {
  Course get c => widget.course;
  late int lateAt = c.lateAt, closeAt = c.closeAt;
  bool get dirty => lateAt != c.lateAt || closeAt != c.closeAt;

  void _save() {
    Store.i.setTiming(c, lateAt, closeAt);
    toast(context, 'Timing saved');
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) {
          final room = Store.i.roomOf(c.room);
          final st = Store.i.statusOf(c);
          final ss = Store.i.students;
          int n(String s) => ss.where((x) => x.status == s).length;
          return Screen(
            back: true,
            backLabel: 'Rooms',
            subtitle: '${c.name} · ${c.time}',
            title: 'Room ${room.id}',
            trailing: Pill(room.online ? 'Online' : 'Offline', room.online ? Tone.green : Tone.red),
            children: [
              if (st == 'Upcoming')
                AppCard(child: Text('Attendance opens automatically at ${hm(c.start)}. You can set the timing below.', style: kMut))
              else
                tileRow([
                  StatTile('${n('Present')}', 'Present', bg: kGreenBg, fg: kGreen, onTap: () => go(context, ClassListScreen(c, initial: 0))),
                  StatTile('${n('Late')}', 'Late', bg: kAmberBg, fg: kAmber, onTap: () => go(context, ClassListScreen(c, initial: 1))),
                  StatTile('${n('Absent') + n('Review')}', 'Not seen', bg: kRedBg, fg: kRed, onTap: () => go(context, ClassListScreen(c, initial: 2))),
                ]),
              const Section('Attendance timing'),
              AppCard(
                child: Column(children: [
                  _Stepper('Mark students late after', hm(lateAt), '${lateAt - c.start} minutes after class start',
                      canMinus: lateAt - 5 >= c.start, canPlus: lateAt + 5 < closeAt,
                      minus: () => setState(() => lateAt -= 5), plus: () => setState(() => lateAt += 5)),
                  const Hr(),
                  _Stepper('Close attendance at', hm(closeAt), 'Nobody is marked after this time',
                      canMinus: closeAt - 5 > lateAt, canPlus: closeAt + 5 <= c.end,
                      minus: () => setState(() => closeAt -= 5), plus: () => setState(() => closeAt += 5)),
                  const SizedBox(height: 16),
                  FilledButton(onPressed: dirty ? _save : null, child: const Text('Save timing')),
                ]),
              ),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: () => go(context, ClassListScreen(c)), child: const Text('View class list')),
              const SizedBox(height: 14),
              const Text('Attendance is marked automatically for the class running in this room.', style: kMut),
            ],
          );
        },
      );
}

class _Stepper extends StatelessWidget {
  const _Stepper(this.label, this.value, this.hint, {required this.minus, required this.plus, required this.canMinus, required this.canPlus});
  final String label, value, hint;
  final VoidCallback minus, plus;
  final bool canMinus, canPlus;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(children: [
          IconButton.outlined(onPressed: canMinus ? minus : null, icon: const Icon(Icons.remove)),
          Expanded(child: Center(child: Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)))),
          IconButton.outlined(onPressed: canPlus ? plus : null, icon: const Icon(Icons.add)),
        ]),
        const SizedBox(height: 6),
        Text(hint, style: kMut),
      ]);
}
