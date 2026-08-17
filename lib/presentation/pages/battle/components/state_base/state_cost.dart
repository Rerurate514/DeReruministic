import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/components/app_linear_percent_indicator.dart';
import 'package:dereruministic/presentation/pages/battle/components/state_base/state_cost_text.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class StateCost extends StatelessWidget {
  const StateCost({required this.cost, required this.maxCost, super.key});

  final int cost;
  final int maxCost;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    return Stack(
      alignment: .center,
      children: [
        AppLinearPercentIndicator(
          percent: cost / maxCost,
          width: 100,
          lineHeight: 8,
          color: theme.brandSecondary.withAlpha(200),
        ),
        AppCard(
          isBlur: true,
          borderColor: Colors.transparent,
          borderRadius: 16,
          child: Row(
            spacing: 16,
            children: [
              Icon(
                Symbols.bolt,
                color: theme.costDp,
                size: 20,
              ),
              StateCostText(
                cost: cost,
                maxCost: maxCost,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
