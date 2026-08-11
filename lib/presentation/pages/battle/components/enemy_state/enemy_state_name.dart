import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class EnemyStateName extends ConsumerWidget {
  const EnemyStateName({required this.name, super.key});

  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themePalette;
    return Text(
      name,
      style: GoogleFonts.poppins(color: theme.textSecondary),
    );
  }
}
