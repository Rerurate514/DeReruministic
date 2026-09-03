import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_hollow_glow_card.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter/services.dart';

class AppCopyButton extends StatelessWidget {
  const AppCopyButton({required this.copiedText, super.key});

  final String copiedText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppHollowGlowCard(
      child: IconButton(
        onPressed: () async {
          await Clipboard.setData(
            ClipboardData(text: copiedText),
          );

          if (!context.mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.snack_bar_clipboard_copy_success),
            ),
          );
        },
        icon: const Icon(Symbols.content_copy),
      ),
    );
  }
}
