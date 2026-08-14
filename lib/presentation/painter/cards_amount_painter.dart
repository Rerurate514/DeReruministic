import 'package:flutter/material.dart';

class CardsAmountPainter extends CustomPainter {
  const CardsAmountPainter({
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

    const y1 = 0.0;
    const y2 = 20.0;

    final path = Path()
      ..moveTo(0, y1)
      ..lineTo(20, y1)
      ..lineTo(30, y2)
      ..lineTo(87, y2);
    canvas
      ..save()
      ..drawPath(path, shadowPaint)
      ..restore()
      ..drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
