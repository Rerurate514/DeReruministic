import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'room_id_text_notifier.g.dart';

@riverpod
class RoomIdTextNotifier extends _$RoomIdTextNotifier {
  @override
  String build() {
    return '';
  }

  void set(String text) => state = text;

  void clear() => state = '';
}
