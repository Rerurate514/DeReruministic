import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/room/components/players_card/player_profile_card/player_profile_card_avatar.dart';
import 'package:dereruministic/presentation/pages/room/components/players_card/player_profile_card/player_profile_card_deck_ready.dart';
import 'package:dereruministic/presentation/pages/room/components/players_card/player_profile_card/player_profile_card_footer.dart';
import 'package:dereruministic/presentation/pages/room/components/players_card/player_profile_card/player_profile_card_name.dart';
import 'package:dereruministic/presentation/pages/room/components/players_card/player_profile_card/player_profile_card_ready_chip.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_gap.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerProfileCard extends StatelessWidget {
  const PlayerProfileCard({
    required this.name,
    required this.level,
    required this.isHost,
    required this.isYou,
    super.key,
  });

  final String name;
  final int level;
  final bool isHost;
  final bool isYou;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlayerProfileCardAvatar(
                isYou: isYou,
              ),
              const UiGap.m(),
              Expanded(
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PlayerProfileCardName(
                      name: name,
                      isHost: isHost,
                    ),
                    const PlayerProfileCardDeckReady(),
                    Text(
                      l10n.room_page_player_profile_level(level),
                      style: GoogleFonts.shareTechMono(
                        color: theme.textSecondary.withAlpha(150),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 16,
                children: [
                  const PlayerProfileCardReadyChip(),
                  Text(
                    l10n.room_page_player_profile_ping(9),
                    style: GoogleFonts.shareTechMono(
                      color: theme.textSecondary.withAlpha(100),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          const PlayerProfileCardFooter(),
        ],
      ),
    );
  }
}
