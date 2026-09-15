import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/auth/utils/firebase_auth_exception_ex.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthErrorMessage extends StatelessWidget {
  const AuthErrorMessage({required this.authState, super.key});

  final AsyncValue<void> authState;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    final error = authState.error;

    if (!authState.hasError) return const SizedBox.shrink();

    return Column(
      children: [
        const UiGap.m(),
        Text(
          resolveAuthErrorMessage(error: error, l10n: l10n),
          style: TextStyle(
            color: theme.brandTertiary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
