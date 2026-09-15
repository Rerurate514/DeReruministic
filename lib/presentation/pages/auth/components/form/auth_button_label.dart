import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthButtonLabel extends StatelessWidget {
  const AuthButtonLabel({
    required this.isLoading,
    required this.text,
    super.key,
  });

  final bool isLoading;
  final String text;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox.square(
        dimension: 22,
        child: FittedBox(
          child: UiLoadingIndicator(),
        ),
      );
    }

    return Text(
      text,
      style: GoogleFonts.shareTechMono(
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
      ),
    );
  }
}
