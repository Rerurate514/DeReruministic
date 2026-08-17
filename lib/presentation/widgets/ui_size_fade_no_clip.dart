import 'dart:math' as math;

import 'package:flutter/material.dart';

class UiSizeFadeNoClip extends StatelessWidget {
  const UiSizeFadeNoClip({
    required this.animation,
    required this.child,
    super.key,
    this.sizeFraction = 0.7,
    this.curve = Curves.easeInOut,
    this.alignment = Alignment.centerLeft,
  });

  final Animation<double> animation;
  final Widget child;
  final double sizeFraction;
  final Curve curve;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final size = CurvedAnimation(
      parent: animation,
      curve: Interval(0, sizeFraction, curve: curve),
    );
    final fade = CurvedAnimation(
      parent: animation,
      curve: Interval(sizeFraction, 1, curve: curve),
    );

    return FadeTransition(
      opacity: fade,
      child: AnimatedBuilder(
        animation: size,
        builder: (context, child) => Align(
          alignment: alignment,
          widthFactor: math.max(size.value, 0),
          child: child,
        ),
        child: child,
      ),
    );
  }
}
