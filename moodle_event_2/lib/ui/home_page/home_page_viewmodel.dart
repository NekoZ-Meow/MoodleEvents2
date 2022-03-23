import 'package:flutter/material.dart';
import 'package:moodle_event_2/model/event/event.dart';
import 'package:moodle_event_2/model/event/event_list_model.dart';
import 'package:moodle_event_2/model/server_interface/server_interface.dart';
import 'package:moodle_event_2/model/user/user_model.dart';
import 'package:moodle_event_2/utility/debug_utility.dart';

class HomePageViewModel with ChangeNotifier {
  List<Event> _events = [];
  final UserModel _user = UserModel();

  List<Event> get events => this._events;

  UserModel get user => this._user;

  /// コンストラクタ
  HomePageViewModel() {
    return;
  }

  Future<void> loadDependencies() async {
    debugLog("load dependence home page");
    this.updateEvents(await EventListModel.loadEventList());
    await this.user.loadUser();
  }

  /// 保持しているイベントを[events]に更新し通知する
  void updateEvents(List<Event> events) async {
    await EventListModel.saveEventList(events);
    this._events = events;
    super.notifyListeners();
    return;
  }

  /// Moodleからイベントを更新する
  Future<void> updateEventsFromMoodle() async {
    if (!await isSessKeyValid(this._user.sessKey)) {
      throw Exception("セッションキーが有効ではありません");
    }
    DateTime now = DateTime.now();
    List<Event> events = await getEvents(DateTime(now.year, now.month - 6),
        DateTime(now.year, now.month + 6), this._user.sessKey);

    this.updateEvents(events);
    return;
  }

  /// セッションキーを更新する
  Future<void> updateSessionKey(String newSessionKey) async {
    this._user.sessKey = newSessionKey;
    await this._user.saveUser();

    return;
  }
}
