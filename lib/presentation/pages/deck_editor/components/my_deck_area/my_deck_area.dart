import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class MyDeckArea extends StatelessWidget {
  const MyDeckArea({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          spacing: 8,
          children: [
            const Icon(Symbols.view_carousel),
            Text(
              l10n.deck_editor_page_my_deck_header_title_text,
              style: GoogleFonts.shareTechMono(),
            ),
          ],
        ),
        Expanded(
          child: DragTarget(
            builder:
                (
                  context,
                  candidateData,
                  rejectedData,
                ) {
                  return const AppCard(
                    child: Text('TARGET AREA'),
                  );
                },
          ),
        ),
      ],
    );
  }
}
