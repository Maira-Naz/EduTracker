// Class list (Present / Late / Absent) with manual "Mark present".
import 'package:flutter/material.dart';
import '../../core/core.dart';

class ClassListScreen extends StatefulWidget {
  const ClassListScreen(this.course, {super.key, this.initial = 0});
  final Course course;
  final int initial;
  @override
  State<ClassListScreen> createState() => _ClassListState();
}

class _ClassListState extends State<ClassListScreen> {
  late int idx = widget.initial;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) {
          final s = Store.i;
          final c = widget.course;
          final groups = [
            s.roster.where((x) => x.status == 'Present').toList(),
            s.roster.where((x) => x.status == 'Late').toList(),
            s.roster.where((x) => x.status == 'Absent').toList(),
          ];
          final list = groups[idx];
          return Screen(
            backLabel: s.roomOf(c.room).name,
            title: 'Class list',
            below: '${c.name} · ${c.time}',
            children: [
              Seg(['Present ${groups[0].length}', 'Late ${groups[1].length}', 'Absent ${groups[2].length}'], idx, (i) => setState(() => idx = i), size: 13),
              RowsPanel(
                empty: 'Nobody here.',
                [
                  for (final x in list)
                    RowItem(
                      x.name,
                      sub: '${x.id} · ${x.status == 'Absent' ? 'not seen' : (x.status == 'Late' ? 'seen late' : 'seen')}',
                      trailing: x.status == 'Absent'
                          ? GestureDetector(
                              onTap: () {
                                s.mark(x, c);
                                toast(context, '${x.name} marked present');
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                decoration: BoxDecoration(color: kChip, borderRadius: BorderRadius.circular(12)),
                                child: const Text('Mark present', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: kDeep)),
                              ),
                            )
                          : null,
                    ),
                ],
              ),
              const Text('Manual marks are recorded in the audit trail.', textAlign: TextAlign.center, style: kNote),
            ],
          );
        },
      );
}
