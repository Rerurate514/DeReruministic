import 'package:flutter/material.dart';

class HollowGlowPainter extends CustomPainter {
  const HollowGlowPainter({
    required this.color,
    required this.blurRadius,
    required this.spreadWidth,
    required this.borderRadius,
  });

  final Color color;
  final double blurRadius;
  final double spreadWidth;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final innerRRect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    final innerPath = Path()..addRRect(innerRRect);

    final outerRect = rect.inflate(blurRadius + spreadWidth);
    final outerPath = Path()..addRect(outerRect);

    final hollowPath = Path.combine(
      PathOperation.difference,
      outerPath,
      innerPath,
    );

    final paint = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);

    canvas
      ..save()
      ..clipPath(hollowPath)
      ..drawRRect(innerRRect, paint)
      ..restore();
  }

  @override
  bool shouldRepaint(covariant HollowGlowPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.blurRadius != blurRadius ||
        oldDelegate.spreadWidth != spreadWidth ||
        oldDelegate.borderRadius != borderRadius;
  }
}
