import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_highlight_transparency_button.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class SettingButton extends StatelessWidget {
  const SettingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return AppHighlightTransparencyButton(
      foregroundColor: theme.textSecondary,
      onPressed: () {},
      child: Row(
        mainAxisAlignment: .center,
        spacing: 8,
        children: [
          Icon(Symbols.settings, color: theme.textSecondary),
          Text(l10n.home_page_setting_button_text),
        ],
      ),
    );
  }
}
