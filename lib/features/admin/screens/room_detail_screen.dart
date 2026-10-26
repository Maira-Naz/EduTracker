import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../data/admin_store.dart';
import '../widgets/admin_widgets.dart';

class RoomDetailScreen extends StatefulWidget {
  const RoomDetailScreen({super.key, required this.room});
  final Room room;
  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  bool _testing = false;

  Future<void> _test() async {
    setState(() => _testing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final r = widget.room;
    r.online = true;
    r.lastSeen = 'today ${fmt(TimeOfDay.now())}';
    adminStore.touch();
    setState(() => _testing = false);
    toast(context, 'Connection OK · ${r.camera} is back online');
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: adminStore,
      builder: (context, _) {
        final r = widget.room;
        return AppPage(children: [
          Header(
            back: 'Cameras',
            title: 'Room ${r.name}',
            sub: r.info,
            trailing: r.online
                ? const Pill('Online', AppColors.greenBg, AppColors.greenFg)
                : const Pill('Offline', AppColors.redBg, AppColors.redFg),
          ),
          const SizedBox(height: 14),
          if (!r.online)
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                  color: AppColors.redBg,
                  borderRadius: BorderRadius.circular(18)),
              child: Text(
                  'Camera lost connection at ${r.lastSeen.split(' ').last}. Attendance in this room needs manual marking until it is back.',
                  style: AppText.style(12, FontWeight.w700, AppColors.redFg,
                      height: 1.4)),
            ),
          AppCard(
            child: Column(children: [
              _row('Camera name', r.camera),
              _div(),
              _row('IP address', r.ip),
              _div(),
              _row('Last seen', r.lastSeen,
                  valueColor: r.online ? null : AppColors.link),
              _div(),
              _row('Installed', r.installed),
            ]),
          ),
          PrimaryButton(_testing ? 'Testing…' : 'Test connection',
              _testing ? () {} : _test),
          const SizedBox(height: 10),
          OutlineBtn('Edit room or camera', () => _edit(context, r)),
          const SizedBox(height: 10),
          Center(
              child: Text('Every edit is saved under your name.',
                  style: AppText.style(11, FontWeight.w600, AppColors.muted))),
        ]);
      },
    );
  }

  void _edit(BuildContext context, Room r) {
    final name = TextEditingController(text: r.camera);
    final ip = TextEditingController(text: r.ip);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Field('Camera name', controller: name),
          const SizedBox(height: 12),
          Field('Camera IP address', controller: ip),
          const SizedBox(height: 16),
          PrimaryButton('Save changes', () {
            r.camera = name.text.trim();
            r.ip = ip.text.trim();
            adminStore.touch();
            Navigator.pop(ctx);
            toast(context, 'Saved under ${adminStore.admin}');
          }),
        ]),
      ),
    );
  }

  Widget _div() => const Divider(height: 1, color: AppColors.divider);
  Widget _row(String k, String v, {Color? valueColor}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(k, style: AppText.style(12, FontWeight.w700, AppColors.ink)),
          Text(v,
              style: AppText.style(
                  12, FontWeight.w600, valueColor ?? AppColors.muted)),
        ]),
      );
}
