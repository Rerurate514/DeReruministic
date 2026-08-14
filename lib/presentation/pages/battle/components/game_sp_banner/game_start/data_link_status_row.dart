import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_infinity_rotation.dart';
import 'package:dereruministic/presentation/widgets/ui_flashing_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class DataLinkStatusRow extends StatelessWidget {
  const DataLinkStatusRow({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return UiFlashingWidget(
      tween: Tween<double>(begin: 1, end: 0.7),
      color: color,
      child: Row(
        mainAxisAlignment: .center,
        spacing: 8,
        children: [
          AppInfinityRotation(
            duration: const Duration(seconds: 1),
            child: Icon(
              Symbols.autorenew,
              color: color,
              size: 20,
            ),
          ),
          Text(
            l10n.battle_page_sp_banner_game_start_data_link_established_text,
            style: GoogleFonts.shareTechMono(
              fontSize: 16,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
