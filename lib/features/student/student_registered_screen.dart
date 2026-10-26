import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/et_icons.dart';
import '../../core/widgets/et_widgets.dart';
import '../../data/student_store.dart';

class StudentRegisteredScreen extends StatelessWidget {
  const StudentRegisteredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StudentStore>();
    final top = math.max(96.0, MediaQuery.of(context).padding.top + 52);
    final bottom = math.max(24.0, MediaQuery.of(context).padding.bottom);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, top, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(79, 70, 229, 0.35),
                          offset: Offset(0, 16),
                          blurRadius: 32,
                        ),
                      ],
                    ),
                    child: const EtCheckIcon(size: 56, color: Colors.white),
                  ),
                  gap(28),
                  Text('You are registered',
                      textAlign: TextAlign.center,
                      style: AppText.style(32, FontWeight.w800, AppColors.ink,
                          ls: -0.03, height: 1.1)),
                  gap(20),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Text(
                      'From now on, the camera in your classroom marks your attendance. Nothing else to do.',
                      textAlign: TextAlign.center,
                      style: AppText.style(15, FontWeight.w400, AppColors.muted,
                          height: 1.55),
                    ),
                  ),
                  gap(30),
                  SizedBox(
                    width: double.infinity,
                    child: EtCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Student ID',
                                  style: AppText.style(
                                      13, FontWeight.w400, AppColors.muted)),
                              Text(store.studentId,
                                  style: AppText.style(
                                      18, FontWeight.w800, AppColors.ink)),
                            ],
                          ),
                          EtPill('Face active',
                              bg: AppColors.greenBg, fg: AppColors.greenFg),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 24, bottom),
            child: EtButton(
              label: 'See my courses',
              height: 56,
              radius: 16,
              fontSize: 16,
              shadow: AppShadows.primaryLarge,
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.studentCourses, (r) => false),
            ),
          ),
        ],
      ),
    );
  }
}
