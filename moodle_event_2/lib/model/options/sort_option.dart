import 'package:moodle_event_2/model/event/event.dart';
import 'package:moodle_event_2/model/event/event_conparator.dart';

/// ソート方法指定のための列挙型
enum SortOption {
  deadLineAsc,
  deadLineDesc,
  titleAsc,
  titleDesc,
  categoryAsc,
  categoryDesc,
  courseAsc,
  courseDesc,
}

extension SortOptionExtension on SortOption {
  static final Map<SortOption, String> optionNames = {
    SortOption.deadLineAsc: "deadLineAsc",
    SortOption.deadLineDesc: "deadLineDesc",
    SortOption.titleAsc: "titleAsc",
    SortOption.titleDesc: "titleDesc",
    SortOption.categoryAsc: "categoryAsc",
    SortOption.categoryDesc: "categoryDesc",
    SortOption.courseAsc: "courseAsc",
    SortOption.courseDesc: "courseDesc",
  };

  static final nameOptions =
      optionNames.map((key, value) => MapEntry(value, key));

  /// 列挙型から文字列へ変換する
  String? get name => optionNames[this];

  /// 文字列から列挙型へ変換する
  static SortOption fromString(String name) {
    if (nameOptions.containsKey(name)) return nameOptions[name]!;
    return SortOption.deadLineAsc;
  }

  /// 列挙型からそれが表す比較関数へ変換
  Function(Event, Event) toComparator() {
    bool isDesc = false;
    int Function(Event, Event) sortMethod = EventComparator.compareByDeadLine;

    switch (this) {
      case SortOption.deadLineAsc:
        sortMethod = EventComparator.compareByDeadLine;
        isDesc = false;
        break;
      case SortOption.deadLineDesc:
        sortMethod = EventComparator.compareByDeadLine;
        isDesc = true;
        break;
      case SortOption.titleAsc:
        sortMethod = EventComparator.compareByTitle;
        isDesc = false;
        break;
      case SortOption.titleDesc:
        sortMethod = EventComparator.compareByTitle;
        isDesc = true;
        break;
      case SortOption.categoryAsc:
        sortMethod = EventComparator.compareByCategory;
        isDesc = false;
        break;
      case SortOption.categoryDesc:
        sortMethod = EventComparator.compareByCategory;
        isDesc = true;
        break;
      case SortOption.courseAsc:
        sortMethod = EventComparator.compareByCourse;
        isDesc = false;
        break;
      case SortOption.courseDesc:
        sortMethod = EventComparator.compareByCourse;
        isDesc = true;
        break;
    }

    return (aEvent, anotherEvent) {
      return (isDesc) ? -1 : 1 * sortMethod(aEvent, anotherEvent);
    };
  }
}
