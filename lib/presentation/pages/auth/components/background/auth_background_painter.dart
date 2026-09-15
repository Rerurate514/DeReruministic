import 'dart:math' as math;

import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class AuthBackgroundPainter extends CustomPainter {
  AuthBackgroundPainter(this.theme);

  final AppColorScheme theme;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = theme.surfaceBackground,
    );
    _drawGrid(canvas, size);
    _drawCircuits(canvas, size);
    _drawNoise(canvas, size);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = theme.brandSecondary.withOpacity(0.08)
      ..strokeWidth = 1;
    const gridSize = 34.0;
    for (var x = 0.0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (var y = 0.0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawCircuits(Canvas canvas, Size size) {
    final circuitPaint = Paint()
      ..color = theme.brandColor.withOpacity(0.32)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas
      ..drawPath(_topCircuit(size), circuitPaint)
      ..drawPath(_bottomCircuit(size), circuitPaint);

    final nodePaint = Paint()..color = theme.brandSecondary.withOpacity(0.78);
    final nodeGlowPaint = Paint()
      ..color = theme.brandSecondary.withOpacity(0.12);
    for (final node in _nodes(size)) {
      canvas
        ..drawCircle(node, 4, nodePaint)
        ..drawCircle(node, 10, nodeGlowPaint);
    }
  }

  Path _topCircuit(Size size) {
    return Path()
      ..moveTo(size.width * 0.08, size.height * 0.18)
      ..lineTo(size.width * 0.28, size.height * 0.18)
      ..lineTo(size.width * 0.35, size.height * 0.32)
      ..lineTo(size.width * 0.62, size.height * 0.32)
      ..lineTo(size.width * 0.76, size.height * 0.55)
      ..lineTo(size.width * 0.94, size.height * 0.55);
  }

  Path _bottomCircuit(Size size) {
    return Path()
      ..moveTo(size.width * 0.16, size.height * 0.86)
      ..lineTo(size.width * 0.16, size.height * 0.66)
      ..lineTo(size.width * 0.42, size.height * 0.66)
      ..lineTo(size.width * 0.50, size.height * 0.48)
      ..lineTo(size.width * 0.72, size.height * 0.48);
  }

  List<Offset> _nodes(Size size) {
    return [
      Offset(size.width * 0.28, size.height * 0.18),
      Offset(size.width * 0.62, size.height * 0.32),
      Offset(size.width * 0.76, size.height * 0.55),
      Offset(size.width * 0.16, size.height * 0.66),
      Offset(size.width * 0.50, size.height * 0.48),
    ];
  }

  void _drawNoise(Canvas canvas, Size size) {
    final noisePaint = Paint()..color = theme.brandQuaternary.withOpacity(0.18);
    for (var i = 0; i < 56; i++) {
      final x = (math.sin(i * 12.9898) * 43758.5453) % 1;
      final y = (math.sin(i * 78.233) * 24634.6345) % 1;
      canvas.drawRect(
        Rect.fromLTWH(x.abs() * size.width, y.abs() * size.height, 2, 8),
        noisePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant AuthBackgroundPainter oldDelegate) {
    return oldDelegate.theme != theme;
  }
}
