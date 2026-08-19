import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/utils/game_phase_ex.dart';

extension GameStepEventEx on GameStepEvent {
  String text(AppLocalizations l10n) {
    return switch (this) {
      GameStepEventComboReset() => l10n.game_step_event_combo_reset,

      GameStepEventDeckShuffled() => l10n.game_step_event_deck_shuffled,

      GameStepEventOverflowCheckTriggered(
        :final playerId,
        :final overflowCount,
      ) =>
        l10n.game_step_event_overflow_check_triggered(
          playerId.value,
          overflowCount,
        ),

      GameStepEventPhaseChanged(:final phase) =>
        l10n.game_step_event_phase_changed(phase.text(l10n)),

      GameStepEventTurnEndEffectsResolved() =>
        l10n.game_step_event_turn_end_effects_resolved,

      GameStepEventRegenApplied(:final targetPlayerId, :final amount) =>
        l10n.game_step_event_regen_applied(targetPlayerId.value, amount),

      GameStepEventCostCalculated(:final targetPlayerId, :final amount) =>
        l10n.game_step_event_cost_calculated(targetPlayerId.value, amount),

      GameStepEventDrawCalculated(:final targetPlayerId, :final amount) =>
        l10n.game_step_event_draw_calculated(targetPlayerId.value, amount),

      GameStepEventComboUpdated(:final targetPlayerId, :final amount) =>
        l10n.game_step_event_combo_updated(targetPlayerId.value, amount),

      GameStepEventDamageDealt(
        :final hpDamage,
        :final shieldDamage,
      ) =>
        l10n.game_step_event_damage_dealt(hpDamage, shieldDamage),

      GameStepEventReflectDamageApplied(
        :final targetPlayerId,
        :final amount,
      ) =>
        l10n.game_step_event_reflect_damage_applied(
          targetPlayerId.value,
          amount,
        ),

      GameStepEventShieldGained(:final targetPlayerId, :final amount) =>
        l10n.game_step_event_shield_gained(targetPlayerId.value, amount),

      GameStepEventShieldRemoved(:final targetPlayerId, :final amount) =>
        l10n.game_step_event_shield_removed(targetPlayerId.value, amount),

      GameStepEventShieldCleared(:final targetPlayerId) =>
        l10n.game_step_event_shield_cleared(targetPlayerId.value),

      GameStepEventHealed(:final targetPlayerId, :final amount) =>
        l10n.game_step_event_healed(targetPlayerId.value, amount),

      GameStepEventHandCardCountersUpdated(:final playerId) =>
        l10n.game_step_event_hand_card_counters_updated(playerId.value),

      GameStepEventBuffApplied(
        :final targetPlayerId,
        :final buff,
        :final stack,
        :final totalStack,
      ) =>
        l10n.game_step_event_buff_applied(
          targetPlayerId.value,
          buff.name,
          stack,
          totalStack,
        ),

      GameStepEventDebuffApplied(
        :final targetPlayerId,
        :final debuff,
        :final stack,
        :final totalStack,
      ) =>
        l10n.game_step_event_debuff_applied(
          targetPlayerId.value,
          debuff.name,
          stack,
          totalStack,
        ),

      GameStepEventBuffRemoved(:final targetPlayerId, :final buff) =>
        l10n.game_step_event_buff_removed(targetPlayerId.value, buff.name),

      GameStepEventDebuffRemoved(:final targetPlayerId, :final debuff) =>
        l10n.game_step_event_debuff_removed(
          targetPlayerId.value,
          debuff.name,
        ),

      GameStepEventStatusEffectChanged(
        :final targetPlayerId,
        :final effectType,
        :final stackCount,
      ) =>
        l10n.game_step_event_status_effect_changed(
          targetPlayerId.value,
          effectType.type.name,
          stackCount,
        ),

      GameStepEventCardPlayed(
        :final playerId,
        :final cardDefId,
        :final targetPlayerId,
      ) =>
        targetPlayerId == null
            ? l10n.game_step_event_card_played(
                playerId.value,
                cardDefId.value,
              )
            : l10n.game_step_event_card_played_with_target(
                playerId.value,
                cardDefId.value,
                targetPlayerId.value,
              ),

      GameStepEventCardExhausted(:final cardInstanceId) =>
        l10n.game_step_event_card_exhausted(cardInstanceId.value),

      GameStepEventDeckRestored(:final playerId, :final count) =>
        l10n.game_step_event_deck_restored(playerId.value, count),

      GameStepEventCardsDrawn(:final playerId, :final cardInstanceIds) =>
        l10n.game_step_event_cards_drawn(
          playerId.value,
          cardInstanceIds.length,
        ),

      GameStepEventCardMovedZone(
        :final playerId,
        :final cardInstanceIds,
        :final zoneFrom,
        :final zoneTo,
      ) =>
        l10n.game_step_event_card_moved_zone(
          playerId.value,
          zoneFrom.name,
          zoneTo.name,
          cardInstanceIds.length,
        ),

      GameStepEventTurnOwnerSwitched(:final newTurnPlayerId) =>
        l10n.game_step_event_turn_owner_switched(newTurnPlayerId.value),

      GameStepEventGameStarted(:final firstTurnPlayerId) =>
        l10n.game_step_event_game_started(firstTurnPlayerId.value),

      GameStepEventGameEnded(
        :final endResult,
        :final reason,
      ) =>
        l10n.game_step_event_game_ended(endResult.name, reason.name),
    };
  }
}
