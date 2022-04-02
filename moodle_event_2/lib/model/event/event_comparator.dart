import 'package:moodle_event_2/model/event/event.dart';
import 'package:moodle_event_2/utility/string_utility.dart';

/// イベントを比較するためのメソッド群
class EventComparator {
  /// 締切で比較する
  static int compareByDeadLine(Event aEvent, Event anotherEvent) {
    return aEvent.compareTo(anotherEvent);
  }

  /// タイトルで比較する
  static int compareByTitle(Event aEvent, Event anotherEvent) {
    String aTitle = kanaToHira(aEvent.title);
    String anotherTitle = kanaToHira(anotherEvent.title);
    return aTitle.compareTo(anotherTitle);
  }

  /// カテゴリ名で比較する
  static int compareByCategory(Event aEvent, Event anotherEvent) {
    String aCategoryName = kanaToHira(aEvent.categoryName);
    String anotherCategoryName = kanaToHira(anotherEvent.categoryName);
    return aCategoryName.compareTo(anotherCategoryName);
  }

  /// コース名で比較する
  static int compareByCourse(Event aEvent, Event anotherEvent) {
    String aCourseName = kanaToHira(aEvent.courseName);
    String anotherCourseName = kanaToHira(anotherEvent.courseName);
    return aCourseName.compareTo(anotherCourseName);
  }
}
