import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/auth/components/form/auth_form.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class AuthPanel extends StatelessWidget {
  const AuthPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    return AppCard(
      isBlur: true,
      blurSigma: 10,
      borderColor: theme.brandSecondary.withOpacity(0.65),
      background: theme.surfaceContainer.withOpacity(0.72),
      padding: const EdgeInsets.all(24),
      child: const AuthForm(),
    );
  }
}
