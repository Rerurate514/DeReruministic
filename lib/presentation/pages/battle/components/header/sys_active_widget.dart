import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/widgets/ui_active_filled_circle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SysActiveWidget extends StatelessWidget {
  const SysActiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      spacing: 8,
      children: [
        const UiActiveFilledCircle(),
        Text(
          l10n.battle_page_header_sys_active_text,
          style: GoogleFonts.shareTechMono(),
        ),
      ],
    );
  }
}
