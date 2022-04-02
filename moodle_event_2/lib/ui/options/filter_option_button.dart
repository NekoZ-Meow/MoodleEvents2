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
      return IconButton(
        tooltip: "フィルタ方法を選択",
        onPressed: () => showDialog(
            context: context,
            builder: (context) {
              return ChangeNotifierProvider<EventListViewModel>.value(
                value: viewModel,
                child: const CategoryFilterDialog(),
              );
            }),
        icon: const Icon(
          Icons.filter_alt_sharp,
          color: ColorConstants.textEnded,
        ),
      );
    });
  }
}
