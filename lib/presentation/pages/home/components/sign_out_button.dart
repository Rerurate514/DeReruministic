import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_highlight_transparency_button.dart';
import 'package:dereruministic/presentation/pages/home/providers/sign_out_notifier.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class SignOutButton extends ConsumerWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    final signOutState = ref.watch(signOutProvider);

    return AppHighlightTransparencyButton(
      foregroundColor: theme.textSecondary,
      onPressed: signOutState.isLoading
          ? null
          : ref.read(signOutProvider.notifier).execute,
      child: signOutState.isLoading
          ? const UiLoadingIndicator(size: 18)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Icon(Symbols.logout, color: theme.textSecondary),
                Text(l10n.home_page_sign_out_button_text),
              ],
            ),
    );
  }
}
