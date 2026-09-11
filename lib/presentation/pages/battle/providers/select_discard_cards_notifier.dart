import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'select_discard_cards_notifier.g.dart';

@riverpod
class SelectDiscardCardsNotifier extends _$SelectDiscardCardsNotifier {
  @override
  List<GameCard> build() {
    return [];
  }

  void add(GameCard card) {
    final list = state..add(card);
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
}
