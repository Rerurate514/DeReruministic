import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/battle/components/game_sp_banner/game_start/glow_line.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TerminalAccessRow extends StatelessWidget {
  const TerminalAccessRow({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FittedBox(
      child: Row(
        spacing: 8,
        children: [
          GlowLine(color: color),
          Text(
            l10n.battle_page_sp_banner_game_start_terminal_access_granted_text,
            style: GoogleFonts.shareTechMono(fontSize: 20),
          ),
          GlowLine(color: color),
        ],
      ),
    );
  }
}
