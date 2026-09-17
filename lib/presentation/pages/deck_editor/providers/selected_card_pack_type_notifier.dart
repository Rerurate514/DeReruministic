import 'package:dereruministic/domain/card_packs/data/card_packs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_card_pack_type_notifier.g.dart';

@riverpod
class SelectedCardPackTypeNotifier extends _$SelectedCardPackTypeNotifier {
  @override
  CardPackTypes build() => CardPackTypes.all;

  void set(CardPackTypes type) => state = type;
}
