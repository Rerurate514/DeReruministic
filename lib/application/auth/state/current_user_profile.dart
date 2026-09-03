import 'package:dereruministic/domain/create_deck_recipe/entities/deck_recipe.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_user_profile.g.dart';

// @riverpod
// Stream<Player?> currentUserProfile(Ref ref) {
// final user = ref.watch(authProvider).value;
// if (user == null) return Stream.value(null);

// final repository = ref.watch(userRepositoryProvider);
// return repository.watchPlayer(user.uid);
// }

//TODO(critical): ちゃんとモックデータから実際のデータにする
@riverpod
Player currentUserProfile(Ref ref) {
  return Player(
    id: PlayerId.generate(),
    name: 'Rerurate',
    deckRecipe: DeckRecipe.empty(),
  );
}
