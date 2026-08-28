import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/presentation/pages/deck_editor/components/card/def_card_component.dart';
import 'package:dereruministic/presentation/pages/deck_editor/state/in_card_place.dart';
import 'package:flutter/material.dart';

class DefCardDraggable<T extends InCardPlace> extends StatelessWidget {
  const DefCardDraggable({
    required this.defCard,
    required this.createPlace,
    this.onDragStarted,
    this.onDragEnd,
    super.key,
  });

  final CardDefinition defCard;
  final T Function(CardDefinition defCard) createPlace;
  final void Function()? onDragStarted;
  final void Function(DraggableDetails)? onDragEnd;

  @override
  Widget build(BuildContext context) {
    return Draggable<T>(
      data: createPlace(defCard),
      onDragStarted: onDragStarted,
      onDragEnd: onDragEnd,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.1,
          child: DefCardComponent(
            defCard: defCard,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: DefCardComponent(
          defCard: defCard,
        ),
      ),
      child: DefCardComponent(
        defCard: defCard,
      ),
    );
  }
}
