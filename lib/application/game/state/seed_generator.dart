import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'seed_generator.g.dart';

@riverpod
int Function() seedGenerator(Ref ref) {
  final seed = Random().nextInt(0x7FFFFFFF);
  return () => seed;
}
