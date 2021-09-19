import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_event_2/constants/margin_constants.dart';
import 'package:moodle_event_2/model/model.dart';
import 'package:moodle_event_2/ui/event_list_widget.dart';

class RootWidget extends StatefulWidget {
  RootWidget();
  @override
  _RootWebView createState() => _RootWebView();
}

class _RootWebView extends State<RootWidget> {
  final _model = new Model();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Moodle Events"),
      ),
      body: Padding(
          padding: EdgeInsets.all(MarginConstants.BASE_MARGIN),
          child: EventListWidget(this._model)),
    );
  }
}
