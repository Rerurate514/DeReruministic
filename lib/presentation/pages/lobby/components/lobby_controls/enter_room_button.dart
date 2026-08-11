import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_highlight_transparency_button.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class EnterRoomButton extends StatelessWidget {
  const EnterRoomButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppHighlightTransparencyButton(
      borderRadius: 4,
      onPressed: () {},
      child: Row(
        mainAxisAlignment: .center,
        spacing: 8,
        children: [
          const Icon(
            Symbols.meeting_room,
          ),
          Text(l10n.lobby_page_controls_panel_enter_room_button_text),
        ],
      ),
    );
  }
}
