import 'package:dereruministic/domain/player/entities/player.dart';

abstract interface class IUserRepository {
  Future<void> save(Player player);
}
