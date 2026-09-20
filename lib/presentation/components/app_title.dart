import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_interlacing_artifacts_text.dart';
import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({
    super.key,
    this.fontSize = 48.0,
  });

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppInterlacingArtifactsText(
      text: l10n.app_title,
    );
  }
}
