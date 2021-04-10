import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_event_2/UserManager/UserManager.dart';
import 'package:moodle_event_2/WidgetHolder/WidgetHolderState.dart';
import 'package:moodle_event_2/server_interface/ServerInterface.dart';
import 'package:moodle_event_2/ui/LoginWidget.dart';

class RootWidget extends StatefulWidget {
  final LoginWidgetState loginWidgetState;
  final UserManager user;
  RootWidget(this.loginWidgetState, this.user);
  @override
  _RootWidgetState createState() => _RootWidgetState();
}

class _RootWidgetState extends WidgetHolderState<RootWidget> {
  @override
  void initState() {
    super.initState();
  }

  void getEvent(String sess) async {
    getCalendarEvents(
        DateTime.now(), DateTime.now().add(Duration(days: 32)), sess);
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
            this.getEvent(await widget.loginWidgetState.getSessionKey());
          },
        )));
  }
}
