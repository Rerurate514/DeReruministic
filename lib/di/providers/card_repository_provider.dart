import 'package:dereruministic/domain/card/repositories/i_card_repository.dart';
import 'package:dereruministic/infrastructure/card/repositories/local_card_reposory_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
ICardRepository cardRepository(Ref ref) {
  return LocalCardReposoryImpl();
}
