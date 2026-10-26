import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/reset_password_screen.dart';
import '../../features/auth/coming_soon_screen.dart';
import '../../features/teacher/teacher_class_list_screen.dart';
import '../../features/teacher/teacher_reports_screen.dart';
import '../../features/teacher/teacher_review_detail_screen.dart';
import '../../features/teacher/teacher_review_screen.dart';
import '../../features/teacher/teacher_room_screen.dart';
import '../../features/teacher/teacher_rooms_screen.dart';

class Routes {
  Routes._();

  static const login = '/';
  static const reset = '/reset';
  static const comingSoon = '/coming-soon';

  // Teacher
  static const teacherRooms = '/teacher/rooms';
  static const teacherRoom = '/teacher/room';
  static const teacherClassList = '/teacher/class-list';
  static const teacherReview = '/teacher/review';
  static const teacherReviewDetail = '/teacher/review/detail';
  static const teacherReports = '/teacher/reports';
}

class ClassListArgs {
  const ClassListArgs(this.sessionId, [this.initial = AttendanceStatus.absent]);
  final String sessionId;
  final AttendanceStatus initial;
}

class AppRouter {
  AppRouter._();

  /// Bottom-nav destinations switch instantly (no slide animation).
  static const _tabRoutes = {
    Routes.teacherRooms,
    Routes.teacherReview,
    Routes.teacherReports,
  };

  static Route<dynamic> onGenerate(RouteSettings settings) {
    final Widget page;
    switch (settings.name) {
      case Routes.reset:
        page = const ResetPasswordScreen();
        break;
      case Routes.comingSoon:
        page = ComingSoonScreen(role: settings.arguments as String);
        break;
      case Routes.teacherRooms:
        page = const TeacherRoomsScreen();
        break;
      case Routes.teacherRoom:
        page = TeacherRoomScreen(sessionId: settings.arguments as String);
        break;
      case Routes.teacherClassList:
        page = TeacherClassListScreen(args: settings.arguments as ClassListArgs);
        break;
      case Routes.teacherReview:
        page = const TeacherReviewScreen();
        break;
      case Routes.teacherReviewDetail:
        page = TeacherReviewDetailScreen(scanId: settings.arguments as String);
        break;
      case Routes.teacherReports:
        page = const TeacherReportsScreen();
        break;
      case Routes.login:
      default:
        page = const LoginScreen();
    }

    if (_tabRoutes.contains(settings.name)) {
      return PageRouteBuilder<void>(
        settings: settings,
        pageBuilder: (_, __, ___) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );
    }
    return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
  }
}
