import 'package:dereruministic/presentation/theme/app_color_scheme.dart';
import 'package:dereruministic/presentation/widgets/ui_gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppTextField extends HookWidget {
  const AppTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.onChanged,
    this.primaryColor,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.hintColor,
  });
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  final Color? primaryColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? hintColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.themePalette;

    final effectivePrimaryColor = primaryColor ?? theme.brandColor;
    final effectiveBackgroundColor = backgroundColor ?? theme.surfaceContainer;
    final effectiveBorderColor = borderColor ?? theme.outlineVariant;
    final effectiveTextColor = textColor ?? theme.textPrimary;
    final effectiveHintColor = hintColor ?? theme.textSecondary;

    final focusNode = useFocusNode();
    final isFocused = useState(false);

    useEffect(() {
      void listener() {
        isFocused.value = focusNode.hasFocus;
      }

      focusNode.addListener(listener);
      return () => focusNode.removeListener(listener);
    }, [focusNode]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!.toUpperCase(),
            style: TextStyle(
              color: effectiveHintColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const UiGap.s(),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isFocused.value
                  ? effectivePrimaryColor
                  : effectiveBorderColor,
              width: isFocused.value ? 1.5 : 1.0,
            ),
            boxShadow: isFocused.value
                ? [
                    BoxShadow(
                      color: effectivePrimaryColor.withOpacity(0.35),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: TextStyle(
              color: effectiveTextColor,
              fontSize: 14,
              letterSpacing: 1.1,
            ),
            cursorColor: effectivePrimaryColor,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: effectiveHintColor,
                fontSize: 14,
                letterSpacing: 1,
              ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
