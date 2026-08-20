import 'package:dereruministic/presentation/components/app_back_button.dart';
import 'package:dereruministic/presentation/components/app_title.dart';
import 'package:dereruministic/presentation/widgets/ui_gap.dart';
import 'package:dereruministic/presentation/widgets/ui_page_wrapper.dart';
import 'package:flutter/material.dart';

class RoomPage extends StatelessWidget {
  const RoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UiPageWrapper(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Row(
              spacing: 16,
              children: [
                AppBackButton(),
                Expanded(
                  child: FittedBox(
                    fit: .scaleDown,
                    child: AppTitle(),
                  ),
                ),
              ],
            ),
            UiGap.s(),
            Text('ROOM IDはここ'),
            UiGap.m(),
            Text('ROOMパラメータはここ'),
            UiGap.m(),
            Text('ROOM IDはここ'),
          ],
        ),
      ),
    );
  }
}
