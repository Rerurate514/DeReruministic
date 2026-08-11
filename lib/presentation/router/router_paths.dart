enum RouterPaths { home, lobby, battle, result }

extension RouterPathsEx on RouterPaths {
  String get path {
    return switch (this) {
      RouterPaths.home => '/${RouterPaths.home.name}',
      RouterPaths.lobby => '/${RouterPaths.lobby}',
      RouterPaths.battle => '/${RouterPaths.battle.name}',
      RouterPaths.result => '/${RouterPaths.result.name}',
    };
  }
}
