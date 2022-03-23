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

  /// イベント群をソートする
  void _sortEvents() {
    this._sortedEvents.sort((aEvent, anotherEvent) =>
        this._options.sortOption.toComparator()(aEvent, anotherEvent));
    return;
  }

  /// タイトルフィルタを設定する
  void setTitleFilter(String title) {
    this._options.filterTitle = title;
    this._updateFilter();
    return;
  }

  /// カテゴリフィルタを設定する
  void setCategoryFilter(Set<String> categories) {
    this._options.filterCategories = categories;
    this._updateFilter();
    return;
  }

  /// コースフィルタを設定する
  void setCoursesFilter(Set<String> courses) {
    this._options.filterCourses = courses;
    this._updateFilter();
    return;
  }

  /// フィルタを更新する
  void _updateFilter() {
    this._listEvents.clear();
    this._listEvents.addAll(this
        ._sortedEvents
        .where((event) => this._titleFilter(event))
        .where((event) => this._categoryFilter(event))
        .where((event) => this._courseFilter(event)));
    super.notifyListeners();
  }

  /// イベント群をタイトルで絞る
  bool _titleFilter(Event event) {
    String filterTitle = this._options.filterTitle;
    return (filterTitle.isEmpty) || event.title.contains(filterTitle);
  }

  /// イベント群をカテゴリで絞る
  bool _categoryFilter(Event event) {
    Set<String> filterCategories = this._options.filterCategories;
    return (filterCategories.isEmpty) ||
        filterCategories.contains(event.categoryName);
  }

  /// イベント群をコースで絞る
  bool _courseFilter(Event event) {
    Set<String> filterCourses = this._options.filterCourses;
    return (filterCourses.isEmpty) || filterCourses.contains(event.courseName);
  }
}
