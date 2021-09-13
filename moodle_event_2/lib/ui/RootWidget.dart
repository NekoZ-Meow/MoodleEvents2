import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_event_2/UserManager/UserManager.dart';
import 'package:moodle_event_2/Utility/DebugUtility.dart';
import 'package:moodle_event_2/WidgetHolder/WidgetHolderState.dart';
import 'package:moodle_event_2/event/Event.dart';
import 'package:moodle_event_2/event/json_to_event.dart';
import 'package:moodle_event_2/server_interface/ServerInterface.dart';
import 'package:moodle_event_2/ui/LoginWidget.dart';

class RootWidget extends StatefulWidget {
  final LoginWidgetState loginWidgetState;
  final UserManager user;
  RootWidget(this.loginWidgetState, this.user);
  @override
  _RootWebView createState() => _RootWebView();
}

class _RootWebView extends WidgetHolderState<RootWidget> {
  @override
  void initState() {
    super.initState();
  }

  ///
  /// カレンダーイベントを取得する
  ///
  void getEvent() async {
    if (await widget.loginWidgetState.waitLogin()) {
      List<Event> events = JsonToEvent.calenderJsonToEvents(
          await getCalendarEvents(DateTime(2021, 1), DateTime(2021, 12),
              await widget.loginWidgetState.getSessionKey()));
      events.forEach((element) {
        debugLog("${element.title}:${element.courseName}");
      });
    } else {
      print("ログイン失敗");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Moodle Events"),
        ),
        body: Container(
            child: TextButton(
          child: Text("ボタン"),
          onPressed: () async {
            this.getEvent();
          },
        )));
  }
}
