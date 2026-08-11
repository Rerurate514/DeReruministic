enum RouterPaths { home, lobby, gameRoom, result }

extension RouterPathsEx on RouterPaths {
  String get name {
    return switch (this) {
      RouterPaths.home => 'home',
      RouterPaths.lobby => 'lobby',
      RouterPaths.gameRoom => 'game-room',
      RouterPaths.result => 'result',
    };
  }

  String get path {
    return switch (this) {
      RouterPaths.home => '/${RouterPaths.home.name}',
      RouterPaths.lobby => '/${RouterPaths.lobby}',
      RouterPaths.gameRoom => '/${RouterPaths.gameRoom.name}',
      RouterPaths.result => '/${RouterPaths.result.name}',
    };
  }
}
