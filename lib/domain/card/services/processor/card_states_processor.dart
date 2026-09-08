import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'card_states_processor.g.dart';

@riverpod
CardStatesProcessor cardStatesProcessor(Ref ref) {
  return CardStatesProcessor();
}

class CardStatesProcessor {}
