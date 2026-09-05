import 'package:dereruministic/application/remote_sync/room/state/room_watch_provider.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_watch_result.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_active_filled_square.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class RoomPlayersStateCard extends ConsumerWidget {
  const RoomPlayersStateCard({required this.roomId, super.key});

  final RoomId roomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    final room = ref.watch(roomWatchProvider(roomId: roomId));

    return AppCard(
      child: SizedBox(
        width: double.infinity,
        child: room.when(
          data: (data) {
            return switch (data) {
              RoomWatchResultAvailable(:final room) =>
                room.guestPlayerId != null
                    ? _PlayerStatusContent(
                        statusColor: theme.brandQuaternary,
                        statusLabel: l10n.room_page_players_state_ready,
                        countText: l10n.room_page_players_state_ready_count,
                      )
                    : _PlayerStatusContent(
                        statusColor: theme.brandTertiary,
                        statusLabel: l10n.room_page_players_state_waiting,
                        countText: l10n.room_page_players_state_waiting_count,
                        isBold: true,
                      ),
              RoomWatchResultUnavailable() => Text(
                l10n.room_page_players_state_error,
              ),
            };
          },
          error: (error, stackTrace) => Text('$error, $stackTrace'),
          loading: () => const UiLoadingIndicator(),
        ),
      ),
    );
  }
}

class _PlayerStatusContent extends StatelessWidget {
  const _PlayerStatusContent({
    required this.statusColor,
    required this.statusLabel,
    required this.countText,
    this.isBold = false,
  });

  final Color statusColor;
  final String statusLabel;
  final String countText;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    final fontWeight = isBold ? FontWeight.bold : FontWeight.normal;

    return Wrap(
      alignment: .center,
      spacing: 64,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisSize: .min,
            spacing: 8,
            children: [
              UiActiveFilledSquare(
                color: statusColor,
              ),
              Text(
                statusLabel,
                style: GoogleFonts.shareTechMono(
                  color: statusColor,
                  fontWeight: fontWeight,
                ),
              ),
            ],
          ),
        ),
        Text(
          countText,
          style: GoogleFonts.shareTechMono(
            color: theme.textSecondary,
            fontWeight: fontWeight,
          ),
        ),
      ],
    );
  }
}
