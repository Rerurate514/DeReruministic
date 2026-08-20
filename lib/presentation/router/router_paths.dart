enum RouterPaths { home, lobby, room, battle, result }

extension RouterPathsEx on RouterPaths {
  String get path {
    return switch (this) {
      RouterPaths.home => '/${RouterPaths.home.name}',
      RouterPaths.lobby => '/${RouterPaths.lobby}',
      RouterPaths.room => '/${RouterPaths.room}',
      RouterPaths.battle => '/${RouterPaths.battle.name}',
      RouterPaths.result => '/${RouterPaths.result.name}',
    };
  }
}
