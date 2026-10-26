import 'models.dart';

/// One past class session as the student sees it.
class SessionRecord {
  const SessionRecord(this.dateLabel, this.status, [this.seenAt]);
  final String dateLabel; // "Fri 23 Oct"
  final AttendanceStatus status;
  final String? seenAt; // "13:02"
}

class StudentCourse {
  const StudentCourse({
    required this.id,
    required this.name,
    required this.teacher,
    required this.room,
    required this.totalSessions,
    required this.attended,
    required this.recent,
  });

  static const int threshold = 75;

  final String id;
  final String name;
  final String teacher;
  final String room;
  final int totalSessions;
  final int attended; // present + late
  final List<SessionRecord> recent;

  int get percent => (attended * 100 / totalSessions).round();
  int get absent => totalSessions - attended;
  bool get below => percent < threshold;

  /// How many more classes can be missed while staying at or above 75%.
  int get canMiss {
    final k = (attended * 4) ~/ 3 - totalSessions;
    return k < 0 ? 0 : k;
  }
}
