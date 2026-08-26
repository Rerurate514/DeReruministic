import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_highlight_button.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class DeckClearButton extends StatelessWidget {
  const DeckClearButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppHighlightButton(
      isGlow: true,
      width: 140,
      height: 40,
      onPressed: () {},
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
