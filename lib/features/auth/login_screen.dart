import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/et_widgets.dart';

enum UserRole { student, teacher, admin }

/// Keeps digits only, max 6, shown as "482 913".
class SixDigitCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final t = digits.length > 6 ? digits.substring(0, 6) : digits;
    final f = t.length > 3 ? '${t.substring(0, 3)} ${t.substring(3)}' : t;
    return TextEditingValue(
      text: f,
      selection: TextSelection.collapsed(offset: f.length),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _demoIds = {
    UserRole.student: 'S-2041',
    UserRole.teacher: 'T-1042',
    UserRole.admin: 'A-0007',
  };

  UserRole _role = UserRole.teacher;
  final _id = TextEditingController(text: 'T-1042');
  final _pw = TextEditingController(text: '12345678');
  final _code = TextEditingController(text: '482 913');
  bool _loading = false;
  bool _submitted = false;

  @override
  void dispose() {
    _id.dispose();
    _pw.dispose();
    _code.dispose();
    super.dispose();
  }

  String get _idLabel {
    switch (_role) {
      case UserRole.student:
        return 'Student ID';
      case UserRole.teacher:
        return 'Staff ID';
      case UserRole.admin:
        return 'Admin ID';
    }
  }

  String? get _idError =>
      _submitted && _id.text.trim().isEmpty ? 'Enter your ID' : null;
  String? get _pwError => _submitted && _pw.text.length < 6
      ? 'Password must be at least 6 characters'
      : null;
  String? get _codeError =>
      _submitted && _code.text.replaceAll(' ', '').length != 6
          ? 'Enter the 6-digit code'
          : null;

  void _refresh([String? _]) {
    if (_submitted) setState(() {});
  }

  void _setRole(int i) {
    final next = UserRole.values[i];
    if (_id.text == _demoIds[_role]) _id.text = _demoIds[next]!;
    setState(() => _role = next);
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _submitted = true);
    if (_idError != null || _pwError != null || _codeError != null) return;

    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) return;
    setState(() => _loading = false);

    switch (_role) {
      case UserRole.teacher:
        Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.teacherRooms, (r) => false);
        break;
      case UserRole.student:
        Navigator.of(context)
            .pushNamed(Routes.comingSoon, arguments: 'Student');
        break;
      case UserRole.admin:
        Navigator.of(context).pushNamed(Routes.comingSoon, arguments: 'Admin');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = math.max(64.0, MediaQuery.of(context).padding.top + 20);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned(
            left: -90,
            top: -90,
            child: Container(
              width: 260,
              height: 260,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.blobLarge),
            ),
          ),
          Positioned(
            right: -30,
            top: 60,
            child: Transform.rotate(
              angle: 20 * math.pi / 180,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: AppColors.blobSmall,
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, top, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  gap(30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 60,
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppShadows.logo,
                      ),
                      child: Text('E',
                          style: AppText.style(
                              26, FontWeight.w800, Colors.white)),
                    ),
                  ),
                  gap(20),
                  Text(
                    'Welcome to\nEduTrack',
                    style: AppText.style(34, FontWeight.w800, AppColors.ink,
                        ls: -0.03, height: 1.1),
                  ),
                  gap(8),
                  Text(
                    'Sign in to manage attendance. Your classroom camera does the marking.',
                    style: AppText.style(15, FontWeight.w400, AppColors.muted,
                        height: 1.5),
                  ),
                  gap(20),
                  EtSegmented(
                    labels: const ['Student', 'Teacher', 'Admin'],
                    selected: _role.index,
                    onChanged: _setRole,
                  ),
                  gap(20),
                  EtTextField(
                    label: _idLabel,
                    controller: _id,
                    error: _idError,
                    onChanged: _refresh,
                    textInputAction: TextInputAction.next,
                  ),
                  gap(12),
                  EtTextField(
                    label: 'Password',
                    controller: _pw,
                    obscure: true,
                    error: _pwError,
                    onChanged: _refresh,
                    textInputAction: TextInputAction.next,
                  ),
                  gap(12),
                  EtTextField(
                    label: '6-digit code sent to your registered phone',
                    controller: _code,
                    weight: FontWeight.w700,
                    letterSpacingEm: 0.18,
                    keyboardType: TextInputType.number,
                    inputFormatters: [SixDigitCodeFormatter()],
                    error: _codeError,
                    onChanged: _refresh,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                  ),
                  gap(20),
                  EtButton(
                    label: 'Sign in securely',
                    height: 56,
                    radius: 16,
                    fontSize: 16,
                    shadow: AppShadows.primaryLarge,
                    loading: _loading,
                    onPressed: _submit,
                  ),
                  gap(20),
                  Center(
                    child: InkWell(
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.reset),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text('Forgot password?',
                            style: AppText.style(
                                14, FontWeight.w600, AppColors.muted)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
