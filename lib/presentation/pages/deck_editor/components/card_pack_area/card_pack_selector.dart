import 'package:dereruministic/domain/card_packs/data/card_packs.dart';
import 'package:dereruministic/presentation/pages/deck_editor/providers/selected_card_pack_type_notifier.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class CardPackSelector extends ConsumerWidget {
  const CardPackSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.themePalette;
    final selectedPackType = ref.watch(selectedCardPackTypeProvider);

    return SizedBox(
      width: 180,
      height: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: theme.outline),
          color: theme.surfaceContainer.withValues(alpha: 0.72),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CardPackTypes>(
              value: selectedPackType,
              isExpanded: true,
              dropdownColor: theme.surfaceContainer,
              icon: Icon(
                Symbols.keyboard_arrow_down,
                color: theme.brandColor,
              ),
              style: GoogleFonts.shareTechMono(
                color: theme.textPrimary,
                fontSize: 13,
              ),
              items: CardPackTypes.values.map((packType) {
                final pack = cardPacksTypes[packType]!;
                return DropdownMenuItem(
                  value: packType,
                  child: Text(
                    pack.packName,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (packType) {
                if (packType == null) return;
                ref.read(selectedCardPackTypeProvider.notifier).set(packType);
              },
            ),
          ),
        ),
      ),
    );
  }
}
