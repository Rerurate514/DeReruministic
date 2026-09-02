import 'package:dereruministic/di/providers/core/fiestore_provider.dart';
import 'package:dereruministic/di/providers/core/firebase_auth_provider.dart';
import 'package:dereruministic/di/providers/core/google_sign_in_provider.dart';
import 'package:dereruministic/domain/auth/repositories/i_auth_repository.dart';
import 'package:dereruministic/infrastructure/auth/repositories/firebase_auth_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
IAuthRepository authRepository(Ref ref) {
  return FirebaseAuthRepositoryImpl(
    firestore: ref.watch(firestoreProviderProvider),
    googleSignIn: ref.watch(googleSignInProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
}
