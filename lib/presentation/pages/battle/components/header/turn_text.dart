import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class TurnNext extends ConsumerWidget {
  const TurnNext({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    final turnCount = ref.watch(gameProvider.select((s) => s?.turnCount));

    return Column(
      children: [
        Text(
          l10n.battle_page_header_turn_text,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: theme.brandColor,
            fontWeight: .bold,
          ),
        ),
        Text(
          '${turnCount ?? l10n.game_state_is_null}',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: .bold,
          ),
        ),
      ],
    );
  }
}
