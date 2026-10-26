import 'package:flutter/foundation.dart';

import 'models.dart';
import 'student_models.dart';

class StudentStore extends ChangeNotifier {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct',
    'Nov', 'Dec',
  ];

  // Profile
  final String studentId = 'CS-2041';
  final String name = 'Ayesha Khan';
  final String program = 'BS Computer Science';
  final String phoneMasked = '+92 3•• ••• 4821';

  // Attendance
  final int overallPercent = 88;
  final List<StudentCourse> courses = const [
    StudentCourse(
      id: 'ds',
      name: 'Data Structures',
      teacher: 'Ms. Rana',
      room: 'B204',
      totalSessions: 22,
      attended: 20,
      recent: [
        SessionRecord('Fri 23 Oct', AttendanceStatus.present, '10:01'),
        SessionRecord('Wed 21 Oct', AttendanceStatus.present, '10:03'),
        SessionRecord('Mon 19 Oct', AttendanceStatus.present, '10:00'),
        SessionRecord('Fri 16 Oct', AttendanceStatus.late, '10:12'),
      ],
    ),
    StudentCourse(
      id: 'dm',
      name: 'Discrete Math',
      teacher: 'Mr. Haider',
      room: 'A110',
      totalSessions: 19,
      attended: 16,
      recent: [
        SessionRecord('Thu 22 Oct', AttendanceStatus.present, '08:02'),
        SessionRecord('Tue 20 Oct', AttendanceStatus.present, '08:00'),
        SessionRecord('Thu 15 Oct', AttendanceStatus.absent),
        SessionRecord('Tue 13 Oct', AttendanceStatus.present, '08:04'),
      ],
    ),
    StudentCourse(
      id: 'algo',
      name: 'Algorithms',
      teacher: 'Ms. Rana',
      room: 'C031',
      totalSessions: 25,
      attended: 18,
      recent: [
        SessionRecord('Fri 23 Oct', AttendanceStatus.present, '13:02'),
        SessionRecord('Wed 21 Oct', AttendanceStatus.late, '13:14'),
        SessionRecord('Mon 19 Oct', AttendanceStatus.absent),
        SessionRecord('Fri 16 Oct', AttendanceStatus.present, '13:00'),
      ],
    ),
  ];

  // Face ID
  bool faceRegistered = true;
  DateTime faceUpdated = DateTime(2026, 8, 12);
  final int recentMatchScore = 92;
  final int scansNeedingReview = 1;

  // Settings
  bool notifyBelow = true;

  StudentCourse courseById(String id) =>
      courses.firstWhere((c) => c.id == id);

  String get initials {
    final p = name.trim().split(RegExp(r'\s+'));
    return (p.first[0] + p.last[0]).toUpperCase();
  }

  String get faceUpdatedLabel =>
      '${faceUpdated.day} ${_months[faceUpdated.month - 1]} ${faceUpdated.year}';

  void completeFaceRegistration() {
    faceRegistered = true;
    faceUpdated = DateTime.now();
    notifyListeners();
  }

  void setNotifyBelow(bool v) {
    notifyBelow = v;
    notifyListeners();
  }
}
