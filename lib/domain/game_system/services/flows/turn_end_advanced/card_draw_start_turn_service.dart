import 'package:dereruministic/domain/card/services/card_draw_service.dart';
import 'package:dereruministic/domain/game_system/constants/game_system_constants.dart';
import 'package:dereruministic/domain/game_system/services/defeat_process_service.dart';
import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_process_step.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'card_draw_start_turn_service.g.dart';

@riverpod
CardDrawStartTurnService cardDrawStartTurnService(Ref ref) {
  return CardDrawStartTurnService(
    cardDrawService: ref.read(cardDrawServiceProvider),
    defeatProcessService: ref.read(defeatProcessServiceProvider),
  );
}

class CardDrawStartTurnService implements TurnProcessStep {
  const CardDrawStartTurnService({
    required this.defeatProcessService,
    required this.cardDrawService,
  });

  final CardDrawService cardDrawService;
  final DefeatProcessService defeatProcessService;

  @override
  ApplyActionResult execute(GameState state) {
    final targetPlayerId = state.phase.turnOwner;
    final targetPlayer = state.players[targetPlayerId];

    final amount = _calculateDrawAmount(targetPlayer!);

    final totalAvailableCards =
        targetPlayer.deck.length + targetPlayer.graveyard.length;

    if (totalAvailableCards < amount) {
      return defeatProcessService.execute(
        state,
        loserPlayerId: targetPlayerId,
        reason: 'defeat_library_out',
      );
    }

    return cardDrawService.execute(
      state,
      targetPlayerId,
      amount,
    );
  }

  int _calculateDrawAmount(PlayerState player) {
    var amount = GameSystemConstants.defaultDrawCount;
    //バフ/デバフの補正 TODO
    amount += 0;
    return amount;
  }
}
