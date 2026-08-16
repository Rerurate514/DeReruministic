import 'package:collection/collection.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_zone.dart';
import 'package:dereruministic/domain/player/constants/player_constants.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_types.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_types.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_state.freezed.dart';
part 'player_state.g.dart';

@freezed
sealed class PlayerState with _$PlayerState {
  const factory PlayerState({
    required PlayerId id,
    required int hp,
    required int maxHp,
    required int shield,
    required int currentCost,
    required int maxCost,
    required List<GameCard> deck,
    required List<GameCard> hand,
    required List<GameCard> graveyard,
    required List<GameCard> exhausted,
    required List<BuffState> buffs,
    required List<DebuffState> debuffs,
    required int cardsPlayedThisTurn,
    required int maxHandSize,
    required int pendingRecoilCost,
  }) = _PlayerState;

  factory PlayerState.create({
    required PlayerId id,
    required List<GameCard> deck,
  }) {
    return PlayerState(
      id: id,
      hp: PlayerConstants.defaultInitialHp,
      maxHp: PlayerConstants.defaultMaxHp,
      shield: 0,
      currentCost: PlayerConstants.defaultInitialCost,
      maxCost: PlayerConstants.defaultMaxCost,
      deck: deck,
      hand: [],
      graveyard: [],
      exhausted: [],
      buffs: [],
      debuffs: [],
      cardsPlayedThisTurn: 0,
      maxHandSize: PlayerConstants.defaultMaxHandSize,
      pendingRecoilCost: 0,
    );
  }

  factory PlayerState.fromJson(Map<String, dynamic> json) =>
      _$PlayerStateFromJson(json);
}

extension PlayerStateCardEx on PlayerState {
  PlayerState updateCost(int amount) {
    return copyWith(currentCost: (currentCost + amount).clamp(0, maxCost));
  }

  PlayerState consumeCost(int amount) {
    return copyWith(currentCost: (currentCost - amount).clamp(0, maxCost));
  }

  PlayerState consumeCard(GameCard card) {
    return copyWith(
      hand: hand
          .where(
            (handCard) => handCard.instanceId != card.instanceId,
          )
          .toList(),
      graveyard: [...graveyard, card],
    );
  }

  PlayerState exhaustCard(GameCard card) {
    return copyWith(
      hand: hand
          .where(
            (handCard) => handCard.instanceId != card.instanceId,
          )
          .toList(),
      exhausted: [...exhausted, card],
    );
  }

  PlayerState moveCardFromHand(GameCardInstanceId instanceId, CardZone to) {
    final card = hand.firstWhereOrNull((c) => c.instanceId == instanceId);
    if (card == null) {
      return this;
    }

    final nextHand = hand.where((c) => c.instanceId != instanceId).toList();

    return switch (to) {
      CardZone.graveyard => copyWith(
        hand: nextHand,
        graveyard: [...graveyard, card],
      ),
      CardZone.exhausted => copyWith(
        hand: nextHand,
        exhausted: [...exhausted, card],
      ),
      CardZone.deck => copyWith(
        hand: nextHand,
        deck: [...deck, card],
      ),
      CardZone.hand => this,
    };
  }
}

extension PlayerStateBuffDebuffEx on PlayerState {
  PlayerState applyBuffState(BuffTypes buff, int stacks) {
    if (stacks <= 0) return this;

    final existingIndex = buffs.indexWhere((element) => element.buff == buff);

    final updatedBuffs = List<BuffState>.from(buffs);
    if (existingIndex >= 0) {
      final existing = updatedBuffs[existingIndex];
      updatedBuffs[existingIndex] = existing.copyWith(
        stack: existing.stack + stacks,
      );
    } else {
      updatedBuffs.add(BuffState(buff: buff, stack: stacks));
    }

    return copyWith(buffs: updatedBuffs);
  }

  PlayerState applyDebuffState(DebuffTypes debuff, int stacks) {
    if (stacks <= 0) return this;

    final existingIndex = debuffs.indexWhere(
      (element) => element.debuff == debuff,
    );

    final updatedDebuffs = List<DebuffState>.from(debuffs);
    if (existingIndex >= 0) {
      final existing = updatedDebuffs[existingIndex];
      updatedDebuffs[existingIndex] = existing.copyWith(
        stack: existing.stack + stacks,
      );
    } else {
      updatedDebuffs.add(DebuffState(debuff: debuff, stack: stacks));
    }

    return copyWith(debuffs: updatedDebuffs);
  }
}

extension PlayerStateBuffDebuffQueryEx on PlayerState {
  int getBuffStack(BuffTypes buff) {
    final index = buffs.indexWhere((element) => element.buff == buff);
    if (index == -1) return 0;
    return buffs[index].stack;
  }

  int getDebuffStack(DebuffTypes debuff) {
    final index = debuffs.indexWhere((element) => element.debuff == debuff);
    if (index == -1) return 0;
    return debuffs[index].stack;
  }

  bool hasBuff(BuffTypes buff) => getBuffStack(buff) > 0;
  bool hasDebuff(DebuffTypes debuff) => getDebuffStack(debuff) > 0;
}
