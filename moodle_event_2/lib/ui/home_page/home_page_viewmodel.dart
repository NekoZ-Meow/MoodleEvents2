import 'package:flutter/material.dart';
import 'package:moodle_event_2/model/event/event.dart';
import 'package:moodle_event_2/model/event/event_list_model.dart';
import 'package:moodle_event_2/model/server_interface/server_interface.dart';

class HomePageViewModel with ChangeNotifier {
  List<Event> _events = [];
  String _sessionKey = "";

  List<Event> get events => this._events;
  String get sessionKey => this._sessionKey;

  /// コンストラクタ
  HomePageViewModel() {
    EventListModel.loadEventList().then((events) => this.updateEvents(events));
    return;
  }

  /// 保持しているイベントを[events]に更新し通知する
  void updateEvents(List<Event> events) {
    this._events = events;
    super.notifyListeners();

    return;
  }

  /// Moodleからイベントを更新する
  Future<void> updateEventsFromMoodle() async {
    if (!await isSessKeyValid(this.sessionKey)) {
      throw Exception("セッションキーが有効ではありません");
    }
    DateTime now = DateTime.now();
    List<Event> events = await getEvents(DateTime(now.year, now.month - 6),
        DateTime(now.year, now.month + 6), this.sessionKey);

    this.updateEvents(events);
    return;
  }

  /// セッションキーを更新する
  void updateSessionKey(String newSessionKey) {
    this._sessionKey = newSessionKey;
    return;
  }
}
