import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_highlight_button.dart';
import 'package:flutter/material.dart';

class FightButton extends StatelessWidget {
  const FightButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppHighlightButton(
      onPressed: () {},
      child: Text(l10n.home_page_fight_button),
    );
  }
}
