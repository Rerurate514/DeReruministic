import 'dart:ui' as ui;

import 'package:dereruministic/presentation/painter/hollow_glow_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HollowGlowPainter', () {
    test('内側を透明にする', () async {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      const size = Size(100, 100);

      const HollowGlowPainter(
        color: Colors.white,
        blurRadius: 10,
        spreadWidth: 5,
        borderRadius: 20,
      ).paint(canvas, size);

      final image = await recorder.endRecording().toImage(100, 100);
      addTearDown(image.dispose);
      final pixels = await image.toByteData();
      final centerAlpha = pixels!.getUint8((50 * 100 + 50) * 4 + 3);

      expect(centerAlpha, isZero);
    });
  });
}
