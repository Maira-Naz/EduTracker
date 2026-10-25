// List of department rooms and the Add camera button.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import 'add_camera_screen.dart';
import '../auth/profile_menu.dart';
import 'room_card.dart';
import 'room_courses_screen.dart';

class RoomsTabAdmin extends StatelessWidget {
  const RoomsTabAdmin({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) => Screen(
          title: 'Rooms and cameras',
          subtitle: 'One camera per classroom',
          trailing: const ProfileMenu(),
          children: [
            for (final r in Store.i.rooms) RoomCard(r, onTap: () => go(context, RoomCoursesScreen(r))),
            const SizedBox(height: 16),
            FilledButton.icon(onPressed: () => go(context, const AddCameraScreen()), icon: const Icon(Icons.add), label: const Text('Add a room camera')),
          ],
        ),
      );
}
