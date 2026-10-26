import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../data/admin_store.dart';
import '../widgets/admin_widgets.dart';
import 'add_room_screen.dart';
import 'room_detail_screen.dart';

class CamerasScreen extends StatefulWidget {
  const CamerasScreen({super.key});
  @override
  State<CamerasScreen> createState() => _CamerasScreenState();
}

class _CamerasScreenState extends State<CamerasScreen> {
  int _filter = 1; // 0 all, 1 online, 2 offline

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: adminStore,
      builder: (context, _) {
        final list = adminStore.rooms
            .where((r) => _filter == 0 || (_filter == 1) == r.online)
            .toList();
        return AppPage(children: [
          Header(
            eyebrow: '${adminStore.total} rooms · ${adminStore.offline} need attention',
            title: 'Cameras',
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: AppColors.deep,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AppShadows.deepCard),
            child: Row(children: [
              _stat('${adminStore.online}', 'Online'),
              const SizedBox(width: 10),
              _stat('${adminStore.offline}', 'Offline'),
            ]),
          ),
          const SizedBox(height: 14),
          Segmented(
            labels: [
              'All ${adminStore.total}',
              'Online ${adminStore.online}',
              'Offline ${adminStore.offline}'
            ],
            index: _filter,
            onChanged: (v) => setState(() => _filter = v),
          ),
          const SizedBox(height: 12),
          OutlineBtn('+ Add room or camera', () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddRoomScreen()));
          }, color: AppColors.primary),
          const SizedBox(height: 12),
          for (final r in list)
            AppCard(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => RoomDetailScreen(room: r))),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Room ${r.name}',
                            style: AppText.style(
                                14, FontWeight.w800, AppColors.ink)),
                        const SizedBox(height: 4),
                        Text(r.info,
                            style: AppText.style(
                                11, FontWeight.w600, AppColors.muted)),
                        const SizedBox(height: 4),
                        Text(
                            r.online ? r.lastSeen : 'Last seen ${r.lastSeen}',
                            style: AppText.style(
                                11, FontWeight.w600, AppColors.muted)),
                      ]),
                ),
                r.online
                    ? const Pill('Online', AppColors.greenBg, AppColors.greenFg)
                    : const Pill('Offline', AppColors.redBg, AppColors.redFg),
              ]),
            ),
          if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                  child: Text('No rooms here',
                      style: AppText.style(
                          13, FontWeight.w700, AppColors.muted))),
            ),
        ]);
      },
    );
  }

  Widget _stat(String n, String label) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(n, style: AppText.style(22, FontWeight.w800, Colors.white)),
            Text(label,
                style: AppText.style(11, FontWeight.w600, AppColors.onDeepMuted)),
          ]),
        ),
      );
}
