import 'package:flutter/cupertino.dart';
import 'package:moodle_event_2/model/event/event.dart';
import 'package:moodle_event_2/model/options/options_model.dart';
import 'package:moodle_event_2/model/options/sort_option.dart';
import 'package:moodle_event_2/utility/debug_utility.dart';

class EventListViewModel with ChangeNotifier {
  final List<Event> _listEvents = []; //実際に表示するイベント
  final List<Event> _sortedEvents = []; //ソート済みのリスト
  final OptionsModel _options = OptionsModel();

  List<Event> get listEvents => this._listEvents;

  EventListViewModel() {
    return;
  }

  Future<void> loadDependencies() async {
    debugLog("load dependence event list");
    await this._options.loadOptions();
    return;
  }

  /// 実際に表示するイベントを更新する
  void updateListEvents(List<Event> events) {
    debugLog("update event list");
    this._sortedEvents.clear();
    this._sortedEvents.addAll(events);
    this.setSortOption(this._options.sortOption);
    return;
  }

  /// ソート方法を設定する
  void setSortOption(SortOption option) {
    this._options.sortOption = option;
    this._sortEvents();
    this._updateFilter();
    return;
  }

  /// 現在のソート方法を取得する
  SortOption getSortOption() {
    return this._options.sortOption;
  }

  /// イベント群をソートする
  void _sortEvents() {
    this._sortedEvents.sort((aEvent, anotherEvent) =>
        this._options.sortOption.toComparator()(aEvent, anotherEvent));
    return;
  }

  /// コースフィルタを取得する
  Set<String> getCourseFilter() {
    return this._options.filterCourses;
  }

  /// タイトルフィルタを設定する
  void setTitleFilter(String title) {
    this._options.filterTitle = title;
    this._updateFilter();
    return;
  }

  /// コースフィルタを追加する
  void addCourseFilter(String course) {
    this._options.filterCourses.add(course);
    this._updateFilter();
    return;
  }

  /// 指定したコースフィルタを削除する
  void removeCourseFilter(String course) {
    this._options.filterCourses.remove(course);
    this._updateFilter();
    return;
  }

  /// フィルタを更新する
  void _updateFilter() {
    this._listEvents.clear();
    this._listEvents.addAll(this
        ._sortedEvents
        .where((event) => this._titleFilter(event))
        .where((event) => this._courseFilter(event))
        .where((event) =>
            this._options.showAlreadyEnded || this._alreadyEndedFilter(event)));
    super.notifyListeners();
  }

  /// イベント群をタイトルで絞る
  bool _titleFilter(Event event) {
    String filterTitle = this._options.filterTitle;
    return (filterTitle.isEmpty) || event.title.contains(filterTitle);
  }

  /// イベント群をコースで絞る
  bool _courseFilter(Event event) {
    Set<String> filterCourses = this._options.filterCourses;
    return (filterCourses.isEmpty) || filterCourses.contains(event.courseName);
  }

  /// すでに終了しているかのフィルタ
  bool _alreadyEndedFilter(Event event) {
    return !event.isAlreadyEnded();
  }
}
