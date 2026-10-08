import 'package:flutter/material.dart';

class StateEffectList extends StatelessWidget {
  const StateEffectList({required this.effects, super.key});

  final List<Widget> effects;

  @override
  Widget build(BuildContext context) {
    if (effects.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(spacing: 8, runSpacing: 8, children: effects),
    );
  }
}
