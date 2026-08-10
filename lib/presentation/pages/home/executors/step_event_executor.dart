import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StepEventExecutor {
  const StepEventExecutor({required this.ref});

  final WidgetRef ref;

  Future<void> execute(GameStepEvent step) async {
    switch (step) {
      case GameStepEventComboReset():
      case GameStepEventDeckShuffled():
      case GameStepEventOverflowCheckTriggered():
      case GameStepEventPhaseChanged():
      case GameStepEventTurnEndEffectsResolved():
      case GameStepEventRegenApplied():
      case GameStepEventCostCalculated():
      case GameStepEventDrawCalculated():
      case GameStepEventComboUpdated():
      case GameStepEventDamageDealt():
      case GameStepEventReflectDamageApplied():
      case GameStepEventShieldGained():
      case GameStepEventShieldCleared():
      case GameStepEventPoisonApplied():
      case GameStepEventHealed():
      case GameStepEventGuardBoostApplied():
      case GameStepEventStatusEffectChanged():
      case GameStepEventCardPlayed():
      case GameStepEventCardExhausted():
      case GameStepEventDeckRestored():
      case GameStepEventCardsDrawn():
      case GameStepEventCardMovedZone():
      case GameStepEventTurnOwnerSwitched():
      case GameStepEventGameStarted():
      case GameStepEventGameEnded():
      case GameStepEventHandCardCountersUpdated():
      case GameStepEventBuffApplied():
      case GameStepEventDebuffApplied():
      case GameStepEventBuffRemoved():
      case GameStepEventDebuffRemoved():
    }
  }
}
