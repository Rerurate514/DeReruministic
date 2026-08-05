import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/services/game_setup_service.dart';
import 'package:dereruministic/domain/game_system/services/remove_shield_service.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_setup_context.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_flow_usecase.g.dart';

@riverpod
GameFlowUsecase gameFlowUsecase(Ref ref) {
  return GameFlowUsecase(
    gameSetupService: ref.read(gameSetupServiceProvider),
    removeShieldService: ref.read(removeShieldServiceProvider),
  );
}

class GameFlowUsecase {
  const GameFlowUsecase({
    required this.removeShieldService,
    required this.gameSetupService,
  });

  final GameSetupService gameSetupService;
  final RemoveShieldService removeShieldService;

  ApplyActionResult applyAction({
    required GameState current,
    required GameActions action,
    GameSetupContext? setupContext,
  }) {
    final steps = <GameStepEvent>[];
    switch (action) {
      case GameActionGameStart():
        {
          if (setupContext == null) throw ArgumentError();
          return _applyGameStart(current, action, setupContext);
        }
      case GameActionPlayCard():
        return _applyPlayCard(current, action);
      case GameActionDiscardCard():
        return _applyDiscardCard(current, action);
      case GameActionSelectOverflowDiscards():
        return _applyOverflowDiscards(
          current,
          action,
        );
      case GameActionTurnEnd():
        return _applyTurnEndAndAutoAdvance(current, action, steps);
      case GameActionSurrender():
        return _applySurrender(current, action);
    }
  }

  ApplyActionResult _applyGameStart(
    GameState current,
    GameActionGameStart action,
    GameSetupContext context,
  ) {
    return ApplyActionResult.noSteps(
      state: gameSetupService.execute(
        player: context.player,
        enemy: context.enemy,
        cardDefs: context.cardDefs,
        seed: context.seed,
      ),
    );
  }

  ApplyActionResult _applyPlayCard(
    GameState current,
    GameActionPlayCard action,
  ) {
    return ApplyActionResult.noSteps(state: current);
  }

  ApplyActionResult _applyDiscardCard(
    GameState current,
    GameActionDiscardCard action,
  ) {
    return ApplyActionResult.noSteps(state: current);
  }

  ApplyActionResult _applyOverflowDiscards(
    GameState current,
    GameActionSelectOverflowDiscards action,
  ) {
    return ApplyActionResult.noSteps(state: current);
  }

  ApplyActionResult _applyTurnEndAndAutoAdvance(
    GameState current,
    GameActionTurnEnd action,
    List<GameStepEvent> steps,
  ) {
    final removeShieldResult = removeShieldService.execute(current: current);
    steps.addAll(removeShieldResult.steps);

    // 3. ターン終了時に発動する効果の解決（パッシブ効果、毒・ドットダメージ、バフ減衰など）
    // final (:state, :event) = ResolveTurnEndEffectsService.execute(current: removeShieldResult.state);
    // steps.add(event);

    // 4. ターン所有権の切り替え（プレイヤー ↔ 敵のターン交代）
    // final (:state, :event) = switchTurnOwner(current);
    // steps.add(event);

    // 5. 新ターンの開始処理（ドロー、AP/マナの回復、ターン開始時イベントの発行など）
    // final startTurnResult = startTurnService.execute(current: switchedState);

    // 6. ターン開始時に発動する効果の解決（ターン開始時カード効果、時限仕掛けの発動など）
    // final (:state, :event) = ResolveTurnStartEffectsService.execute(current: startTurnResult.state);
    // steps.add(event);

    // 7. 最終的なゲーム状態（GameState）と集約された一連の演出ステップ（steps）を返却

    return ApplyActionResult(state: removeShieldResult.state, steps: steps);
  }

  ApplyActionResult _applySurrender(
    GameState current,
    GameActionSurrender action,
  ) {
    return ApplyActionResult.noSteps(state: current);
  }
}
