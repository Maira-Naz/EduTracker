import 'package:flutter/foundation.dart';

import 'models.dart';

/// In-memory data + business rules for the teacher module.
/// Swap the internals for a repository / API later; screens only use this API.
class TeacherStore extends ChangeNotifier {
  TeacherStore() {
    _seed();
  }

  static const double autoApproveThreshold = 75;
  static const int timeStep = 5;

  late final List<ClassSession> sessions;
  late final List<ScanReview> _scans;
  final List<ScanReview> _resolved = []; // newest first
  late final List<CourseReport> reports;

  // ── queries ────────────────────────────────────────────────────────────
  ClassSession sessionById(String id) =>
      sessions.firstWhere((s) => s.id == id);

  List<ClassSession> sessionsWhere(SessionState state) =>
      sessions.where((s) => s.state == state).toList();

  ClassSession? get runningSession {
    final r = sessionsWhere(SessionState.running);
    return r.isEmpty ? null : r.first;
  }

  List<ScanReview> get pendingScans =>
      _scans.where((s) => !s.resolved).toList();

  List<ScanReview> get resolvedScans => List.unmodifiable(_resolved);

  ScanReview scanById(String id) => _scans.firstWhere((s) => s.id == id);

  // ── attendance ─────────────────────────────────────────────────────────
  void markPresent(String sessionId, String studentId) {
    final st = _student(sessionId, studentId);
    st.status = AttendanceStatus.present;
    st.seenAt = 'manual';
    notifyListeners();
  }

  void restoreStatus(String sessionId, String studentId,
      AttendanceStatus status, String? seenAt) {
    final st = _student(sessionId, studentId);
    st.status = status;
    st.seenAt = seenAt;
    notifyListeners();
  }

  void setTiming(String sessionId, int lateAfterMin, int closeAtMin) {
    final s = sessionById(sessionId);
    s.lateAfterMin = lateAfterMin;
    s.closeAtMin = closeAtMin;
    notifyListeners();
  }

  // ── scan review ────────────────────────────────────────────────────────
  void approveScan(String scanId) => _resolve(scanId, ScanOutcome.approved);

  void rejectScan(String scanId) =>
      _resolve(scanId, ScanOutcome.markedAbsent);

  void undoScan(String scanId) {
    final scan = scanById(scanId);
    if (!scan.resolved) return;
    scan.resolved = false;
    scan.outcome = null;
    _resolved.remove(scan);
    if (scan.studentId != null) {
      final st = _student(scan.sessionId, scan.studentId!);
      st.status = AttendanceStatus.pending;
      st.seenAt = scan.seenAt;
    }
    notifyListeners();
  }

  void _resolve(String scanId, ScanOutcome outcome) {
    final scan = scanById(scanId);
    if (scan.resolved) return;
    scan.resolved = true;
    scan.outcome = outcome;
    _resolved.insert(0, scan);
    if (scan.studentId != null) {
      final st = _student(scan.sessionId, scan.studentId!);
      if (outcome == ScanOutcome.approved) {
        st.status = AttendanceStatus.present;
        st.seenAt = scan.seenAt;
      } else {
        st.status = AttendanceStatus.absent;
        st.seenAt = null;
      }
    }
    notifyListeners();
  }

  Student _student(String sessionId, String studentId) =>
      sessionById(sessionId).students.firstWhere((x) => x.id == studentId);

  // ── seed data ──────────────────────────────────────────────────────────
  static const _names = [
    'Ayesha Khan', 'Bilal Ahmed', 'Sana Malik', 'Hamza Sheikh',
    'Zainab Iqbal', 'Ahmed Raza', 'Fatima Noor', 'Omar Farooq',
    'Areeba Shah', 'Daniyal Butt', 'Mahnoor Ali', 'Talha Mehmood',
    'Laiba Aslam', 'Hassan Javed', 'Iqra Younas', 'Saad Qureshi',
    'Noor Fatima', 'Faizan Ali', 'Rida Anwar', 'Zeeshan Haider',
    'Ali Zafar',
  ];

  void _seed() {
    // Data Structures (running): 21 present, 2 late, 3 absent, 1 pending scan.
    final ds = <Student>[
      for (var i = 0; i < _names.length; i++)
        Student(
          id: 'ds$i',
          name: _names[i],
          roll: 'CS-${2100 + i}',
          status: AttendanceStatus.present,
          seenAt: '10:0${i % 9}',
        ),
      Student(
          id: 'dsL0',
          name: 'Kashif Mirza',
          roll: 'CS-2112',
          status: AttendanceStatus.late,
          seenAt: '10:14'),
      Student(
          id: 'dsL1',
          name: 'Amna Siddiqui',
          roll: 'CS-2113',
          status: AttendanceStatus.late,
          seenAt: '10:12'),
      Student(
          id: 'usman',
          name: 'Usman Tariq',
          roll: 'CS-2050',
          status: AttendanceStatus.absent),
      Student(
          id: 'hira',
          name: 'Hira Saeed',
          roll: 'CS-2022',
          status: AttendanceStatus.absent),
      Student(
          id: 'maryam',
          name: 'Maryam Raza',
          roll: 'CS-2031',
          status: AttendanceStatus.absent),
      Student(
          id: 'nida',
          name: 'Nida Farooq',
          roll: 'CS-2037',
          status: AttendanceStatus.pending,
          seenAt: '10:09'),
    ];

    // Algorithms (upcoming): nobody scanned yet.
    final algo = <Student>[
      for (var i = 0; i < 24; i++)
        Student(
          id: 'al$i',
          name: i < _names.length ? _names[i] : 'Usman Tariq',
          roll: 'CS-${2100 + i}',
          status: AttendanceStatus.pending,
        ),
    ];

    // Discrete Math (closed): final result.
    final dm = <Student>[
      for (var i = 0; i < 20; i++)
        Student(
          id: 'dm$i',
          name: _names[i],
          roll: 'CS-${2100 + i}',
          status: AttendanceStatus.present,
          seenAt: '08:0${i % 9}',
        ),
      Student(
          id: 'dmL',
          name: 'Kashif Mirza',
          roll: 'CS-2112',
          status: AttendanceStatus.late,
          seenAt: '08:13'),
      Student(
          id: 'dmA0',
          name: 'Usman Tariq',
          roll: 'CS-2050',
          status: AttendanceStatus.absent),
      Student(
          id: 'dmA1',
          name: 'Maryam Raza',
          roll: 'CS-2031',
          status: AttendanceStatus.absent),
    ];

    sessions = [
      ClassSession(
        id: 'ds',
        course: 'Data Structures',
        room: 'B204',
        block: 'B',
        startMin: 10 * 60,
        endMin: 11 * 60 + 30,
        state: SessionState.running,
        students: ds,
        lateAfterMin: 10 * 60 + 10,
        closeAtMin: 10 * 60 + 30,
      ),
      ClassSession(
        id: 'algo',
        course: 'Algorithms',
        room: 'C031',
        block: 'C',
        startMin: 13 * 60,
        endMin: 14 * 60 + 30,
        state: SessionState.upcoming,
        students: algo,
        lateAfterMin: 13 * 60 + 10,
        closeAtMin: 13 * 60 + 30,
      ),
      ClassSession(
        id: 'dm',
        course: 'Discrete Math',
        room: 'A110',
        block: 'A',
        startMin: 8 * 60,
        endMin: 9 * 60 + 30,
        state: SessionState.closed,
        students: dm,
        lateAfterMin: 8 * 60 + 10,
        closeAtMin: 8 * 60 + 30,
      ),
    ];

    final pending = ScanReview(
      id: 'scan-nida',
      sessionId: 'ds',
      studentId: 'nida',
      name: 'Nida Farooq',
      roll: 'CS-2037',
      seenAt: '10:09',
      confidence: 71.3,
    );
    final r1 = ScanReview(
      id: 'scan-hira',
      sessionId: 'ds',
      name: 'Hira Saeed',
      roll: 'CS-2022',
      seenAt: '10:04',
      confidence: 78.2,
      resolved: true,
      outcome: ScanOutcome.approved,
    );
    final r2 = ScanReview(
      id: 'scan-ali',
      sessionId: 'ds',
      name: 'Ali Zafar',
      roll: 'CS-2120',
      seenAt: '10:02',
      confidence: 74.9,
      resolved: true,
      outcome: ScanOutcome.approved,
    );
    _scans = [pending, r1, r2];
    _resolved.addAll([r1, r2]);

    reports = const [
      CourseReport(
        course: 'Data Structures',
        averagePercent: 86,
        sessionCount: 14,
        belowThreshold: [
          AtRiskStudent('Usman Tariq', 'CS-2050', 64),
          AtRiskStudent('Hira Saeed', 'CS-2022', 71),
          AtRiskStudent('Maryam Raza', 'CS-2031', 73),
        ],
      ),
      CourseReport(
        course: 'Algorithms',
        averagePercent: 91,
        sessionCount: 12,
        belowThreshold: [
          AtRiskStudent('Nida Farooq', 'CS-2037', 68),
          AtRiskStudent('Daniyal Butt', 'CS-2109', 72),
        ],
      ),
    ];
  }
}
