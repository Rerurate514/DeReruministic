import 'package:dereruministic/domain/remote_sync/room/value_objects/join_room_result.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension JoinRoomResultSnackBarX on JoinRoomResult {
  void showSnackBar(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final message = switch (this) {
      JoinRoomResultRoomNotFound() => l10n.room_page_join_error_room_not_found,
      JoinRoomResultRoomAlreadyFull() =>
        l10n.room_page_join_error_room_already_full,
      JoinRoomResultRoomAlreadyClosed() =>
        l10n.room_page_join_error_room_already_closed,
      JoinRoomResultSuccess() => throw UnimplementedError(),
    };

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }
}
