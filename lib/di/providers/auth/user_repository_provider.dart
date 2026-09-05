import 'package:dereruministic/di/providers/core/fiestore_provider.dart';
import 'package:dereruministic/domain/auth/repositories/i_user_repository.dart';
import 'package:dereruministic/infrastructure/auth/repositories/user_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository_provider.g.dart';

@riverpod
IUserRepository userRepository(Ref ref) {
  return UserRepositoryImpl(firestore: ref.watch(firestoreProvider));
}
