import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:flutter/material.dart';

class ProviderButton extends StatelessWidget {
  const ProviderButton({
    required this.icon,
    required this.onPressed,
    required this.child,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: child,
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.textPrimary,
        side: BorderSide(color: theme.brandSecondary.withOpacity(0.55)),
        shape: const RoundedRectangleBorder(),
        minimumSize: const Size.fromHeight(46),
      ),
    );
  }
}
