import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/deck_editor/components/card_pack_area/card_packs_component.dart';
import 'package:dereruministic/presentation/pages/deck_editor/components/card_pack_area/in_deck_card_remove_area.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class CardPackArea extends StatelessWidget {
  const CardPackArea({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Row(
              spacing: 8,
              children: [
                const Icon(Symbols.inventory_2),
                Text(
                  l10n.deck_editor_page_cards_header_title_text,
                  style: GoogleFonts.shareTechMono(),
                ),
              ],
            ),
            const Text('ここにセレクタ'),
          ],
        ),
        const Expanded(
          child: Stack(
            children: [
              CardPacksComponent(),
              Positioned.fill(
                child: InDeckCardRemoveArea(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
