import 'package:dereruministic/presentation/components/app_subtitle.dart';
import 'package:dereruministic/presentation/components/app_subtitle_trailing.dart';
import 'package:dereruministic/presentation/components/app_title.dart';
import 'package:dereruministic/presentation/pages/home/components/deck_editor_button.dart';
import 'package:dereruministic/presentation/pages/home/components/player_info.dart';
import 'package:dereruministic/presentation/pages/home/components/player_info_system_chip.dart';
import 'package:dereruministic/presentation/pages/home/components/setting_button.dart';
import 'package:dereruministic/presentation/pages/home/components/start_battle_button.dart';
import 'package:dereruministic/presentation/widgets/ui_gap.dart';
import 'package:dereruministic/presentation/widgets/ui_page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const UiPageWrapper(
      child: Column(
        children: [
          FittedBox(
            child: AppTitle(),
          ),
          AppSubtitle(),
          AppSubtitleTrailing(),
          UiGap.m(),
          StartBattleButton(),
          UiGap.s(),
          DeckEditorButton(),
          UiGap.s(),
          SettingButton(),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PlayerInfo(),
                  PlayerInfoSystemChip(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
