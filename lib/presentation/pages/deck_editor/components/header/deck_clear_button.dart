import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_highlight_button.dart';
import 'package:dereruministic/presentation/dialogs/simple_ok_dialog.dart';
import 'package:dereruministic/presentation/pages/deck_editor/providers/draft_deck_recipe_notifier.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class DeckClearButton extends ConsumerWidget {
  const DeckClearButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return AppHighlightButton(
      isGlow: true,
      width: 140,
      height: 40,
      onPressed: () async {
        await showSimpleOkDialog(
          context: context,
          l10n: l10n,
          onOkTapped: () {
            ref.read(draftDeckRecipeProvider.notifier).clear();
          },
          title: Column(
            spacing: 4,
            children: [
              Icon(
                Symbols.delete,
                color: theme.brandSecondary,
              ),
              Text(
                l10n.deck_editor_page_clear_all_dialog_title_text,
                style: GoogleFonts.shareTechMono(),
              ),
            ],
          ),
        );
      },
      child: Row(
        spacing: 4,
        children: [
          const Icon(Symbols.delete),
          Text(
            l10n.deck_editor_page_deck_clear_all_button_text,
            style: GoogleFonts.shareTechMono(),
          ),
        ],
      ),
    );
  }
}
