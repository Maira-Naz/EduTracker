// Add a room camera form with validation.
import 'package:flutter/material.dart';
import '../../core/core.dart';

class AddCameraScreen extends StatefulWidget {
  const AddCameraScreen({super.key});
  @override
  State<AddCameraScreen> createState() => _AddCamState();
}

class _AddCamState extends State<AddCameraScreen> {
  final key = GlobalKey<FormState>();
  final room = TextEditingController(), block = TextEditingController(), cam = TextEditingController();

  @override
  void dispose() {
    room.dispose();
    block.dispose();
    cam.dispose();
    super.dispose();
  }

  String? _req(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  void _save() {
    if (!key.currentState!.validate()) return;
    final m = ScaffoldMessenger.of(context);
    Store.i.addCamera(room.text.trim().toUpperCase(), block.text.trim(), cam.text.trim().toUpperCase());
    Navigator.pop(context);
    m.showSnackBar(const SnackBar(content: Text('Camera added')));
  }

  @override
  Widget build(BuildContext context) => Screen(
        back: true,
        backLabel: 'Rooms',
        title: 'Add a room camera',
        subtitle: 'One camera per classroom',
        children: [
          Form(
            key: key,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const FieldLabel('Room'),
              TextFormField(controller: room, validator: (v) => _req(v) ?? (Store.i.rooms.any((r) => r.id == v!.trim().toUpperCase()) ? 'This room already has a camera' : null), decoration: const InputDecoration(hintText: 'E105')),
              const FieldLabel('Block'),
              TextFormField(controller: block, validator: _req, decoration: const InputDecoration(hintText: 'Block E')),
              const FieldLabel('Camera ID'),
              TextFormField(controller: cam, validator: _req, decoration: const InputDecoration(hintText: 'CAM-E105')),
            ]),
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: _save, child: const Text('Save camera')),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ],
      );
}
