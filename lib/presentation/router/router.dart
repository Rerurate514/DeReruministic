import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/presentation/pages/battle/battle_page.dart';
import 'package:dereruministic/presentation/pages/deck_editor/deck_editor_page.dart';
import 'package:dereruministic/presentation/pages/home/home_page.dart';
import 'package:dereruministic/presentation/pages/lobby/lobby_page.dart';
import 'package:dereruministic/presentation/pages/room/room_page.dart';
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
        path: RouterPaths.deckEditor.path,
        name: RouterPaths.deckEditor.name,
        builder: (context, state) => const DeckEditorPage(),
      ),
      GoRoute(
        path: RouterPaths.lobby.path,
        name: RouterPaths.lobby.name,
        builder: (context, state) => const LobbyPage(),
      ),
      GoRoute(
        path: '${RouterPaths.room.path}/:roomId',
        name: RouterPaths.room.name,
        builder: (context, state) {
          final roomId = RoomId(value: state.pathParameters['roomId']!);
          return RoomPage(roomId: roomId);
        },
      ),
      GoRoute(
        path: '${RouterPaths.battle.path}/:roomId',
        name: RouterPaths.battle.name,
        builder: (context, state) {
          final roomId = RoomId(value: state.pathParameters['roomId']!);
          return BattlePage(
            roomId: roomId,
          );
        },
      ),
      GoRoute(
        path: RouterPaths.result.path,
        name: RouterPaths.result.name,
        builder: (context, state) => const Placeholder(),
      ),
    ],
  );
}
