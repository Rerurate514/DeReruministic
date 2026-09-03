import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_hollow_glow_card.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class RoomIdCopyButton extends StatelessWidget {
  const RoomIdCopyButton({required this.copiedText, super.key});

  final String copiedText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return AppHollowGlowCard(
      blurRadius: 4,
      borderRadius: 4,
      child: InkWell(
        onTap: () async {
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
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            spacing: 4,
            children: [
              Icon(Symbols.content_copy, size: 20, color: theme.brandColor),
              Text(
                l10n.room_page_room_id_card_copy_button,
                style: GoogleFonts.shareTechMono(color: theme.brandColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
