import 'package:flutter/material.dart';
import 'package:moodle_event_2/constants/color_constants.dart';
import 'package:moodle_event_2/model/options/sort_option.dart';
import 'package:moodle_event_2/ui/event_list/event_list_viewmodel.dart';
import 'package:provider/provider.dart';

class SortOptionPopupMenu extends StatelessWidget {
  final Map<SortOption, String> choiceTitleOfSortOptions = const {
    SortOption.deadLineAsc: "締め切り - 昇順",
    SortOption.deadLineDesc: "締め切り - 降順",
    SortOption.courseAsc: "コース名 - 昇順",
    SortOption.courseDesc: "コース名 - 降順",
    SortOption.titleAsc: "タイトル名 - 昇順",
    SortOption.titleDesc: "タイトル名 - 降順",
  };

  const SortOptionPopupMenu({Key? key}) : super(key: key);

  CheckedPopupMenuItem<SortOption> popUpMenuBuilder(
      BuildContext context, SortOption option, String title,
      {bool isChecked = false}) {
    return CheckedPopupMenuItem<SortOption>(
      padding: EdgeInsets.zero,
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline2,
      ),
      value: option,
      checked: isChecked,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventListViewModel>(builder: (context, viewModel, _) {
      SortOption groupValue = viewModel.getSortOption();
      List<PopupMenuEntry<SortOption>> popUpMenus = SortOption.values
          .map((option) => this.popUpMenuBuilder(
              context, option, this.choiceTitleOfSortOptions[option]!,
              isChecked: (groupValue == option)))
          .toList();

      return PopupMenuButton<SortOption>(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.sort, color: ColorConstants.textEnded),
        onSelected: (selected) => viewModel.setSortOption(selected),
        itemBuilder: (context) => popUpMenus,
        tooltip: "ソート方法を選択",
      );
    });
  }
}
