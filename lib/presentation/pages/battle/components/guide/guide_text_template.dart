import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GuideTextTemplate extends StatelessWidget {
  const GuideTextTemplate({
    required this.title,
    required this.titleColor,
    required this.leading,
    required this.details,
    super.key,
  });

  final String title;
  final Color titleColor;
  final Widget leading;
  final Widget details;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          title,
          style: GoogleFonts.shareTechMono(color: titleColor),
        ),
        AppCard(
          child: Row(
            children: [
              Expanded(
                child: leading,
              ),
              Expanded(
                flex: 4,
                child: details,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
