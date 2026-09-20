import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class OverflowDicardRuleText extends StatelessWidget {
  const OverflowDicardRuleText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    return AppCard(
      isBlur: true,
      child: Text(
        '残り枚数がある状態で、捨て札を確定させると「残り枚数x10ダメージ」のペナルティが発生します。',
        style: GoogleFonts.shareTechMono(
          letterSpacing: 2,
          color: theme.textPrimary.withAlpha(100),
        ),
      ),
    );
  }
}
