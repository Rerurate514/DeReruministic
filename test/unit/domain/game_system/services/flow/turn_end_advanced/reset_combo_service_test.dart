import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/reset_combo_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../helpers/game_test_helpers.dart';

void main() {
  const playerId = PlayerId(value: 'player_a');

  test('comboを解除してそのターンのカード使用枚数をリセットする', () {
    final state = buildState(
      players: {
        playerId: buildPlayer(
          id: playerId,
          buffs: const [
            BuffState(buff: BuffTypes.combo, stack: 3),
            BuffState(buff: BuffTypes.atkBuff, stack: 2),
          ],
          cardsPlayedThisTurn: 2,
        ),
      },
    );

    final result =
        ResetComboService().execute(state) as ApplyActionResultSuccess;

    expect(result.state.players[playerId]!.getBuffStack(BuffTypes.combo), 0);
    expect(result.state.players[playerId]!.getBuffStack(BuffTypes.atkBuff), 2);
    expect(result.state.players[playerId]!.cardsPlayedThisTurn, 0);
    expect(result.steps, [GameStepEvent.comboReset(phase: state.phase)]);
  });
}
