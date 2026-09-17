import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_highlight_button.dart';
import 'package:dereruministic/presentation/components/app_text_field.dart';
import 'package:dereruministic/presentation/pages/auth/components/form/auth_button_label.dart';
import 'package:dereruministic/presentation/pages/auth/components/form/auth_error_message.dart';
import 'package:dereruministic/presentation/pages/auth/components/form/auth_header.dart';
import 'package:dereruministic/presentation/pages/auth/components/form/supported_providers_section.dart';
import 'package:dereruministic/presentation/pages/auth/providers/auth_action_notifier.dart';
import 'package:dereruministic/presentation/pages/auth/state/auth_mode.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class AuthForm extends HookConsumerWidget {
  const AuthForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final mode = useState(AuthMode.signIn);
    final authState = ref.watch(authActionProvider);
    final isLoading = authState.isLoading;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthHeader(mode: mode.value),
        const UiGap.l(),
        AppTextField(
          labelText: l10n.auth_page_email_label,
          hintText: l10n.auth_page_email_hint,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(
            Symbols.alternate_email,
            color: theme.brandSecondary,
          ),
        ),
        const UiGap.m(),
        AppTextField(
          labelText: l10n.auth_page_password_label,
          hintText: l10n.auth_page_password_hint,
          controller: passwordController,
          obscureText: true,
          prefixIcon: Icon(
            Symbols.key,
            color: theme.brandSecondary,
          ),
        ),
        AuthErrorMessage(authState: authState),
        const UiGap.l(),
        AppHighlightButton(
          onPressed: () => ref
              .read(authActionProvider.notifier)
              .submit(
                mode: mode.value,
                email: emailController.text,
                password: passwordController.text,
              ),
          isGlow: true,
          child: AuthButtonLabel(
            isLoading: isLoading,
            text: switch (mode.value) {
              AuthMode.signUp => l10n.auth_page_button_sign_up,
              AuthMode.signIn => l10n.auth_page_button_sign_in,
            },
          ),
        ),
        const UiGap.s(),
        TextButton(
          onPressed: isLoading ? null : () => mode.value = mode.value.toggled,
          child: Text(
            switch (mode.value) {
              AuthMode.signUp => l10n.auth_page_toggle_to_sign_in,
              AuthMode.signIn => l10n.auth_page_toggle_to_sign_up,
            },
            style: TextStyle(color: theme.brandSecondary),
          ),
        ),
        SupportedProvidersSection(isLoading: isLoading),
      ],
    );
  }
}
