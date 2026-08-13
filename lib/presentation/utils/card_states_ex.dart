import 'package:dereruministic/domain/card/value_objects/card_states.dart';
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
}
