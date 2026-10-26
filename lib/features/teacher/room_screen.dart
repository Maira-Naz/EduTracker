// Open room: attendance counts and edit late time / closing time.
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
    setState(() {});
    toast(context, 'Timing saved');
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) {
          final s = Store.i;
          final room = s.roomOf(c.room);
          return Screen(
            backLabel: 'Rooms',
            title: room.name,
            below: '${c.name} · ${c.time}',
            trailing: Pill(room.online ? 'Online' : 'Offline', room.online ? Tone.green : Tone.red),
            children: [
              statRow([
                StatCard('${s.count('Present')}', 'Present', onTap: () => go(context, ClassListScreen(c, initial: 0))),
                StatCard('${s.count('Late')}', 'Late', onTap: () => go(context, ClassListScreen(c, initial: 1))),
                StatCard('${s.count('Absent')}', 'Not seen', onTap: () => go(context, ClassListScreen(c, initial: 2))),
              ]),
              GestureDetector(
                onTap: () => go(context, ClassListScreen(c)),
                child: const Padding(padding: EdgeInsets.symmetric(vertical: 2), child: Text('View class list  ›', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kLink))),
              ),
              const SectionTitle('Attendance timing'),
              Panel(
                child: Column(children: [
                  _Stepper('Mark students late after', hm(lateAt), '${lateAt - c.start} minutes after class start',
                      canMinus: lateAt - 5 >= c.start, canPlus: lateAt + 5 < closeAt, minus: () => setState(() => lateAt -= 5), plus: () => setState(() => lateAt += 5)),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(height: 1, color: kDivider)),
                  _Stepper('Close attendance at', hm(closeAt), 'Nobody is marked after this time',
                      canMinus: closeAt - 5 > lateAt, canPlus: closeAt + 5 <= c.end, minus: () => setState(() => closeAt -= 5), plus: () => setState(() => closeAt += 5)),
                ]),
              ),
              PButton('Save timing', dirty ? _save : null, height: 54, size: 15),
              const Text('Attendance is marked automatically for the class running in this room.', textAlign: TextAlign.center, style: kNote),
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

  Widget _btn(String t, VoidCallback? f) => GestureDetector(
        onTap: f,
        child: Opacity(
          opacity: f == null ? 0.4 : 1,
          child: Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: kBorder, width: 2), borderRadius: BorderRadius.circular(14)),
            child: Text(t, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: kDeep)),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Row(children: [
          _btn('−', canMinus ? minus : null),
          Expanded(child: Center(child: Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5)))),
          _btn('+', canPlus ? plus : null),
        ]),
        const SizedBox(height: 8),
        Center(child: Text(hint, style: kRowSub)),
      ]);
}
