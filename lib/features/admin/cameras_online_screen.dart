// All cameras with status (from Overview tile).
import 'package:flutter/material.dart';
import '../../core/core.dart';
import 'room_card.dart';
import 'room_live_screen.dart';
import 'room_offline_screen.dart';

class CamerasOnlineScreen extends StatelessWidget {
  const CamerasOnlineScreen({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) {
          final s = Store.i;
          return Screen(
            back: true,
            backLabel: 'Overview',
            title: 'Cameras online',
            subtitle: '${s.onlineCams} of ${s.rooms.length} cameras are streaming',
            children: [
              for (final r in s.rooms)
                RoomCard(r,
                    sub: r.online ? '${r.cam} · 24 fps' : '${r.cam} · offline since ${r.since ?? 'earlier'}',
                    onTap: () => go(context, r.online ? RoomLiveScreen(r) : RoomOfflineScreen(r))),
            ],
          );
        },
      );
}
