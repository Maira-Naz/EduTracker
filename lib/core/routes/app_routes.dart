
import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../data/admin_store.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/reset_password_screen.dart';

// Student
import '../../features/student/student_account_screen.dart';
import '../../features/student/student_course_detail_screen.dart';
import '../../features/student/student_courses_screen.dart';
import '../../features/student/student_face_id_screen.dart';
import '../../features/student/student_register_screen.dart';
import '../../features/student/student_registered_screen.dart';

// Teacher
import '../../features/teacher/teacher_class_list_screen.dart';
import '../../features/teacher/teacher_reports_screen.dart';
import '../../features/teacher/teacher_review_detail_screen.dart';
import '../../features/teacher/teacher_review_screen.dart';
import '../../features/teacher/teacher_room_screen.dart';
import '../../features/teacher/teacher_rooms_screen.dart';

// Admin
import '../../features/admin/screens/admin_shell.dart';
import '../../features/admin/screens/add_room_screen.dart';
import '../../features/admin/screens/cameras_screen.dart';
import '../../features/admin/screens/edit_slot_screen.dart';
import '../../features/admin/screens/request_detail_screen.dart';
import '../../features/admin/screens/requests_screen.dart';
import '../../features/admin/screens/room_detail_screen.dart';
import '../../features/admin/screens/schedule_screen.dart';
import '../../features/admin/screens/sign_in_screen.dart';

class Routes {
  Routes._();

  static const login = '/';
  static const reset = '/reset';

  // Student
  static const studentRegister = '/student/register';
  static const studentRegistered = '/student/registered';
  static const studentCourses = '/student/courses';
  static const studentCourseDetail = '/student/course';
  static const studentFaceId = '/student/face-id';
  static const studentAccount = '/student/account';

  // Teacher
  static const teacherRooms = '/teacher/rooms';
  static const teacherRoom = '/teacher/room';
  static const teacherClassList = '/teacher/class-list';
  static const teacherReview = '/teacher/review';
  static const teacherReviewDetail = '/teacher/review/detail';
  static const teacherReports = '/teacher/reports';

  // Admin
  static const adminSignIn = '/admin/sign-in';
  static const adminDashboard = '/admin';
  static const adminAddRoom = '/admin/add-room';
  static const adminCameras = '/admin/cameras';
  static const adminEditSlot = '/admin/edit-slot';
  static const adminRequests = '/admin/requests';
  static const adminRequestDetail = '/admin/request/detail';
  static const adminRoomDetail = '/admin/room/detail';
  static const adminSchedule = '/admin/schedule';
}

// Teacher class-list arguments
class ClassListArgs {
  const ClassListArgs(
      this.sessionId, [
        this.initial = AttendanceStatus.absent,
      ]);

  final String sessionId;
  final AttendanceStatus initial;
}

// Admin screen arguments
class EditSlotArgs {
  const EditSlotArgs({
    required this.slot,
    required this.dept,
    required this.sem,
    required this.day,
  });

  final Slot? slot;
  final String dept;
  final String sem;
  final String day;
}

class RequestDetailArgs {
  const RequestDetailArgs(this.req);

  final Request req;
}

class RoomDetailArgs {
  const RoomDetailArgs(this.room);

  final Room room;
}

class AppRouter {
  AppRouter._();

  // Bottom-navigation destinations switch instantly.
  static const _tabRoutes = {
    // Teacher
    Routes.teacherRooms,
    Routes.teacherReview,
    Routes.teacherReports,

    // Student
    Routes.studentCourses,
    Routes.studentFaceId,
    Routes.studentAccount,

    // Admin
    Routes.adminDashboard,
    Routes.adminCameras,
    Routes.adminRequests,
    Routes.adminSchedule,
  };

  static Route<dynamic> onGenerate(RouteSettings settings) {
    final Widget page;

    switch (settings.name) {
    // Authentication
      case Routes.reset:
        page = const ResetPasswordScreen();
        break;

      case Routes.login:
        page = const LoginScreen();
        break;

    // Student
      case Routes.studentRegister:
        page = StudentRegisterScreen(
          reregister: (settings.arguments as bool?) ?? false,
        );
        break;

      case Routes.studentRegistered:
        page = const StudentRegisteredScreen();
        break;

      case Routes.studentCourses:
        page = const StudentCoursesScreen();
        break;

      case Routes.studentCourseDetail:
        page = StudentCourseDetailScreen(
          courseId: settings.arguments as String,
        );
        break;

      case Routes.studentFaceId:
        page = const StudentFaceIdScreen();
        break;

      case Routes.studentAccount:
        page = const StudentAccountScreen();
        break;

    // Teacher
      case Routes.teacherRooms:
        page = const TeacherRoomsScreen();
        break;

      case Routes.teacherRoom:
        page = TeacherRoomScreen(
          sessionId: settings.arguments as String,
        );
        break;

      case Routes.teacherClassList:
        page = TeacherClassListScreen(
          args: settings.arguments as ClassListArgs,
        );
        break;

      case Routes.teacherReview:
        page = const TeacherReviewScreen();
        break;

      case Routes.teacherReviewDetail:
        page = TeacherReviewDetailScreen(
          scanId: settings.arguments as String,
        );
        break;

      case Routes.teacherReports:
        page = const TeacherReportsScreen();
        break;

    // Admin
      case Routes.adminSignIn:
        page = const SignInScreen();
        break;

      case Routes.adminDashboard:
        page = const AdminShell();
        break;

      case Routes.adminAddRoom:
        page = const AddRoomScreen();
        break;

      case Routes.adminCameras:
        page = const CamerasScreen();
        break;

      case Routes.adminEditSlot:
        final args = settings.arguments as EditSlotArgs;

        page = EditSlotScreen(
          slot: args.slot,
          dept: args.dept,
          sem: args.sem,
          day: args.day,
        );
        break;

      case Routes.adminRequests:
        page = const RequestsScreen();
        break;

      case Routes.adminRequestDetail:
        final args = settings.arguments as RequestDetailArgs;

        page = RequestDetailScreen(
          req: args.req,
        );
        break;

      case Routes.adminRoomDetail:
        final args = settings.arguments as RoomDetailArgs;

        page = RoomDetailScreen(
          room: args.room,
        );
        break;

      case Routes.adminSchedule:
        page = const ScheduleScreen();
        break;

      default:
      // Unknown routes return to login.
        page = const LoginScreen();
        break;
    }

    if (_tabRoutes.contains(settings.name)) {
      return PageRouteBuilder<dynamic>(
        settings: settings,
        pageBuilder: (_, __, ___) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );
    }

    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) => page,
    );
  }
}
