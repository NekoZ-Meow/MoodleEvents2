import 'package:flutter/material.dart';
import 'package:moodle_event_2/ui/event_list/event_list_viewmodel.dart';
import 'package:provider/provider.dart';

class FilterCheckBox extends StatefulWidget {
  final String _title;

  const FilterCheckBox(String title, {Key? key})
      : this._title = title,
        super(key: key);

  @override
  State<FilterCheckBox> createState() => _FilterCheckBoxState();
}

class _FilterCheckBoxState extends State<FilterCheckBox> {
  /// 値が変更された時
  void onChangeHandler(bool isSelected, EventListViewModel viewModel) {
    super.setState(() {
      if (isSelected) {
        viewModel.removeCourseFilter(widget._title);
      } else {
        viewModel.addCourseFilter(widget._title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: double.maxFinite,
      child: Consumer<EventListViewModel>(builder: (context, viewModel, _) {
        return CheckboxListTile(
          title: Text(
            widget._title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline2,
          ),
          value: !viewModel.getCourseFilter().contains(widget._title),
          onChanged: (value) =>
              (value != null) ? onChangeHandler(value, viewModel) : {},
        );
      }),
    );
  }
}
