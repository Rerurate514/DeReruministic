import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/components/app_linear_percent_indicator.dart';
import 'package:dereruministic/presentation/pages/battle/components/player_state/player_state_cost_text.dart';
import 'package:dereruministic/presentation/pages/battle/providers/player_ui_state_provider.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_cost_calculated_notifier.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class PlayerStateCost extends ConsumerWidget {
  const PlayerStateCost({required this.player, super.key});

  final Player player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themePalette;

    final cost = ref.watch(
      myPlayerUiStateProvider(player).select((s) => s?.cost),
    );

    final maxCost = ref.watch(
      myPlayerUiStateProvider(player).select((s) => s?.maxCost),
    );

    if (cost == null || maxCost == null) return const UiLoadingIndicator();

    final event = ref.watch(displayedCostCalculatedProvider);

    return Stack(
      alignment: .center,
      children: [
        AppLinearPercentIndicator(
          percent: event != null ? cost / maxCost : 0,
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
              PlayerStateCostText(
                cost: event != null ? cost : 0,
                maxCost: maxCost,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
