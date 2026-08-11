import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/state/enemy_player_ui_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'enemy_ui_state_provider.g.dart';

@riverpod
EnemyPlayerUiState? enemyPlayerUiState(Ref ref, Player enemy) {
  final playerState = ref.watch(
    gameProvider.select((s) => s?.players[enemy.id]),
  );
  if (playerState == null) return null;

  final turnOwner = ref.watch(gameProvider.select((s) => s?.phase.turnOwner));

  return EnemyPlayerUiState.create(
    player: enemy,
    playerState: playerState,
    isTurn: turnOwner == enemy.id,
  );
}
