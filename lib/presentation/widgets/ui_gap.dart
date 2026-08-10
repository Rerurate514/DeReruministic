import 'package:flutter/material.dart';

class UiGap extends StatelessWidget {
  const UiGap.xs({super.key}) : size = 8;
  const UiGap.s({super.key}) : size = 16; //余白
  const UiGap.m({super.key}) : size = 24; //セクション
  const UiGap.l({super.key}) : size = 32; //カテゴリ

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size);
  }
}
