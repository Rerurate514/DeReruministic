import 'package:dereruministic/domain/card/services/states/apply_countdown_state_service.dart';
import 'package:dereruministic/domain/card/services/states/apply_decay_state_service.dart';
import 'package:dereruministic/domain/card/services/states/apply_recycle_state_service.dart';
import 'package:dereruministic/domain/card/services/states/apply_retain_state_service.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/card_states_trigger_type.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'resolve_triggered_card_states_service.g.dart';

@riverpod
ResolveTriggeredCardStatesService resolveTriggeredCardStatesService(Ref ref) {
  return ResolveTriggeredCardStatesService(
    applyRecycleStateService: ref.watch(applyRecycleStateServiceProvider),
    applyRetainStateService: ref.watch(applyRetainStateServiceProvider),
    applyDecayStateService: ref.watch(applyDecayStateServiceProvider),
    applyCountdownStateService: ref.watch(applyCountdownStateServiceProvider),
  );
}

class ResolveTriggeredCardStatesService {
  ResolveTriggeredCardStatesService({
    required this.applyRecycleStateService,
    required this.applyRetainStateService,
    required this.applyDecayStateService,
    required this.applyCountdownStateService,
  });

  final ApplyRecycleStateService applyRecycleStateService;
  final ApplyRetainStateService applyRetainStateService;
  final ApplyDecayStateService applyDecayStateService;
  final ApplyCountdownStateService applyCountdownStateService;

  ApplyActionResult execute({
    required GameState state,
    required PlayerId playerId,
    required GameCardInstanceId instanceId,
    required CardStatesTriggerType triggerType,
  }) => switch (triggerType) {
    CardStatesTriggerType.recycleExpired => applyRecycleStateService.execute(
      state,
      playerId,
      instanceId,
    ),
    CardStatesTriggerType.decayExpired => applyDecayStateService.execute(
      state,
      playerId,
      instanceId,
    ),
    CardStatesTriggerType.countdownExpired =>
      applyCountdownStateService.execute(
        state,
        playerId,
        instanceId,
      ),
    CardStatesTriggerType.retainCostReduced => applyRetainStateService.execute(
      state,
      playerId,
      instanceId,
    ),
  };
}
