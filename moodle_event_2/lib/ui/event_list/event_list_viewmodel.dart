import 'package:flutter/cupertino.dart';
import 'package:moodle_event_2/model/event/event.dart';
import 'package:moodle_event_2/model/options/options_model.dart';
import 'package:moodle_event_2/model/options/sort_option.dart';
import 'package:moodle_event_2/ui/event_card/event_card.dart';
import 'package:moodle_event_2/ui/event_card/event_card_viewmodel.dart';
import 'package:moodle_event_2/utility/debug_utility.dart';
import 'package:provider/provider.dart';

class EventListViewModel with ChangeNotifier {
  List<Event> _listEvents = []; //実際に表示するイベント
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
    this._listEvents = events;
    this._sortEvents();
    debugLog("update event list");
    super.notifyListeners();
    return;
  }

  /// ソート方法を設定する
  void setSortOption(SortOption option) {
    this._options.sortOption = option;
    this._sortEvents();
    super.notifyListeners();
    return;
  }

  /// イベント群をソートする
  void _sortEvents() {
    this._listEvents.sort((aEvent, anotherEvent) =>
        this._options.sortOption.toComparator()(aEvent, anotherEvent));
    return;
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

  /// Event群をChangeNotifierProviderクラスをラップしたウィジェットへ変換し返す
  List<ChangeNotifierProvider> getEventCardList() {
    return this
        ._listEvents
        .where((event) => this._titleFilter(event))
        .where((event) => this._categoryFilter(event))
        .where((event) => this._courseFilter(event))
        .map((event) => ChangeNotifierProvider(
            create: (context) => EventCardViewModel(event),
            child: const EventCard()))
        .toList();
  }
}
