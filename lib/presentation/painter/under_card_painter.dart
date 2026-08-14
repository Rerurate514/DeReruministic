import 'package:flutter/material.dart';

class UnderCardPainter extends CustomPainter {
  const UnderCardPainter({
    required this.color,
  });

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final shadowPaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    const y1 = -25.0;
    const y2 = -15.0;

    final path = Path()
      ..moveTo(10, y1)
      ..lineTo(35, y1)
      ..lineTo(45, y2)
      ..lineTo(135, y2)
      ..lineTo(145, y1)
      ..lineTo(170, y1);

    canvas
      ..save()
      ..drawPath(path, shadowPaint)
      ..restore()
      ..drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
