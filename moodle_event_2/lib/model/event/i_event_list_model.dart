import 'package:moodle_event_2/model/event/event.dart';

/// EventListModelのインターフェース
abstract class IEventListModel {
  List<Event> get events => [];

  Future<void> saveEventList() async => {};

  Future<void> loadEventList() async => {};

  void updateEvents(List<Event> events) => {};
}
