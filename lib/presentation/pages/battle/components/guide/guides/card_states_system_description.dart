import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guide_text_template.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guides/card_states/card_state_chain_description.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guides/card_states/card_state_conceal_description.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guides/card_states/card_state_countdown_description.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guides/card_states/card_state_decay_description.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guides/card_states/card_state_engrave_description.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guides/card_states/card_state_exhaust_description.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guides/card_states/card_state_infect_description.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guides/card_states/card_state_overload_description.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guides/card_states/card_state_recycle_description.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guides/card_states/card_state_retain_description.dart';
import 'package:dereruministic/presentation/pages/battle/components/guide/guides/card_states/card_state_undiscardable_description.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class CardStateSystemDescription extends StatelessWidget {
  const CardStateSystemDescription({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;
    return GuideTextTemplate(
      title: l10n.battle_page_card_state_system_title,
      titleColor: theme.brandSecondary,
      leading: const Icon(Symbols.flex_no_wrap),
      details: Column(
        crossAxisAlignment: .start,
        spacing: 8,
        children: [
          Text(l10n.battle_page_card_state_system_details_1),

          const Column(
            spacing: 2,
            children: [
              CardStateExhaustDescription(),
              CardStateUndiscardableDescription(),
              CardStateRecycleDescription(),
              CardStateOverloadDescription(),
              CardStateConcealDescription(),
              CardStateRetainDescription(),
              CardStateEngraveDescription(),
              CardStateChainDescription(),
              CardStateCountdownDescription(),
              CardStateDecayDescription(),
              CardStateInfectDescription(),
            ],
          ),
        ],
      ),
    );
  }
}
