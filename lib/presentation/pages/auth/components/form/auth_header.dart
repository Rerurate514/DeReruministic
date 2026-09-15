import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_title.dart';
import 'package:dereruministic/presentation/pages/auth/state/auth_mode.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_gap.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({required this.mode, super.key});

  final AuthMode mode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return Column(
      children: [
        Icon(
          Symbols.encrypted,
          color: theme.brandSecondary,
          size: 42,
        ),
        const UiGap.m(),
        const FittedBox(
          child: AppTitle(),
        ),
        const UiGap.s(),
        Text(
          switch (mode) {
            AuthMode.signUp => l10n.auth_page_subtitleSignUp,
            AuthMode.signIn => l10n.auth_page_subtitleSignIn,
          },
          textAlign: TextAlign.center,
          style: GoogleFonts.shareTechMono(
            color: theme.brandSecondary,
            fontSize: 14,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}
