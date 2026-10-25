// Face registration (3 capture steps) and the success screen.
import 'package:flutter/material.dart';
import '../../core/core.dart';

class FaceRegisterScreen extends StatefulWidget {
  const FaceRegisterScreen({super.key});
  @override
  State<FaceRegisterScreen> createState() => _FaceState();
}

class _FaceState extends State<FaceRegisterScreen> {
  int step = 0;
  bool busy = false;
  static const prompts = ['Look straight at the camera', 'Turn your head slightly left', 'Turn your head slightly right'];

  Future<void> _capture() async {
    setState(() => busy = true);
    await Future.delayed(const Duration(milliseconds: 900)); // replace with real camera capture
    if (!mounted) return;
    if (step < 2) {
      setState(() {
        step++;
        busy = false;
      });
    } else {
      Store.i.registerFace();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const FaceDoneScreen()));
    }
  }

  @override
  Widget build(BuildContext context) => Screen(
        back: true,
        backLabel: 'Back',
        title: 'Register your face',
        children: [
          const SizedBox(height: 6),
          Text('Step ${step + 1} of 3 · ${prompts[step]}', style: kMut),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ClipRRect(borderRadius: BorderRadius.circular(9), child: LinearProgressIndicator(value: (step + 1) / 3, minHeight: 8, backgroundColor: kGrey, color: kPrimary)),
          ),
          Center(
            child: Container(
              width: 230,
              height: 290,
              margin: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1D3A),
                borderRadius: const BorderRadius.all(Radius.elliptical(115, 145)),
                border: Border.all(color: kPrimary, width: 4),
              ),
              child: Center(
                child: busy
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.face_retouching_natural, color: Color(0xFFC9CCF5), size: 56),
                        SizedBox(height: 8),
                        Text('Camera preview', style: TextStyle(color: Color(0xFFC9CCF5), fontSize: 13)),
                      ]),
              ),
            ),
          ),
          const Text('Good light on your face, no cap or mask. Next you will turn left, then right.', textAlign: TextAlign.center, style: kMut),
          const SizedBox(height: 20),
          FilledButton(onPressed: busy ? null : _capture, child: Text(busy ? 'Capturing...' : 'Capture')),
        ],
      );
}

class FaceDoneScreen extends StatelessWidget {
  const FaceDoneScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(color: kGreenBg, shape: BoxShape.circle),
                child: const Icon(Icons.check, size: 52, color: kGreen),
              ),
              const SizedBox(height: 28),
              const Text('Face registered', style: kH1),
              const SizedBox(height: 10),
              const Text('You are all set. The camera in your classroom will mark your attendance.', textAlign: TextAlign.center, style: TextStyle(color: kMuted, fontSize: 14, height: 1.5)),
              const SizedBox(height: 36),
              FilledButton(onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst), child: const Text('Done')),
            ]),
          ),
        ),
      );
}
