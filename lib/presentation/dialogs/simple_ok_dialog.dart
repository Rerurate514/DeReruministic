import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/components/app_highlight_button.dart';
import 'package:dereruministic/presentation/components/app_highlight_transparency_button.dart';
import 'package:dereruministic/presentation/widgets/ui_gap.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> showSimpleOkDialog({
  required BuildContext context,
  required AppLocalizations l10n,
  required void Function() onOkTapped,
  required Widget title,
}) async {
  await showDialog<void>(
    context: context,
    builder: (context) {
      return Center(
        child: AppCard(
          isBlur: true,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: .min,
            children: [
              title,
              const UiGap.m(),
              Row(
                spacing: 8,
                mainAxisSize: .min,
                mainAxisAlignment: .spaceAround,
                children: [
                  AppHighlightTransparencyButton(
                    width: 120,
                    onPressed: () {
                      Navigator.pop(context);
                      return;
                    },
                    child: Text(
                      l10n.dialogs_simple_ok_dialog_cancel_button_text,
                      style: GoogleFonts.shareTechMono(),
                    ),
                  ),
                  AppHighlightButton(
                    width: 120,
                    onPressed: () {
                      onOkTapped();
                      Navigator.pop(context);
                    },
                    child: Text(
                      l10n.dialogs_simple_ok_dialog_ok_button_text,
                      style: GoogleFonts.shareTechMono(fontWeight: .bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
