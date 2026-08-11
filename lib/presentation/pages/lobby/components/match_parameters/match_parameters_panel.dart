import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/components/app_parameter_panel_text.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MatchParametersPanel extends StatelessWidget {
  const MatchParametersPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return AppCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 4,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            l10n.lobby_page_match_parameters_panel_title,
            style: GoogleFonts.shareTechMono(
              fontSize: 13,
              letterSpacing: 2,
              color: theme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          AppParameterPanelText(
            label: l10n.lobby_page_match_parameters_panel_format,
            value: 'STANDARD',
            valueColor: theme.brandSecondary,
          ),
          AppParameterPanelText(
            label: l10n.lobby_page_match_parameters_panel_time_limit,
            value: '15 MIN',
          ),
        ],
      ),
    );
  }
}
