import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/value_objects/apply_action_result.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
ConsumeCardService consumeCardService(Ref ref) {
  return ConsumeCardService();
}

class ConsumeCardService {
  ApplyActionResult execute({
    required GameState current,
    required GameActionPlayCard action,
  }) {
    
  }
}
