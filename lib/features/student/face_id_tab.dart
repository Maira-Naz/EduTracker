// Face registration status, update and delete own face data.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../auth/face_register_screen.dart';

class FaceIdTab extends StatelessWidget {
  const FaceIdTab({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: Store.i,
        builder: (context, _) {
          final s = Store.i;
          return Screen(
            title: 'Face ID',
            subtitle: s.uid,
            children: [
              AppCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Item(s.faceRegistered ? 'Face registered' : 'No face registered',
                      sub: s.faceRegistered ? 'Last updated ${s.faceUpdated}' : 'Attendance cannot be marked automatically',
                      trailing: s.faceRegistered ? const Pill('Active', Tone.green) : const Pill('Not set', Tone.amber)),
                  const Hr(),
                  const Text('Classroom cameras use your face to mark attendance. A live-person (liveness) check is always on.', style: kMut),
                ]),
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: () => go(context, const FaceRegisterScreen()), child: Text(s.faceRegistered ? 'Update my face' : 'Register my face')),
              if (s.faceRegistered) ...[
                const SizedBox(height: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(foregroundColor: kRed),
                  onPressed: () async {
                    final ok = await confirm(context, 'Delete face data?', 'Automatic attendance will stop until you register again. This is recorded in the audit trail.', yes: 'Delete', danger: true);
                    if (ok && context.mounted) {
                      s.deleteFace();
                      toast(context, 'Face data deleted');
                    }
                  },
                  child: const Text('Delete my face data'),
                ),
              ],
              const SizedBox(height: 14),
              const Text('You can delete your face data at any time.', style: kMut),
            ],
          );
        },
      );
}
