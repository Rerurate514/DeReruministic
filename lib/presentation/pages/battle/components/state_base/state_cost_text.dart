import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

class StateCostText extends HookWidget {
  const StateCostText({
    required this.cost,
    required this.maxCost,
    super.key,
  });

  final int cost;
  final int maxCost;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    final controller = useAnimationController(
      duration: const Duration(seconds: 2),
    );

    useEffect(() {
      controller.repeat(reverse: true);
      return null;
    }, []);

    final animation = useAnimation(
      Tween<double>(
        begin: 10,
        end: 0,
      ).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      ),
    );

    return Text(
      l10n.battle_page_header_cost(cost, maxCost),
      style: GoogleFonts.shareTechMono(
        fontSize: 20,
        color: theme.brandSecondary,
        shadows: [Shadow(color: theme.brandSecondary, blurRadius: animation)],
      ),
    );
  }
}
