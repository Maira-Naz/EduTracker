// Login for all roles. Teacher/admin get a second step (6-digit code). 3 wrong tries locks for 30 s.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../admin/admin_shell.dart';
import 'face_register_screen.dart';
import 'forgot_screen.dart';
import '../student/student_shell.dart';
import '../teacher/teacher_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  Role role = Role.student;
  final id = TextEditingController(), pw = TextEditingController(), otp = TextEditingController();
  bool hide = true;
  int step = 0, fails = 0;
  String? error;
  DateTime? lock;

  static const _labels = {Role.student: 'Student ID', Role.teacher: 'Staff ID', Role.admin: 'Admin ID'};
  static const _demo = {Role.student: 'CS-2041', Role.teacher: 'T-1042', Role.admin: 'HOD-CS'};

  @override
  void dispose() {
    id.dispose();
    pw.dispose();
    otp.dispose();
    super.dispose();
  }

  void _pick(int i) => setState(() {
        role = Role.values[i];
        step = 0;
        error = null;
        id.clear();
        pw.clear();
        otp.clear();
      });

  void _submit() {
    if (lock != null && DateTime.now().isBefore(lock!)) {
      setState(() => error = 'Too many attempts. Try again in 30 seconds.');
      return;
    }
    if (step == 0) {
      if (!Store.i.check(role, id.text, pw.text)) {
        fails++;
        setState(() {
          if (fails >= 3) {
            lock = DateTime.now().add(const Duration(seconds: 30));
            fails = 0;
            error = 'Too many attempts. Try again in 30 seconds.';
          } else {
            error = 'ID or password is incorrect.';
          }
        });
        return;
      }
      if (role == Role.student) {
        _enter();
      } else {
        setState(() {
          step = 1;
          error = null;
        });
      }
    } else if (otp.text == '123456') {
      _enter();
    } else {
      setState(() => error = 'That code is not right.');
    }
  }

  void _enter() {
    Store.i.signIn(role);
    final next = switch (role) {
      Role.student => const StudentShell(),
      Role.teacher => const TeacherShell(),
      Role.admin => const AdminShell(),
    };
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => next), (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = switch (role) {
      Role.student => 'Sign in to see your attendance. The camera in your classroom marks it for you.',
      Role.teacher => 'Sign in to manage attendance for your classes.',
      Role.admin => "Department head sign-in. You see your department's rooms and cameras only.",
    };
    return Scaffold(
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(24), children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(18)),
            child: const Icon(Icons.center_focus_strong, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 28),
          const Text('Welcome to EduTracker', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: kInk, letterSpacing: -0.5, height: 1.15)),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: kMuted, fontSize: 14, height: 1.4)),
          Seg(const ['Student', 'Teacher', 'Admin'], role.index, _pick),
          if (step == 0) ...[
            FieldLabel(_labels[role]!),
            TextField(controller: id, textInputAction: TextInputAction.next, decoration: InputDecoration(helperText: 'Demo ID: ${_demo[role]}')),
            const FieldLabel('Password'),
            TextField(
              controller: pw,
              obscureText: hide,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                helperText: 'Demo password: 12345678',
                suffixIcon: IconButton(
                  icon: Icon(hide ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  onPressed: () => setState(() => hide = !hide),
                ),
              ),
            ),
          ] else ...[
            const FieldLabel('6-digit code sent to your registered phone'),
            TextField(
              controller: otp,
              autofocus: true,
              maxLength: 6,
              keyboardType: TextInputType.number,
              style: const TextStyle(letterSpacing: 6, fontSize: 20),
              onSubmitted: (_) => _submit(),
              decoration: const InputDecoration(counterText: '', helperText: 'Demo code: 123456'),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => setState(() {
                  step = 0;
                  error = null;
                  otp.clear();
                }),
                child: const Text('Back'),
              ),
            ),
          ],
          if (error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(error!, style: const TextStyle(color: kRed, fontSize: 13))),
          const SizedBox(height: 20),
          FilledButton(onPressed: _submit, child: Text(step == 1 ? 'Sign in securely' : (role == Role.student ? 'Sign in' : 'Continue'))),
          const SizedBox(height: 8),
          Center(child: TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotScreen())), child: const Text('Forgot password?'))),
          if (role == Role.student)
            Center(
              child: TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FaceRegisterScreen())),
                child: const Text('First time here? Register your face', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
        ]),
      ),
    );
  }
}
