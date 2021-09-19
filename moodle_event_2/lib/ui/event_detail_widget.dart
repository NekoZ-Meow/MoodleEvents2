import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:moodle_event_2/constants/color_constants.dart';
import 'package:moodle_event_2/constants/margin_constants.dart';
import 'package:moodle_event_2/event/event.dart';
import 'package:moodle_event_2/utility/event_utility.dart';
import "package:url_launcher/url_launcher.dart";

class EventDetailWidget extends StatefulWidget {
  final Event event;
  const EventDetailWidget(this.event, {Key key}) : super(key: key);

  @override
  _EventDetailWidgetState createState() => _EventDetailWidgetState();
}

class _EventDetailWidgetState extends State<EventDetailWidget> {
  final double SUB_TEXT_MARGIN = 10;
  Timer _dateTimer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._dateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      this.setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    this._dateTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    DateTime startTime = widget.event.startTime;
    DateTime endTime = widget.event.endTime;
    String startTimeText;
    String endTimeText;
    String submitText;
    Color submitTextColor;
    if (startTime != null) {
      startTimeText =
          "${startTime.year}年${startTime.month}月${startTime.day}日 ${startTime.hour.toString().padLeft(2, "0")}:${startTime.minute.toString().padLeft(2, "0")}";
    } else {
      startTimeText = "ーーーー";
    }
    endTimeText =
        "${endTime.year}年${endTime.month}月${endTime.day}日 ${endTime.hour.toString().padLeft(2, "0")}:${endTime.minute.toString().padLeft(2, "0")}";

    if (widget.event.categoryName == Event.CATEGORY_USER) {
      submitText = "ーーーー";
      submitTextColor = ColorConstants.TEXT_ENDED;
    } else if (widget.event.isSubmit) {
      submitText = "提出済み";
      submitTextColor = ColorConstants.TEXT_SAFE;
    } else {
      submitText = "未提出";
      submitTextColor = ColorConstants.TEXT_DANGER;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("イベント詳細"),
      ),
      body: Padding(
        padding: EdgeInsets.all(MarginConstants.BASE_MARGIN),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 10),
              child: Text(
                widget.event.title,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                widget.event.courseName,
                style: TextStyle(color: ColorConstants.TEXT_SUB),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: SUB_TEXT_MARGIN),
              child: Text(
                "開始時刻  ${startTimeText}",
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: SUB_TEXT_MARGIN),
              child: Text("終了時刻  ${endTimeText}"),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: SUB_TEXT_MARGIN),
              child: Row(
                children: [
                  Text("終了まで  "),
                  getEventFullDateText(widget.event),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: SUB_TEXT_MARGIN * 2),
              child: Row(
                children: [
                  Text("提出状況  "),
                  Text(submitText, style: TextStyle(color: submitTextColor)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: SUB_TEXT_MARGIN),
              child: Row(
                children: [
                  Text("説明",
                      style: TextStyle(color: ColorConstants.TEXT_ENDED)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Html(
                  data: widget.event.description,
                  onLinkTap: (url, _, __, ___) async {
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
