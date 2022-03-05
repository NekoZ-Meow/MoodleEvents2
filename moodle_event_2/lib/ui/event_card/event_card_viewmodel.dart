import 'package:flutter/material.dart';
import 'package:moodle_event_2/model/event/event.dart';

class EventCardViewModel with ChangeNotifier {
  final Event _event;

  get event => this._event;

  EventCardViewModel(Event aEvent) : this._event = aEvent;
}
