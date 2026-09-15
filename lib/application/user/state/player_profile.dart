import 'package:dereruministic/di/providers/auth/user_repository_provider.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_profile.g.dart';

@riverpod
Stream<Player?> playerProfile(Ref ref, PlayerId playerId) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.watch(playerId);
}
