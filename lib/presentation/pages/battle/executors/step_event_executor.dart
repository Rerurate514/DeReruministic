import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/presentation/pages/battle/providers/animation_signal_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_card_drawn_animation_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_cost_calculated_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_game_start_notifier.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_phase_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'step_event_executor.g.dart';

@riverpod
StepEventExecutor stepEventExecutor(Ref ref, PlayerId playerId) {
  return StepEventExecutor(ref: ref, id: playerId);
}

class StepEventExecutor {
  const StepEventExecutor({required this.id, required this.ref});

  final Ref ref;
  final PlayerId id;

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
        {
          ref.read(displayedCostCalculatedProvider.notifier).apply();
        }
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
      case GameStepEventCardsDrawn(:final playerId, :final cardInstanceIds):
        {
          if (id != playerId) return;
          ref
              .read(displayedCardDrawnAnimationProvider.notifier)
              .apply(cardInstanceIds);
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
