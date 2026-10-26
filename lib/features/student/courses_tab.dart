// My courses: overall attendance and one card per current-semester course.
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
          return Screen(
            above: '${s.uid} · Current semester',
            title: 'My courses',
            children: [
              HeroCard(
                radius: 24,
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                child: Row(children: [
                  Text('${s.overall}%', style: const TextStyle(fontSize: 50, height: 1, fontWeight: FontWeight.w800, letterSpacing: -2, color: Colors.white)),
                  const SizedBox(width: 18),
                  const Expanded(child: Text('Overall attendance this semester. Keep every course above 75%.', style: TextStyle(fontSize: 14, height: 1.45, color: kSoft))),
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
    final p = s.pctOf(c);
    final absent = s.stats[c.name]![3];
    final low = p < 75;
    return Panel(
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      color: low ? const Color(0xFFFFF6DF) : Colors.white,
      border: low ? Border.all(color: const Color(0xFFF2B84B), width: 2) : null,
      shadow: !low,
      onTap: () => go(context, CourseDetailScreen(c)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              Padding(padding: const EdgeInsets.only(top: 2), child: Text(c.teacher, style: kRowSub)),
            ]),
          ),
          Text('$p%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: low ? const Color(0xFF8A5A00) : kLink)),
        ]),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(value: p / 100, minHeight: 10, backgroundColor: low ? const Color(0xFFF4E6C2) : kChip, valueColor: AlwaysStoppedAnimation(low ? kAmberBar : kIndigo500)),
        ),
        if (low) ...[const SizedBox(height: 12), const _Tag('Below 75%', Color(0xFFF9E3B0), Color(0xFF5C4108))] else if (absent > 0) ...[const SizedBox(height: 12), _Tag('$absent absent', const Color(0xFFFCE3DE), kRed)],
      ]),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text, this.bg, this.fg);
  final String text;
  final Color bg, fg;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
        child: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: fg)),
      );
}
