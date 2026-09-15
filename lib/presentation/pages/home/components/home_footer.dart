import 'package:dereruministic/application/auth/state/current_user_profile.dart';
import 'package:dereruministic/presentation/pages/home/components/player_info.dart';
import 'package:dereruministic/presentation/pages/home/components/player_info_system_chip.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeFooter extends ConsumerWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(currentUserProfileProvider);

    return player.when(
      data: (player) {
        if (player == null) return const UiLoadingIndicator();

        return FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PlayerInfo(player: player),
              PlayerInfoSystemChip(player: player),
            ],
          ),
        );
      },
      error: (error, stackTrace) => Text('$error, $stackTrace'),
      loading: UiLoadingIndicator.new,
    );
  }
}
