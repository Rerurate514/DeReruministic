import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_highlight_transparency_button.dart';
import 'package:dereruministic/presentation/pages/deck_editor/providers/save_deck_recipe_notifier.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class DeckSaveButton extends ConsumerWidget {
  const DeckSaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final saveState = ref.watch(saveDeckRecipeProvider);

    return AppHighlightTransparencyButton(
      width: 128,
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      onPressed: () async {
        await ref.read(saveDeckRecipeProvider.notifier).execute();
      },
      child: FittedBox(
        child: saveState.isLoading
            ? const UiLoadingIndicator()
            : Row(
                spacing: 8,
                children: [
                  const Icon(Symbols.save),
                  Text(
                    l10n.deck_editor_page_deck_save_button_text,
                    style: GoogleFonts.shareTechMono(),
                  ),
                ],
              ),
      ),
    );
  }
}
