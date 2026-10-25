// Offline camera help: retry connection, report to IT.
import 'package:flutter/material.dart';
import '../../core/core.dart';

class RoomOfflineScreen extends StatefulWidget {
  const RoomOfflineScreen(this.room, {super.key});
  final Room room;
  @override
  State<RoomOfflineScreen> createState() => _OfflineState();
}

class _OfflineState extends State<RoomOfflineScreen> {
  bool busy = false;

  Future<void> _retry() async {
    setState(() => busy = true);
    await Future.delayed(const Duration(milliseconds: 1400)); // replace with real health check
    if (!mounted) return;
    final m = ScaffoldMessenger.of(context);
    Store.i.reconnect(widget.room);
    Navigator.pop(context);
    m.showSnackBar(SnackBar(content: Text('${widget.room.cam} is back online')));
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.room;
    return Screen(
      back: true,
      backLabel: 'Back',
      subtitle: '${r.cam}, ${r.block}',
      title: 'Room ${r.id}',
      trailing: const Pill('Offline', Tone.red),
      children: [
        AppCard(
          color: kRedBg,
          border: const Color(0xFFF5B8B2),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Camera went offline at ${r.since ?? 'an earlier time'}', style: kH3),
            const SizedBox(height: 6),
            const Text('Classes in this room cannot be marked automatically until the camera is back.', style: kMut),
          ]),
        ),
        const Section('Try this first'),
        AppCard(child: const Text('1. Check the camera power\n2. Check the network cable\n3. Restart the camera', style: TextStyle(height: 2))),
        const SizedBox(height: 16),
        FilledButton(onPressed: busy ? null : _retry, child: Text(busy ? 'Checking...' : 'Retry connection')),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            Store.i.log('You reported ${r.cam} to IT', 'Cameras');
            toast(context, 'IT has been notified');
          },
          child: const Text('Report to IT'),
        ),
      ],
    );
  }
}
