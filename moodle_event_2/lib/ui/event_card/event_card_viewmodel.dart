import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moodle_event_2/constants/color_constants.dart';
import 'package:moodle_event_2/model/event/event.dart';
import 'package:moodle_event_2/utility/debug_utility.dart';

class EventCardViewModel with ChangeNotifier {
  final Event _event;
  Timer? _timer; //　提出期限更新のためのタイマー
  String _deadLineString = "";

  Event get event => this._event;

  String get deadLineString => this._deadLineString;

  EventCardViewModel(Event aEvent) : this._event = aEvent {
    this.startTimer();
    debugLog(aEvent.endTime);
    this._updateDeadLineString();
  }

  /// ウィジェットが破棄された時
  @override
  void dispose() {
    this.stopTimer();
    super.dispose();
  }

  /// 1秒に1回正確に更新をかける
  void startTimer() {
    int duration = 1000 - DateTime.now().millisecond;
    this._timer = Timer(Duration(milliseconds: duration), () {
      this._updateDeadLineString();
      this.startTimer();
    });
  }

  /// タイマーを止める
  void stopTimer() {
    this._timer?.cancel();
  }

  /// このイベントを選択した時の処理
  Future<void> onTapped(BuildContext context) async {}

  /// 提出済みかのテキストを取得する
  Text getSubmitText() {
    if (this.event.categoryName == Event.categoryUser) {
      return const Text(
        "-",
        style: TextStyle(color: ColorConstants.textEnded),
      );
    } else if (this.event.isSubmit) {
      return const Text(
        "済",
        style: TextStyle(color: ColorConstants.textSafe),
      );
    }
    return const Text(
      "未",
      style: TextStyle(color: ColorConstants.textDanger),
    );
  }

  /// イベントカード用の日付のテキストを返す
  void _updateDeadLineString() {
    DateTime eventTime = this._event.getRepresentativeTime();
    Duration difference = eventTime.difference(DateTime.now());
    int seconds = difference.inSeconds.abs() % 60;
    int minutes = difference.inMinutes.abs() % 60;
    int hours = difference.inHours.abs() % 24;
    int days = difference.inDays.abs();
    String dayText = "";
    String suffix = "";
    if (difference.isNegative) {
      suffix = "前";
    }
    if (days > 0) {
      dayText = '$days日';
    } else if (hours > 0) {
      if (minutes == 0) {
        dayText = "$hours時間";
      } else {
        dayText = '$hours時間$minutes分';
      }
    } else if (minutes > 0) {
      dayText = '$minutes分';
    } else {
      dayText = '$seconds秒';
    }

    String deadLineString = dayText + suffix;
    if (this._deadLineString != deadLineString) {
      this._deadLineString = deadLineString;
      super.notifyListeners();
    }
    return;
  }
}
