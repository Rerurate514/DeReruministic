import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/utils/card_states_ex.dart';
import 'package:flutter/material.dart';

class CardStateComponent extends StatelessWidget {
  const CardStateComponent({required this.state, super.key});

  final CardStates state;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    final color = state.color(theme);

    return AppCard(
      isBlur: true,
      blurSigma: 10,
      padding: const EdgeInsets.all(2),
      borderColor: color,
      child: Icon(
        state.icon,
        color: color,
        size: 20,
      ),
    );
  }
}
