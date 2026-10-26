// Face ID status, re-register, and match info.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../auth/register_face_screen.dart';

class FaceIdTab extends StatelessWidget {
  const FaceIdTab({super.key});

  Widget _stat(String label, String value, {Color color = kInk}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color)),
        ]),
      );

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) {
          final s = Store.i;
          return Screen(
            above: s.uid,
            title: 'Face ID',
            gap: 16,
            children: [
              HeroCard(
                child: Row(children: [
                  Container(width: 72, height: 72, decoration: const BoxDecoration(color: kBlobB, shape: BoxShape.circle), child: const Icon(Icons.person_outline, size: 40, color: kDeep)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(s.faceRegistered ? 'Face registered' : 'No face registered', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(s.faceRegistered ? 'Last updated ${s.faceUpdated}' : 'Register to turn on automatic attendance', style: const TextStyle(fontSize: 13, color: kSoft)),
                      ),
                    ]),
                  ),
                ]),
              ),
              Panel(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.faceRegistered ? 'Looks different lately?' : 'One quick scan', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 10),
                  Text(
                    s.faceRegistered
                        ? 'New glasses, a new haircut or a beard can lower your match score. Re-register your face to keep attendance accurate.'
                        : 'Register your face once so the classroom camera can recognise you.',
                    style: const TextStyle(fontSize: 14, height: 1.5, color: kMuted),
                  ),
                  const SizedBox(height: 10),
                  PButton(s.faceRegistered ? 'Re-register face' : 'Register face', () => goRoot(context, const RegisterFaceScreen()), height: 50, size: 15),
                ]),
              ),
              if (s.faceRegistered)
                Panel(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                  child: Column(children: [
                    _stat('Recent match score', '92%', color: kGreen),
                    const Divider(height: 1, thickness: 1, color: kDivider),
                    _stat('Scans needing review', '1 this month'),
                  ]),
                ),
            ],
          );
        },
      );
}
