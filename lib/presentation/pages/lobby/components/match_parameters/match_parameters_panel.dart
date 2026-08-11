import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
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
          _buildParameter(
            theme,
            l10n.lobby_page_match_parameters_panel_format,
            'STANDARD',
          ),
          _buildParameter(
            theme,
            l10n.lobby_page_match_parameters_panel_time_limit,
            '15 MIN',
          ),
        ],
      ),
    );
  }

  Widget _buildParameter(AppColorScheme theme, String leading, String text) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          leading,
          style: GoogleFonts.shareTechMono(
            fontSize: 13,
            letterSpacing: 2,
            color: theme.textSecondary,
          ),
        ),
        Text(
          text,
          style: GoogleFonts.shareTechMono(
            fontSize: 13,
            letterSpacing: 2,
            color: theme.brandSecondary,
          ),
        ),
      ],
    );
  }
}
