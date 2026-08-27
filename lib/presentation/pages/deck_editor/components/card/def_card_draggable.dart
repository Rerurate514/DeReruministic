import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/presentation/pages/deck_editor/components/card/def_card_component.dart';
import 'package:flutter/material.dart';

class DefCardDraggable extends StatelessWidget {
  const DefCardDraggable({required this.defCard, super.key});

  final CardDefinition defCard;

  @override
  Widget build(BuildContext context) {
    return Draggable<CardDefinition>(
      data: defCard,
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
