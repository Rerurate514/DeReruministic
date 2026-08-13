import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_scan_line.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/utils/game_phase_ex.dart';
import 'package:dereruministic/presentation/widgets/ui_active_filled_circle.dart';
import 'package:dereruministic/presentation/widgets/ui_gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

class PhaseBanner extends HookWidget {
  const PhaseBanner({required this.phase, super.key});

  final GamePhase phase;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    return SizedBox(
      height: 90,
      child: Row(
        mainAxisSize: .min,
        spacing: 8,
        children: [
          _buildLine(theme),
          ClipRRect(
            child: Stack(
              children: [
                _buildContent(l10n, theme),
                const Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: AppScanLine(
                      lineWidth: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const UiGap.l(),
        ],
      ),
    );
  }

  Widget _buildLine(AppColorScheme theme) {
    return Container(
      width: 4,
      decoration: BoxDecoration(
        color: theme.brandSecondary,
        boxShadow: [
          BoxShadow(
            color: theme.brandSecondary,
            spreadRadius: 1,
            blurRadius: 15,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n, AppColorScheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
        border: Border(
          top: BorderSide(color: theme.buttonSecondary),
          bottom: BorderSide(color: theme.buttonSecondary),
          right: BorderSide(color: theme.buttonSecondary),
        ),
      ),
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .start,
        children: [
          Row(
            spacing: 4,
            children: [
              const UiActiveFilledCircle(),
              Text(
                l10n.battle_page_phase_current_text,
                style: GoogleFonts.poppins(color: theme.brandSecondary),
              ),
            ],
          ),
          Text(
            phase.text(l10n),
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: .bold),
          ),
        ],
      ),
    );
  }
}
