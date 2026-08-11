import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

class UiInterlacingArtifactsText extends HookWidget {
  const UiInterlacingArtifactsText({
    required this.text,
    super.key,
    this.fontSize = 48.0,
    this.animationDuration = const Duration(seconds: 3),
  });

  final String text;
  final double fontSize;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    final faceColor = theme.textSecondary;
    final orangeShadow = theme.brandColor;
    final cyanCyanShift = theme.brandSecondary;

    final controller = useAnimationController(
      duration: animationDuration,
    );

    final leftAnimation = useAnimation(
      Tween<Offset>(
        begin: const Offset(4, -4),
        end: const Offset(-4, 4),
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      ),
    );

    final rightAnimation = useAnimation(
      Tween<Offset>(
        begin: const Offset(-4, 4),
        end: const Offset(4, -4),
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      ),
    );

    useEffect(() {
      controller.repeat(reverse: true);
      return null;
    }, [controller]);

    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          text,
          style: GoogleFonts.shareTechMono(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: faceColor,
            shadows: [
              Shadow(
                offset: rightAnimation,
                color: cyanCyanShift,
              ),
              Shadow(
                offset: leftAnimation,
                color: orangeShadow,
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: ScanlinePainter(),
          ),
        ),
      ],
    );
  }
}

class ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withAlpha(50)
      ..strokeWidth = 1.0;

    const lineSpacing = 3.0;

    for (double y = 0; y < size.height; y += lineSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
