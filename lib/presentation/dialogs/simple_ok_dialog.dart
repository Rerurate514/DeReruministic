import 'package:dereruministic/l10n/app_localizations.dart';
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
      return AlertDialog(
        title: title,
        actionsAlignment: .center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              return;
            },
            child: Text(
              l10n.dialogs_simple_ok_dialog_cancel_button_text,
              style: GoogleFonts.shareTechMono(),
            ),
          ),
          TextButton(
            onPressed: () {
              onOkTapped();
              Navigator.pop(context);
            },
            child: Text(
              l10n.dialogs_simple_ok_dialog_ok_button_text,
              style: GoogleFonts.shareTechMono(),
            ),
          ),
        ],
      );
    },
  );
}
