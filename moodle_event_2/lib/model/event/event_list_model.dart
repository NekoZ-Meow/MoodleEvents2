import 'dart:convert';
import 'dart:io';

import 'package:moodle_event_2/model/event/event.dart';
import 'package:moodle_event_2/utility/debug_utility.dart';
import 'package:path_provider/path_provider.dart';

class EventListModel {
  static const String eventListFileName = "events"; //保存するファイル名

  /// [events]Json形式でファイルに出力する
  static Future<void> saveEventList(List<Event> events) async {
    String rootSavePath = (await getApplicationDocumentsDirectory()).path;
    String eventsJson = json.encode(events);
    File eventsFile = File("$rootSavePath/${EventListModel.eventListFileName}");
    await eventsFile.writeAsString(eventsJson);

    return;
  }

  /// eventを読み込み、リスト形式で返す
  static Future<List<Event>> loadEventList() async {
    String rootSavePath = (await getApplicationDocumentsDirectory()).path;
    File eventsFile = File("$rootSavePath/${EventListModel.eventListFileName}");

    List<Event> events = [];
    try {
      List<dynamic> eventsJson = json.decode(await eventsFile.readAsString());
      events =
          eventsJson.map((eventJson) => Event.fromJson(eventJson)).toList();
    } catch (e) {
      debugLog(e);
    }

    return events;
  }
}
