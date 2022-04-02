import 'dart:convert';
import 'dart:io';

import 'package:moodle_event_2/model/event/event.dart';
import 'package:moodle_event_2/model/event/i_event_list_model.dart';
import 'package:moodle_event_2/utility/debug_utility.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class EventListModel implements IEventListModel {
  static const String eventListFileName = "events"; //保存するファイル名
  final List<Event> _events = [];

  @override
  List<Event> get events => this._events;

  /// [events]Json形式でファイルに出力する
  @override
  Future<void> saveEventList() async {
    String rootSavePath = (await getApplicationDocumentsDirectory()).path;
    String eventsJson = json.encode(this._events);
    File eventsFile =
        File(path.join(rootSavePath, EventListModel.eventListFileName));
    await eventsFile.writeAsString(eventsJson);

    return;
  }

  /// eventを読み込み、リスト形式で返す
  @override
  Future<void> loadEventList() async {
    String rootSavePath = (await getApplicationDocumentsDirectory()).path;
    File eventsFile =
        File(path.join(rootSavePath, EventListModel.eventListFileName));

    try {
      List<dynamic> eventsJson = json.decode(await eventsFile.readAsString());
      List<Event> loadEvents =
          eventsJson.map((eventJson) => Event.fromJson(eventJson)).toList();
      this.updateEvents(loadEvents);
    } catch (e) {
      debugLog(e);
    }
    return;
  }

  /// イベントを更新する
  @override
  void updateEvents(List<Event> events) {
    this._events.clear();
    this._events.addAll(events);
  }
}
