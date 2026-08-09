import 'package:dereruministic/domain/card/value_objects/card_runtime_states.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_states.freezed.dart';
part 'card_states.g.dart';

@freezed
sealed class CardStates with _$CardStates {
  //焼却
  const factory CardStates.exhaust() = CardStateExhaust;

  //停滞
  const factory CardStates.undiscardable() = CardStateUndiscardable;

  //循環
  const factory CardStates.recycle({
    int? count,
  }) = CardStateRecycle;

  //反動
  const factory CardStates.overload({
    required int amount,
  }) = CardStateOverload;

  //潜伏
  const factory CardStates.conceal() = CardStateConceal;

  //保留
  const factory CardStates.retain({
    required int turnThreshold,
    required int costReduction,
  }) = CardStateRetain;

  //刻印
  const factory CardStates.engrave({
    required String subTypeEffect,
  }) = CardStateEngrave;

  //連携
  const factory CardStates.chain({
    required String subTypeEffect,
    required int order,
  }) = CardStateChain;

  //時限
  const factory CardStates.countdown({
    required int turns,
  }) = CardStateCountdown;

  //腐敗
  const factory CardStates.decay({
    required int turns,
  }) = CardStateDecay;

  //感染
  const factory CardStates.infect() = CardStateInfect;

  factory CardStates.fromJson(Map<String, dynamic> json) =>
      _$CardStatesFromJson(json);
}

extension CardStatesListEx on List<CardStates> {
  List<CardRuntimeStates> buildInitialRuntimeStates() {
    final runtimeStates = <CardRuntimeStates>[];

    for (final state in this) {
      switch (state) {
        case CardStateRecycle(:final count):
          if (count != null) {
            runtimeStates.add(
              CardRuntimeStates.recycle(remainingCount: count),
            );
          }
        case CardStateCountdown(:final turns):
          runtimeStates.add(
            CardRuntimeStates.countdown(remainingTurns: turns),
          );
        case CardStateDecay(:final turns):
          runtimeStates.add(
            CardRuntimeStates.decay(remainingTurns: turns),
          );
        case CardStateRetain():
          runtimeStates.add(
            const CardRuntimeStates.retain(turnsInHand: 0),
          );
        default:
          // 焼却、停滞、反動、連携など、静的なフラグのみで動的カウントを持たない状態はスキップ
          break;
      }
    }

    return runtimeStates;
  }
}
