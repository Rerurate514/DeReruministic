import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class TurnText extends ConsumerWidget {
  const TurnText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    final turnCount = ref.watch(gameProvider.select((s) => s?.turnCount));

    return Row(
      spacing: 8,
      children: [
        Text(
          l10n.battle_page_header_turn_text.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: .bold,
            color: theme.brandColor,
          ),
        ),
        Text(
          '${turnCount ?? l10n.game_state_is_null}',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: .bold,
          ),
        ),
      ],
    );
  }
}
