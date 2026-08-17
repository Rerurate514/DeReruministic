import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AppLinearPercentIndicator extends StatelessWidget {
  const AppLinearPercentIndicator({
    required this.percent,
    this.width,
    this.lineHeight = 4,
    this.color,
    this.backgroundColor,
    super.key,
  });

  final double percent;
  final double? width;
  final double lineHeight;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    final activeColor = color ?? theme.brandSecondary;

    final indicator = LinearPercentIndicator(
      percent: percent.clamp(0.0, 1.0),
      lineHeight: lineHeight,
      padding: EdgeInsets.zero,
      barRadius: Radius.zero,
      progressColor: activeColor,
      backgroundColor: backgroundColor ?? activeColor.withValues(alpha: 0.2),
      animation: true,
      animationDuration: 200,
      animateFromLastPercent: true,
    );

    if (width != null) {
      return SizedBox(
        width: width,
        child: indicator,
      );
    }

    return indicator;
  }
}
