import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'deck_recipe_id.freezed.dart';
part 'deck_recipe_id.g.dart';

@freezed
abstract class DeckRecipeId with _$DeckRecipeId {
  const factory DeckRecipeId({required String value}) = _DeckRecipeId;

  factory DeckRecipeId.generate() {
    return DeckRecipeId(value: const Uuid().v4());
  }

  factory DeckRecipeId.fromJson(Map<String, dynamic> json) =>
      _$DeckRecipeIdFromJson(json);
}
