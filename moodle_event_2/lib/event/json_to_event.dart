import 'dart:collection';

import 'package:moodle_event_2/Utility/debug_utility.dart';
import 'package:moodle_event_2/model/event/event.dart';

///
/// サーバから受け取ったJson形式の情報をEventクラスに変換し、
/// idをキー、Eventを要素に持つマップを作成する
///
Map<int, Event> calenderJsonToEventsMap(List<dynamic> topElements) {
  Map<int, Event> idEventMap = new Map<int, Event>();
  topElements.forEach((jsonElement) {
    LinkedHashMap<String, dynamic> jsonMap =
        jsonElement[0] as LinkedHashMap<String, dynamic>;
    List<dynamic> weekList = jsonMap["data"]["weeks"];
    weekList.forEach((weekElement) {
      List<dynamic> dayList = weekElement["days"];
      dayList.forEach((dayElement) {
        LinkedHashMap<String, dynamic> dayMap =
            dayElement as LinkedHashMap<String, dynamic>;

        if (!(dayMap["hasevents"] as bool)) {
          return; //foreach内なのでcontinue
        }

        List<dynamic> events = dayMap["events"];
        events.forEach((eventElement) {
          LinkedHashMap<String, dynamic> eventMap =
              eventElement as LinkedHashMap<String, dynamic>;

          Event? createdEvent = _eventMapToEvent(eventMap);
          if (createdEvent == null) {
            return;
          }

          ///
          /// ユーザイベントの時の処理
          ///
          if (createdEvent.eventInstance == null) {
            //-idはinstanceとかぶらない
            if (!idEventMap.containsKey(-createdEvent.eventId)) {
              idEventMap[-createdEvent.eventId] = createdEvent;
            }
            return; //foreach内なのでcontinue
          }

          if (idEventMap.containsKey(createdEvent.eventInstance)) {
            Event mappedEvent = idEventMap[createdEvent.eventInstance]!;
            if (mappedEvent.startTime != null) {
              return;
            }
            DateTime time1 = createdEvent.endTime;
            DateTime time2 = mappedEvent.endTime;
            if (time1.compareTo(time2) < 0) {
              mappedEvent.setTime(time2, start: time1);
            } else {
              mappedEvent.setTime(time1, start: time2);
            }
            return;
          }
          idEventMap[createdEvent.eventInstance!] = createdEvent;
        });
      });
    });
  });
  debugLog("fin");
  return idEventMap;
}

///
/// jsonから取得したLinkedHashMapのイベントデータをEventクラスへ変換する
///
Event? _eventMapToEvent(Map<String, dynamic> eventMap) {
  int? id = eventMap["id"]; //id
  int? instance = eventMap["instance"]; //インスタンスid
  String? title = eventMap["name"]; //名前
  String? description = eventMap["description"]; //詳細
  String? categoryName = eventMap["normalisedeventtype"]; //カテゴリ名
  String? url = eventMap["url"];

  if (id == null || title == null || categoryName == null || url == null) {
    return null;
  }
  description ??= "なし";

  ///
  ///タイトルの取得
  ///
  if (RegExp(r"(」の提出期限.+)$").hasMatch(title)) {
    Match? match = RegExp(r"「.+」").firstMatch(title);
    if (match != null) {
      title = match.group(0)!;
      title = title.substring(1, title.length - 1);
    }
  } else if (RegExp(r"(」開始)$").hasMatch(title)) {
    Match? match = RegExp(r"「.+」").firstMatch(title);
    if (match != null) {
      title = match.group(0)!;
      title = title.substring(1, title.length - 1);
    }
  }
  if (eventMap["modulename"] == "quiz") {
    title = title.replaceFirst(RegExp(r" (終了|開始)$"), "");
  }
  title = title.replaceAll(RegExp(r"( の(受験).+(終了|開始))$"), "");

  ///
  ///カテゴリ名の取得
  ///
  String courseName = "";
  if (eventMap.containsKey("course")) {
    courseName = eventMap["course"]["fullname"];
  } else {
    courseName = eventMap["normalisedeventtypetext"];
  }

  ///
  /// 時間の取得
  ///
  DateTime endTime;
  DateTime? startTime;
  int timeDuration = eventMap["timeduration"] as int;
  int unixTime = eventMap["timestart"] as int;
  if (timeDuration != 0) {
    startTime = DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);
    endTime = startTime.add(Duration(seconds: timeDuration));
  } else {
    endTime = DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);
  }

  return Event(
      id, instance, title, description, categoryName, courseName, url, endTime,
      startTime: startTime);
}
