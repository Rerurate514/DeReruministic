import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/battle/components/enemy_state/enemy_state_name.dart';
import 'package:dereruministic/presentation/pages/battle/state/enemy_player_ui_state.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnemyStateCard extends ConsumerWidget {
  const EnemyStateCard({required this.enemy, super.key});

  final Player enemy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    if (gameState == null) return const UiLoadingIndicator();

    final enemyState = gameState.players[enemy.id];
    if (enemyState == null) return const UiLoadingIndicator();

    final enemyUiState = EnemyPlayerUiState.create(
      player: enemy,
      playerState: enemyState,
      isTurn: gameState.phase.turnOwner == enemy.id,
    );

    return AppCard(
      child: Column(
        children: [
          EnemyStateName(
            name: enemyUiState.name,
          ),
        ],
      ),
    );
  }
}
