import 'package:dereruministic/presentation/pages/battle/state/in_card_discard_area.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'select_discard_cards_notifier.g.dart';

@riverpod
class SelectDiscardCardsNotifier extends _$SelectDiscardCardsNotifier {
  @override
  List<InCardDiscardArea> build() {
    return [];
  }

  void add(InCardDiscardArea card) {
    final list = state..add(card);
    state = list;
  }

  void removeAt(int index) {
    final list = state..removeAt(index);
    state = list;
  }

  void clear() {
    state = [];
  }
}
