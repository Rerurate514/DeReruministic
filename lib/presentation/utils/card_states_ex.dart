import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

extension CardStatesEx on CardStates {
  IconData get icon {
    return switch (this) {
      CardStateExhaust() => Symbols.local_fire_department,
      CardStateUndiscardable() => Symbols.lock,
      CardStateRecycle() => Symbols.autorenew,
      CardStateOverload() => Symbols.trending_up,
      CardStateConceal() => Symbols.visibility_off,
      CardStateRetain() => Symbols.hourglass_bottom,
      CardStateEngrave() => Symbols.verified,
      CardStateChain() => Symbols.link_2,
      CardStateCountdown() => Symbols.alarm,
      CardStateDecay() => Symbols.skull,
      CardStateInfect() => Symbols.coronavirus,
    };
  }

  Color color(AppColorScheme theme) {
    return switch (this) {
      CardStateExhaust() => theme.stateExhausted,
      CardStateUndiscardable() => theme.stateUndiscardable,
      CardStateRecycle() => theme.stateRecycle,
      CardStateOverload() => theme.stateOverload,
      CardStateConceal() => theme.stateConceal,
      CardStateRetain() => theme.stateRetain,
      CardStateEngrave() => theme.stateEngrave,
      CardStateChain() => theme.stateChain,
      CardStateCountdown() => theme.stateCountdown,
      CardStateDecay() => theme.stateDecay,
      CardStateInfect() => theme.stateInfect,
    };
  }

  String title(AppLocalizations l10n) {
    return switch (this) {
      CardStateExhaust() => l10n.battle_page_card_state_system_exhaust_title,
      CardStateUndiscardable() =>
        l10n.battle_page_card_state_system_undiscardable_title,
      CardStateRecycle() => l10n.battle_page_card_state_system_recycle_title,
      CardStateOverload() => l10n.battle_page_card_state_system_overload_title,
      CardStateConceal() => l10n.battle_page_card_state_system_conceal_title,
      CardStateRetain() => l10n.battle_page_card_state_system_retain_title,
      CardStateEngrave() => l10n.battle_page_card_state_system_engrave_title,
      CardStateChain() => l10n.battle_page_card_state_system_chain_title,
      CardStateCountdown() =>
        l10n.battle_page_card_state_system_countdown_title,
      CardStateDecay() => l10n.battle_page_card_state_system_decay_title,
      CardStateInfect() => l10n.battle_page_card_state_system_infect_title,
    };
  }

  String details(AppLocalizations l10n) {
    return switch (this) {
      CardStateExhaust() => l10n.battle_page_card_state_system_exhaust_details,
      CardStateUndiscardable() =>
        l10n.battle_page_card_state_system_undiscardable_details,
      CardStateRecycle() => l10n.battle_page_card_state_system_recycle_details,
      CardStateOverload() =>
        l10n.battle_page_card_state_system_overload_details,
      CardStateConceal() => l10n.battle_page_card_state_system_conceal_details,
      CardStateRetain() => l10n.battle_page_card_state_system_retain_details,
      CardStateEngrave() => l10n.battle_page_card_state_system_engrave_details,
      CardStateChain() => l10n.battle_page_card_state_system_chain_details,
      CardStateCountdown() =>
        l10n.battle_page_card_state_system_countdown_details,
      CardStateDecay() => l10n.battle_page_card_state_system_decay_details,
      CardStateInfect() => l10n.battle_page_card_state_system_infect_details,
    };
  }
}
