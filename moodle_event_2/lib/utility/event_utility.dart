import 'package:flutter/material.dart';
import 'package:moodle_event_2/constants/color_constants.dart';
import 'package:moodle_event_2/event/event.dart';

///
/// イベントカード用の日付のテキストを返す
///
String getEventDateText(Event event) {
  DateTime eventTime = event.getRepresentativeTime();
  Duration difference = eventTime.difference(DateTime.now());
  int sec = difference.inSeconds;
  String dayText = "";
  String suffix = "";

  if (sec < 0) {
    sec *= -1;
    suffix = "前";
  }

  if (sec >= 86400) {
    dayText = '${difference.inDays.abs()}日';
  } else if (sec >= 3600) {
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

  return dayText;
}

///
/// イベント詳細用の日付のテキストを返す
///
String getEventFullDateText(Event event) {
  DateTime eventTime = event.getRepresentativeTime();
  Duration difference = eventTime.difference(DateTime.now());
  int sec = difference.inSeconds;
  String dayText = "";
  String suffix = "";

  if (sec < 0) {
    sec *= -1;
    suffix = "前に終了";
  }

  if (sec >= 86400) {
    dayText += '${difference.inDays.abs()}日と';
  }
  if (sec >= 3600) {
    dayText += "${difference.inHours.abs() % 24}時間";
  }
  if (sec >= 60) {
    dayText += '${difference.inMinutes.abs() % 60}分';
  }
  dayText += '${sec.abs() % 60}秒';

  dayText += suffix;

  return dayText;
}

///
/// イベントの日付の色を返す
///
Color getEventDateColor(Event event) {
  DateTime eventTime = event.getRepresentativeTime();
  Duration difference = eventTime.difference(DateTime.now());
  if (difference.inDays > 3) {
    return ColorConstants.textSafe;
  } else if (difference.inDays > 1) {
    return ColorConstants.textWarning;
  } else if (difference.inSeconds < 0) {
    return ColorConstants.textEnded;
  }
  return ColorConstants.textDanger;
}

///
/// イベントの日付に応じて接頭辞を返す
///
String getEventDatePrefix(Event event, {bool isEventDetail = false}) {
  if (event.isAlreadyEnded()) {
    return (isEventDetail) ? "終了まで" : "終了";
  }
  if (event.startTime != null || event.categoryName == Event.CATEGORY_USER) {
    if (event.isAlreadyStarted()) {
      return "終了まで";
    }
    return "開始まで";
  }
  return "提出まで";
}
