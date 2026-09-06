import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/battle/providers/switcher/event_log_switcher.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_active_filled_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SysActiveWidget extends ConsumerWidget {
  const SysActiveWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return Row(
      spacing: 8,
      children: [
        const UiActiveFilledCircle(),
        TextButton(
          onPressed: () {
            ref.read(eventLogSwitcherProvider.notifier).toggle();
          },
          child: Text(
            l10n.battle_page_header_sys_active_text,
            style: GoogleFonts.shareTechMono(color: theme.brandSecondary),
          ),
        ),
      ],
    );
  }
}
