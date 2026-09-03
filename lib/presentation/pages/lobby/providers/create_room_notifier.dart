import 'package:dereruministic/application/remote_sync/room/usecases/create_room_usecase.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/remote_sync/room/entities/room.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_room_notifier.g.dart';

@riverpod
class CreateRoomNotifier extends _$CreateRoomNotifier {
  @override
  FutureOr<Room?> build() {
    return null;
  }

  Future<void> execute({required PlayerId hostPlayerId}) async {
    state = const AsyncLoading();
    final useCase = ref.read(createRoomUseCaseProvider);

    state = await AsyncValue.guard(
      () => useCase.execute(hostPlayerId: hostPlayerId),
    );
  }
}
