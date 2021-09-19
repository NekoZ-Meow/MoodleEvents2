import 'package:flutter/cupertino.dart';
import 'package:moodle_event_2/event/event.dart';
import 'package:moodle_event_2/user_manager/user_manager.dart';

class Model extends ChangeNotifier {
  List<Event> _events = [];
  UserManager _user;

  Model() {
    this._user = new UserManager();
    return;
  }

  List<Event> get events => this._events;
  UserManager get user => this._user;

  ///
  /// イベントのリストを更新する
  ///
  void updateEventList(List<Event> events) {
    this.events.clear();
    this.events.addAll(events);
    notifyListeners();
    return;
  }
}
