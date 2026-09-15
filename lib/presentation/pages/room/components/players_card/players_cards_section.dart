import 'package:dereruministic/application/auth/state/current_user_profile.dart';
import 'package:dereruministic/application/remote_sync/room/state/room_watch_provider.dart';
import 'package:dereruministic/application/user/state/player_profile.dart';
import 'package:dereruministic/domain/create_deck_recipe/constants/create_deck_recipe_rules.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_watch_result.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/room/components/players_card/player_profile_card/not_exist/not_exist_player_card.dart';
import 'package:dereruministic/presentation/pages/room/components/players_card/player_profile_card/player_profile_card.dart';
import 'package:dereruministic/presentation/pages/room/components/players_card/players_card_header.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PlayersCardsSection extends ConsumerWidget {
  const PlayersCardsSection({required this.roomId, super.key});

  final RoomId roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    final roomData = ref.watch(roomWatchProvider(roomId: roomId));
    final player = ref.watch(currentUserProfileProvider).value;

    return Column(
      spacing: 8,
      children: [
        const PlayersCardHeader(),
        roomData.when(
          data: (result) {
            switch (result) {
              case RoomWatchResultAvailable(:final room):
                {
                  final currentPlayerId = player?.id;
                  final isHost = room.hostPlayerId == currentPlayerId;
                  final host = ref.watch(
                    playerProfileProvider(room.hostPlayerId),
                  );
                  final guest = room.guestPlayerId == null
                      ? null
                      : ref.watch(
                          playerProfileProvider(room.guestPlayerId!),
                        );
                  return Column(
                    children: [
                      host.when(
                        data: (hostPlayer) => PlayerProfileCard(
                          name: hostPlayer?.name ?? room.hostPlayerId.value,
                          level: 32,
                          isHost: true,
                          isYou: isHost,
                          isDeckReady:
                              hostPlayer?.deckRecipe.cardsCount ==
                              CreateDeckRecipeRules.maxDeckCards,
                        ),
                        error: (error, stackTrace) =>
                            Text('$error, $stackTrace'),
                        loading: UiLoadingIndicator.new,
                      ),
                      if (room.guestPlayerId != null)
                        guest!.when(
                          data: (guestPlayer) => PlayerProfileCard(
                            name:
                                guestPlayer?.name ?? room.guestPlayerId!.value,
                            level: 64,
                            isHost: false,
                            isYou: !isHost,
                            isDeckReady:
                                guestPlayer?.deckRecipe.cardsCount ==
                                CreateDeckRecipeRules.maxDeckCards,
                          ),
                          error: (error, stackTrace) =>
                              Text('$error, $stackTrace'),
                          loading: UiLoadingIndicator.new,
                        )
                      else
                        const NotExistPlayerCard(),
                    ],
                  );
                }
              case RoomWatchResultUnavailable():
                return Text(l10n.room_page_players_state_error);
            }
          },
          error: (error, stackTrace) => Text('$error, $stackTrace'),
          loading: UiLoadingIndicator.new,
        ),
      ],
    );
  }
}
