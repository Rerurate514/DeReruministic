import 'package:dereruministic/presentation/components/app_back_button.dart';
import 'package:dereruministic/presentation/components/app_title.dart';
import 'package:dereruministic/presentation/pages/lobby/components/lobby_controls/lobby_controls_panel.dart';
import 'package:dereruministic/presentation/pages/lobby/components/match_parameters/match_parameters_panel.dart';
import 'package:dereruministic/presentation/widgets/ui_gap.dart';
import 'package:dereruministic/presentation/widgets/ui_page_wrapper.dart';
import 'package:flutter/material.dart';

class LobbyPage extends StatelessWidget {
  const LobbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UiPageWrapper(
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Row(
            spacing: 16,
            children: [
              AppBackButton(),
              Expanded(
                child: FittedBox(
                  fit: .scaleDown,
                  child: AppTitle(),
                ),
              ),
            ],
          ),
          UiGap.s(),
          LobbyControlsPanel(),
          UiGap.m(),
          MatchParametersPanel(),
        ],
      ),
    );
  }
}
