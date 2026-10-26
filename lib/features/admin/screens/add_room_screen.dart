import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../data/admin_store.dart';
import '../widgets/admin_widgets.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({super.key});
  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  int _mode = 0; // 0 new room, 1 camera only
  final _block = TextEditingController(text: 'C');
  final _room = TextEditingController(text: 'C032');
  final _cap = TextEditingController(text: '40');
  final _cam = TextEditingController(text: 'C032-CAM-1');
  final _ip = TextEditingController(text: '192.168.4.32');

  void _save() {
    final room = _room.text.trim();
    if (room.isEmpty || _cam.text.trim().isEmpty || _ip.text.trim().isEmpty) {
      toast(context, 'Please fill in all fields');
      return;
    }
    final existing = adminStore.rooms.where((r) => r.name == room).toList();
    if (_mode == 0) {
      if (existing.isNotEmpty) {
        toast(context, 'Room $room already exists');
        return;
      }
      adminStore.addRoom(Room(
        name: room,
        block: _block.text.trim(),
        info: 'Block ${_block.text.trim()} · No class today',
        online: true,
        lastSeen: 'Just added',
        camera: _cam.text.trim(),
        ip: _ip.text.trim(),
        installed: 'Today',
        capacity: int.tryParse(_cap.text) ?? 40,
      ));
    } else {
      if (existing.isEmpty) {
        toast(context, 'Room $room not found. Use "New room" instead.');
        return;
      }
      existing.first
        ..camera = _cam.text.trim()
        ..ip = _ip.text.trim();
      adminStore.touch();
    }
    Navigator.of(context).pop();
    toast(context, 'Added by ${adminStore.admin}');
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(children: [
      const Header(
        back: 'Cameras',
        title: 'Add room',
        sub: 'Register a room and connect its camera',
      ),
      const SizedBox(height: 14),
      Segmented(
        labels: const ['New room', 'Camera only'],
        index: _mode,
        onChanged: (v) => setState(() => _mode = v),
      ),
      const SizedBox(height: 14),
      Row(children: [
        if (_mode == 0) ...[
          Expanded(flex: 2, child: Field('Block', controller: _block)),
          const SizedBox(width: 12),
        ],
        Expanded(
            flex: 3, child: Field('Room number', controller: _room)),
      ]),
      if (_mode == 0) ...[
        const SizedBox(height: 14),
        Field('Seat capacity', controller: _cap, keyboard: TextInputType.number),
      ],
      const SizedBox(height: 14),
      Field('Camera name', controller: _cam),
      const SizedBox(height: 14),
      Field('Camera IP address',
          controller: _ip, keyboard: TextInputType.number),
      const SizedBox(height: 16),
      Text(
          'The camera is tested before saving. It will be recorded as added by ${adminStore.admin}.',
          style: AppText.style(11, FontWeight.w600, AppColors.muted)),
      const SizedBox(height: 12),
      PrimaryButton('Save room and camera', _save),
    ]);
  }
}
