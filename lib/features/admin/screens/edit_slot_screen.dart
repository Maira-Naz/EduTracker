import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../data/admin_store.dart';
import '../widgets/admin_widgets.dart';

class EditSlotScreen extends StatefulWidget {
  const EditSlotScreen({
    super.key,
    required this.slot,
    required this.dept,
    required this.sem,
    required this.day,
  });
  final Slot? slot; // null = add
  final String dept, sem, day;
  @override
  State<EditSlotScreen> createState() => _EditSlotScreenState();
}

class _EditSlotScreenState extends State<EditSlotScreen> {
  late final _course = TextEditingController(text: widget.slot?.course ?? '');
  late final _teacher = TextEditingController(text: widget.slot?.teacher ?? '');
  late final _room = TextEditingController(text: widget.slot?.room ?? '');
  late String _day = widget.slot?.day ?? widget.day;
  late String _start = widget.slot?.start ?? '09:00';
  late String _end = widget.slot?.end ?? '10:30';

  Future<void> _pickTime(bool start) async {
    final t = await showTimePicker(
        context: context, initialTime: parseTime(start ? _start : _end));
    if (t != null) setState(() => start ? _start = fmt(t) : _end = fmt(t));
  }

  void _save() {
    if (_course.text.trim().isEmpty ||
        _teacher.text.trim().isEmpty ||
        _room.text.trim().isEmpty) {
      toast(context, 'Please fill in course, teacher and room');
      return;
    }
    if (_end.compareTo(_start) <= 0) {
      toast(context, 'End time must be after start time');
      return;
    }
    final s = widget.slot;
    if (s == null) {
      adminStore.addSlot(Slot(
        dept: widget.dept,
        sem: widget.sem,
        day: _day,
        course: _course.text.trim(),
        teacher: _teacher.text.trim(),
        room: _room.text.trim(),
        start: _start,
        end: _end,
      ));
    } else {
      s
        ..course = _course.text.trim()
        ..teacher = _teacher.text.trim()
        ..room = _room.text.trim()
        ..day = _day
        ..start = _start
        ..end = _end;
      adminStore.touch();
    }
    Navigator.of(context).pop();
    toast(context, 'Saved under ${adminStore.admin}');
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        title: Text('Delete this slot?',
            style: AppText.style(16, FontWeight.w800, AppColors.ink)),
        content: Text('Teachers and students will stop seeing this class.',
            style: AppText.style(13, FontWeight.w600, AppColors.muted)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('Delete',
                  style: AppText.style(14, FontWeight.w800, AppColors.redFg))),
        ],
      ),
    );
    if (ok == true && mounted) {
      adminStore.removeSlot(widget.slot!);
      Navigator.of(context).pop();
      toast(context, 'Slot deleted');
    }
  }

  @override
  Widget build(BuildContext context) {
    final adding = widget.slot == null;
    return AppPage(children: [
      Header(
        back: 'Schedule',
        title: adding ? 'Add slot' : 'Edit slot',
        sub: '${widget.dept} · ${widget.sem}',
      ),
      const SizedBox(height: 14),
      Field('Course', controller: _course),
      const SizedBox(height: 14),
      Field('Teacher', controller: _teacher),
      const SizedBox(height: 14),
      Row(children: [
        Expanded(child: Field('Room', controller: _room)),
        const SizedBox(width: 12),
        Expanded(
          child: Field('Day',
              value: _day,
              onTap: () async {
                final v = await pickOption(context, 'Day', kDays);
                if (v != null) setState(() => _day = v);
              }),
        ),
      ]),
      const SizedBox(height: 14),
      Row(children: [
        Expanded(
            child: Field('Starts', value: _start, onTap: () => _pickTime(true))),
        const SizedBox(width: 12),
        Expanded(
            child: Field('Ends', value: _end, onTap: () => _pickTime(false))),
      ]),
      const SizedBox(height: 12),
      Text(
          'Teachers and students see the change straight away. It is recorded under ${adminStore.admin}.',
          style: AppText.style(11, FontWeight.w600, AppColors.muted)),
      const SizedBox(height: 12),
      PrimaryButton('Save changes', _save),
      if (!adding) ...[
        const SizedBox(height: 10),
        OutlineBtn('Delete slot', _delete,
            color: AppColors.redFg, border: AppColors.redBg),
      ],
    ]);
  }
}
