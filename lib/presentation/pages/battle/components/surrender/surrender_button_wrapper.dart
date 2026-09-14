import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/dialogs/simple_ok_dialog.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class SurrenderButtonWrapper extends ConsumerWidget {
  const SurrenderButtonWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(1000),
      child: InkWell(
        borderRadius: BorderRadius.circular(1000),
        onTap: () async {
          await showSimpleOkDialog(
            context: context,
            l10n: l10n,
            onOkTapped: () {
              ref.read(gameProvider.notifier).surrender();
            },
            title: Column(
              spacing: 4,
              children: [
                Icon(
                  Symbols.delete,
                  color: theme.brandSecondary,
                ),
                Text(
                  "降参しますか？",
                  style: GoogleFonts.shareTechMono(),
                ),
              ],
            ),
          );
        },
        child: child,
      ),
    );
  }
}
