import 'package:flutter/material.dart';

class HpPainter extends CustomPainter {
  const HpPainter({
    required this.count,
    required this.max,
    required this.color,
  });

  final int count;
  final int max;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (count <= 0) return;

    const gap = 4;
    final totalGap = gap * (max - 1);
    final rectWidth = (size.width - totalGap) / max;
    final hpPaint = Paint()..color = color;

    for (var i = 0; i < count; i++) {
      final left = i * (rectWidth + gap);
      final rect = Rect.fromLTWH(left, 0, rectWidth, size.height);
      canvas.drawRect(rect, hpPaint);
    }
  }

  @override
  bool shouldRepaint(covariant HpPainter oldDelegate) {
    return oldDelegate.count != count;
  }
}
