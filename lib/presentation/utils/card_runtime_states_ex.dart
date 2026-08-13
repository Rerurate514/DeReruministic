import 'package:dereruministic/domain/card/value_objects/card_runtime_states.dart';
import 'package:dereruministic/l10n/app_localizations.dart';

extension CardRuntimeStatesEx on CardRuntimeStates {
  String text(AppLocalizations l10n) {
    switch (this) {
      case CardRuntimeStateRecycleState(:final maxCount, :final remainingCount):
        {
          if (maxCount == null)
            return l10n.battle_page_card_runtime_states_recycle_infinity_text;
          return l10n.battle_page_card_runtime_states_recycle_text;
        }
      case CardRuntimeStateCountdownState(
        :final initialTurns,
        :final remainingTurns,
      ):
        {
          return l10n.battle_page_card_runtime_states_countdown_text;
        }
      case CardRuntimeStateDecayState(
        :final initialTurns,
        :final remainingTurns,
      ):
        {
          return l10n.battle_page_card_runtime_states_decay_text;
        }
      case CardRuntimeStateRetainState(:final turnsInHand):
        {
          return l10n.battle_page_card_runtime_states_retain_text;
        }
    }
  }
}
