import 'package:dereruministic/domain/card/value_objects/game_card_instance_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'displayed_card_drawn_animation_notifier.g.dart';

typedef HandDrawRequest = ({int seq, List<GameCardInstanceId> targets});

@riverpod
class DisplayedCardDrawnAnimationNotifier
    extends _$DisplayedCardDrawnAnimationNotifier {
  var _seq = 0;

  @override
  HandDrawRequest? build() => null;

  void apply(List<GameCardInstanceId> targets) =>
      state = (seq: ++_seq, targets: targets);
}
