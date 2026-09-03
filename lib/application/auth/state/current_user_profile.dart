// import 'package:dereruministic/application/auth/state/auth_provider.dart';
// import 'package:dereruministic/di/providers/auth/user_repository_provider.dart';
// import 'package:dereruministic/domain/player/entities/player.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'current_user_profile.g.dart';

// @riverpod
// Stream<Player?> currentUserProfile(Ref ref) {
//   final user = ref.watch(authProvider).value;
//   if (user == null) return Stream.value(null);

//   final repository = ref.watch(userRepositoryProvider);
//   return repository.watchPlayer(user.uid);
// }
