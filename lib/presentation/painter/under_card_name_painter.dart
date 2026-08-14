import 'package:flutter/material.dart';

class UnderCardNamePainter extends CustomPainter {
  const UnderCardNamePainter({
    required this.color,
  });

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

    final path = Path()
      ..moveTo(0, 27)
      ..lineTo(50, 27)
      ..lineTo(60, 22)
      ..lineTo(125, 22);

    canvas
      ..save()
      ..translate(0, 2)
      ..drawPath(path, shadowPath)
      ..restore()
      ..drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
