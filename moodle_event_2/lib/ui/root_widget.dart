import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_event_2/constants/margin_constants.dart';
import 'package:moodle_event_2/model/model.dart';
import 'package:moodle_event_2/ui/error_dialog.dart';
import 'package:moodle_event_2/ui/event_list_widget.dart';

class RootWidget extends StatefulWidget {
  const RootWidget({Key? key}) : super(key: key);
  @override
  _RootWebView createState() => _RootWebView();
}

class _RootWebView extends State<RootWidget> {
  final _model = Model();
  @override
  void initState() {
    super.initState();
    this._model.load().then((_) {
      this.setState(() {});
    }).onError((error, stackTrace) {
      ErrorDialog.showErrorDialog(this.context, "データの読み込みに失敗しました");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Moodle Events"),
      ),
      body: Padding(
        padding: EdgeInsets.all(MarginConstants.baseMargin),
        child: EventListWidget(this._model),
      ),
    );
  }
}
