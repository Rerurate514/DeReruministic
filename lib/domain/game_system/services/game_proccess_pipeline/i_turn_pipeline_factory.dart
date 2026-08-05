import 'package:dereruministic/domain/game_system/services/game_proccess_pipeline/turn_pipeline.dart';

abstract interface class ITurnPipelineFactory {
  TurnPipeline createGameStartPipeline();
  TurnPipeline createTurnEndPipeline();
}
