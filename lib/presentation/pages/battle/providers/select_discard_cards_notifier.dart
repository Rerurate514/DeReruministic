import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'select_discard_cards_notifier.g.dart';

@riverpod
class SelectDiscardCardsNotifier extends _$SelectDiscardCardsNotifier {
  @override
  List<GameCard> build() {
    return [];
  }

  void add(GameCard card) {
    final list = List<GameCard>.from(state)..add(card);
    state = list;
  }

  void removeAt(int index) {
    if (index < 0 || index >= state.length) return;

    final list = List<GameCard>.from(state)..removeAt(index);
    state = list;
  }

  void clear() {
    state = [];
  }

  bool contains(GameCardInstanceId instanceId) =>
      state.map((card) => card.instanceId).contains(instanceId);
}
