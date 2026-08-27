import 'package:dereruministic/domain/card/entities/card_definition.dart';
import 'package:dereruministic/presentation/pages/deck_editor/components/card/def_card_base_component.dart';
import 'package:dereruministic/presentation/pages/deck_editor/components/card/def_card_meta.dart';
import 'package:dereruministic/presentation/pages/deck_editor/components/card/def_card_name_text.dart';
import 'package:dereruministic/presentation/painter/under_card_painter.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_interlacing_artifacts_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DefCardComponent extends ConsumerWidget {
  const DefCardComponent({required this.defCard, super.key});

  final CardDefinition defCard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themePalette;
    return SizedBox(
      width: 180,
      height: 240,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                DefCardBaseComponent(
                  defCard: defCard,
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: ScanlinePainter(),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: DefCardMeta(
              defCard: defCard,
            ),
          ),
          Positioned(
            child: DefCardNameText(
              defCard: defCard,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: CustomPaint(
              painter: UnderCardPainter(color: theme.brandSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
