import 'package:dereruministic/presentation/pages/battle/components/header/battle_header.dart';
import 'package:dereruministic/presentation/widgets/ui_page_wrapper.dart';
import 'package:flutter/material.dart';

class BattlePage extends StatelessWidget {
  const BattlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UiPageWrapper(
      padding: EdgeInsets.all(4),
      child: Column(
        children: [BattleHeader()],
      ),
    );
  }
}
