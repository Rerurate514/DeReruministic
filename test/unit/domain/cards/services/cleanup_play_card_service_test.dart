import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/services/cleanup_play_card_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/game_test_helpers.dart';

const infectCardDefinition = CardDefinition(
  cardDefId: CardDefinitionId(value: 'infect_card'),
  name: 'Infect',
  baseCost: 1,
  effects: [],
  states: [CardStates.infect()],
);

void main() {
  const sourcePlayerId = PlayerId(value: 'source');
  const targetPlayerId = PlayerId(value: 'target');
  const service = CleanupPlayCardService();

  group('CleanupPlayCardService.execute', () {
    test('感染カードを相手の山札の一番下へ移動する', () {
      final existingTargetCard = buildCard(instanceId: 'target_card');
      final infectCard = buildCard(
        instanceId: 'infect_card',
        definition: infectCardDefinition,
      );
      final state = buildState(
        players: {
          sourcePlayerId: buildPlayer(id: sourcePlayerId).copyWith(
            playArea: [infectCard],
          ),
          targetPlayerId: buildPlayer(
            id: targetPlayerId,
            deck: [existingTargetCard],
          ),
        },
        turnOwner: sourcePlayerId,
      );

      final result = service.execute(
        state: state,
        playerId: sourcePlayerId,
        instanceId: infectCard.instanceId,
      );

      expect(result, isA<ApplyActionResultSuccess>());
      final success = result as ApplyActionResultSuccess;
      expect(success.state.players[sourcePlayerId]!.playArea, isEmpty);
      expect(
        success.state.players[targetPlayerId]!.deck,
        [existingTargetCard, infectCard],
      );
      expect(success.steps, isEmpty);
    });
  });
}
