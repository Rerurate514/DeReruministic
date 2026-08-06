import 'package:dereruministic/domain/game_system/services/flows/turn_end_advanced/remove_shield_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RemoveShieldService removeShieldService;

  const playerAId = PlayerId(value: 'player_a');
  const playerBId = PlayerId(value: 'player_b');

  final playerAState = PlayerState.create(
    id: playerAId,
    deck: const [],
  ).copyWith(shield: 10);

  final playerBState = PlayerState.create(
    id: playerBId,
    deck: const [],
  ).copyWith(shield: 5);

  final baseState = GameState(
    seed: 12345,
    players: {
      playerAId: playerAState,
      playerBId: playerBState,
    },
    phase: GamePhase.init(playerAId),
    turnCount: 1,
  );

  setUp(() {
    removeShieldService = RemoveShieldService();
  });

  group('RemoveShieldService', () {
    test('ターンプレイヤーのシールドのみがクリアされ、非ターンプレイヤーのシールドは維持される', () {
      final result = removeShieldService.execute(baseState);

      final statePlayerA = result.state.players[playerAId]!;
      final statePlayerB = result.state.players[playerBId]!;

      expect(statePlayerA.shield, equals(0));
      expect(statePlayerB.shield, equals(5));

      expect(result.steps.length, equals(1));
      final step = result.steps.first as GameStepEventShieldCleared;
      expect(step.targetPlayerId, equals(playerAId));
    });
  });
}
