import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';

class ApplyPlayCardService {
  GameState execute({
    required GameState state,
    required GameActionPlayCard action,
  }) {
    // TODO: ActionのplayerIdから現在のこのカードを使用したプレイヤーを選択し、
    // ActionのinstanceIdとplayerのhandからGameCardを選択し、
    // そこからeffectsResolverとstateResolverを処理する
  }
}
