import 'package:dereruministic/di/providers/core/fiestore_provider.dart';
import 'package:dereruministic/domain/remote_sync/in_game/repositories/i_game_actions_repository.dart';
import 'package:dereruministic/infrastructure/remote_sync/in_game/repositories/firebase_game_actions_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_actions_repository_provider.g.dart';

@riverpod
IGameActionsRepository gameActionsRepository(Ref ref) {
  return FirebaseGameActionsRepositoryImpl(
    firestore: ref.watch(firestoreProviderProvider),
  );
}
