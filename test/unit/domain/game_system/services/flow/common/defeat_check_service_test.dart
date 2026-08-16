import 'package:dereruministic/domain/game_system/services/flows/common/defeat_check_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/defeat_reason.dart';
import 'package:dereruministic/domain/game_system/value_objects/defeat_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/defeat_rule.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_end_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'defeat_check_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DefeatRule>()])
void main() {
  late MockDefeatRule mockRule;
  late DefeatCheckService service;
  late GameState state;

  const playerAId = PlayerId(value: 'player1');
  const playerBId = PlayerId(value: 'player2');

  setUp(() {
    mockRule = MockDefeatRule();
    service = DefeatCheckService(rules: [mockRule]);

    state = GameState(
      seed: 0,
      players: {
        playerAId: PlayerState.create(id: playerAId, deck: []),
        playerBId: PlayerState.create(id: playerBId, deck: []),
      },
      phase: GamePhase.init(playerAId),
      turnCount: 0,
      initialTurnOwner: playerAId,
    );
  });

  test('敗北ルールに該当しない場合、noStepsが返ること', () {
    when(mockRule.evaluate(state)).thenReturn([]);

    final result = service.execute(state) as ApplyActionResultSuccess;

    expect(result.steps, isEmpty);
    verify(mockRule.evaluate(state)).called(1);
  });

  test('プレイヤー1が敗北した場合、プレイヤー2が勝者としてイベントが生成されること', () {
    const defeatResult = DefeatResult(
      loserPlayerId: playerAId,
      reason: DefeatReason.hpZero,
    );

    when(mockRule.evaluate(state)).thenReturn([defeatResult]);

    final result = service.execute(state) as ApplyActionResultSuccess;

    expect(result.steps.length, equals(1));
    expect(
      result.steps.first,
      isA<GameStepEventGameEnded>()
          .having((e) => e.endResult, 'endResult', GameEndResult.winnerDecided)
          .having((e) => e.winnerPlayerId, 'winnerPlayerId', playerBId)
          .having((e) => e.loserPlayerId, 'loserPlayerId', playerAId)
          .having((e) => e.reason, 'reason', DefeatReason.hpZero),
    );
  });

  test('プレイヤー2が敗北した場合、プレイヤー1が勝者としてイベントが生成されること', () {
    const defeatResult = DefeatResult(
      loserPlayerId: playerBId,
      reason: DefeatReason.deckOut,
    );

    when(mockRule.evaluate(state)).thenReturn([defeatResult]);

    final result = service.execute(state) as ApplyActionResultSuccess;

    expect(result.steps.length, equals(1));
    expect(
      result.steps.first,
      isA<GameStepEventGameEnded>()
          .having((e) => e.endResult, 'endResult', GameEndResult.winnerDecided)
          .having((e) => e.winnerPlayerId, 'winnerPlayerId', playerAId)
          .having((e) => e.loserPlayerId, 'loserPlayerId', playerBId)
          .having((e) => e.reason, 'reason', DefeatReason.deckOut),
    );
  });

  test('両プレイヤーが同時に敗北した場合、引き分けイベントが生成されること', () {
    const defeatA = DefeatResult(
      loserPlayerId: playerAId,
      reason: DefeatReason.hpZero,
    );
    const defeatB = DefeatResult(
      loserPlayerId: playerBId,
      reason: DefeatReason.hpZero,
    );

    when(mockRule.evaluate(state)).thenReturn([defeatA, defeatB]);

    final result = service.execute(state) as ApplyActionResultSuccess;

    expect(result.steps.length, equals(1));
    expect(
      result.steps.first,
      isA<GameStepEventGameEnded>()
          .having((e) => e.endResult, 'endResult', GameEndResult.draw)
          .having((e) => e.winnerPlayerId, 'winnerPlayerId', isNull)
          .having((e) => e.loserPlayerId, 'loserPlayerId', isNull)
          .having((e) => e.reason, 'reason', DefeatReason.simultaneousDefeat),
    );
  });

  test('同一プレイヤーが複数の敗北条件を同時に満たした場合、単独敗北となること', () {
    const defeat1 = DefeatResult(
      loserPlayerId: playerAId,
      reason: DefeatReason.hpZero,
    );
    const defeat2 = DefeatResult(
      loserPlayerId: playerAId,
      reason: DefeatReason.deckOut,
    );

    when(mockRule.evaluate(state)).thenReturn([defeat1, defeat2]);

    final result = service.execute(state) as ApplyActionResultSuccess;

    expect(result.steps.length, equals(1));
    expect(
      result.steps.first,
      isA<GameStepEventGameEnded>()
          .having((e) => e.endResult, 'endResult', GameEndResult.winnerDecided)
          .having((e) => e.winnerPlayerId, 'winnerPlayerId', playerBId)
          .having((e) => e.loserPlayerId, 'loserPlayerId', playerAId),
    );
  });
}
