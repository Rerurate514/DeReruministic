import 'package:dereruministic/presentation/components/app_back_button.dart';
import 'package:dereruministic/presentation/components/app_title.dart';
import 'package:dereruministic/presentation/pages/deck_editor/components/deck_save_button.dart';
import 'package:dereruministic/presentation/pages/deck_editor/components/header/deck_infos_header.dart';
import 'package:dereruministic/presentation/pages/deck_editor/components/my_deck_area/my_deck_area.dart';
import 'package:dereruministic/presentation/widgets/ui_page_wrapper.dart';
import 'package:flutter/material.dart';

class DeckEditorPage extends StatelessWidget {
  const DeckEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const UiPageWrapper(
      child: Column(
        crossAxisAlignment: .start,
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
              Expanded(
                child: DeckSaveButton(),
              ),
            ],
          ),

          Divider(),
          DeckInfosHeader(),
          Divider(),

          Expanded(
            child: MyDeckArea(),
          ),

          Divider(),

          Expanded(
            child: Text('Test'),
          ),
        ],
      ),
    );
  }
}
