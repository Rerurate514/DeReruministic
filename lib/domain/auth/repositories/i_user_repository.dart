import 'package:dereruministic/domain/create_deck_recipe/entities/deck_recipe.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';

abstract interface class IUserRepository {
  Future<void> save(Player player);
  Future<void> saveDeckRecipe({
    required PlayerId playerId,
    required DeckRecipe deckRecipe,
  });
  Stream<Player?> watch(PlayerId playerId);
}
