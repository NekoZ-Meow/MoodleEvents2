import 'package:flutter/cupertino.dart';
import 'package:moodle_event_2/model/event/event.dart';

class EventListViewModel with ChangeNotifier {
  List<Event> _listEvents = []; //実際に表示するイベント
  Function? _sortMethod;

  List<Event> get listEvents => this._listEvents;

  EventListViewModel() {
    this._sortMethod = this._sortByDeadLine;
  }

  /// 実際に表示するイベントを更新する
  void updateListEvents(List<Event> events) {
    this._listEvents = events;
    this.formatEvents();
    return;
  }

  void formatEvents() {
    this._sortMethod?.call();
    super.notifyListeners();
  }

  /// 締切日時でソートする
  void _sortByDeadLine({isDesc = false}) {
    this._listEvents.sort((aEvent, anotherEvent) =>
        (isDesc) ? -1 : 1 * aEvent.compareTo(anotherEvent));
    return;
  }
}
