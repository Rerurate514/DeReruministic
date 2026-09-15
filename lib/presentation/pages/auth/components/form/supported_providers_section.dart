import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/auth/components/form/provider_button.dart';
import 'package:dereruministic/presentation/pages/auth/providers/auth_action_notifier.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_gap.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class SupportedProvidersSection extends ConsumerWidget {
  const SupportedProvidersSection({required this.isLoading, super.key});

  final bool isLoading;

  bool get _supportsSocialProviders {
    return kIsWeb || defaultTargetPlatform != TargetPlatform.linux;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    if (!_supportsSocialProviders) return const SizedBox.shrink();

    return Column(
      children: [
        const UiGap.m(),
        Row(
          children: [
            Expanded(child: Divider(color: theme.outline)),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: Text(
                l10n.auth_page_providerDivider,
                style: GoogleFonts.shareTechMono(
                  color: theme.textSecondary,
                ),
              ),
            ),
            Expanded(child: Divider(color: theme.outline)),
          ],
        ),
        const UiGap.m(),
        ProviderButton(
          icon: Symbols.account_circle,
          onPressed: isLoading
              ? null
              : ref.read(authActionProvider.notifier).signInWithGoogle,
          child: Text(l10n.auth_page_googleProvider),
        ),
        const UiGap.s(),
        ProviderButton(
          icon: Symbols.code,
          onPressed: isLoading
              ? null
              : ref.read(authActionProvider.notifier).signInWithGitHub,
          child: Text(l10n.auth_page_githubProvider),
        ),
      ],
    );
  }
}
