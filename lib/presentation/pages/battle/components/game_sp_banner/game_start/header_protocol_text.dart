import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderProtocolText extends StatelessWidget {
  const HeaderProtocolText({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FittedBox(
      child: Text(
        l10n.battle_page_sp_banner_game_start_initializing_combat_protocol_text,
        style: GoogleFonts.shareTechMono(
          fontSize: 20,
          letterSpacing: 4,
        ),
      ),
    );
  }
}
