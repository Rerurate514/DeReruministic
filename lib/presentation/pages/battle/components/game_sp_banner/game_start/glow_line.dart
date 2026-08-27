import 'package:flutter/material.dart';

class GlowLine extends StatelessWidget {
  const GlowLine({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 1,
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
