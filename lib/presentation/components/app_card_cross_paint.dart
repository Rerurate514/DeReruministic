import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/painter/glow_line_painter.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AppCardCrossPaint extends ConsumerWidget {
  const AppCardCrossPaint({
    required this.label,
    required this.isVisible,
    required this.child,
    super.key,
  });

  final String label;
  final bool isVisible;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themePalette;

    const x = 180.0;
    const y = 240.0;

    final path = Path()
      ..lineTo(x, 0)
      ..lineTo(x, y)
      ..lineTo(0, y)
      ..lineTo(0, 0)
      ..lineTo(x, y)
      ..moveTo(0, y)
      ..lineTo(x, 0);

    return Stack(
      children: [
        child,
        if (isVisible)
          Positioned.fill(
            child: Stack(
              children: [
                _DiscardedPaint(
                  x: x,
                  y: y,
                  path: path,
                  theme: theme,
                ),
                Align(
                  child: _CenterContent(
                    label: label,
                    color: theme.brandTertiary,
                  ),
                ),
              ],
            ),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }
}

class _CenterContent extends StatelessWidget {
  const _CenterContent({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      isBlur: true,
      child: Text(
        label,
        style: GoogleFonts.shareTechMono(
          color: color,
        ),
      ),
    );
  }
}

class _DiscardedPaint extends StatelessWidget {
  const _DiscardedPaint({
    required this.x,
    required this.y,
    required this.path,
    required this.theme,
  });

  final double x;
  final double y;
  final Path path;
  final AppColorScheme theme;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(2),
      isBlur: true,
      child: FittedBox(
        child: CustomPaint(
          size: Size(x, y),
          painter: GlowLinePainter(
            path: path,
            color: theme.brandTertiary,
          ),
        ),
      ),
    );
  }
}
