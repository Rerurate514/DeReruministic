import 'package:dereruministic/application/auth/usecases/sign_out_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_out_notifier.g.dart';

@riverpod
class SignOutNotifier extends _$SignOutNotifier {
  @override
  FutureOr<void> build() {}

  Future<void> execute() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(signOutUsecaseProvider).signOut();
    });
  }
}
