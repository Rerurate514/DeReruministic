import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/state/my_player_ui_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_ui_state_provider.g.dart';

@riverpod
MyPlayerUiState? myPlayerUiState(Ref ref, Player player) {
  final playerState = ref.watch(
    gameProvider.select((s) => s?.players[player.id]),
  );
  if (playerState == null) return null;

  final turnOwner = ref.watch(gameProvider.select((s) => s?.phase.turnOwner));

  return MyPlayerUiState.create(
    player: player,
    playerState: playerState,
    isTurn: turnOwner == player.id,
  );
}
