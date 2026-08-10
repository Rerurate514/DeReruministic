import 'package:dereruministic/presentation/pages/home/components/deck_editor_button.dart';
import 'package:dereruministic/presentation/pages/home/components/start_battle_button.dart';
import 'package:dereruministic/presentation/widgets/ui_page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const UiPageWrapper(
      child: Column(
        spacing: 16,
        children: [StartBattleButton(), DeckEditorButton()],
      ),
    );
  }
}
