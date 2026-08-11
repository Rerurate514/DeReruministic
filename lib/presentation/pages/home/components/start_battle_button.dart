import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_highlight_button.dart';
import 'package:dereruministic/presentation/router/router_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class StartBattleButton extends StatelessWidget {
  const StartBattleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppHighlightButton(
      onPressed: () {
        context.push(RouterPaths.lobby.path);
      },
      child: Row(
        mainAxisAlignment: .center,
        spacing: 8,
        children: [
          const Icon(
            Symbols.swords,
          ),
          Text(l10n.home_page_start_battle_button_text),
        ],
      ),
    );
  }
}
