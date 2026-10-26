import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../data/admin_store.dart';
import '../widgets/admin_widgets.dart';

class RequestDetailScreen extends StatefulWidget {
  const RequestDetailScreen({super.key, required this.req});
  final Request req;
  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  late final _reply = TextEditingController(text: 'We are checking the camera now.');

  void _setStatus(String s) {
    final r = widget.req..status = s;
    r.seen ??= '${fmt(TimeOfDay.now())} by ${adminStore.admin}';
    adminStore.touch();
    Navigator.of(context).pop();
    toast(context, s == 'Resolved' ? 'Marked as resolved' : 'Marked in progress');
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.req;
    return AppPage(children: [
      Header(
        back: 'Requests',
        title: r.title,
        sub: '${r.teacher} · Room ${r.room} · ${r.ago}',
      ),
      const SizedBox(height: 12),
      Row(children: [
        if (r.urgent) ...[
          const Pill('Urgent', AppColors.redBg, AppColors.redFg),
          const SizedBox(width: 8),
        ],
        Pill(r.tag, AppColors.chip, AppColors.deep),
      ]),
      const SizedBox(height: 14),
      AppCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Message',
              style: AppText.style(12, FontWeight.w800, AppColors.ink)),
          const SizedBox(height: 6),
          Text(r.message,
              style: AppText.style(12, FontWeight.w600, AppColors.link,
                  height: 1.45)),
        ]),
      ),
      AppCard(
        child: Column(children: [
          _row('Sent', r.sent),
          const Divider(height: 1, color: AppColors.divider),
          _row('Seen', r.seen ?? 'Not yet'),
          const Divider(height: 1, color: AppColors.divider),
          _row('Status', r.status),
        ]),
      ),
      Field('Reply to ${r.teacher}', controller: _reply),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(
            child: OutlineBtn('Mark in progress', () => _setStatus('In progress'))),
        const SizedBox(width: 12),
        Expanded(child: PrimaryButton('Resolve', () => _setStatus('Resolved'))),
      ]),
      const SizedBox(height: 10),
      Center(
          child: Text('Status changes are saved under your name.',
              style: AppText.style(11, FontWeight.w600, AppColors.muted))),
    ]);
  }

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(k, style: AppText.style(12, FontWeight.w700, AppColors.ink)),
          Text(v, style: AppText.style(12, FontWeight.w600, AppColors.muted)),
        ]),
      );
}
