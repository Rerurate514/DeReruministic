import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_highlight_transparency_button.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class DeckSaveButton extends StatelessWidget {
  const DeckSaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppHighlightTransparencyButton(
      width: 128,
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      onPressed: () {},
      child: FittedBox(
        child: Row(
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
