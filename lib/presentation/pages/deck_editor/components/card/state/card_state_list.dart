import 'package:dereruministic/domain/card/value_objects/card_runtime_states.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/state/card_state_component.dart';
import 'package:flutter/material.dart';

class CardStateList extends StatelessWidget {
  const CardStateList({
    required this.states,
    required this.runtimeStates,
    super.key,
  });

  final List<CardStates> states;
  final List<CardRuntimeStates> runtimeStates;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: states
          .map(
            (state) => CardStateComponent(
              state: state,
              runtimeStates: state.findIn(runtimeStates),
            ),
          )
          .toList(),
    );
  }
}
