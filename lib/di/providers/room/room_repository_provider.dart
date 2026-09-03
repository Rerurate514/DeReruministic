import 'package:dereruministic/di/providers/core/fiestore_provider.dart';
import 'package:dereruministic/domain/remote_sync/repositories/i_room_repository.dart';
import 'package:dereruministic/infrastructure/remote_sync/repositories/firebase_room_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'room_repository_provider.g.dart';

@riverpod
IRoomRepository roomRepository(Ref ref) {
  return FirebaseRoomRepositoryImpl(
    firestore: ref.watch(firestoreProviderProvider),
  );
}
