import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/switch_turn_owner_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/game_system/value_objects/system_metadata.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SwitchTurnOwnerService switchTurnOwnerService;

  const playerAId = PlayerId(value: 'player_a');
  const playerBId = PlayerId(value: 'player_b');

  final playerAState = PlayerState.create(
    id: playerAId,
    deck: const [],
  );

  final playerBState = PlayerState.create(
    id: playerBId,
    deck: const [],
  );

  final baseState = GameState(
    players: {
      playerAId: playerAState,
      playerBId: playerBState,
    },
    phase: GamePhase.init(playerAId),
    turnCount: 1,
    initialTurnOwner: playerAId,
    metadata: const SystemMetadata(seed: 12345, actionSequenceNumber: 0),
  );

  setUp(() {
    switchTurnOwnerService = SwitchTurnOwnerService();
  });

  group('SwitchTurnOwnerService', () {
    test('nextTurnが呼び出されてターン所有者が更新され、GameStepEventTurnOwnerSwitchedが発行される', () {
      final result =
          switchTurnOwnerService.execute(baseState) as ApplyActionResultSuccess;

      expect(result.state, equals(baseState.nextTurn()));

      expect(result.steps.length, equals(2));
      final step = result.steps.first as GameStepEventTurnOwnerSwitched;
      expect(step.newTurnPlayerId, equals(playerBId));
    });
  });
}
