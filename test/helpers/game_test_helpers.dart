import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/card/value_objects/card_definition_id.dart';
import 'package:dereruministic/domain/card/value_objects/card_states.dart';
import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:dereruministic/domain/game_system/entities/game_actions.dart';
import 'package:dereruministic/domain/game_system/value_objects/battle_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_actions_id.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_state.dart';
import 'package:dereruministic/domain/game_system/value_objects/system_metadata.dart';
import 'package:dereruministic/domain/player/value_objects/player_id.dart';
import 'package:dereruministic/domain/player/value_objects/player_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/buff_state.dart';
import 'package:dereruministic/domain/status_effect/value_objects/debuff_state.dart';

const normalCardDef = CardDefinition(
  cardDefId: CardDefinitionId(value: 'def_normal'),
  name: 'Strike',
  baseCost: 1,
  effects: [],
  states: [],
);

const exhaustCardDef = CardDefinition(
  cardDefId: CardDefinitionId(value: 'def_exhaust'),
  name: 'Ultimate',
  baseCost: 3,
  effects: [],
  states: [CardStates.exhaust()],
);

GameCard buildCard({
  required String instanceId,
  CardDefinition definition = normalCardDef,
  int currentCost = 1,
  int enteredHandAtTurn = 0,
}) {
  return GameCard(
    instanceId: GameCardInstanceId(value: instanceId),
    definition: definition,
    currentCost: currentCost,
    enteredHandAtTurn: enteredHandAtTurn,
  );
}

PlayerState buildPlayer({
  required PlayerId id,
  int hp = 20,
  int maxHp = 20,
  int shield = 0,
  int currentCost = 3,
  int maxCost = 4,
  List<GameCard> deck = const [],
  List<GameCard> hand = const [],
  List<GameCard> graveyard = const [],
  List<GameCard> exhausted = const [],
  List<BuffState> buffs = const [],
  List<DebuffState> debuffs = const [],
  int cardsPlayedThisTurn = 0,
  int maxHandSize = 5,
  int pendingRecoilCost = 0,
}) {
  return PlayerState(
    id: id,
    hp: hp,
    maxHp: maxHp,
    shield: shield,
    currentCost: currentCost,
    maxCost: maxCost,
    deck: deck,
    hand: hand,
    graveyard: graveyard,
    exhausted: exhausted,
    buffs: buffs,
    debuffs: debuffs,
    cardsPlayedThisTurn: cardsPlayedThisTurn,
    maxHandSize: maxHandSize,
    pendingRecoilCost: pendingRecoilCost,
    pendingOverloadCost: 0,
  );
}

GameState buildState({
  required Map<PlayerId, PlayerState> players,
  BattlePhase battlePhase = BattlePhase.mainPhase,
  PlayerId? turnOwner,
  int seed = 0,
  int turnCount = 0,
}) {
  return GameState(
    players: players,
    phase: GamePhase(
      battlePhase: battlePhase,
      turnOwner: turnOwner ?? players.keys.first,
    ),
    turnCount: turnCount,
    initialTurnOwner: players.keys.first,
    metadata: SystemMetadata(seed: seed, actionSequenceNumber: 0),
  );
}

GameActionPlayCard buildPlayCardAction({
  required PlayerId playerId,
  required String cardInstanceId,
  String actionId = 'action_1',
}) {
  return GameActionPlayCard(
    id: GameActionsId(value: actionId),
    actionSequenceNumber: 0,
    playerId: playerId,
    cardInstanceId: GameCardInstanceId(value: cardInstanceId),
  );
}
