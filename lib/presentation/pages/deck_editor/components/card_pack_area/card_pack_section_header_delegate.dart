import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/painter/glow_line_painter.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardPackSectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  CardPackSectionHeaderDelegate({required this.title});

  final String title;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = context.themePalette;

    final topPath = Path()
      ..moveTo(27, 0)
      ..lineTo(37, 10)
      ..lineTo(37, 170)
      ..moveTo(30, 0)
      ..lineTo(40, 10)
      ..lineTo(40, 200)
      ..moveTo(33, 0)
      ..lineTo(43, 10)
      ..lineTo(43, 130);

    final bottomPath = Path()
      ..moveTo(18, 0)
      ..lineTo(8, -10)
      ..lineTo(8, -170)
      ..moveTo(15, 0)
      ..lineTo(5, -10)
      ..lineTo(5, -200)
      ..moveTo(12, 0)
      ..lineTo(2, -10)
      ..lineTo(2, -130);

    return Stack(
      children: [
        AppCard(
          isBlur: true,
          child: SizedBox(
            width: 50,
            child: FittedBox(
              child: Column(
                children: title
                    .split('')
                    .asMap()
                    .entries
                    .map(
                      (entry) => Text(
                        entry.value,
                        style: GoogleFonts.shareTechMono(
                          fontWeight: .bold,
                          color: entry.key == 0 ? theme.brandColor : null,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        Align(
          alignment: .topLeft,
          child: CustomPaint(
            painter: GlowLinePainter(
              path: topPath,
              color: theme.brandSecondary,
            ),
          ),
        ),
        Align(
          alignment: .bottomLeft,
          child: CustomPaint(
            painter: GlowLinePainter(
              path: bottomPath,
              color: theme.brandSecondary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant CardPackSectionHeaderDelegate oldDelegate) =>
      oldDelegate.title != title;
}
