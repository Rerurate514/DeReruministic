import 'package:flutter/material.dart';

class ScanlinePainter extends CustomPainter {
  const ScanlinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withAlpha(50)
      ..strokeWidth = 1.0;

    const lineSpacing = 3.0;

    for (double y = 0; y < size.height; y += lineSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
