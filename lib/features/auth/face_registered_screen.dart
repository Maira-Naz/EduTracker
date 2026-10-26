// Face registration finished.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../student/student_shell.dart';

class FaceRegisteredScreen extends StatelessWidget {
  const FaceRegisteredScreen({super.key, required this.wasSignedIn});
  final bool wasSignedIn;

  void _done(BuildContext context) {
    if (wasSignedIn) {
      Navigator.of(context).popUntil((r) => r.isFirst);
    } else {
      Store.i.signIn(Role.student); // demo: first-time student continues into the app
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const StudentShell()), (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: kBg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(children: [
              const Spacer(),
              Container(width: 96, height: 96, decoration: const BoxDecoration(color: kGreenBg, shape: BoxShape.circle), child: const Icon(Icons.check_rounded, size: 54, color: kGreen)),
              const SizedBox(height: 24),
              const Text('You are registered', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -1, height: 1.1)),
              const SizedBox(height: 10),
              const Text('From now on, the camera in your classroom marks your attendance. Nothing else to do.', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, height: 1.5, color: kMuted)),
              const SizedBox(height: 24),
              Panel(
                child: Row(children: [
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Student ID', style: kRowSub), Text('CS-2041', style: kRowTitle)])),
                  const Pill('Face active', Tone.green, dot: true),
                ]),
              ),
              const Spacer(),
              PButton(wasSignedIn ? 'Done' : 'See my courses', () => _done(context)),
            ]),
          ),
        ),
      );
}
