import 'package:animated_text_effects/animated_text_effects.dart';
import 'package:collection/collection.dart';
import 'package:dereruministic/application/game/state/step_event_queue_notifier.dart';
import 'package:dereruministic/domain/game_system/value_objects/game_step_event.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/utils/game_step_event_ex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class BackgroundLogs extends HookConsumerWidget {
  const BackgroundLogs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    const maxCount = 10;

    final nextId = useRef(0);
    final events = useState<QueueList<(int, GameStepEvent)>>(
      QueueList.from([]),
    );

    ref.listen(stepEventQueueProvider, (previous, next) {
      if (previous == null || next.length >= previous.length) return;

      final removedEvents = previous.where((event) => !next.contains(event));
      final nextQueue = QueueList.from(events.value)
        ..addAll(removedEvents.map((e) => (nextId.value++, e)));
      while (nextQueue.length > maxCount) {
        nextQueue.removeFirst();
      }
      events.value = nextQueue;
    });

    return Padding(
      padding: const EdgeInsets.all(4),
      child: SizedBox(
        height: 300,
        child: Column(
          children: [
            Row(
              spacing: 8,
              children: [
                Icon(
                  Symbols.terminal,
                  size: 18,
                  color: theme.textPrimary.withAlpha(100),
                ),
                Text(
                  l10n.battle_page_combat_log_text,
                  style: GoogleFonts.shareTechMono(
                    letterSpacing: 2,
                    color: theme.textPrimary.withAlpha(100),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                findChildIndexCallback: (key) {
                  final valuekey = key as ValueKey<int>;
                  final index = events.value.indexWhere(
                    (e) => e.$1 == valuekey.value,
                  );
                  return index == -1 ? null : index;
                },
                itemCount: events.value.length,
                itemBuilder: (context, index) {
                  final (id, event) = events.value[index];
                  return AnimatedText(
                    key: ValueKey(id),
                    event.text(l10n),
                    effects: const [
                      TypewriterEffect(
                        delayBetweenChars: Duration(milliseconds: 20),
                      ),
                    ],
                    style: GoogleFonts.shareTechMono(
                      color: theme.textPrimary.withAlpha(100),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
