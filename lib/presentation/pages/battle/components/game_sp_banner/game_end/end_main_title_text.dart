import 'package:animated_text_effects/animated_text_effects.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EndMainTitleText extends StatelessWidget {
  const EndMainTitleText({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FittedBox(
      child: AnimatedText(
        l10n.battle_page_sp_banner_game_end_game_sequence_end_text,
        effects: const [
          TypewriterErrorEffect(
            delayBetweenChars: Duration(milliseconds: 30),
          ),
          VHSGlitchEffect(),
        ],
        style: GoogleFonts.shareTechMono(
          fontSize: 120,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
