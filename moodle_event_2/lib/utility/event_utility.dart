import 'package:flutter/material.dart';
import 'package:moodle_event_2/constants/color_constants.dart';
import 'package:moodle_event_2/event/event.dart';

///
/// イベントの日付をテキストに変換する
///
Text getEventDateText(Event event) {
  DateTime eventTime = event.getRepresentativeTime();
  Duration difference = eventTime.difference(DateTime.now());
  int sec = difference.inSeconds;
  String dayText = "";
  String suffix = "";
  Color textColor = ColorConstants.TEXT_DANGER;

  if (sec < 0) {
    sec *= -1;
    suffix = "前";
  }

  if (difference.inDays > 3) {
    textColor = ColorConstants.TEXT_SAFE;
  } else if (difference.inDays > 1) {
    textColor = ColorConstants.TEXT_WARNING;
  } else if (difference.inSeconds < 0) {
    textColor = ColorConstants.TEXT_ENDED;
  }

  if (sec >= 60 * 60 * 24) {
    dayText = '${difference.inDays.abs()}日';
  } else if (sec >= 60 * 60) {
    if (difference.inMinutes.abs() % 60 == 0) {
      dayText = "${difference.inHours.abs()}時間";
    } else {
      dayText =
          '${difference.inHours.abs()}時間${difference.inMinutes.abs() % 60}分';
    }
  } else if (sec >= 60) {
    dayText = '${difference.inMinutes.abs()}分';
  } else {
    dayText = '${sec.abs()}秒';
  }
  dayText += suffix;

  return new Text(dayText, style: TextStyle(color: textColor, fontSize: 15.5));
}

getEventFullDateText(Event event) {
  DateTime eventTime = event.getRepresentativeTime();
  Duration difference = eventTime.difference(DateTime.now());
  int sec = difference.inSeconds;
  String dayText = "";
  String suffix = "";
  Color textColor = ColorConstants.TEXT_DANGER;

  if (sec < 0) {
    sec *= -1;
    suffix = "前に終了";
  }

  if (difference.inDays > 3) {
    textColor = ColorConstants.TEXT_SAFE;
  } else if (difference.inDays > 1) {
    textColor = ColorConstants.TEXT_WARNING;
  } else if (difference.inSeconds < 0) {
    textColor = ColorConstants.TEXT_ENDED;
  }

  if (sec >= 60 * 60 * 24) {
    dayText += '${difference.inDays.abs()}日と';
  }
  if (sec >= 60 * 60) {
    dayText += "${difference.inHours.abs() % 24}時間";
  }
  if (sec >= 60) {
    dayText += '${difference.inMinutes.abs() % 60}分';
  }
  dayText += '${sec.abs() % 60}秒';

  dayText += suffix;

  return new Text(dayText, style: TextStyle(color: textColor));
}

///
/// イベントの日付に応じて接頭辞を返す
///
String getEventDatePrefix(Event event) {
  if (event.isAlreadyEnded()) {
    return "終了";
  }
  if (event.startTime != null) {
    if (event.isAlreadyStarted()) {
      return "終了まで";
    }
    return "開始まで";
  }
  return "提出まで";
}
