import 'dart:async';

import 'package:dereruministic/application/auth/state/current_user_profile.dart';
import 'package:dereruministic/application/remote_sync/room/usecases/join_room_usecase.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/join_room_result.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_highlight_transparency_button.dart';
import 'package:dereruministic/presentation/pages/lobby/providers/room_id_text_notifier.dart';
import 'package:dereruministic/presentation/pages/room/utils/join_room_result_ex.dart';
import 'package:dereruministic/presentation/router/router_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class EnterRoomButton extends ConsumerWidget {
  const EnterRoomButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final playerId = ref.watch(currentUserProfileProvider.select((s) => s.id));

    final roomIdinput = ref.watch(roomIdTextProvider);
    final roomId = RoomId(value: roomIdinput);

    return AppHighlightTransparencyButton(
      borderRadius: 4,
      onPressed: () async {
        final result = await ref
            .read(joinRoomUseCaseProvider)
            .execute(
              roomId: roomId,
              guestPlayerId: playerId,
            );

        if (!context.mounted) return;

        switch (result) {
          case JoinRoomResultSuccess(:final room):
            {
              unawaited(
                context.pushNamed(
                  RouterPaths.room.name,
                  pathParameters: {'roomId': room.roomId.value},
                ),
              );
            }
          default:
            {
              result.showSnackBar(context);
            }
        }
      },
      child: Row(
        mainAxisAlignment: .center,
        spacing: 8,
        children: [
          const Icon(
            Symbols.meeting_room,
          ),
          Text(l10n.lobby_page_controls_panel_enter_room_button_text),
        ],
      ),
    );
  }
}
