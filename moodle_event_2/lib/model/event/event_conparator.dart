import 'package:moodle_event_2/model/event/event.dart';

/// イベントを比較するためのメソッド群
class EventComparator {
  /// 締切で比較する
  static int compareByDeadLine(Event aEvent, Event anotherEvent) {
    return aEvent.compareTo(anotherEvent);
  }

  /// タイトルで比較する
  static int compareByTitle(Event aEvent, Event anotherEvent) {
    return aEvent.title.compareTo(anotherEvent.title);
  }

  /// カテゴリ名で比較する
  static int compareByCategory(Event aEvent, Event anotherEvent) {
    return aEvent.categoryName.compareTo(anotherEvent.categoryName);
  }

  /// コース名で比較する
  static int compareByCourse(Event aEvent, Event anotherEvent) {
    return aEvent.courseName.compareTo(anotherEvent.courseName);
  }
}
