// Models and the in-memory demo Store. Replace the Store with your API / database later.
import 'package:flutter/material.dart';

enum Role { student, teacher, admin }

String hm(int m) => '${(m ~/ 60).toString().padLeft(2, '0')}:${(m % 60).toString().padLeft(2, '0')}';

String stamp() {
  final n = TimeOfDay.now();
  return 'Today ${n.hour.toString().padLeft(2, '0')}:${n.minute.toString().padLeft(2, '0')}';
}

String todayLabel() {
  const w = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final n = DateTime.now();
  return '${w[n.weekday - 1]}, ${n.day} ${m[n.month - 1]}';
}

class Room {
  Room(this.id, this.block, this.cam, this.online, [this.since]);
  final String id, block, cam;
  bool online;
  String? since;
}

class Course {
  Course(this.name, this.teacher, this.tid, this.room, this.days, this.start, this.end, this.avg) {
    lateAt = start + 10;
    closeAt = start + 30;
  }
  final String name, teacher, tid, room, days;
  final int start, end, avg;
  late int lateAt, closeAt;
  String get time => '${hm(start)}–${hm(end)}';
}

class Stu {
  Stu(this.name, this.id, this.pct, this.status);
  final String name, id;
  final int pct;
  String status; // Present | Late | Absent | Review
}

class Scan {
  Scan(this.name, this.id, this.course, this.time, this.conf, [this.state = 'pending']);
  final String name, id, course, time;
  final double conf;
  String state; // pending | approved | absent
}

class Audit {
  Audit(this.when, this.text, this.kind);
  final String when, text, kind; // kind: Cameras | Attendance
}

class Sess {
  Sess(this.course, this.status);
  final Course course;
  final String status; // Done | Live | Upcoming
}

/// In-memory demo data. Replace with your API / database layer later.
class Store extends ChangeNotifier {
  Store._();
  static final i = Store._();

  static const _acc = {
    Role.student: ('CS-2041', 'Student'),
    Role.teacher: ('T-1042', 'Ms. Rana'),
    Role.admin: ('HOD-CS', 'Computer Science'),
  };

  Role role = Role.student;
  String uid = '', name = '';
  bool faceRegistered = true;
  String faceUpdated = '12 Sep 2026';

  String get actor => role == Role.admin ? 'You' : name;
  String get initials => name.isEmpty ? '' : name.split(' ').take(2).map((w) => w[0]).join().toUpperCase();

  bool check(Role r, String id, String pw) => id.trim().toUpperCase() == _acc[r]!.$1 && pw == '12345678';
  void signIn(Role r) {
    role = r;
    uid = _acc[r]!.$1;
    name = _acc[r]!.$2;
  }

  void signOut() {
    uid = '';
    name = '';
  }

  final rooms = [
    Room('B204', 'Block B', 'CAM-B204', true),
    Room('A110', 'Block A', 'CAM-A110', true),
    Room('C031', 'Block C', 'CAM-C031', true),
    Room('D012', 'Block D', 'CAM-D012', false, '09:12'),
  ];

  final courses = [
    Course('Data Structures', 'Ms. Rana', 'T-1042', 'B204', 'Mon, Wed', 600, 690, 91),
    Course('Operating Systems', 'Mr. Haider', 'T-1050', 'B204', 'Tue', 720, 810, 86),
    Course('Discrete Math', 'Ms. Rana', 'T-1042', 'A110', 'Tue, Thu', 510, 600, 84),
    Course('Databases', 'Mr. Haider', 'T-1050', 'C031', 'Thu', 540, 630, 78),
    Course('Algorithms', 'Ms. Rana', 'T-1042', 'C031', 'Fri', 780, 870, 72),
  ];

  late final sessions = [
    Sess(courses[2], 'Done'),
    Sess(courses[3], 'Done'),
    Sess(courses[0], 'Live'),
    Sess(courses[1], 'Upcoming'),
    Sess(courses[4], 'Upcoming'),
  ];

  final students = [
    Stu('Sara Khan', 'CS-2001', 96, 'Present'),
    Stu('Zainab Ali', 'CS-2019', 94, 'Present'),
    Stu('Hira Saeed', 'CS-2022', 82, 'Present'),
    Stu('Ali Zafar', 'CS-2044', 73, 'Present'),
    Stu('Bilal Ahmed', 'CS-2012', 68, 'Late'),
    Stu('Nida Farooq', 'CS-2037', 79, 'Review'),
    Stu('Usman Tariq', 'CS-2050', 85, 'Absent'),
    Stu('Maryam Raza', 'CS-2031', 88, 'Absent'),
  ];

  final scans = [
    Scan('Nida Farooq', 'CS-2037', 'Data Structures', '10:09', 71.3),
    Scan('Hira Saeed', 'CS-2022', 'Data Structures', '10:05', 78.2, 'approved'),
    Scan('Ali Zafar', 'CS-2044', 'Data Structures', '10:07', 74.9, 'approved'),
    Scan('Maryam Raza', 'CS-2031', 'Operating Systems', '12:08', 72.8),
    Scan('Usman Tariq', 'CS-2050', 'Operating Systems', '12:11', 70.9),
    Scan('Bilal Ahmed', 'CS-2012', 'Operating Systems', '12:14', 73.3),
    Scan('Zainab Ali', 'CS-2019', 'Databases', '09:06', 75.1),
    Scan('Hira Saeed', 'CS-2022', 'Databases', '09:12', 71.8),
  ];

  final audit = [
    Audit('Today 09:58', 'Ms. Rana closed Discrete Math attendance', 'Attendance'),
    Audit('Today 09:12', 'Camera CAM-D012 went offline', 'Cameras'),
    Audit('Today 08:40', 'Camera CAM-A110 reconnected', 'Cameras'),
    Audit('Today 08:31', 'Mr. Haider approved 2 scans', 'Attendance'),
    Audit('Today 08:02', 'Face data deleted by CS-2088 (own request)', 'Attendance'),
    Audit('Yesterday 16:05', 'You added camera CAM-C031 (Room C031)', 'Cameras'),
    Audit('Yesterday 10:05', 'Ms. Rana changed late time 10:10 to 10:15 (Data Structures)', 'Attendance'),
  ];

  // Student CS-2041: [held, present, late, absent] per course (current semester only)
  final stats = <String, List<int>>{
    'Data Structures': [23, 19, 2, 2],
    'Discrete Math': [19, 14, 2, 3],
    'Databases': [25, 21, 1, 3],
    'Algorithms': [18, 12, 1, 5],
  };
  final absentDays = <String, List<String>>{
    'Data Structures': ['Mon, 12 Oct 2026', 'Wed, 7 Oct 2026'],
    'Discrete Math': ['Thu, 15 Oct 2026', 'Tue, 6 Oct 2026', 'Thu, 24 Sep 2026'],
    'Databases': ['Thu, 8 Oct 2026', 'Thu, 17 Sep 2026', 'Thu, 10 Sep 2026'],
    'Algorithms': ['Fri, 16 Oct 2026', 'Fri, 9 Oct 2026', 'Fri, 2 Oct 2026', 'Fri, 25 Sep 2026', 'Fri, 18 Sep 2026'],
  };

  List<Course> get myCourses => courses.where((c) => stats.containsKey(c.name)).toList();
  int pctOf(Course c) {
    final s = stats[c.name]!;
    return ((s[1] + s[2]) * 100 / s[0]).round();
  }

  int get overall {
    var a = 0, h = 0;
    for (final c in myCourses) {
      final s = stats[c.name]!;
      h += s[0];
      a += s[1] + s[2];
    }
    return (a * 100 / h).round();
  }

  Room roomOf(String id) => rooms.firstWhere((r) => r.id == id);
  Course courseNamed(String n) => courses.firstWhere((c) => c.name == n);
  String statusOf(Course c) => sessions.firstWhere((s) => s.course == c, orElse: () => Sess(c, 'Upcoming')).status;
  int get pendingScans => scans.where((s) => s.state == 'pending').length;
  int get onlineCams => rooms.where((r) => r.online).length;

  void log(String text, String kind) {
    audit.insert(0, Audit(stamp(), text, kind));
    notifyListeners();
  }

  void setTiming(Course c, int late, int close) {
    if (late != c.lateAt) log('$actor changed late time ${hm(c.lateAt)} to ${hm(late)} (${c.name})', 'Attendance');
    if (close != c.closeAt) log('$actor changed closing time ${hm(c.closeAt)} to ${hm(close)} (${c.name})', 'Attendance');
    c.lateAt = late;
    c.closeAt = close;
    notifyListeners();
  }

  void mark(Stu s) {
    s.status = 'Present';
    log('$actor marked ${s.name} present (manual)', 'Attendance');
  }

  void resolveScan(Scan s, bool approve) {
    s.state = approve ? 'approved' : 'absent';
    if (s.course == 'Data Structures') {
      for (final x in students.where((x) => x.id == s.id)) {
        x.status = approve ? 'Present' : 'Absent';
      }
    }
    log('$actor ${approve ? 'approved' : 'marked absent'} scan: ${s.name} (${s.course})', 'Attendance');
  }

  void deleteFace() {
    faceRegistered = false;
    log('Face data deleted by $uid (own request)', 'Attendance');
  }

  void registerFace() {
    faceRegistered = true;
    faceUpdated = 'Today';
    notifyListeners();
  }

  void addCamera(String room, String block, String cam) {
    rooms.add(Room(room, block, cam, true));
    log('You added camera $cam (Room $room)', 'Cameras');
  }

  void reconnect(Room r) {
    r.online = true;
    r.since = null;
    log('Camera ${r.cam} reconnected', 'Cameras');
  }
}

// Average attendance per room. Rows: Today / Week / Term. Columns: rooms (null = no camera data).
const kRoomAvg = [
  [91, 88, 92, null],
  [90, 87, 91, null],
  [88, 86, 90, null],
];
const kRanges = ['Today', 'Week', 'Term'];

int avgFor(int r) {
  final v = kRoomAvg[r].whereType<int>().toList();
  return (v.reduce((a, b) => a + b) / v.length).round();
}
