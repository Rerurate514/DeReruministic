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
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        path: RouterPaths.library.path,
        name: RouterPaths.library.name,
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        path: RouterPaths.waitingRoom.path,
        name: RouterPaths.waitingRoom.name,
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        path: RouterPaths.gameRoom.path,
        name: RouterPaths.gameRoom.name,
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        path: RouterPaths.result.path,
        name: RouterPaths.result.name,
        builder: (context, state) => const Placeholder(),
      ),
    ],
  );
}
