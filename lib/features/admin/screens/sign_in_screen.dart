import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../data/admin_store.dart';
import '../widgets/admin_widgets.dart';
import 'admin_shell.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _name = TextEditingController(text: 'Hamza Raza');
  final _pass = TextEditingController(text: '12345678');

  void _submit() {
    if (_name.text.trim().isEmpty || _pass.text.isEmpty) {
      toast(context, 'Enter your name and password');
      return;
    }
    adminStore.admin = _name.text.trim();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AdminShell()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(children: [
        Positioned(
          top: -60,
          left: -60,
          child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                  color: AppColors.blobLarge, shape: BoxShape.circle)),
        ),
        Positioned(
          top: 60,
          right: -30,
          child: Transform.rotate(
            angle: 0.35,
            child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: AppColors.blobSmall.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(30))),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            padding: kPad.copyWith(top: 60, bottom: 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 52,
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: AppShadows.logo),
                child: Text('E',
                    style: AppText.style(22, FontWeight.w800, Colors.white)),
              ),
              const SizedBox(height: 14),
              const Pill('Admin', AppColors.chip, AppColors.deep),
              const SizedBox(height: 10),
              Text('Welcome to\nEduTrack', style: AppText.h1(30)),
              const SizedBox(height: 6),
              Text('Sign in to manage rooms, cameras and schedules.',
                  style: AppText.style(12, FontWeight.w600, AppColors.link)),
              const SizedBox(height: 22),
              Field('Your name', controller: _name),
              const SizedBox(height: 14),
              Field('Password', controller: _pass, obscure: true),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(14)),
                child: Text(
                    'Your name is saved with every change you make, so the team can see who updated what.',
                    style: AppText.style(11, FontWeight.w600, AppColors.muted)),
              ),
              const SizedBox(height: 14),
              PrimaryButton('Sign in securely', _submit),
              const SizedBox(height: 14),
              Center(
                child: GestureDetector(
                  onTap: () =>
                      toast(context, 'Password reset link sent to your email'),
                  child: Text('Forgot password?',
                      style: AppText.style(12, FontWeight.w700, AppColors.ink)),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
