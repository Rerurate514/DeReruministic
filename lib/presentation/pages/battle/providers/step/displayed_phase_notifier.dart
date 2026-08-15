import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_phase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'displayed_phase_notifier.g.dart';

@riverpod
class DisplayedPhaseNotifier extends _$DisplayedPhaseNotifier {
  @override
  GamePhase? build() => ref.read(gameProvider)?.phase;

  void apply(GamePhase phase) => state = phase;
}
