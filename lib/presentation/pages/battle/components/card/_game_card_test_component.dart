import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dereruministic/domain/card/data/basic_pack.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/game_card_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameCardTestComponent extends ConsumerWidget {
  const GameCardTestComponent({
    required this.player,
    super.key,
  });

  final Player player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final gameCard = ref
    //     .watch(
    //       myPlayerUiStateProvider(player).select((s) => s?.deck),
    //     )
    //     ?.first;

    // if (gameCard == null) return const Text('game card is null');

    final def = basicPack.firstWhereOrNull(
      (def) => def.cardDefId.value == 'basic_pack_doomsday_seal',
    )!;

    return GameCardComponent(
      gameCard: GameCard(
        instanceId: GameCardInstanceId.generate(Random(23)),
        definition: def,
        currentCost: 32,
        enteredHandAtTurn: 0,
        runtimeStates: def.states.buildInitialRuntimeStates(),
      ),
    );
  }
}
