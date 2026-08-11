import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/lobby/components/lobby_controls/create_room_button.dart';
import 'package:dereruministic/presentation/pages/lobby/components/lobby_controls/ender_room_panel.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LobbyControlsPanel extends StatelessWidget {
  const LobbyControlsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return AppCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 4,
      child: Column(
        spacing: 16,
        children: [
          Align(
            alignment: .topLeft,
            child: Text(
              l10n.lobby_page_controls_panel_title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                letterSpacing: 2,
                color: theme.textPrimary,
              ),
            ),
          ),
          const CreateRoomButton(),
          const Divider(),
          const EnterRoomPanel(),
        ],
      ),
    );
  }
}
