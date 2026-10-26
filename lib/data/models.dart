/// Minutes since midnight -> "HH:MM".
String fmtTime(int minutes) {
  final h = (minutes ~/ 60).toString().padLeft(2, '0');
  final m = (minutes % 60).toString().padLeft(2, '0');
  return '$h:$m';
}

enum AttendanceStatus { present, late, absent, pending }

class Student {
  Student({
    required this.id,
    required this.name,
    required this.roll,
    required this.status,
    this.seenAt,
  });

  final String id;
  final String name;
  final String roll;
  AttendanceStatus status;

  /// "10:03", or "manual" when the teacher marked the student by hand.
  String? seenAt;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

enum SessionState { running, upcoming, closed }

class ClassSession {
  ClassSession({
    required this.id,
    required this.course,
    required this.room,
    required this.block,
    required this.startMin,
    required this.endMin,
    required this.state,
    required this.students,
    required this.lateAfterMin,
    required this.closeAtMin,
  });

  final String id;
  final String course;
  final String room; // e.g. B204
  final String block; // e.g. B
  final int startMin;
  final int endMin;
  final SessionState state;
  final List<Student> students;
  int lateAfterMin; // absolute minutes since midnight
  int closeAtMin;

  int count(AttendanceStatus s) =>
      students.where((x) => x.status == s).length;

  String get timeRange => '${fmtTime(startMin)}–${fmtTime(endMin)}';
  String get roomLabel => 'Room $room';
  String get roomAndBlock => 'Room $room, Block $block';
}

enum ScanOutcome { approved, markedAbsent }

/// A face scan whose confidence was below the auto-approve threshold.
class ScanReview {
  ScanReview({
    required this.id,
    required this.sessionId,
    this.studentId,
    required this.name,
    required this.roll,
    required this.seenAt,
    required this.confidence,
    this.resolved = false,
    this.outcome,
  });

  final String id;
  final String sessionId;
  final String? studentId;
  final String name;
  final String roll;
  final String seenAt;
  final double confidence; // percent, e.g. 71.3
  bool resolved;
  ScanOutcome? outcome;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  String get confidenceLabel => '${confidence.toStringAsFixed(1)}%';
}

class AtRiskStudent {
  const AtRiskStudent(this.name, this.roll, this.percent);
  final String name;
  final String roll;
  final int percent;
}

class CourseReport {
  const CourseReport({
    required this.course,
    required this.averagePercent,
    required this.sessionCount,
    required this.belowThreshold,
  });

  final String course;
  final int averagePercent;
  final int sessionCount;
  final List<AtRiskStudent> belowThreshold;
}
