import 'dart:math';

import 'package:dereruministic/domain/card/data/basic_pack.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/presentation/pages/battle/battle_page.dart';
import 'package:dereruministic/presentation/pages/home/home_page.dart';
import 'package:dereruministic/presentation/pages/lobby/lobby_page.dart';
import 'package:dereruministic/presentation/router/router_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    initialLocation: RouterPaths.home.path,
    routes: [
      GoRoute(
        path: RouterPaths.home.path,
        name: RouterPaths.home.name,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouterPaths.lobby.path,
        name: RouterPaths.lobby.name,
        builder: (context, state) => const LobbyPage(),
      ),
      GoRoute(
        path: RouterPaths.battle.path,
        name: RouterPaths.battle.name,
        builder: (context, state) => BattlePage(
          playerA: Player(
            id: PlayerId.generate(),
            name: 'Player_01',
            deckRecipe: List.generate(
              40,
              (_) => basicPack[Random().nextInt(basicPack.length)].cardDefId,
            ),
          ),
          playerB: Player(
            id: PlayerId.generate(),
            name: 'Player_02',
            deckRecipe: List.generate(
              40,
              (_) => const CardDefinitionId(value: 'basic_pack_hit'),
            ),
          ),
          seed: 514,
        ),
      ),
      GoRoute(
        path: RouterPaths.result.path,
        name: RouterPaths.result.name,
        builder: (context, state) => const Placeholder(),
      ),
    ],
  );
}
