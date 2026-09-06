import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/pages/battle/providers/event_step_log_notifier.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/utils/game_step_event_ex.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EventLogContent extends HookConsumerWidget {
  const EventLogContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    final events = ref.watch(eventStepLogProvider);

    return Padding(
      padding: const EdgeInsets.all(4),
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Text(
            key: ValueKey(event),
            event.text(l10n),
            style: GoogleFonts.shareTechMono(
              color: theme.textPrimary.withAlpha(100),
            ),
          );
        },
      ),
    );
  }
}
