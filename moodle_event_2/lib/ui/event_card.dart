import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_event_2/constants/color_constants.dart';
import 'package:moodle_event_2/event/event.dart';
import 'package:moodle_event_2/ui/event_detail_widget.dart';
import 'package:moodle_event_2/utility/event_utility.dart';

///
/// リスト表示の際のイベント1つを表すウィジェット
///
class EventCardWidget extends StatelessWidget {
  final Event event;
  const EventCardWidget(this.event, {Key? key}) : super(key: key);

  ///
  /// イベント詳細ウィジェットを表示する
  ///
  void _goEventDetailWidget(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return EventDetailWidget(this.event);
      },
    ));
  }

  ///
  /// 提出済みかのテキストを取得する
  ///
  Text _getSubmitText() {
    if (this.event.categoryName == Event.CATEGORY_USER) {
      return const Text(
        "-",
        style: TextStyle(color: ColorConstants.TEXT_ENDED),
      );
    } else if (this.event.isSubmit) {
      return const Text(
        "済",
        style: TextStyle(color: ColorConstants.TEXT_SAFE),
      );
    }
    return const Text(
      "未",
      style: TextStyle(color: ColorConstants.TEXT_DANGER),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this._goEventDetailWidget(context);

        return;
      },
      child: Card(
        child: Container(
          height: (Theme.of(context).textTheme.headline2!.fontSize)! * 6,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ///
              /// タイトルとコース名
              ///
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text(
                        this.event.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                    Text(
                      this.event.courseName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                ),
              ),

              ///
              /// 提出済みかどうかのテキスト
              ///
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: this._getSubmitText(),
                ),
              ),

              ///
              /// 提出を表すウィジェット
              ///
              Expanded(
                flex: 3,
                child: _EventCardSubmitWidget(this.event),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventCardSubmitWidget extends StatefulWidget {
  final Event event;
  const _EventCardSubmitWidget(this.event, {Key? key}) : super(key: key);

  @override
  _EventCardSubmitWidgetState createState() => _EventCardSubmitWidgetState();
}

class _EventCardSubmitWidgetState extends State<_EventCardSubmitWidget> {
  final StreamController<Text> _onDatePrefixChange = StreamController<Text>();
  final StreamController<Text> _onDateTextChange = StreamController<Text>();

  Timer? _dateTimer;
  String _eventDateString = "";
  String _eventDatePrefixString = "";

  ///
  /// 締め切りの文字を更新する
  ///
  void _updateDeadlineText() {
    String newEventDateString = getEventDateText(widget.event);
    String newEventDatePrefixString = getEventDatePrefix(widget.event);
    if (newEventDateString != this._eventDateString) {
      this._eventDateString = newEventDateString;
      this._onDateTextChange.sink.add(Text(
            this._eventDateString,
            style: TextStyle(
              color: getEventDateColor(widget.event),
            ),
          ));
    }
    if (newEventDatePrefixString != this._eventDatePrefixString) {
      this._eventDatePrefixString = newEventDatePrefixString;
      this._onDatePrefixChange.sink.add(Text(
            this._eventDatePrefixString,
            style: Theme.of(this.context).textTheme.subtitle2,
          ));
    }
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
    this._onDatePrefixChange.close();
    this._onDateTextChange.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: StreamBuilder<Text>(
            stream: this._onDatePrefixChange.stream,
            builder: (BuildContext context, AsyncSnapshot<Text> snapShot) {
              return (snapShot.hasData)
                  ? snapShot.data!
                  : const SizedBox.shrink();
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: StreamBuilder<Text>(
            stream: this._onDateTextChange.stream,
            builder: (BuildContext context, AsyncSnapshot<Text> snapShot) {
              return (snapShot.hasData)
                  ? snapShot.data!
                  : const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
