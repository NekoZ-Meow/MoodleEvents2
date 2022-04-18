import 'package:flutter/material.dart';
import 'package:moodle_event_2/constants/color_constants.dart';
import 'package:moodle_event_2/ui/dialog/category_filter_dialog.dart';
import 'package:moodle_event_2/ui/event_list/event_list_viewmodel.dart';
import 'package:provider/provider.dart';

class FilterOptionButton extends StatelessWidget {
  const FilterOptionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<EventListViewModel>(builder: (context, viewModel, _) {
      return PopupMenuButton<void>(
        tooltip: "フィルタを設定",
        icon: const Icon(
          Icons.filter_alt_sharp,
          color: ColorConstants.textEnded,
        ),
        itemBuilder: (context) {
          return <PopupMenuEntry<void>>[
            PopupMenuItem<void>(
              enabled: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "コースフィルタ...",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ChangeNotifierProvider<
                                EventListViewModel>.value(
                              value: viewModel,
                              child: const CategoryFilterDialog(),
                            );
                          });
                    },
                  ),
                  const PopupMenuDivider(),
                  StatefulBuilder(builder: (context, setState) {
                    return CheckboxListTile(
                      contentPadding: const EdgeInsets.only(right: 14),
                      title: Text(
                        "終了済みの課題を表示",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      value: viewModel.isShowEndedEvent(),
                      onChanged: (value) => (value != null)
                          ? setState(() => viewModel.setShowEndedEvent(value))
                          : {},
                    );
                  }),
                ],
              ),
            ),
          ];
        },
      );
    });
  }
}
