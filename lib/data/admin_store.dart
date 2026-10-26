import 'package:flutter/material.dart';

class Room {
  Room({
    required this.name,
    required this.block,
    required this.info,
    required this.online,
    required this.lastSeen,
    required this.camera,
    required this.ip,
    required this.installed,
    this.capacity = 40,
  });
  String name, block, info, lastSeen, camera, ip, installed;
  bool online;
  int capacity;
}

class Request {
  Request({
    required this.title,
    required this.teacher,
    required this.room,
    required this.ago,
    required this.status,
    required this.tag,
    required this.message,
    required this.sent,
    this.urgent = false,
    this.seen,
  });
  String title, teacher, room, ago, status, tag, message, sent;
  String? seen;
  bool urgent;
}

class Slot {
  Slot({
    required this.dept,
    required this.sem,
    required this.day,
    required this.course,
    required this.teacher,
    required this.room,
    required this.start,
    required this.end,
  });
  String dept, sem, day, course, teacher, room, start, end;
}

class AdminStore extends ChangeNotifier {
  AdminStore._();
  static final i = AdminStore._();

  String admin = 'Hamza Raza';

  // The design shows 16 rooms (14 online / 2 offline); 13 online rooms are
  // assumed to exist outside the sample list below.
  static const _hiddenOnline = 13;

  final rooms = <Room>[
    Room(
        name: 'C031',
        block: 'C',
        info: 'Block C · Algorithms 13:00',
        online: false,
        lastSeen: 'today 09:12',
        camera: 'C031-CAM-1',
        ip: '192.168.4.31',
        installed: '14 Aug 2026'),
    Room(
        name: 'D105',
        block: 'D',
        info: 'Block D · No class today',
        online: false,
        lastSeen: 'yesterday 17:40',
        camera: 'D105-CAM-1',
        ip: '192.168.4.105',
        installed: '02 Sep 2026'),
    Room(
        name: 'B204',
        block: 'B',
        info: 'Block B · Data Structures live',
        online: true,
        lastSeen: 'Streaming · last scan 10:09',
        camera: 'B204-CAM-1',
        ip: '192.168.4.204',
        installed: '10 Aug 2026'),
  ];

  int get total => _hiddenOnline + rooms.length;
  int get online => _hiddenOnline + rooms.where((r) => r.online).length;
  int get offline => rooms.where((r) => !r.online).length;

  final requests = <Request>[
    Request(
        title: 'Camera not detecting students',
        teacher: 'Ms. Rana',
        room: 'C031',
        ago: '25 min ago',
        status: 'New',
        tag: 'Camera',
        urgent: true,
        sent: '09:20 by Ms. Rana',
        seen: '09:41 by Hamza Raza',
        message:
            'The camera shows online but nobody is marked present. This started before today\'s 10:00 class.'),
    Request(
        title: 'Wrong class shown for the 10:00 slot',
        teacher: 'Mr. Haider',
        room: 'A110',
        ago: '1 h ago',
        status: 'New',
        tag: 'Schedule',
        sent: '08:45 by Mr. Haider',
        message:
            'The 10:00 slot shows Algorithms but I teach Discrete Math in this room.'),
    Request(
        title: 'Need a longer attendance window',
        teacher: 'Ms. Rana',
        room: 'B204',
        ago: 'Yesterday',
        status: 'New',
        tag: 'Settings',
        sent: 'Yesterday by Ms. Rana',
        message:
            'Many students arrive late because of the bus. Please allow a longer attendance window.'),
    Request(
        title: 'Student cannot register face',
        teacher: 'Ms. Saba',
        room: 'B204',
        ago: 'Yesterday',
        status: 'In progress',
        tag: 'Student',
        sent: 'Yesterday by Ms. Saba',
        message: 'One student\'s face registration keeps failing.'),
    Request(
        title: 'Late time not saving',
        teacher: 'Ms. Saba',
        room: 'A110',
        ago: '2 days ago',
        status: 'In progress',
        tag: 'Settings',
        sent: '2 days ago by Ms. Saba',
        message: 'The late time resets to the old value after I save it.'),
    Request(
        title: 'Wrong semester shown',
        teacher: 'Mr. Haider',
        room: 'A110',
        ago: '3 days ago',
        status: 'Resolved',
        tag: 'Schedule',
        sent: '3 days ago by Mr. Haider',
        message: 'My course appears under Semester 4 instead of Semester 3.'),
  ];

  final slots = <Slot>[
    Slot(dept: 'Computer Science', sem: 'Semester 3', day: 'Monday', course: 'Data Structures', teacher: 'Ms. Rana', room: 'B204', start: '10:00', end: '11:30'),
    Slot(dept: 'Computer Science', sem: 'Semester 3', day: 'Monday', course: 'Algorithms', teacher: 'Ms. Rana', room: 'C031', start: '13:00', end: '14:30'),
    Slot(dept: 'Computer Science', sem: 'Semester 3', day: 'Monday', course: 'Discrete Math', teacher: 'Mr. Haider', room: 'A110', start: '15:00', end: '16:30'),
    Slot(dept: 'Computer Science', sem: 'Semester 3', day: 'Tuesday', course: 'Database Systems', teacher: 'Ms. Saba', room: 'B204', start: '09:00', end: '10:30'),
    Slot(dept: 'Computer Science', sem: 'Semester 3', day: 'Wednesday', course: 'Algorithms', teacher: 'Ms. Rana', room: 'C031', start: '11:00', end: '12:30'),
    Slot(dept: 'Computer Science', sem: 'Semester 3', day: 'Thursday', course: 'Discrete Math', teacher: 'Mr. Haider', room: 'A110', start: '10:00', end: '11:30'),
    Slot(dept: 'Computer Science', sem: 'Semester 3', day: 'Friday', course: 'Data Structures', teacher: 'Ms. Rana', room: 'B204', start: '09:00', end: '10:30'),
  ];

  void touch() => notifyListeners();
  void addRoom(Room r) {
    rooms.add(r);
    notifyListeners();
  }

  void addSlot(Slot s) {
    slots.add(s);
    notifyListeners();
  }

  void removeSlot(Slot s) {
    slots.remove(s);
    notifyListeners();
  }
}

final adminStore = AdminStore.i;

// Dropdown options used by the schedule screens.
const kDepts = ['Computer Science', 'Software Engineering', 'Electrical Engineering'];
const kSems = ['Semester 1', 'Semester 2', 'Semester 3', 'Semester 4'];
const kDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
