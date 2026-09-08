import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'card_effects_processor.g.dart';

@riverpod
CardEffectsProcessor cardEffectsProcessor(Ref ref) {
  return CardEffectsProcessor();
}

class CardEffectsProcessor {}
