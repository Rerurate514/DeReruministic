import 'package:animated_text_effects/animated_text_effects.dart';
import 'package:dereruministic/application/remote_sync/room/state/room_watch_provider.dart';
import 'package:dereruministic/application/remote_sync/room/usecases/start_game_usecase.dart';
import 'package:dereruministic/domain/remote_sync/room/entities/room.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_id.dart';
import 'package:dereruministic/domain/remote_sync/room/value_objects/room_watch_result.dart';
import 'package:dereruministic/l10n/app_localizations.dart';
import 'package:dereruministic/presentation/components/app_highlight_transparency_button.dart';
import 'package:dereruministic/presentation/painter/glow_line_painter.dart';
import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class GameStartButton extends ConsumerWidget {
  const GameStartButton({required this.roomId, super.key});

  final RoomId roomId;

  Widget _corner({
    required Color color,
    required bool flipX,
    required bool flipY,
  }) {
    final path = Path()
      ..moveTo(-15, 20)
      ..lineTo(0, -3)
      ..lineTo(150, -3)
      ..moveTo(-15, 25)
      ..lineTo(0, 0)
      ..lineTo(150, 0)
      ..moveTo(-15, 30)
      ..lineTo(0, 3)
      ..lineTo(150, 3)
      // 終端
      ..lineTo(160, -2)
      ..moveTo(150, 3)
      ..lineTo(160, 8)
      ..lineTo(155, -2)
      ..moveTo(145, 3)
      ..lineTo(155, 8)
      ..lineTo(150, -2)
      ..moveTo(140, 3)
      ..lineTo(150, 8)
      ..moveTo(155, 3)
      ..lineTo(165, 8)
      ..lineTo(160, -2)
      ..moveTo(165, 3)
      ..lineTo(175, 8)
      ..lineTo(170, -2);

    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.diagonal3Values(
        flipX ? -1.0 : 1.0,
        flipY ? -1.0 : 1.0,
        1,
      ),
      child: CustomPaint(
        painter: GlowLinePainter(path: path, color: color),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themePalette;

    final roomData = ref.watch(roomWatchProvider(roomId: roomId));

    return roomData.maybeWhen<Widget>(
      data: (data) {
        return switch (data) {
          RoomWatchResultAvailable(:final room) => _buildContent(
            ref,
            l10n,
            theme,
            room,
          ),
          RoomWatchResultUnavailable() =>
            throw UnimplementedError(), //TODO(low): Error
        };
      },
      orElse: UiLoadingIndicator.new,
    );
  }

  Widget _buildContent(
    WidgetRef ref,
    AppLocalizations l10n,
    AppColorScheme theme,
    Room room,
  ) {
    final isExistGuest = room.guestPlayerId != null;
    final color = isExistGuest ? theme.brandSecondary : theme.brandTertiary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Stack(
        children: [
          AppHighlightTransparencyButton(
            foregroundColor: Colors.transparent,
            onPressed: () async {
              await ref.read(startGameUseCaseProvider).execute(roomId: roomId);
            },
            child: AnimatedText(
              l10n.room_page_game_start_button_text,
              repeat: true,
              effects: isExistGuest
                  ? const [
                      VHSGlitchEffect(
                        duration: Duration(milliseconds: 1000),
                        colorOffset: 0,
                        jitter: 128,
                        maxBlur: 2,
                      ),
                    ]
                  : [],
              style: GoogleFonts.shareTechMono(
                letterSpacing: 2,
                color: color,
                fontWeight: .bold,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: _corner(color: color, flipX: false, flipY: false),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _corner(color: color, flipX: true, flipY: false),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: _corner(color: color, flipX: false, flipY: true),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: _corner(color: color, flipX: true, flipY: true),
          ),
        ],
      ),
    );
  }
}
