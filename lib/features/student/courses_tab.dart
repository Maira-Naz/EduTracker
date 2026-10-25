// Current-semester courses with attendance percentages and a warning banner.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import 'course_detail_screen.dart';

class CoursesTab extends StatelessWidget {
  const CoursesTab({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) {
          final s = Store.i;
          final low = s.myCourses.where((c) => s.pctOf(c) < 75).toList();
          return Screen(
            title: 'My courses',
            subtitle: '${s.uid} · Current semester',
            onRefresh: () async {},
            children: [
              AppCard(
                child: Row(children: [
                  Text('${s.overall}%', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 16),
                  const Expanded(child: Text('Overall attendance this semester. Keep every course above 75%.', style: kMut)),
                ]),
              ),
              if (low.isNotEmpty)
                AppCard(
                  color: kAmberBg,
                  border: kAmberBg,
                  child: Row(children: [
                    const Icon(Icons.warning_amber_rounded, color: kAmber),
                    const SizedBox(width: 12),
                    Expanded(child: Text('${low.map((c) => c.name).join(', ')} ${low.length == 1 ? 'is' : 'are'} below 75%. Attend upcoming classes to recover.', style: const TextStyle(color: kAmber, fontSize: 13, height: 1.4))),
                  ]),
                ),
              for (final c in s.myCourses) _CourseCard(c),
            ],
          );
        },
      );
}

class _CourseCard extends StatelessWidget {
  const _CourseCard(this.c);
  final Course c;
  @override
  Widget build(BuildContext context) {
    final s = Store.i;
    final p = s.pctOf(c), absent = s.stats[c.name]![3];
    return AppCard(
      onTap: () => go(context, CourseDetail(c)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Item(c.name, sub: c.teacher, trailing: Text('$p%', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700))),
        PercentBar(p),
        const SizedBox(height: 10),
        Wrap(spacing: 8, children: [
          if (absent > 0) Pill('$absent absent', Tone.red),
          if (p < 75) const Pill('Below 75%', Tone.amber),
        ]),
      ]),
    );
  }
}
