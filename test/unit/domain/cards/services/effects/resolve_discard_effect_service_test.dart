import 'package:dereruministic/domain/card/services/effects/resolve_discard_effect_service.dart';
import 'package:dereruministic/domain/card/services/move_card_zone_service.dart';
import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/game_system/value_objects/action_failure_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/game_test_helpers.dart';

void main() {
  const playerId = PlayerId(value: 'player');
  const otherPlayerId = PlayerId(value: 'other');
  const service = ResolveDiscardEffectService(
    moveCardZoneService: MoveCardZoneService(),
  );

  group('ResolveDiscardEffectService.execute', () {
    test('指定した手札カードを墓地へ移動する', () {
      final discardedCard = buildCard(instanceId: 'discarded');
      final remainingCard = buildCard(instanceId: 'remaining');
      final state = buildState(
        players: {
          playerId: buildPlayer(
            id: playerId,
            hand: [discardedCard, remainingCard],
          ),
        },
      );

      final result = service.execute(
        state: state,
        effect: CardEffects.discard(card: discardedCard) as CardEffectDiscard,
        sourcePlayerId: playerId,
      );

      final success = result as ApplyActionResultSuccess;
      final player = success.state.players[playerId]!;
      expect(player.hand, [remainingCard]);
      expect(player.graveyard, [discardedCard]);
      expect(success.steps, hasLength(1));
      expect(success.steps.single, isA<GameStepEventCardMovedZone>());
      final step = success.steps.single as GameStepEventCardMovedZone;
      expect(step.zoneFrom, CardZone.hand);
      expect(step.zoneTo, CardZone.graveyard);
      expect(step.instanceIds, [discardedCard.instanceId]);
    });

    test('指定カードが手札にない場合はcardNotFoundで失敗する', () {
      final card = buildCard(instanceId: 'missing');
      final state = buildState(players: {playerId: buildPlayer(id: playerId)});

      final result = service.execute(
        state: state,
        effect: CardEffects.discard(card: card) as CardEffectDiscard,
        sourcePlayerId: playerId,
      );

      expect(result, isA<ApplyActionResultFailure>());
      final failure = result as ApplyActionResultFailure;
      expect(failure.reason, ActionFailureReason.cardNotFound);
      expect(failure.state, state);
    });

    test('使用者が存在しない場合はplayerNotFoundで失敗する', () {
      final card = buildCard(instanceId: 'discarded');
      final state = buildState(
        players: {otherPlayerId: buildPlayer(id: otherPlayerId)},
      );

      final result = service.execute(
        state: state,
        effect: CardEffects.discard(card: card) as CardEffectDiscard,
        sourcePlayerId: playerId,
      );

      expect(result, isA<ApplyActionResultFailure>());
      expect(
        (result as ApplyActionResultFailure).reason,
        ActionFailureReason.playerNotFound,
      );
    });
  });
}
