import 'package:flutter/material.dart';

class StateStatus extends StatelessWidget {
  const StateStatus({
    required this.hpStateWidget,
    required this.shieldStateWidget,
    super.key,
  });

  final Widget hpStateWidget;
  final Widget shieldStateWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: hpStateWidget),
        Align(alignment: .centerEnd, child: shieldStateWidget),
      ],
    );
  }
}
