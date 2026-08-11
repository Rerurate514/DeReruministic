import 'package:dereruministic/presentation/pages/lobby/components/lobby_controls/enter_room_button.dart';
import 'package:dereruministic/presentation/pages/lobby/components/lobby_controls/enter_room_id_input.dart';
import 'package:flutter/material.dart';

class EnterRoomPanel extends StatelessWidget {
  const EnterRoomPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 16,
      children: [EnterRoomIdInput(), EnterRoomButton()],
    );
  }
}
