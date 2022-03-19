import 'package:flutter/cupertino.dart';
import 'package:moodle_event_2/model/event/event.dart';

class EventListViewModel with ChangeNotifier {
  List<Event> _listEvents = []; //実際に表示するイベント

  /// 実際に表示するイベントを更新する
  void updateListEvents(List<Event> events) {
    this._listEvents = events;
    super.notifyListeners();
    return;
  }

  /// 締切日時でソートする
  void _sortByDeadLine({is_desc = false}) {
    this._listEvents.sort();
    return;
  }
}
