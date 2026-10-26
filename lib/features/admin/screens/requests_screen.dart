import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../data/admin_store.dart';
import '../widgets/admin_widgets.dart';
import 'request_detail_screen.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});
  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  static const _tabs = ['New', 'In progress', 'Resolved'];
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: adminStore,
      builder: (context, _) {
        int count(String s) =>
            adminStore.requests.where((r) => r.status == s).length;
        final list =
            adminStore.requests.where((r) => r.status == _tabs[_tab]).toList();
        return AppPage(children: [
          const Header(eyebrow: 'Issues sent by teachers', title: 'Requests'),
          const SizedBox(height: 14),
          Segmented(
            labels: [
              'New ${count('New')}',
              'In progress ${count('In progress')}',
              if (count('Resolved') > 0) 'Resolved' else 'Resolved',
            ],
            index: _tab,
            onChanged: (v) => setState(() => _tab = v),
          ),
          const SizedBox(height: 12),
          for (final r in list)
            AppCard(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => RequestDetailScreen(req: r))),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.title,
                            style: AppText.style(
                                13, FontWeight.w800, AppColors.ink,
                                height: 1.25)),
                        const SizedBox(height: 4),
                        Text('${r.teacher} · Room ${r.room} · ${r.ago}',
                            style: AppText.style(
                                10, FontWeight.w600, AppColors.muted)),
                      ]),
                ),
                const SizedBox(width: 8),
                if (r.urgent)
                  const Pill('Urgent', AppColors.redBg, AppColors.redFg)
                else if (r.status == 'New')
                  const Pill('New', AppColors.amberBg, AppColors.amberFg)
                else if (r.status == 'In progress')
                  const Pill('In progress', AppColors.chip, AppColors.deep)
                else
                  const Pill('Resolved', AppColors.greenBg, AppColors.greenFg),
              ]),
            ),
          if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                  child: Text('Nothing here',
                      style: AppText.style(
                          13, FontWeight.w700, AppColors.muted))),
            ),
        ]);
      },
    );
  }
}
