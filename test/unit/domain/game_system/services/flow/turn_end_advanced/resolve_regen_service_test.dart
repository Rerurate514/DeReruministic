import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/resolve_regen_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/game_test_helpers.dart';

void main() {
  const playerId = PlayerId(value: 'player_a');

  test('regenerationのスタック数だけHPを回復する', () {
    final state = buildState(
      players: {
        playerId: buildPlayer(
          id: playerId,
          hp: 12,
          buffs: const [
            BuffState(buff: BuffTypes.regeneration, stack: 5),
          ],
        ),
      },
    );

    final result =
        ResolveRegenService().execute(state) as ApplyActionResultSuccess;

    expect(result.state.players[playerId]!.hp, 17);
    expect(
      result.steps,
      [const GameStepEvent.regenApplied(targetPlayerId: playerId, amount: 5)],
    );
  });

  test('最大HPを超えて回復しない', () {
    final state = buildState(
      players: {
        playerId: buildPlayer(
          id: playerId,
          hp: 18,
          buffs: const [
            BuffState(buff: BuffTypes.regeneration, stack: 5),
          ],
        ),
      },
    );

    final result =
        ResolveRegenService().execute(state) as ApplyActionResultSuccess;

    expect(result.state.players[playerId]!.hp, 20);
    expect(
      result.steps,
      [const GameStepEvent.regenApplied(targetPlayerId: playerId, amount: 2)],
    );
  });
}
