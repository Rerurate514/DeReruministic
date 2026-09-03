import 'dart:async';

import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_highlight_button.dart';
import 'package:dereruministic/presentation/pages/lobby/providers/create_room_notifier.dart';
import 'package:dereruministic/presentation/router/router_paths.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class CreateRoomButton extends ConsumerWidget {
  const CreateRoomButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    final room = ref.watch(createRoomProvider);

    ref.listen(createRoomProvider, (p, n) {
      n.whenData((room) {
        if (room == null) return;
        context.goNamed(
          RouterPaths.room.name,
          pathParameters: {'roomId': room.roomId.value},
        );
      });
    });

    return AppHighlightButton(
      isGlow: true,
      borderRadius: 4,
      onPressed: () async {
        unawaited(
          ref
              .read(createRoomProvider.notifier)
              .execute(
                hostPlayerId: PlayerId.generate(),
              ),
        ); //TODO(critical): ここをcurrent_user_profileから取得する
      },
      child: room.when(
        data: (data) {
          if (data == null) {
            return _buildButtonContent(l10n);
          }

          return const UiLoadingIndicator();
        },
        error: (error, stackTrace) {
          debugPrint('$error, $stackTrace');
          return _buildButtonContent(l10n);
        },
        loading: () => const UiLoadingIndicator(),
      ),
    );
  }

  Widget _buildButtonContent(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: .center,
      spacing: 8,
      children: [
        const Icon(
          Symbols.add_circle,
        ),
        Text(l10n.lobby_page_controls_panel_create_room_button_text),
      ],
    );
  }
}
