import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/battle/providers/switcher/guide_switcher.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class DataLinkWidget extends ConsumerWidget {
  const DataLinkWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return Row(
      spacing: 2,
      children: [
        TextButton(
          onPressed: () {
            ref.read(guideSwitcherProvider.notifier).toggle();
          },
          child: Text(
            l10n.battle_page_header_data_link_text,
            style: GoogleFonts.shareTechMono(
              color: theme.brandSecondary,
              letterSpacing: 1,
            ),
          ),
        ),
        Icon(Symbols.person, color: theme.brandSecondary),
      ],
    );
  }
}
