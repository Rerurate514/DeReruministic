import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_highlight_button.dart';
import 'package:dereruministic/presentation/router/router_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class CreateRoomButton extends StatelessWidget {
  const CreateRoomButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppHighlightButton(
      isGlow: true,
      borderRadius: 4,
      onPressed: () async {
        await context.push(RouterPaths.room.path);
      },
      child: Row(
        mainAxisAlignment: .center,
        spacing: 8,
        children: [
          const Icon(
            Symbols.add_circle,
          ),
          Text(l10n.lobby_page_controls_panel_create_room_button_text),
        ],
      ),
    );
  }
}
