
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/et_widgets.dart';

enum UserRole { student, teacher, admin }

/// Role-specific text, field configuration, and layout.
class _RoleSpec {
  const _RoleSpec({
    required this.idLabel,
    required this.demoId,
    required this.subtitle,
    required this.formNote,
    required this.buttonLabel,
    required this.sectionGap,
    required this.fieldHeight,
    required this.fieldGap,
    required this.labelGap,
    this.showRegisterLink = false,
  });

  final String idLabel;
  final String demoId;

  /// First note displayed above the login form.
  final String subtitle;

  /// Additional role-specific note below the form.
  final String formNote;

  final String buttonLabel;
  final double sectionGap;
  final double fieldHeight;
  final double fieldGap;
  final double labelGap;
  final bool showRegisterLink;
}

const Map<UserRole, _RoleSpec> _specs = {
  UserRole.student: _RoleSpec(
    idLabel: 'Student ID',
    demoId: 'CS-2041',
    subtitle: 'Your classroom camera records attendance automatically.',
    formNote: 'Keep your account details safe.',
    buttonLabel: 'Sign in',
    sectionGap: 22,
    fieldHeight: 54,
    fieldGap: 14,
    labelGap: 6,
    showRegisterLink: true,
  ),
  UserRole.teacher: _RoleSpec(
    idLabel: 'Teacher ID',
    demoId: 'T-1042',
    subtitle: 'Manage your classes and attendance with ease.',
    formNote: 'Use your registered teacher ID and password.',
    buttonLabel: 'Sign in securely',
    sectionGap: 20,
    fieldHeight: 52,
    fieldGap: 12,
    labelGap: 5,
  ),
  UserRole.admin: _RoleSpec(
    idLabel: 'Your Name',
    demoId: 'Admin',
    subtitle: 'Manage rooms, cameras and schedules from one place.',
    formNote: 'Changes are recorded under your name.',
    buttonLabel: 'Sign in as Admin',
    sectionGap: 20,
    fieldHeight: 52,
    fieldGap: 12,
    labelGap: 5,
  ),
};

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole _role = UserRole.teacher;

  final TextEditingController _id =
  TextEditingController(text: 'T-1042');
  final TextEditingController _pw =
  TextEditingController(text: '12345678');

  bool _loading = false;
  bool _submitted = false;

  _RoleSpec get _spec => _specs[_role]!;

  @override
  void dispose() {
    _id.dispose();
    _pw.dispose();
    super.dispose();
  }

  String? get _idError {
    if (!_submitted || _id.text.trim().isNotEmpty) {
      return null;
    }

    return _role == UserRole.admin
        ? 'Enter your name'
        : 'Enter your ${_role == UserRole.student ? 'student' : 'teacher'} ID';
  }

  String? get _pwError {
    if (!_submitted || _pw.text.length >= 6) {
      return null;
    }

    return 'Password must be at least 6 characters';
  }

  void _refresh([String? value]) {
    if (_submitted) {
      setState(() {});
    }
  }

  void _setRole(int index) {
    if (index < 0 || index >= UserRole.values.length) {
      return;
    }

    final UserRole next = UserRole.values[index];
    final String previousDemoId = _specs[_role]!.demoId;

    // Change the demo value only if the user has not entered
    // a custom ID or name.
    if (_id.text == previousDemoId) {
      _id.text = _specs[next]!.demoId;
    }

    setState(() {
      _role = next;
      _submitted = false;
    });
  }

  Future<void> _submit() async {
    if (_loading) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _submitted = true;
    });

    if (_idError != null || _pwError != null) {
      return;
    }

    setState(() {
      _loading = true;
    });

    // Temporary demonstration delay.
    // Replace this with your real authentication service.
    await Future<void>.delayed(
      const Duration(milliseconds: 650),
    );

    if (!mounted) return;

    setState(() {
      _loading = false;
    });

    final NavigatorState nav = Navigator.of(context);

    switch (_role) {
      case UserRole.student:
        nav.pushNamedAndRemoveUntil(
          Routes.studentCourses,
              (route) => false,
        );
        break;

      case UserRole.teacher:
        nav.pushNamedAndRemoveUntil(
          Routes.teacherRooms,
              (route) => false,
        );
        break;

      case UserRole.admin:
        nav.pushNamedAndRemoveUntil(
          Routes.adminDashboard,
              (route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double top = math.max(
      64.0,
      MediaQuery.of(context).padding.top + 20,
    );

    final _RoleSpec spec = _spec;
    final double g = spec.sectionGap;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Decorative background circle.
          Positioned(
            left: -90,
            top: -90,
            child: Container(
              width: 260,
              height: 260,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.blobLarge,
              ),
            ),
          ),

          // Decorative background shape.
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
              padding: EdgeInsets.fromLTRB(
                24,
                top,
                24,
                24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  gap(30),

                  // EduTrack logo.
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
                      child: Text(
                        'E',
                        style: AppText.style(
                          26,
                          FontWeight.w800,
                          Colors.white,
                        ),
                      ),
                    ),
                  ),

                  gap(g),

                  // Welcome heading.
                  Text(
                    'Welcome to\nEduTrack',
                    style: AppText.style(
                      34,
                      FontWeight.w800,
                      AppColors.ink,
                      ls: -0.03,
                      height: 1.1,
                    ),
                  ),

                  gap(8),

                  // Role-specific note above the login form.
                  Text(
                    spec.subtitle,
                    style: AppText.style(
                      13,
                      FontWeight.w400,
                      AppColors.muted,
                      height: 1.5,
                    ),
                  ),

                  gap(g),

                  // Shared role selector.
                  EtSegmented(
                    labels: const [
                      'Student',
                      'Teacher',
                      'Admin',
                    ],
                    selected: _role.index,
                    onChanged: _setRole,
                  ),

                  gap(g),

                  // Student ID, Teacher ID, or Admin name.
                  EtTextField(
                    label: spec.idLabel,
                    controller: _id,
                    height: spec.fieldHeight,
                    labelGap: spec.labelGap,
                    error: _idError,
                    onChanged: _refresh,
                    textInputAction: TextInputAction.next,
                  ),

                  gap(spec.fieldGap),

                  // Shared password field.
                  EtTextField(
                    label: 'Password',
                    controller: _pw,
                    obscure: true,
                    height: spec.fieldHeight,
                    labelGap: spec.labelGap,
                    error: _pwError,
                    onChanged: _refresh,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                  ),

                  gap(g),

                  // Shared sign-in button.
                  EtButton(
                    label: spec.buttonLabel,
                    height: 56,
                    radius: 16,
                    fontSize: 16,
                    shadow: AppShadows.primaryLarge,
                    loading: _loading,
                    onPressed: _submit,
                  ),

                  gap(12),

                  // Role-specific note below the login form.
                  Text(
                    spec.formNote,
                    textAlign: TextAlign.center,
                    style: AppText.style(
                      13,
                      FontWeight.w500,
                      AppColors.muted,
                      height: 1.45,
                    ),
                  ),

                  gap(g),

                  // Shared forgot-password navigation.
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          Routes.reset,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        child: Text(
                          'Forgot password?',
                          style: AppText.style(
                            14,
                            FontWeight.w600,
                            AppColors.muted,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Student-only registration link.
                  if (spec.showRegisterLink) ...[
                    gap(8),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            Routes.studentRegister,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                          ),
                          child: Text(
                            'First time here? Register your face',
                            textAlign: TextAlign.center,
                            style: AppText.style(
                              14,
                              FontWeight.w800,
                              AppColors.link,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
