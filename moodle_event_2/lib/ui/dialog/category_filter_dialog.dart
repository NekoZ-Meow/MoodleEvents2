import 'package:flutter/material.dart';
import 'package:moodle_event_2/ui/event_list/event_list_viewmodel.dart';
import 'package:moodle_event_2/ui/home_page/home_page_viewmodel.dart';
import 'package:moodle_event_2/ui/options/filter_checkbox.dart';
import 'package:provider/provider.dart';

class CategoryFilterDialog extends StatefulWidget {
  const CategoryFilterDialog({Key? key}) : super(key: key);

  @override
  State<CategoryFilterDialog> createState() => _CategoryFilterDialogState();
}

class _CategoryFilterDialogState extends State<CategoryFilterDialog> {
  @override
  Widget build(BuildContext context) {
    Set<String> categories = context
        .watch<HomePageViewModel>()
        .events
        .map((event) => event.courseName)
        .toSet();

    List<FilterCheckBox> checkboxes =
        categories.map((category) => FilterCheckBox(category)).toList();

    return AlertDialog(
      title: const Text("コースフィルタ"),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(shrinkWrap: true, children: checkboxes),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  setState(() {
                    categories.forEach((category) {
                      context
                          .read<EventListViewModel>()
                          .addCourseFilter(category);
                    });
                  });
                },
                child: const Text("全てを除外")),
            TextButton(
                onPressed: () {
                  setState(() {
                    categories.forEach((category) {
                      context
                          .read<EventListViewModel>()
                          .removeCourseFilter(category);
                    });
                  });
                },
                child: const Text("全てを表示")),
          ],
        ),
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK")),
      ],
    );
  }
}
