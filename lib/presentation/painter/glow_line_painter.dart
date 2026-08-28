import 'package:flutter/material.dart';

class GlowLinePainter extends CustomPainter {
  const GlowLinePainter({
    required this.path,
    required this.color,
  });

  final Path path;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final shadowPath = Paint()
      ..color = color.withAlpha(150)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas
      ..save()
      ..translate(0, 2)
      ..drawPath(path, shadowPath)
      ..restore()
      ..drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
