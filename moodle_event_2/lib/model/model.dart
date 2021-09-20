import 'dart:convert';
import 'dart:io';

import 'package:moodle_event_2/event/event.dart';
import 'package:moodle_event_2/user_manager/user_manager.dart';
import 'package:path_provider/path_provider.dart';

class Model {
  static final String userFileName = "user";
  static final String eventsFileName = "events";

  List<Event> _events = [];
  UserManager _user = new UserManager();

  List<Event> get events => this._events;
  UserManager get user => this._user;

  ///
  /// イベントのリストを更新する
  ///
  void updateEventList(List<Event> events) {
    this.events.clear();
    this.events.addAll(events);
    return;
  }

  ///
  /// モデル情報を保存する
  ///
  Future<void> save() async {
    String rootSavePath = (await getApplicationDocumentsDirectory()).path;
    String userJson = json.encode(this.user);
    String eventsJson = json.encode(this.events);
    File userFile = new File("${rootSavePath}/${Model.userFileName}");
    File eventsFile = new File("${rootSavePath}/${Model.eventsFileName}");
    await Future.wait([
      userFile.writeAsString(userJson),
      eventsFile.writeAsString(eventsJson),
    ]);

    return;
  }

  ///
  /// モデル情報をロードする
  ///
  Future<void> load() async {
    String rootSavePath = (await getApplicationDocumentsDirectory()).path;
    File userFile = new File("${rootSavePath}/${Model.userFileName}");
    File eventsFile = new File("${rootSavePath}/${Model.eventsFileName}");
    await Future.wait([
      this._createUserFromUserFile(userFile).then((value) {
        if (value == null) return;
        this._user = value;
      }),
      this._createEventsFromEventsFile(eventsFile).then((value) {
        if (value.isEmpty) return;
        this._events = value;
      }),
    ]);
    return;
  }

  Future<UserManager?> _createUserFromUserFile(File userFile) async {
    if (await userFile.exists()) {
      return UserManager.fromJson(json.decode(await userFile.readAsString()));
    } else {
      return null;
    }
  }

  Future<List<Event>> _createEventsFromEventsFile(File eventsFile) async {
    if (await eventsFile.exists()) {
      List<dynamic> eventsJson = json.decode(await eventsFile.readAsString());
      return eventsJson.map((eventJson) => Event.fromJson(eventJson)).toList();
    } else {
      return [];
    }
  }
}
