import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:moodle_event_2/constants/color_constants.dart';
import 'package:moodle_event_2/constants/margin_constants.dart';
import 'package:moodle_event_2/event/event.dart';
import 'package:moodle_event_2/ui/popup_menu_widget.dart';
import 'package:moodle_event_2/utility/event_utility.dart';
import "package:url_launcher/url_launcher.dart";

const double SUB_TEXT_MARGIN = 10;

class EventDetailWidget extends StatelessWidget {
  final Event event;
  const EventDetailWidget(this.event, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime? startTime = this.event.startTime;
    final DateTime endTime = this.event.endTime;
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

    if (this.event.categoryName == Event.CATEGORY_USER) {
      submitText = "ーーーー";
      submitTextColor = ColorConstants.textEnded;
    } else if (this.event.isSubmit) {
      submitText = "提出済み";
      submitTextColor = ColorConstants.textSafe;
    } else {
      submitText = "未提出";
      submitTextColor = ColorConstants.textDanger;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("イベント詳細"),
        actions: [
          PopupMenuWidget(this.event),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(MarginConstants.BASE_MARGIN),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 10),
              child: Text(
                this.event.title,
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                this.event.courseName,
                style: const TextStyle(color: ColorConstants.textSub),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: SUB_TEXT_MARGIN),
              child: Text(
                "開始時刻  ${startTimeText}",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: SUB_TEXT_MARGIN),
              child: Text("終了時刻  ${endTimeText}"),
            ),
            _EventDetailSubmitWidget(this.event),
            Padding(
              padding: const EdgeInsets.only(bottom: SUB_TEXT_MARGIN * 2),
              child: Row(
                children: [
                  const Text("提出状況  "),
                  Text(submitText, style: TextStyle(color: submitTextColor)),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: SUB_TEXT_MARGIN),
              child: Text("説明",
                  style: TextStyle(color: ColorConstants.textEnded)),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Html(
                  data: this.event.description,
                  onLinkTap: (url, _, __, ___) async {
                    if (url == null) {
                      return;
                    }
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

class _EventDetailSubmitWidget extends StatefulWidget {
  final Event event;
  const _EventDetailSubmitWidget(this.event, {Key? key}) : super(key: key);

  @override
  _EventDetailSubmitWidgetState createState() =>
      _EventDetailSubmitWidgetState();
}

class _EventDetailSubmitWidgetState extends State<_EventDetailSubmitWidget> {
  final _onTimeChange = StreamController<List<Widget>>();
  Timer? _dateTimer;

  ///
  /// 締め切りのテキストを更新する
  ///
  void _updateDeadlineText() {
    this._onTimeChange.sink.add([
      Text("${getEventDatePrefix(widget.event, isEventDetail: true)}  "),
      Text(
        getEventFullDateText(widget.event),
        style: TextStyle(color: getEventDateColor(widget.event)),
      ),
    ]);

    return;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._updateDeadlineText();
    this._dateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      this._updateDeadlineText();
    });
  }

  @override
  void dispose() {
    if (this._dateTimer != null) {
      this._dateTimer!.cancel();
    }
    this._onTimeChange.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: SUB_TEXT_MARGIN),
        child: StreamBuilder(
          stream: this._onTimeChange.stream,
          builder:
              (BuildContext context, AsyncSnapshot<List<Widget>> snapShot) {
            return Row(
              children: (snapShot.hasData) ? snapShot.data! : const [],
            );
          },
        ));
  }
}
