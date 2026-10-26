import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/et_icons.dart';
import '../../core/widgets/et_widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _id = TextEditingController(text: 'T-1042');
  bool _loading = false;
  bool _submitted = false;

  @override
  void dispose() {
    _id.dispose();
    super.dispose();
  }

  String? get _error =>
      _submitted && _id.text.trim().isEmpty ? 'Enter your ID' : null;

  Future<void> _send() async {
    FocusScope.of(context).unfocus();
    setState(() => _submitted = true);
    if (_error != null) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    setState(() => _loading = false);
    final nav = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    nav.pop();
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(const SnackBar(
      content: Text('Code sent to your registered phone'),
      margin: EdgeInsets.fromLTRB(24, 0, 24, 24),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final top = math.max(64.0, MediaQuery.of(context).padding.top + 20);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, top, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const EtBackLink('← Back to sign in'),
            gap(20),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.chip,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const EtLockIcon(size: 28, color: AppColors.deep),
              ),
            ),
            gap(20),
            Text(
              'Reset your password',
              style: AppText.style(32, FontWeight.w800, AppColors.ink,
                  ls: -0.03, height: 1.1),
            ),
            gap(8),
            Text(
              'Enter your ID. We will send a 6-digit code to your registered phone.',
              style: AppText.style(15, FontWeight.w400, AppColors.muted,
                  height: 1.5),
            ),
            gap(20),
            EtTextField(
              label: 'Staff or student ID',
              controller: _id,
              height: 54,
              error: _error,
              onChanged: (_) {
                if (_submitted) setState(() {});
              },
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _send(),
            ),
            gap(20),
            EtButton(
              label: 'Send code',
              height: 56,
              radius: 16,
              fontSize: 16,
              shadow: AppShadows.primaryLarge,
              loading: _loading,
              onPressed: _send,
            ),
            gap(20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                'The code expires in 10 minutes. Your face data is not affected by a password reset.',
                style: AppText.style(13, FontWeight.w400, AppColors.muted,
                    height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
