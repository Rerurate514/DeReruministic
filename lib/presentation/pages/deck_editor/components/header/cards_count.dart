import 'package:dereruministic/domain/create_deck_recipe/constants/create_deck_recipe_rules.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class CardsCount extends StatelessWidget {
  const CardsCount({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              Symbols.playing_cards,
              color: theme.costDp,
            ),
            alignment: PlaceholderAlignment.middle,
          ),
          const WidgetSpan(
            child: UiGap.xs(),
          ),
          TextSpan(text: l10n.deck_editor_page_cards_count_text_title),
          const WidgetSpan(
            child: UiGap.xs(),
          ),
          TextSpan(
            text: l10n.deck_editor_page_cards_count_text_count(
              count,
              CreateDeckRecipeRules.maxDeckCards,
            ),
            style: TextStyle(color: theme.brandSecondary),
          ),
        ],
      ),
      style: GoogleFonts.shareTechMono(),
    );
  }
}
