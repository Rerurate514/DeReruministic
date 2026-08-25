enum RouterPaths { home, deckEditor, lobby, room, battle, result }

extension RouterPathsEx on RouterPaths {
  String get path {
    return switch (this) {
      RouterPaths.home => '/${RouterPaths.home.name}',
      RouterPaths.deckEditor => '/${RouterPaths.deckEditor.name}',
      RouterPaths.lobby => '/${RouterPaths.lobby.name}',
      RouterPaths.room => '/${RouterPaths.room.name}',
      RouterPaths.battle => '/${RouterPaths.battle.name}',
      RouterPaths.result => '/${RouterPaths.result.name}',
    };
  }
}
