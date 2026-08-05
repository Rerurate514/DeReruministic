import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_process_step.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';

class TurnPipeline {
  const TurnPipeline({
    required this.turnProcessSteps,
  });

  final List<TurnProcessStep> turnProcessSteps;

  ApplyActionResult process(
    GameState current,
    List<GameStepEvent> initialSteps,
  ) {
    final accumulatedSteps = <GameStepEvent>[];
    var currentState = current;

    for (final turnProcessStep in turnProcessSteps) {
      final result = turnProcessStep.execute(currentState);
      accumulatedSteps.addAll(result.steps);
      currentState = result.state;
    }

    return ApplyActionResult(state: currentState, steps: accumulatedSteps);
  }
}

// import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_process_step.dart';
// import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
// import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
// import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';

// class TurnPipeline {
//   const TurnPipeline({
//     required List<TurnProcessStep> turnProcessSteps,
//   }) : _turnProcessSteps = turnProcessSteps;

//   final List<TurnProcessStep> _turnProcessSteps;

//   ApplyActionResult process(
//     GameState initialState,
//     List<GameStepEvent> initialSteps,
//   ) {
//     var currentState = initialState;
//     final accumulatedSteps = List<GameStepEvent>.from(initialSteps);

//     print('==================================================');
//     print(
//       ' 🚀 [Pipeline Start] Turn: ${currentState.turnCount} | Phase: ${currentState.phase}',
//     );
//     print('==================================================');

//     if (initialSteps.isNotEmpty) {
//       print(' 📋 [Initial Steps]');
//       for (final step in initialSteps) {
//         _printStepDetail(step, indent: '   ');
//       }
//     }

//     for (final stepService in _turnProcessSteps) {
//       final stepName = stepService.runtimeType.toString();
//       final result = stepService.execute(currentState);
//       currentState = result.state;
//       accumulatedSteps.addAll(result.steps);

//       print(' ├─ ⚙️ Executing: $stepName');
//       print(' │    ├─ Phase -> ${currentState.phase}');

//       if (result.steps.isEmpty) {
//         print(' │    └─ Steps Generated: (none)');
//       } else {
//         print(' │    └─ Steps Generated (${result.steps.length}):');
//         for (final step in result.steps) {
//           _printStepDetail(step, indent: ' │         ');
//         }
//       }
//     }

//     print('==================================================');
//     print(
//       ' 🏁 [Pipeline End] Next Turn: ${currentState.turnCount} | Phase: ${currentState.phase}',
//     );
//     print('==================================================\n');

//     return ApplyActionResult(
//       state: currentState,
//       steps: accumulatedSteps,
//     );
//   }

//   void _printStepDetail(GameStepEvent step, {required String indent}) {
//     step.when(
//       transition: (type, phase) {
//         print('$indent• [$type] 遷移先フェーズ: $phase');
//       },
//       valueChanged: (type, playerId, amount) {
//         print('$indent• [$type] プレイヤー: ${playerId.value} | 変動量: $amount');
//       },
//       statusEffectChanged: (type, playerId, statusType, value) {
//         print(
//           '$indent• [$type] プレイヤー: ${playerId.value} | 状態: $statusType (値: $value)',
//         );
//       },
//       cardsAffected: (type, playerId, cardIds) {
//         final ids = cardIds.map((e) => e.value).join(', ');
//         print('$indent• [$type] プレイヤー: ${playerId.value} | 対象カード: [$ids]');
//       },
//       cardAction: (type, playerId, cardId, targetPlayerId) {
//         final target = targetPlayerId != null
//             ? ' -> ターゲット: ${targetPlayerId.value}'
//             : '';
//         print(
//           '$indent• [$type] プレイヤー: ${playerId.value} | カード: ${cardId.value}$target',
//         );
//       },
//       deckRestored: (type, playerId, count) {
//         print('$indent• [$type] プレイヤー: ${playerId.value} | 山札復元枚数: $count');
//       },
//       cardZoneMoved: (type, playerId, cardIds, fromZone, toZone) {
//         final ids = cardIds.map((e) => e.value).join(', ');
//         print(
//           '$indent• [$type] プレイヤー: ${playerId.value} | 移動: $fromZone -> $toZone | カード: [$ids]',
//         );
//       },
//       gameStarted: (type, firstTurnPlayerId) {
//         print('$indent• [$type] 先攻プレイヤー: ${firstTurnPlayerId.value}');
//       },
//       gameEnded: (type, winnerPlayerId, reason) {
//         final winner = winnerPlayerId != null ? winnerPlayerId.value : '引き分け';
//         print('$indent• [$type] 勝者: $winner | 理由: $reason');
//       },
//     );
//   }
// }
