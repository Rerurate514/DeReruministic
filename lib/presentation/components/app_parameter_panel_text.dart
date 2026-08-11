import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppParameterPanelText extends StatelessWidget {
  const AppParameterPanelText({
    required this.label,
    required this.value,
    super.key,
    this.labelColor,
    this.valueColor,
    this.valuePadding = const EdgeInsets.all(4),
  });

  final String label;
  final String value;
  final Color? labelColor;
  final Color? valueColor;
  final EdgeInsets valuePadding;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.shareTechMono(
            fontSize: 13,
            letterSpacing: 2,
            color: labelColor ?? theme.textSecondary,
          ),
        ),
        AppCard(
          padding: valuePadding,
          borderRadius: 2,
          child: Text(
            value.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 10,
              letterSpacing: 2,
              color: valueColor ?? theme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
