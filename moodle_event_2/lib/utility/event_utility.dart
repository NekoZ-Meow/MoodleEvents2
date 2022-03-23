import 'package:flutter/material.dart';
import 'package:moodle_event_2/constants/color_constants.dart';
import 'package:moodle_event_2/model/event/event.dart';

/// イベントカード用の日付のテキストを返す
List<String> getDateStrings(DateTime dateTime) {
  Duration difference = dateTime.difference(DateTime.now());
  int seconds = difference.inSeconds.abs() % 60;
  int minutes = difference.inMinutes.abs() % 60;
  int hours = difference.inHours.abs() % 24;
  int days = difference.inDays.abs();
  List<String> dateStrings = [];
  if (days > 0) {
    dateStrings.add('$days日');
  }
  if (hours > 0) {
    dateStrings.add("$hours時間");
    if (minutes != 0) {
      dateStrings.add('$minutes分');
    }
  } else if (minutes > 0) {
    dateStrings.add('$minutes分');
  }
  dateStrings.add('$seconds秒');

  if (difference.isNegative) {
    dateStrings.add("前");
  } else {
    dateStrings.add("");
  }

  return dateStrings;
}

/// イベントの日付の色を返す
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

/// イベントの日付に応じて接頭辞を返す
String getEventDatePrefix(Event event, {bool isEventDetail = false}) {
  if (event.isAlreadyEnded()) {
    return (isEventDetail) ? "終了まで" : "終了";
  }
  if (event.startTime != null || event.categoryName == Event.categoryUser) {
    if (event.isAlreadyStarted()) {
      return "終了まで";
    }
    return "開始まで";
  }
  return "提出まで";
}
