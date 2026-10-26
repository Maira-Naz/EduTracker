import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/et_widgets.dart';
import '../../data/student_store.dart';
import 'student_scaffold.dart';

class StudentAccountScreen extends StatelessWidget {
  const StudentAccountScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Text('Sign out?',
            style: AppText.style(20, FontWeight.w800, AppColors.ink)),
        content: Text('You can sign back in any time with your student ID.',
            style: AppText.style(14, FontWeight.w500, AppColors.muted,
                height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style: AppText.style(14, FontWeight.w700, AppColors.muted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Sign out',
                style: AppText.style(14, FontWeight.w800, AppColors.redFg)),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.login, (r) => false);
    }
  }

  void _changePassword(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _ChangePasswordSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<StudentStore>();
    return StudentScaffold(
      tab: StudentTab.account,
      children: [
        Text('Account', style: AppText.h1()),
        gap(16),
        EtCard(
          radius: 24,
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.primary),
                child: Text(s.initials,
                    style: AppText.style(20, FontWeight.w800, Colors.white)),
              ),
              hgap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.name,
                        style:
                            AppText.style(19, FontWeight.w800, AppColors.ink)),
                    gap(2),
                    Text('${s.studentId} · ${s.program}',
                        style: AppText.style(
                            13, FontWeight.w400, AppColors.muted)),
                  ],
                ),
              ),
            ],
          ),
        ),
        gap(16),
        EtRowList(
          rows: [
            InkWell(
              onTap: () => _changePassword(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Change password',
                        style:
                            AppText.style(15, FontWeight.w700, AppColors.ink)),
                    Text('›',
                        style: AppText.style(
                            16, FontWeight.w400, AppColors.muted)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Registered phone',
                      style: AppText.style(15, FontWeight.w700, AppColors.ink)),
                  Text(s.phoneMasked,
                      style: AppText.style(
                          14, FontWeight.w400, AppColors.muted)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text('Notify me when below 75%',
                        style:
                            AppText.style(15, FontWeight.w700, AppColors.ink)),
                  ),
                  hgap(12),
                  EtSwitch(
                    value: s.notifyBelow,
                    onChanged: (v) {
                      context.read<StudentStore>().setNotifyBelow(v);
                      showEtSnack(
                          context,
                          v
                              ? "We'll notify you when a course drops below 75%"
                              : 'Attendance alerts are off');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        gap(16),
        EtButton(
          label: 'Sign out',
          style: EtButtonStyle.outline,
          onPressed: () => _signOut(context),
          customForeground: AppColors.redFg,
          customBorder: AppColors.signOutBorder,
        ),
      ],
    );
  }
}

class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet();

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();
  bool _submitted = false;
  bool _saving = false;

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String? get _currentErr =>
      _submitted && _current.text.isEmpty ? 'Enter your current password' : null;
  String? get _nextErr => _submitted && _next.text.length < 8
      ? 'Use at least 8 characters'
      : null;
  String? get _confirmErr => _submitted && _confirm.text != _next.text
      ? 'Passwords do not match'
      : null;

  Future<void> _save() async {
    setState(() => _submitted = true);
    if (_currentErr != null || _nextErr != null || _confirmErr != null) return;
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(const SnackBar(
      content: Text('Password updated'),
      margin: EdgeInsets.fromLTRB(24, 0, 24, 96),
    ));
  }

  @override
  Widget build(BuildContext context) {
    void refresh(String _) {
      if (_submitted) setState(() {});
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Change password',
                style: AppText.style(22, FontWeight.w800, AppColors.ink,
                    ls: -0.02)),
            gap(16),
            EtTextField(
              label: 'Current password',
              controller: _current,
              obscure: true,
              error: _currentErr,
              onChanged: refresh,
            ),
            gap(12),
            EtTextField(
              label: 'New password',
              controller: _next,
              obscure: true,
              error: _nextErr,
              onChanged: refresh,
            ),
            gap(12),
            EtTextField(
              label: 'Confirm new password',
              controller: _confirm,
              obscure: true,
              error: _confirmErr,
              onChanged: refresh,
            ),
            gap(18),
            EtButton(
              label: 'Update password',
              height: 54,
              radius: 16,
              shadow: AppShadows.primarySmall,
              loading: _saving,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
