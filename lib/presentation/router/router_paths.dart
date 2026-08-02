enum RouterPaths { home, library, waitingRoom, gameRoom, result }

extension RouterPathsEx on RouterPaths {
  String get name {
    return switch (this) {
      RouterPaths.home => 'home',
      RouterPaths.library => 'library',
      RouterPaths.waitingRoom => 'waiting-room',
      RouterPaths.gameRoom => 'game-room',
      RouterPaths.result => 'result',
    };
  }

  String get path {
    return switch (this) {
      RouterPaths.home => '/${RouterPaths.home.name}',
      RouterPaths.library => '/${RouterPaths.library.name}',
      RouterPaths.waitingRoom => '/${RouterPaths.waitingRoom.name}',
      RouterPaths.gameRoom => '/${RouterPaths.gameRoom.name}',
      RouterPaths.result => '/${RouterPaths.result.name}',
    };
  }
}
