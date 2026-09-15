import 'package:dereruministic/domain/create_deck_recipe/constants/create_deck_recipe_rules.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_flashing_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class PlayerInfoSystemChip extends StatelessWidget {
  const PlayerInfoSystemChip({required this.player, super.key});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    final cardsCount = player.deckRecipe.cardsCount;

    return AppCard(
      child: Column(
        children: [
          Row(
            spacing: 16,
            children: [
              UiFlashingWidget(
                color: theme.brandSecondary,
                child: Icon(
                  Symbols.check_circle_filled,
                  color: theme.brandSecondary,
                  size: 16,
                ),
              ),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    l10n.home_page_user_deck_count(
                      cardsCount,
                      CreateDeckRecipeRules.maxDeckCards,
                    ),
                    style: GoogleFonts.shareTechMono(
                      color: theme.brandSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
