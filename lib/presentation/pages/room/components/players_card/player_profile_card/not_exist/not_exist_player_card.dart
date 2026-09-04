import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:dereruministic/presentation/pages/room/components/players_card/player_profile_card/not_exist/player_profile_card_unknown_chip.dart';
import 'package:dereruministic/presentation/pages/room/components/players_card/player_profile_card/player_profile_card_avatar.dart';
import 'package:dereruministic/presentation/pages/room/components/players_card/player_profile_card/player_profile_card_deck_ready.dart';
import 'package:dereruministic/presentation/pages/room/components/players_card/player_profile_card/player_profile_card_footer.dart';
import 'package:dereruministic/presentation/pages/room/components/players_card/player_profile_card/player_profile_card_name.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_gap.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotExistPlayerCard extends StatelessWidget {
  const NotExistPlayerCard({
    super.key,
  });

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
              const PlayerProfileCardAvatar(
                isYou: false,
                isUnknown: true,
              ),
              const UiGap.m(),
              Expanded(
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PlayerProfileCardName(
                      name: l10n.room_page_player_profile_unknown_name,
                      isHost: false,
                      isUnknown: true,
                    ),
                    const PlayerProfileCardDeckReady(isReady: false),
                    Text(
                      l10n.room_page_player_profile_unknown_level,
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
                  const PlayerProfileCardUnknownChip(),
                  Text(
                    l10n.room_page_player_profile_unknown_ping,
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
          const PlayerProfileCardFooter(isUnknown: true),
        ],
      ),
    );
  }
}
