// Sign in for all three roles. Teacher and admin also enter a 6-digit code.
// 3 wrong attempts lock sign-in for 30 seconds.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../admin/admin_shell.dart';
import '../student/student_shell.dart';
import '../teacher/teacher_shell.dart';
import 'register_face_screen.dart';
import 'reset_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  Role role = Role.teacher;
  final id = TextEditingController(), pw = TextEditingController(), code = TextEditingController();
  bool hide = true;
  int fails = 0;
  String? error;
  DateTime? lock;

  static const _demo = {Role.student: ('CS-2041', ''), Role.teacher: ('T-1042', '482 913'), Role.admin: ('HOD-01', '204 771')};
  static const _idLabel = {Role.student: 'Student ID', Role.teacher: 'Staff ID', Role.admin: 'Admin ID'};

  @override
  void initState() {
    super.initState();
    _fill();
  }

  void _fill() {
    id.text = _demo[role]!.$1;
    pw.text = Store.demoPassword;
    code.text = _demo[role]!.$2;
    error = null;
  }

  @override
  void dispose() {
    id.dispose();
    pw.dispose();
    code.dispose();
    super.dispose();
  }

  void _submit() {
    if (lock != null && DateTime.now().isBefore(lock!)) {
      setState(() => error = 'Too many attempts. Try again in 30 seconds.');
      return;
    }
    if (!Store.i.check(role, id.text, pw.text, code.text)) {
      fails++;
      setState(() {
        if (fails >= 3) {
          lock = DateTime.now().add(const Duration(seconds: 30));
          fails = 0;
          error = 'Too many attempts. Try again in 30 seconds.';
        } else {
          error = role == Role.student ? 'ID or password is incorrect.' : 'ID, password or code is incorrect.';
        }
      });
      return;
    }
    Store.i.signIn(role);
    final Widget next = switch (role) {
      Role.student => const StudentShell(),
      Role.teacher => const TeacherShell(),
      Role.admin => const AdminShell(),
    };
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => next), (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = switch (role) {
      Role.student => 'Sign in to see your attendance. The camera in your classroom marks it for you.',
      Role.teacher => 'Sign in to manage attendance. Your classroom camera does the marking.',
      Role.admin => 'Department admin access. Sign in to monitor cameras and attendance.',
    };
    return Scaffold(
      backgroundColor: kBg,
      body: Stack(children: [
        Positioned(left: -90, top: -90, child: Container(width: 260, height: 260, decoration: const BoxDecoration(color: kBlobA, shape: BoxShape.circle))),
        Positioned(right: -30, top: 60, child: Transform.rotate(angle: 0.349, child: Container(width: 110, height: 110, decoration: BoxDecoration(color: kBlobB, borderRadius: BorderRadius.circular(32))))),
        SafeArea(
          child: ListView(padding: const EdgeInsets.fromLTRB(24, 34, 24, 24), children: [
            Container(
              width: 60,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Color(0x594F46E5), blurRadius: 24, offset: Offset(0, 10))]),
              child: const Text('E', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 20),
            const Text('Welcome to\nEduTracker', style: TextStyle(fontSize: 34, height: 1.1, fontWeight: FontWeight.w800, letterSpacing: -1, color: kInk)),
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(fontSize: 15, height: 1.5, color: kMuted)),
            const SizedBox(height: 20),
            Seg(const ['Student', 'Teacher', 'Admin'], role.index, (i) => setState(() {
                  role = Role.values[i];
                  _fill();
                })),
            const SizedBox(height: 16),
            AppField(_idLabel[role]!, id),
            const SizedBox(height: 12),
            AppField('Password', pw, obscure: hide, onSubmit: (_) => _submit(), suffix: IconButton(icon: Icon(hide ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: kMuted), onPressed: () => setState(() => hide = !hide))),
            if (role != Role.student) ...[
              const SizedBox(height: 12),
              AppField('6-digit code sent to your registered phone', code, keyboard: TextInputType.number, spacing: 3, maxLength: 7, onSubmit: (_) => _submit()),
            ],
            if (error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(error!, style: const TextStyle(color: kRed, fontSize: 13, fontWeight: FontWeight.w600))),
            const SizedBox(height: 20),
            PButton(role == Role.student ? 'Sign in' : 'Sign in securely', _submit),
            const SizedBox(height: 14),
            Center(child: GestureDetector(onTap: () => go(context, const ResetScreen()), child: const Padding(padding: EdgeInsets.all(6), child: Text('Forgot password?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kMuted))))),
            if (role == Role.student)
              Center(child: GestureDetector(onTap: () => go(context, const RegisterFaceScreen()), child: const Padding(padding: EdgeInsets.all(6), child: Text('First time here? Register your face', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kLink))))),
          ]),
        ),
      ]),
    );
  }
}
