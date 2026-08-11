import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_text_field.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_filled_circle.dart';
import 'package:dereruministic/presentation/widgets/ui_flashing_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnterRoomIdInput extends StatelessWidget {
  const EnterRoomIdInput({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return Column(
      crossAxisAlignment: .start,
      spacing: 8,
      children: [
        Row(
          spacing: 8,
          children: [
            UiFlashingWidget(
              color: theme.brandSecondary,
              child: const UiFilledCircle(),
            ),
            Text(
              l10n.lobby_page_controls_panel_enter_room_id_text,
              style: GoogleFonts.shareTechMono(
                color: theme.brandSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
        AppTextField(
          hintText: l10n.lobby_page_controls_panel_enter_room_id_hint_text,
          hintColor: theme.textSecondary.withAlpha(100),
        ),
      ],
    );
  }
}
