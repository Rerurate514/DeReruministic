import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_highlight_transparency_button.dart';
import 'package:dereruministic/presentation/router/router_paths.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class DeckEditorButton extends StatelessWidget {
  const DeckEditorButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return AppHighlightTransparencyButton(
      onPressed: () async {
        await context.push(RouterPaths.deckEditor.path);
      },
      child: Row(
        mainAxisAlignment: .center,
        spacing: 8,
        children: [
          Icon(Symbols.playing_cards, color: theme.brandColor),
          Text(l10n.home_page_deck_editor_button_text),
        ],
      ),
    );
  }
}
