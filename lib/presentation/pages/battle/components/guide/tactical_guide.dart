import 'package:dereruministic/presentation/components/app_card.dart';
import 'package:flutter/material.dart';

class TacticalGuide extends StatelessWidget {
  const TacticalGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: AppCard(
        isBlur: true,
        blurSigma: 10,
        child: SingleChildScrollView(
          child: Column(
            children: [Text("text")],
          ),
        ),
      ),
    );
  }
}
