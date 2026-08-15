import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/presentation/pages/battle/providers/animation_signal_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_card_drawn_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_game_start_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_phase_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'step_event_executor.g.dart';

@riverpod
StepEventExecutor stepEventExecutor(Ref ref) {
  return StepEventExecutor(ref: ref);
}

class StepEventExecutor {
  const StepEventExecutor({required this.ref});

  final Ref ref;

  Future<void> execute(GameStepEvent step) async {
    switch (step) {
      case GameStepEventComboReset():
        {}
      case GameStepEventDeckShuffled():
        {}
      case GameStepEventOverflowCheckTriggered():
        {}
      case GameStepEventPhaseChanged(:final phase):
        {
          ref.read(displayedPhaseProvider.notifier).apply(phase);
          await _awaitAnimation();
        }
      case GameStepEventTurnEndEffectsResolved():
        {}
      case GameStepEventRegenApplied():
        {}
      case GameStepEventCostCalculated():
        {}
      case GameStepEventDrawCalculated():
        {}
      case GameStepEventComboUpdated():
        {}
      case GameStepEventDamageDealt():
        {}
      case GameStepEventReflectDamageApplied():
        {}
      case GameStepEventShieldGained():
        {}
      case GameStepEventShieldCleared():
        {}
      case GameStepEventPoisonApplied():
        {}
      case GameStepEventHealed():
        {}
      case GameStepEventGuardBoostApplied():
        {}
      case GameStepEventStatusEffectChanged():
        {}
      case GameStepEventCardPlayed():
        {}
      case GameStepEventCardExhausted():
        {}
      case GameStepEventDeckRestored():
        {}
      case GameStepEventCardsDrawn():
        {
          ref.read(displayedCardDrawnProvider.notifier).apply();
          await _awaitAnimation();
        }
      case GameStepEventCardMovedZone():
        {
          await Future<void>.delayed(const Duration(milliseconds: 200));
        }
      case GameStepEventTurnOwnerSwitched():
        {}
      case GameStepEventGameStarted():
        {
          ref.read(displayedGameStartProvider.notifier).apply();
          await _awaitAnimation();
        }
      case GameStepEventGameEnded():
        {}
      case GameStepEventHandCardCountersUpdated():
        {}
      case GameStepEventBuffApplied():
        {}
      case GameStepEventDebuffApplied():
        {}
      case GameStepEventBuffRemoved():
        {}
      case GameStepEventDebuffRemoved():
        {}
    }
  }

  Future<void> _awaitAnimation() =>
      ref.read(animationSignalProvider.notifier).wait();
}
