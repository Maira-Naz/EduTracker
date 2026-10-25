// Audit trail with All / Cameras / Attendance filter.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../auth/profile_menu.dart';

class AuditTab extends StatefulWidget {
  const AuditTab({super.key});
  @override
  State<AuditTab> createState() => _AuditState();
}

class _AuditState extends State<AuditTab> {
  int f = 0;
  static const _f = ['All', 'Cameras', 'Attendance'];
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) {
          final list = Store.i.audit.where((a) => f == 0 || a.kind == _f[f]).toList();
          return Screen(
            title: 'Audit trail',
            subtitle: 'Every manual change, with who and when',
            trailing: const ProfileMenu(),
            children: [
              Seg(_f, f, (i) => setState(() => f = i)),
              if (list.isEmpty)
                emptyNote('Nothing here yet.')
              else
                AppCard(
                  child: Column(children: [
                    for (var i = 0; i < list.length; i++) ...[
                      if (i > 0) const Hr(),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        SizedBox(width: double.infinity, child: Text(list[i].when, style: kMut)),
                        const SizedBox(height: 2),
                        Text(list[i].text),
                      ]),
                    ],
                  ]),
                ),
            ],
          );
        },
      );
}
