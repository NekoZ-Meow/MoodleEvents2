import 'package:flutter/material.dart';
import 'package:moodle_event_2/model/event/event.dart';
import 'package:moodle_event_2/ui/event_card/event_card_viewmodel.dart';
import 'package:provider/provider.dart';

class EventCard extends StatelessWidget {
  const EventCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Event event = context.watch<EventCardViewModel>().event;

    return Card(
      child: Text(event.title),
    );
  }
}
