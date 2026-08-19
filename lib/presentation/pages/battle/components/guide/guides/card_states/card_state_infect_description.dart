import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guides/card_states_base.dart';
import 'package:flutter/material.dart';

class CardStateInfectDescription extends StatelessWidget {
  const CardStateInfectDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return const CardStatesBase(
      states: CardStates.infect(),
    );
  }
}
