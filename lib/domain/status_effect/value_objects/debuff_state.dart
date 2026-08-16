import 'package:dereruministic/domain/card/value_objects/card_effects.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'debuff_state.freezed.dart';
part 'debuff_state.g.dart';

@freezed
sealed class DebuffState with _$DebuffState {
  const factory DebuffState({
    required DebuffTypes debuff,
    required int stack,
  }) = _DebuffState;

  factory DebuffState.fromJson(Map<String, dynamic> json) =>
      _$DebuffStateFromJson(json);
}

extension DebuffStateListEx on List<DebuffState> {
  List<DebuffState> removeDebuffEffect(CardEffectRemoveDebuffs effect) {
    return map((state) {
      if (state.debuff != effect.debuff) return state;
      final updatedStacks = state.stack - effect.stacks;
      return updatedStacks > 0 ? state.copyWith(stack: updatedStacks) : null;
    }).whereType<DebuffState>().toList();
  }
}

extension BuffStateDamageModifier on DebuffState {
  int modifyOutgoingDamage(int currentDamage) {
    return switch (debuff) {
      DebuffTypes.atkDebuff => currentDamage - stack,
      _ => currentDamage,
    };
  }

  int modifyIncomingDamage(int currentDamage) {
    return switch (debuff) {
      DebuffTypes.vulnerable => currentDamage + stack,
      _ => currentDamage,
    };
  }
}
