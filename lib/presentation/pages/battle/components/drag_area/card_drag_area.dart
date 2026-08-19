import 'package:dereruministic/application/game/state/game_notifier.dart';
import 'package:dereruministic/domain/card/entities/game_card.dart';
import 'package:dereruministic/domain/player/entities/player.dart';
import 'package:dereruministic/presentation/pages/battle/components/card/game_card_component.dart';
import 'package:dereruministic/presentation/pages/battle/components/drag_area/drag_area_card.dart';
import 'package:dereruministic/presentation/pages/battle/providers/player_ui_state_provider.dart';
import 'package:dereruministic/presentation/pages/battle/providers/step/displayed_phase_notifier.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef AnimationContext = ({GameCard card, Offset offset});

class CardDragArea extends HookConsumerWidget {
  const CardDragArea({required this.player, super.key});

  final Player player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themePalette;

    final droppedCard = useState<AnimationContext?>(null);

    final controller = useAnimationController(
      duration: const Duration(milliseconds: 200),
    );

    useEffect(() {
      Future<void> listener(AnimationStatus status) async {
        if (status == AnimationStatus.completed) {
          final ac = droppedCard.value;
          if (ac != null) {
            await ref.read(gameProvider.notifier).playCard(ac.card, player.id);
            droppedCard.value = null;
            controller.reset();
          }
        }
      }

      controller.addStatusListener(listener);
      return () => controller.removeStatusListener(listener);
    }, [controller]);
    useEffect(() {
      if (droppedCard.value != null) {
        controller.forward(from: 0);
      }
      return null;
    }, [droppedCard.value]);

    final currentPhase = ref.watch(displayedPhaseProvider);
    final isMainPhase =
        currentPhase?.battlePhase == .mainPhase &&
        currentPhase?.turnOwner == player.id;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: DragTarget<GameCard>(
        onWillAcceptWithDetails: (details) {
          final gameState = ref.read(gameProvider);
          final playerState = ref.read(myPlayerUiStateProvider(player));

          if (gameState == null || playerState == null) return false;

          final playerCost = playerState.cost;
          final cardCost = details.data.currentCost;

          return gameState.phase.turnOwner == player.id &&
              isMainPhase &&
              playerCost >= cardCost;
        },
        onAcceptWithDetails: (detail) async {
          final renderBox = context.findRenderObject() as RenderBox?;
          final localOffset = renderBox != null
              ? renderBox.globalToLocal(detail.offset)
              : detail.offset;

          droppedCard.value = (card: detail.data, offset: localOffset);
        },
        builder: (context, candidateData, rejectedData) {
          final isHovering = candidateData.isNotEmpty;

          return Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isHovering
                        ? theme.brandSecondary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: const DragAreaCard(),
              ),

              if (droppedCard.value != null)
                Positioned(
                  left: droppedCard.value!.offset.dx,
                  top: droppedCard.value!.offset.dy,
                  child:
                      GameCardComponent(
                            gameCard: droppedCard.value!.card,
                          )
                          .animate()
                          .shakeX(amount: 8, duration: 150.ms)
                          .tint(color: theme.brandSecondary, duration: 100.ms)
                          .fadeOut(duration: 150.ms),
                ),
            ],
          );
        },
      ),
    );
  }
}
