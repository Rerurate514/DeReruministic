import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/l10n/app_localizations.dart';

extension GamePhaseEx on GamePhase {
  String text(AppLocalizations l10n) {
    return switch (this.battlePhase) {
      BattlePhase.initialize => l10n.battle_page_phase_initialize,
      BattlePhase.battleStart => l10n.battle_page_phase_battle_start,
      BattlePhase.turnStart => l10n.battle_page_phase_turn_start,
      BattlePhase.mainPhase => l10n.battle_page_phase_main_phase,
      BattlePhase.turnEnd => l10n.battle_page_phase_turn_end,
      BattlePhase.battleEnd => l10n.battle_page_phase_turn_end,
      BattlePhase.selectDiscard => l10n.battle_page_phase_select_discard,
    };
  }
}
