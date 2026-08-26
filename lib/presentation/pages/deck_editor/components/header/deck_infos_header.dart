import 'package:dereruministic/presentation/pages/deck_editor/components/header/cards_count.dart';
import 'package:dereruministic/presentation/pages/deck_editor/components/header/deck_clear_button.dart';
import 'package:flutter/widgets.dart';

class DeckInfosHeader extends StatelessWidget {
  const DeckInfosHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        CardsCount(
          count: 10,
        ),
        DeckClearButton(),
      ],
    );
  }
}
