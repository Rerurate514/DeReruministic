import 'package:dereruministic/presentation/components/app_card.dart';
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

    final strs = title.split('');

    return AppCard(
      isBlur: true,
      child: SizedBox(
        width: 50,
        child: FittedBox(
          child: Column(
            children: strs
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
