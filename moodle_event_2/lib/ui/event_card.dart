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
class EventCard extends StatefulWidget {
  final Event event;
  const EventCard(this.event, {Key key}) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  ///
  /// イベント詳細ウィジェットを表示する
  ///
  void _goEventDetailWidget() {
    Navigator.of(this.context).push(MaterialPageRoute(
      builder: (context) {
        return EventDetailWidget(widget.event);
      },
    ));
  }

  ///
  /// 提出済みかのテキストを取得する
  ///
  Text _getSubmitText() {
    if (widget.event.categoryName == Event.CATEGORY_USER) {
      return const Text(
        "-",
        style: TextStyle(color: ColorConstants.TEXT_ENDED),
      );
    } else if (widget.event.isSubmit) {
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
    return Container(
      child: GestureDetector(
        onTap: this._goEventDetailWidget,
        child: Card(
          child: Container(
            height: (Theme.of(this.context).textTheme.headline2.fontSize) * 6,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                ///
                /// タイトルとコース名
                ///
                Expanded(
                  flex: 6,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          child: Text(
                            widget.event.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(this.context).textTheme.headline2,
                          ),
                        ),
                        Container(
                          child: Text(
                            widget.event.courseName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(this.context).textTheme.subtitle2,
                          ),
                        ),
                      ],
                    ),
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
                  child: _EventCardSubmitWidget(widget.event),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EventCardSubmitWidget extends StatefulWidget {
  final Event event;
  const _EventCardSubmitWidget(this.event, {Key key}) : super(key: key);

  @override
  _EventCardSubmitWidgetState createState() => _EventCardSubmitWidgetState();
}

class _EventCardSubmitWidgetState extends State<_EventCardSubmitWidget> {
  Timer _dateTimer;
  String _eventDateString = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._eventDateString = getEventDateText(widget.event);
    this._dateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      String newEventDateString = getEventDateText(widget.event);
      if (newEventDateString != this._eventDateString) {
        this.setState(() {
          this._eventDateString = newEventDateString;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    this._dateTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              getEventDatePrefix(widget.event),
              style: Theme.of(this.context).textTheme.subtitle2,
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              this._eventDateString,
              style: TextStyle(
                color: getEventDateColor(widget.event),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
