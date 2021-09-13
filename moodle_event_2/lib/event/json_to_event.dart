import 'dart:collection';
import "dart:convert";

import 'package:moodle_event_2/Utility/DebugUtility.dart';
import 'package:moodle_event_2/event/Event.dart';

///
/// サーバから受け取ったJson形式の情報をEventクラスに変換する
/// 順序はランダム
///
class JsonToEvent {
  static List<Event> calenderJsonToEvents(List<String> jsonList) {
    Map<int, Event> memoEventMap = new Map<int, Event>();
    jsonList.forEach((jsonString) {
      List<dynamic> jsonList = json.decode(jsonString);
      jsonList.forEach((jsonElement) {
        LinkedHashMap<String, dynamic> jsonMap =
            jsonElement as LinkedHashMap<String, dynamic>;
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

              Event createdEvent = _eventMapToEvent(eventMap);
              if (memoEventMap.containsKey(createdEvent.eventId)) {
                Event mappedEvent = memoEventMap[createdEvent.eventId];
                DateTime time1 = createdEvent.endTime;
                DateTime time2 = mappedEvent.endTime;
                if (time1.compareTo(time2) < 0) {
                  mappedEvent.setTime(time2, start: time1);
                } else {
                  mappedEvent.setTime(time1, start: time2);
                }
              }
              memoEventMap[createdEvent.eventId] = createdEvent;
            });
          });
        });
      });
    });

    debugLog("fin");
    return memoEventMap.values.toList();
  }

  static Event _eventMapToEvent(Map<String, dynamic> eventMap) {
    int id = eventMap["instance"] as int;
    String title = eventMap["name"];
    if (new RegExp(r"(」の提出期限.+)$").hasMatch(title)) {
      title = new RegExp(r"「.+」").firstMatch(title).group(0);
      title = title.substring(1, title.length - 1);
    }
    title = title.replaceAll(new RegExp(r"( の(受験).+(終了|開始))$"), "");

    String description = eventMap["description"];
    String categoryName = eventMap["normalisedeventtype"];
    String courseName = "";
    if (eventMap.containsKey("course")) {
      courseName = eventMap["course"]["fullname"];
    } else {
      courseName = eventMap["normalisedeventtypetext"];
    }
    int unixTime = eventMap["timestart"] as int;
    DateTime endTime = DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);

    return new Event(id, title, description, categoryName, courseName, endTime);
  }
}
