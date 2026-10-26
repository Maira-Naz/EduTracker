// Student face registration: guide + a simulated 3-step scan.
// Replace the delays with real camera capture when you integrate the camera.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import 'face_registered_screen.dart';

class RegisterFaceScreen extends StatefulWidget {
  const RegisterFaceScreen({super.key});
  @override
  State<RegisterFaceScreen> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterFaceScreen> {
  int step = 0;
  bool scanning = false;
  static const steps = ['Look straight at the camera', 'Slowly turn left, then right', 'Good light, no glasses or mask'];

  Future<void> _scan() async {
    setState(() {
      scanning = true;
      step = 0;
    });
    for (var s = 0; s < 3; s++) {
      setState(() => step = s);
      await Future.delayed(const Duration(milliseconds: 1200));
      if (!mounted) return;
    }
    setState(() => step = 3);
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    final wasSignedIn = Store.i.uid.isNotEmpty;
    Store.i.registerFace();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => FaceRegisteredScreen(wasSignedIn: wasSignedIn)));
  }

  @override
  Widget build(BuildContext context) => Screen(
        backLabel: 'Back',
        title: 'Register your face',
        titleSize: 32,
        gap: 18,
        children: [
          const Text('One time only. This lets the classroom camera recognise you.', style: TextStyle(fontSize: 15, height: 1.5, color: kMuted)),
          Center(
            child: SizedBox(
              width: 230,
              height: 230,
              child: CustomPaint(
                painter: _RingPainter(solid: scanning),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: kBlobA, shape: BoxShape.circle),
                  child: scanning && step < 3
                      ? const Center(child: SizedBox(width: 56, height: 56, child: CircularProgressIndicator(strokeWidth: 5, color: kDeep)))
                      : const Icon(Icons.person_outline, size: 110, color: kDeep),
                ),
              ),
            ),
          ),
          RowsPanel([
            for (var i = 0; i < steps.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: i <= step && scanning || (!scanning && i == 0) ? kPrimary : kChip, shape: BoxShape.circle),
                    child: scanning && i < step
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : Text('${i + 1}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: (i <= step && scanning) || (!scanning && i == 0) ? Colors.white : kDeep)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(steps[i], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
                ]),
              ),
          ]),
          PButton(scanning ? 'Scanning...' : 'Start scan', scanning ? null : _scan),
        ],
      );
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.solid});
  final bool solid;
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = kIndigo500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final r = size.width / 2 - 2;
    final c = Offset(size.width / 2, size.height / 2);
    if (solid) {
      canvas.drawCircle(c, r, p);
      return;
    }
    const n = 36;
    for (var k = 0; k < n; k++) {
      final a = k * 2 * 3.14159265 / n;
      canvas.drawArc(Rect.fromCircle(center: c, radius: r), a, 2 * 3.14159265 / n * 0.55, false, p);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.solid != solid;
}
