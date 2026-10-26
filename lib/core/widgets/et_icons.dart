import 'package:flutter/material.dart';

/// Lock icon (24-unit grid) drawn exactly like the design's SVG.
class EtLockIcon extends StatelessWidget {
  const EtLockIcon({super.key, this.size = 28, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: _LockPainter(color),
      );
}

class _LockPainter extends CustomPainter {
  _LockPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(4 * s, 11 * s, 16 * s, 10 * s), Radius.circular(3 * s)),
      p,
    );
    final path = Path()
      ..moveTo(8 * s, 11 * s)
      ..lineTo(8 * s, 8 * s)
      ..arcToPoint(Offset(16 * s, 8 * s),
          radius: Radius.circular(4 * s), clockwise: true)
      ..lineTo(16 * s, 11 * s);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant _LockPainter old) => old.color != color;
}

/// Head-and-shoulders placeholder (64-unit grid) used for face images.
class EtPersonIcon extends StatelessWidget {
  const EtPersonIcon(
      {super.key, this.size = 64, required this.color, this.strokeWidth = 3});
  final double size;
  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: _PersonPainter(color, strokeWidth),
      );
}

class _PersonPainter extends CustomPainter {
  _PersonPainter(this.color, this.strokeWidth);
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 64;
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * s;
    canvas.drawCircle(Offset(32 * s, 24 * s), 12 * s, p);
    final path = Path()
      ..moveTo(10 * s, 58 * s)
      ..cubicTo(12 * s, 44 * s, 22 * s, 38 * s, 32 * s, 38 * s)
      ..cubicTo(42 * s, 38 * s, 52 * s, 44 * s, 54 * s, 58 * s);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant _PersonPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}


/// Check mark (24-unit grid).
class EtCheckIcon extends StatelessWidget {
  const EtCheckIcon(
      {super.key, this.size = 24, required this.color, this.strokeWidth = 3});
  final double size;
  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: _CheckPainter(color, strokeWidth),
      );
}

class _CheckPainter extends CustomPainter {
  _CheckPainter(this.color, this.strokeWidth);
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()
      ..moveTo(5 * s, 12.5 * s)
      ..lineTo(9.5 * s, 17 * s)
      ..lineTo(19 * s, 7.5 * s);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant _CheckPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}
