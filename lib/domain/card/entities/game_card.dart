import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/value_objects/card_runtime_states.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_card.freezed.dart';
part 'game_card.g.dart';

@freezed
sealed class GameCard with _$GameCard {
  const factory GameCard({
    required GameCardInstanceId instanceId,
    required CardDefinition definition,
    required int currentCost,
    required int enteredHandAtTurn,
    @Default([]) List<CardRuntimeStates> runtimeStates,
  }) = _GameCard;

  factory GameCard.fromJson(Map<String, dynamic> json) =>
      _$GameCardFromJson(json);
}

extension GameCardEx on GameCard {
  // --- 循環 (Recycle) ---
  bool get hasRecycleRuntime =>
      runtimeStates.any((state) => state is CardRuntimeStateRecycleState);

  CardRuntimeStateRecycleState? get recycleRuntime =>
      runtimeStates.whereType<CardRuntimeStateRecycleState>().firstOrNull;

  bool get isRecycleActive {
    final recycle = recycleRuntime;
    if (recycle != null) {
      return recycle.remainingCount > 0;
    }
    return definition.hasState<CardStateRecycle>();
  }

  // --- 時限 (Countdown) ---
  bool get hasCountdownRuntime =>
      runtimeStates.any((state) => state is CardRuntimeStateCountdownState);

  CardRuntimeStateCountdownState? get countdownRuntime =>
      runtimeStates.whereType<CardRuntimeStateCountdownState>().firstOrNull;

  bool get isCountdownActive {
    final countdown = countdownRuntime;
    if (countdown != null) {
      return countdown.remainingTurns > 0;
    }
    return definition.hasState<CardStateCountdown>();
  }

  bool get isCountdownTriggered {
    final countdown = countdownRuntime;
    return countdown != null && countdown.remainingTurns == 0;
  }

  // --- 腐敗 (Decay) ---
  bool get hasDecayRuntime =>
      runtimeStates.any((state) => state is CardRuntimeStateDecayState);

  CardRuntimeStateDecayState? get decayRuntime =>
      runtimeStates.whereType<CardRuntimeStateDecayState>().firstOrNull;

  bool get isDecayActive {
    final decay = decayRuntime;
    if (decay != null) {
      return decay.remainingTurns > 0;
    }
    return definition.hasState<CardStateDecay>();
  }

  bool get isDecayTriggered {
    final decay = decayRuntime;
    return decay != null && decay.remainingTurns == 0;
  }

  // --- 保留 (Retain) ---
  bool get hasRetainRuntime =>
      runtimeStates.any((state) => state is CardRuntimeStateRetainState);

  CardRuntimeStateRetainState? get retainRuntime =>
      runtimeStates.whereType<CardRuntimeStateRetainState>().firstOrNull;

  bool get isRetainActive {
    return hasRetainRuntime || definition.hasState<CardStateRetain>();
  }

  GameCard resetRuntimeStatesForZoneChange() {
    final resetStates = runtimeStates.map((state) {
      return switch (state) {
        CardRuntimeStateRetainState() => state.copyWith(turnsInHand: 0),
        CardRuntimeStateCountdownState(:final initialTurns) => state.copyWith(
          remainingTurns: initialTurns,
        ),
        CardRuntimeStateDecayState(:final initialTurns) => state.copyWith(
          remainingTurns: initialTurns,
        ),
        _ => state,
      };
    }).toList();

    return copyWith(
      currentCost: definition.baseCost,
      runtimeStates: resetStates,
    );
  }
}
