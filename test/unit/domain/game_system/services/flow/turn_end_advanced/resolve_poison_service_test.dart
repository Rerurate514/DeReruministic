import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/resolve_poison_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/game_test_helpers.dart';

void main() {
  const playerId = PlayerId(value: 'player_a');

  test('poisonのスタック数だけHPへダメージを与え、シールドは無視する', () {
    final state = buildState(
      players: {
        playerId: buildPlayer(
          id: playerId,
          hp: 12,
          shield: 10,
          debuffs: const [DebuffState(debuff: DebuffTypes.poison, stack: 5)],
        ),
      },
    );

    final result =
        ResolvePoisonService().execute(state) as ApplyActionResultSuccess;

    expect(result.state.players[playerId]!.hp, 7);
    expect(result.state.players[playerId]!.shield, 10);
    expect(
      result.steps,
      [
        const GameStepEvent.damageDealt(
          targetPlayerId: playerId,
          hpDamage: 5,
          shieldDamage: 0,
        ),
      ],
    );
  });
}
