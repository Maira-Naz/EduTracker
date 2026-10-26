import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../core/widgets/et_icons.dart';
import '../../core/widgets/et_widgets.dart';
import '../../data/student_store.dart';

/// Face registration. [reregister] true = opened from Face ID (returns there
/// when done), false = first-time flow (goes to the "You are registered" page).
///
/// The scan is simulated: swap `_runScan` for a real camera + face-embedding
/// call when the backend is ready.
class StudentRegisterScreen extends StatefulWidget {
  const StudentRegisterScreen({super.key, this.reregister = false});
  final bool reregister;

  @override
  State<StudentRegisterScreen> createState() => _StudentRegisterScreenState();
}

class _StudentRegisterScreenState extends State<StudentRegisterScreen>
    with SingleTickerProviderStateMixin {
  static const _steps = [
    'Look straight at the camera',
    'Slowly turn left, then right',
    'Good light, no glasses or mask',
  ];

  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 5400),
  );
  bool _scanning = false;

  int get _step => _scanning ? math.min(2, (_ctrl.value * 3).floor()) : 0;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _runScan() async {
    setState(() => _scanning = true);
    try {
      await _ctrl.forward().orCancel;
    } on TickerCanceled {
      return;
    }
    if (!mounted) return;
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    final store = context.read<StudentStore>();
    store.completeFaceRegistration();
    if (widget.reregister) {
      final messenger = ScaffoldMessenger.of(context);
      Navigator.of(context).pop();
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(const SnackBar(
        content: Text('Face updated. Your new scan is active.'),
        margin: EdgeInsets.fromLTRB(24, 0, 24, 96),
      ));
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.studentRegistered);
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = math.max(60.0, MediaQuery.of(context).padding.top + 16);
    final bottom = math.max(24.0, MediaQuery.of(context).padding.bottom);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, top, 24, 0),
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (context, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    EtBackLink('← Back',
                        onTap: _scanning
                            ? null
                            : () => Navigator.of(context).maybePop()),
                    gap(18),
                    Text('Register your face',
                        style: AppText.style(
                            32, FontWeight.w800, AppColors.ink,
                            ls: -0.03, height: 1.1)),
                    gap(6),
                    Text(
                      'One time only. This lets the classroom camera recognise you.',
                      style: AppText.style(
                          15, FontWeight.w400, AppColors.muted,
                          height: 1.5),
                    ),
                    gap(18),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Center(
                        child: Container(
                          width: 230,
                          height: 230,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.blobLarge),
                          child: CustomPaint(
                            size: const Size(230, 230),
                            painter: _FaceRingPainter(
                              progress: _scanning ? _ctrl.value : null,
                            ),
                            child: const Center(
                              child: EtPersonIcon(
                                  size: 110,
                                  color: AppColors.deep,
                                  strokeWidth: 2.6),
                            ),
                          ),
                        ),
                      ),
                    ),
                    gap(18),
                    EtCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 6),
                      child: Column(
                        children: [
                          for (var i = 0; i < _steps.length; i++)
                            DecoratedBox(
                              decoration: BoxDecoration(
                                border: i == _steps.length - 1
                                    ? null
                                    : const Border(
                                        bottom: BorderSide(
                                            color: AppColors.divider)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  children: [
                                    _StepBadge(
                                      number: i + 1,
                                      done: _scanning && i < _step,
                                      active: i <= _step,
                                    ),
                                    hgap(12),
                                    Expanded(
                                      child: Text(_steps[i],
                                          style: AppText.style(15,
                                              FontWeight.w600, AppColors.ink)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    gap(18),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 24, bottom),
            child: EtButton(
              label: _scanning ? 'Scanning…' : 'Start scan',
              height: 56,
              radius: 16,
              fontSize: 16,
              shadow: AppShadows.primaryLarge,
              loading: _scanning,
              onPressed: _runScan,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepBadge extends StatelessWidget {
  const _StepBadge(
      {required this.number, required this.done, required this.active});
  final int number;
  final bool done;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? AppColors.primary : AppColors.chip,
      ),
      child: done
          ? const EtCheckIcon(size: 16, color: Colors.white, strokeWidth: 3.2)
          : Text('$number',
              style: AppText.style(13, FontWeight.w800,
                  active ? Colors.white : AppColors.deep)),
    );
  }
}

/// Dashed ring while idle (as in the design); solid progress ring while scanning.
class _FaceRingPainter extends CustomPainter {
  _FaceRingPainter({this.progress});
  final double? progress;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 4.0;
    final rect = Rect.fromLTWH(stroke / 2, stroke / 2, size.width - stroke,
        size.height - stroke);
    final p = Paint()
      ..color = AppColors.indigoBar
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt;

    if (progress == null) {
      const dashes = 40;
      const sweepEach = 2 * math.pi / dashes;
      for (var i = 0; i < dashes; i++) {
        canvas.drawArc(rect, i * sweepEach, sweepEach * 0.55, false, p);
      }
    } else {
      final track = Paint()
        ..color = AppColors.blobSmall
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke;
      canvas.drawArc(rect, 0, 2 * math.pi, false, track);
      p.strokeCap = StrokeCap.round;
      canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress!, false, p);
    }
  }

  @override
  bool shouldRepaint(covariant _FaceRingPainter old) =>
      old.progress != progress;
}
