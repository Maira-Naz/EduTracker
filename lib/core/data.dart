// Models and the in-memory demo Store (sample data from the design).
// Replace Store with your API / Firebase layer later; screens only talk to Store.
import 'package:flutter/material.dart';

enum Role { student, teacher, admin }

String hm(int m) => '${(m ~/ 60).toString().padLeft(2, '0')}:${(m % 60).toString().padLeft(2, '0')}';

String nowHm() {
  final n = TimeOfDay.now();
  return hm(n.hour * 60 + n.minute);
}

String todayLabel() {
  const w = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final n = DateTime.now();
  return '${w[n.weekday - 1]}, ${n.day} ${m[n.month - 1]}';
}

class Room {
  Room(this.id, this.name, this.block, this.online, {this.since});
  final String id, name, block;
  bool online;
  String? since;
  String get cam => 'cam-${id.toLowerCase()}';
}

class Course {
  Course(this.name, this.teacher, this.tid, this.room, this.days, this.start, this.end, this.avg, this.enrolled, [this.present = 0]) {
    lateAt = start + 10;
    closeAt = start + 30;
  }
  final String name, teacher, tid, room, days;
  final int start, end, avg, enrolled, present;
  late int lateAt, closeAt;
  String get time => '${hm(start)}–${hm(end)}';
}

class Stu {
  Stu(this.name, this.id, this.pct, this.status, {this.face = true});
  final String name, id;
  final int pct;
  final bool face;
  String status; // Present | Late | Absent
  int get absences => ((100 - pct) * 14 / 100).round();
}

class Scan {
  Scan(this.name, this.id, this.course, this.time, this.conf, [this.state = 'pending']);
  final String name, id, course, time;
  final double conf;
  String state; // pending | approved | absent
}

class Audit {
  Audit(this.title, this.sub, this.kind);
  final String title, sub, kind; // kind: Cameras | Attendance
}

class Sess {
  Sess(this.course, this.status);
  final Course course;
  final String status; // Closed | Live | Next | No camera | Later
}

class CamEvent {
  const CamEvent(this.title, this.when, this.color);
  final String title, when;
  final Color color;
}

class Store extends ChangeNotifier {
  Store._();
  static final i = Store._();

  // ---------- accounts ----------
  static const _acc = {
    Role.student: ('CS-2041', 'Ayesha Khan'),
    Role.teacher: ('T-1042', 'Ms. Rana'),
    Role.admin: ('HOD-01', 'Computer Science'),
  };
  static String demoPassword = '12345678';
  static const demoCode = {Role.teacher: '482913', Role.admin: '204771'};

  Role role = Role.student;
  String uid = '', name = '';
  String get actor => role == Role.admin ? 'You' : name;

  bool check(Role r, String id, String pw, String code) {
    if (id.trim().toUpperCase() != _acc[r]!.$1 || pw != demoPassword) return false;
    if (r == Role.student) return true;
    return code.replaceAll(' ', '') == demoCode[r];
  }

  void signIn(Role r) {
    role = r;
    uid = _acc[r]!.$1;
    name = _acc[r]!.$2;
  }

  void signOut() {
    uid = '';
    name = '';
  }

  // ---------- rooms and courses ----------
  final rooms = [
    Room('B204', 'Room B204', 'Block B', true),
    Room('A110', 'Room A110', 'Block A', true),
    Room('C031', 'Room C031', 'Block C', false, since: '09:42'),
    Room('B101', 'Room B101', 'Block B', true),
    Room('A205', 'Room A205', 'Block A', true),
    Room('L2', 'Lab L2', 'Block C', true),
  ];

  final courses = [
    Course('Data Structures', 'Ms. Rana', 'T-1042', 'B204', 'Mon, Wed', 600, 690, 91, 26, 21),
    Course('Software Engineering', 'Dr. Iqbal', 'T-1077', 'B204', 'Fri', 870, 960, 88, 28),
    Course('Technical Writing', 'Mr. Haider', 'T-1050', 'B204', 'Tue', 720, 810, 90, 30),
    Course('Discrete Math', 'Ms. Rana', 'T-1042', 'A110', 'Tue, Thu', 510, 600, 84, 30),
    Course('Operating Systems', 'Mr. Haider', 'T-1050', 'A110', 'Mon, Fri', 600, 690, 88, 24, 17),
    Course('Algorithms', 'Ms. Rana', 'T-1042', 'C031', 'Fri', 780, 870, 72, 27),
    Course('Web Engineering', 'Dr. Iqbal', 'T-1077', 'C031', 'Thu', 540, 630, 89, 25),
    Course('Databases', 'Mr. Haider', 'T-1050', 'B101', 'Fri', 690, 780, 84, 29),
    Course('Artificial Intelligence', 'Dr. Iqbal', 'T-1077', 'B101', 'Wed', 540, 630, 90, 31),
    Course('Calculus II', 'Dr. Iqbal', 'T-1077', 'A205', 'Mon, Fri', 510, 600, 79, 33),
    Course('Networks Lab', 'Mr. Haider', 'T-1050', 'L2', 'Fri', 870, 960, 66, 20),
  ];

  Course course(String n) => courses.firstWhere((c) => c.name == n);
  Room roomOf(String id) => rooms.firstWhere((r) => r.id == id);
  List<Course> coursesIn(String roomId) => courses.where((c) => c.room == roomId).toList();
  List<Course> get myTeaching => courses.where((c) => c.tid == uid).toList();
  int get onlineCams => rooms.where((r) => r.online).length;

  late final sessions = [
    Sess(course('Calculus II'), 'Closed'),
    Sess(course('Discrete Math'), 'Closed'),
    Sess(course('Data Structures'), 'Live'),
    Sess(course('Operating Systems'), 'Live'),
    Sess(course('Databases'), 'Next'),
    Sess(course('Algorithms'), 'No camera'),
    Sess(course('Software Engineering'), 'Later'),
    Sess(course('Networks Lab'), 'Later'),
  ];

  Sess? nextIn(String roomId) {
    for (final s in sessions) {
      if (s.course.room == roomId && s.status != 'Closed') return s;
    }
    return null;
  }

  // ---------- Data Structures roster (26 students) ----------
  late final roster = _makeRoster();
  List<Stu> _makeRoster() {
    final out = <Stu>[
      Stu('Ayesha Khan', 'CS-2041', 88, 'Present'),
      Stu('Nida Farooq', 'CS-2037', 82, 'Present'),
      Stu('Ali Zafar', 'CS-2018', 86, 'Present'),
      Stu('Hira Saeed', 'CS-2022', 71, 'Present'),
      Stu('Usman Tariq', 'CS-2050', 64, 'Absent'),
      Stu('Maryam Raza', 'CS-2031', 73, 'Absent'),
      Stu('Fatima Noor', 'CS-2066', 90, 'Absent'),
    ];
    const first = ['Sara', 'Zainab', 'Omar', 'Hamza', 'Iqra', 'Taha', 'Mahnoor', 'Danish', 'Rida', 'Saad', 'Laiba', 'Ahsan', 'Komal', 'Faizan', 'Noor', 'Hassan', 'Amna', 'Eman', 'Junaid'];
    const last = ['Khan', 'Ali', 'Malik', 'Sheikh', 'Butt', 'Chaudhry', 'Qureshi', 'Mirza'];
    for (var k = 0; k < first.length; k++) {
      out.add(Stu('${first[k]} ${last[(k * 3) % 8]}', 'CS-${2100 + k}', 78 + (k * 7) % 20, k < 2 ? 'Late' : 'Present'));
    }
    return out;
  }

  int count(String status) => roster.where((x) => x.status == status).length;

  /// All students of the department (admin Students tab).
  late final directory = [
    ...roster,
    Stu('Zain Malik', 'CS-2060', 78, 'Absent', face: false),
    Stu('Bilal Shah', 'CS-2071', 68, 'Absent'),
    Stu('Sana Aslam', 'CS-2072', 83, 'Absent'),
  ];

  /// Students below 75% for [c] (sample: derived from roster).
  List<Stu> lowest(Course c, {int? limit}) {
    final shift = c.avg - 91;
    final list = roster.where((s) => s.pct + shift < 75).toList()..sort((a, b) => a.pct.compareTo(b.pct));
    return limit == null ? list : list.take(limit).toList();
  }

  int pctFor(Stu s, Course c) => (s.pct + c.avg - 91).clamp(0, 100).toInt();

  String csvFor(Course c) {
    final b = StringBuffer('Name,ID,Attendance %,Absences\n');
    for (final s in roster) {
      b.writeln('${s.name},${s.id},${pctFor(s, c)},${s.absences}');
    }
    return b.toString();
  }

  // ---------- scans ----------
  final scans = [
    Scan('Nida Farooq', 'CS-2037', 'Data Structures', '10:09', 71.3),
    Scan('Hira Saeed', 'CS-2022', 'Data Structures', '10:05', 78.2, 'approved'),
    Scan('Ali Zafar', 'CS-2018', 'Data Structures', '10:07', 74.9, 'approved'),
    Scan('Bilal Shah', 'CS-2071', 'Operating Systems', '10:12', 68.0),
    Scan('Sana Aslam', 'CS-2072', 'Operating Systems', '10:14', 73.5),
    Scan('Zain Malik', 'CS-2060', 'Calculus II', '08:41', 70.8),
  ];
  int get pendingScans => scans.where((s) => s.state == 'pending').length;

  // ---------- audit trail ----------
  final audit = [
    Audit('Ms. Rana approved Hira Saeed', 'Data Structures · today 10:12 · scan 78.2%', 'Attendance'),
    Audit('Ms. Rana approved Ali Zafar', 'Data Structures · today 10:11 · scan 74.9%', 'Attendance'),
    Audit('You viewed live camera B204', 'Today 10:09', 'Cameras'),
    Audit('Camera cam-c031 went offline', 'Room C031 · today 09:42', 'Cameras'),
    Audit('Mr. Haider marked Usman Tariq present', 'Operating Systems · yesterday 10:20 · manual', 'Attendance'),
    Audit('Dr. Iqbal marked Zain Malik absent', 'Calculus II · Wed 21 Oct · scan rejected', 'Attendance'),
    Audit('Camera cam-b204 back online', 'Tue 20 Oct 08:21', 'Cameras'),
    Audit('cam-b204 went offline', 'Tue 20 Oct 07:40 · 41 min', 'Cameras'),
    Audit('Ms. Rana changed late time to 10:10', 'Data Structures · Mon 19 Oct', 'Attendance'),
    Audit('You added camera cam-b101', 'Mon 12 Oct 15:30', 'Cameras'),
  ];

  // ---------- camera history ----------
  List<CamEvent> eventsFor(Room r) {
    if (r.id == 'B204') {
      return const [
        CamEvent('Back online', 'Tue 20 Oct, 08:21', kDotGreenC),
        CamEvent('Went offline', 'Tue 20 Oct, 07:40 · power cut, 41 min', kDotRedC),
        CamEvent('Firmware updated', 'Sat 17 Oct, 22:05', kPrimaryC),
      ];
    }
    if (!r.online) {
      return [CamEvent('Went offline', 'Today, ${r.since ?? '09:42'} · network unreachable', kDotRedC), const CamEvent('Firmware updated', 'Sat 17 Oct, 22:05', kPrimaryC)];
    }
    return const [CamEvent('Back online', 'Mon 19 Oct, 08:05', kDotGreenC), CamEvent('Firmware updated', 'Sat 17 Oct, 22:05', kPrimaryC)];
  }

  /// Uptime per day (Sat..Fri) as 0..1 and the overall percentage.
  List<double> uptimeBars(Room r) => r.id == 'B204' ? [1, 1, 1, 0.7, 1, 1, 1] : (r.online ? [1, 1, 1, 1, 1, 1, 1] : [1, 1, 1, 1, 1, 1, 0.55]);
  String uptimeText(Room r) => r.id == 'B204' ? '99.2%' : (r.online ? '100%' : '94.6%');

  // ---------- student (Ayesha Khan, CS-2041) ----------
  final stats = <String, List<int>>{
    'Data Structures': [23, 19, 2, 2],
    'Discrete Math': [19, 14, 2, 3],
    'Algorithms': [18, 12, 1, 5],
  };
  final recent = <String, List<(String, String, String)>>{
    'Data Structures': [('Wed 21 Oct', 'Seen 10:02', 'Present'), ('Mon 19 Oct', 'Not seen', 'Absent'), ('Wed 14 Oct', 'Seen 10:12', 'Late'), ('Mon 12 Oct', 'Not seen', 'Absent')],
    'Discrete Math': [('Thu 22 Oct', 'Seen 08:31', 'Present'), ('Tue 20 Oct', 'Not seen', 'Absent'), ('Thu 15 Oct', 'Seen 08:41', 'Late'), ('Tue 13 Oct', 'Seen 08:29', 'Present')],
    'Algorithms': [('Fri 23 Oct', 'Seen 13:02', 'Present'), ('Wed 21 Oct', 'Seen 13:14', 'Late'), ('Mon 19 Oct', 'Not seen', 'Absent'), ('Fri 16 Oct', 'Seen 13:00', 'Present')],
  };
  bool faceRegistered = true;
  String faceUpdated = '12 Aug 2026';
  bool notifyLow = true;

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

  /// How many more classes can be missed while staying at 75% or above.
  int canMiss(Course c) {
    final s = stats[c.name]!;
    final attended = s[1] + s[2];
    var m = 0;
    while (attended * 100 / (s[0] + m + 1) >= 75) {
      m++;
    }
    return m;
  }

  // ---------- actions ----------
  void _log(String title, String sub, String kind) {
    audit.insert(0, Audit(title, sub, kind));
    notifyListeners();
  }

  void setTiming(Course c, int late, int close) {
    if (late != c.lateAt) _log('$actor changed late time to ${hm(late)}', '${c.name} · today ${nowHm()}', 'Attendance');
    if (close != c.closeAt) _log('$actor changed closing time to ${hm(close)}', '${c.name} · today ${nowHm()}', 'Attendance');
    c.lateAt = late;
    c.closeAt = close;
    notifyListeners();
  }

  void mark(Stu s, Course c) {
    s.status = 'Present';
    _log('$actor marked ${s.name} present', '${c.name} · today ${nowHm()} · manual', 'Attendance');
  }

  void resolveScan(Scan s, bool approve) {
    s.state = approve ? 'approved' : 'absent';
    if (s.course == 'Data Structures') {
      for (final x in roster.where((x) => x.id == s.id)) {
        x.status = approve ? 'Present' : 'Absent';
      }
    }
    _log(approve ? '$actor approved ${s.name}' : '$actor marked ${s.name} absent', '${s.course} · today ${nowHm()} · ${approve ? 'scan ${s.conf}%' : 'scan rejected'}', 'Attendance');
  }

  void registerFace() {
    faceRegistered = true;
    faceUpdated = 'Today';
    notifyListeners();
  }

  void addCamera(String roomId, String block) {
    final r = Room(roomId, roomId.startsWith('L') ? 'Lab $roomId' : 'Room $roomId', block, true);
    rooms.add(r);
    _log('You added camera ${r.cam}', 'Today ${nowHm()}', 'Cameras');
  }

  void viewLive(Room r) => _log('You viewed live camera ${r.id}', 'Today ${nowHm()}', 'Cameras');

  void reconnect(Room r) {
    r.online = true;
    r.since = null;
    _log('Camera ${r.cam} back online', 'Today ${nowHm()}', 'Cameras');
  }

  void notifyIT(Room r) => _log('You notified IT about ${r.cam}', 'Today ${nowHm()}', 'Cameras');
}

const kDotGreenC = Color(0xFF2E9E6B);
const kDotRedC = Color(0xFFD9483B);
const kPrimaryC = Color(0xFF4F46E5);
