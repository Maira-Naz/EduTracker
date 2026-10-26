import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/et_widgets.dart';

/// Placeholder shown until the Student / Admin modules are built.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key, required this.role});
  final String role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('$role module',
                style: AppText.h1(32)),
            gap(8),
            Text(
              'This module is built next. For now, sign in as Teacher.',
              style: AppText.style(15, FontWeight.w400, AppColors.muted,
                  height: 1.5),
            ),
            gap(24),
            EtButton(
              label: 'Back to sign in',
              height: 56,
              radius: 16,
              fontSize: 16,
              shadow: AppShadows.primaryLarge,
              onPressed: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routes.login, (r) => false),
            ),
          ],
        ),
      ),
    );
  }
}
