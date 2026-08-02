import 'package:flutter/material.dart';

class UiInk extends StatelessWidget {
  const UiInk({
    required this.child,
    super.key,
    this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.color,
    this.splashColor,
    this.highlightColor,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final Color? color;
  final Color? splashColor;
  final Color? highlightColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? Colors.transparent,
      borderRadius: borderRadius,
      clipBehavior: borderRadius != null ? Clip.antiAlias : Clip.none,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        splashColor: splashColor,
        highlightColor: highlightColor,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
