// Row card for one room/camera (used by two screens).
import 'package:flutter/material.dart';
import '../../core/core.dart';

class RoomCard extends StatelessWidget {
  const RoomCard(this.r, {required this.onTap, this.sub});
  final Room r;
  final VoidCallback onTap;
  final String? sub;
  @override
  Widget build(BuildContext context) => AppCard(
        onTap: onTap,
        child: Item('Room ${r.id}',
            sub: sub ?? '${r.cam}, ${r.block}',
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: r.online ? kVioletBg : kRedBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(r.online ? Icons.videocam : Icons.videocam_off, color: r.online ? kViolet : kRed),
            ),
            trailing: Pill(r.online ? 'Online' : 'Offline', r.online ? Tone.green : Tone.red)),
      );
}
